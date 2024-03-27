{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
{-# HLINT ignore "Use when" #-}
module Servicos.Sessao.SessaoServico where


import Modelos.Sessao
import Data.Aeson ( FromJSON, ToJSON, encode,decode )
import qualified Data.ByteString.Lazy as B
import System.Directory
import Data.Maybe
import Data.Bool (Bool)
import Modelos.Sessao (Sessao(horario))
import Control.Concurrent (threadDelay)
import Data.String (String)
import qualified Modelos.Administrador 
import Modelos.Filme (Filme(Filme, ident, duracao))

instance FromJSON Sessao
instance ToJSON Sessao

constantePATH:: String
constantePATH = "./BancoDeDados/Sessao.json"

constanteTempPATH:: String
constanteTempPATH = "./BancoDeDados/SessaoTemp.json"


-- Retorna uma lista com todas as sessoes cadastradas
getSessoesJSON:: IO [Sessao]
getSessoesJSON = do
    file <- B.readFile constantePATH
    let decodedFile = decode file :: Maybe [Sessao]
    case decodedFile of
        Nothing -> pure []
        Just out -> pure out

-- Recebe um IO[Sessao] e uma sessao e retorna uma nova lista adicionando as duas
retornaLista :: IO [Sessao] -> Sessao -> IO [Sessao]
retornaLista acaoLista sessao = do
    lista <- acaoLista
    return (lista ++ [mudaId (length lista + 1) sessao])


-- Muda o id de umma sessao de acordo com a quantidade de sessoes
mudaId:: Int -> Sessao -> Sessao
mudaId newIdent sessao = sessao { Modelos.Sessao.ident = newIdent }

    
-- Adiciona uma sessao ao arquivo JSON
adicionaSessaoJSON:: Sessao -> IO()
adicionaSessaoJSON sessao = do
    let conteudo = getSessoesJSON
    listaSessoes <- retornaLista conteudo sessao
        
    B.writeFile constanteTempPATH $ encode listaSessoes
    removeFile constantePATH
    renameFile constanteTempPATH constantePATH


-- A regra para registrar duas sessoes na mesma sala é que outra sessao só pode ser cadastrada
-- uma hora após um filme acabar
validaSessaoSala :: Sessao -> Sessao -> Bool
validaSessaoSala novaSessao sessaoExistente =
  idSala novaSessao == idSala sessaoExistente
    && (comparaHorarioSessao (horario novaSessao) (horario sessaoExistente) || verificaFilmeTerminou novaSessao sessaoExistente)

-- Função para comparar o horário das sessões
comparaHorarioSessao :: (Int, Int) -> (Int, Int) -> Bool
comparaHorarioSessao (hora1, minuto1) (hora2, minuto2) = hora1 == hora2

-- Verifica se o horario  esta no formato correto, hora >=0 e <=23 e minuto >=0 e <=59
validaHorario :: (Int, Int) -> Bool
validaHorario (hora, minuto) = (hora >= 0 && hora <= 23) && (minuto >= 0 && minuto <= 59)

verificaFilmeTerminou :: Sessao -> Sessao -> Bool
verificaFilmeTerminou novaSessao sessaoExistente =
  let duracaoFilmeSessaoExistente = read (duracao (filme sessaoExistente)) :: Int
      duracaoFilmeSessaoNova = read (duracao (filme novaSessao)) :: Int
      (horasSessaoExistente, minutosSessaoExistente) = horario sessaoExistente
      (horasSessaoNova, minutosSessaoNova) = horario novaSessao
      totalMinutosExistentes = horasSessaoExistente * 60 + duracaoFilmeSessaoExistente + minutosSessaoExistente
      totalMinutosNova = horasSessaoNova * 60 + duracaoFilmeSessaoNova + minutosSessaoNova
      totalMinutosSessaoNova = horasSessaoNova * 60 + minutosSessaoNova
      totalMinutosSessaoExistente = horasSessaoExistente * 60 + minutosSessaoExistente
   in if horasSessaoNova < horasSessaoExistente
        then totalMinutosSessaoExistente - totalMinutosNova < 60
        else totalMinutosSessaoNova - totalMinutosExistentes < 60



-- Funções que se comunicam com o Controller

-- Realiza as validações na sessao para adicionar ao JSON
adicionaSessao :: Sessao -> IO ()
adicionaSessao sessao = do
  if not (validaHorario (horario sessao))
    then do
      print "Horario invalido (hora >= 0 e <=23, minuto >=0 e <= 59)."
      threadDelay 1200000
    else do
      sessoesExistem <- getSessoesJSON
      if any (validaSessaoSala sessao) sessoesExistem
        then do
          putStrLn "Já existe uma sessão na mesma sala e horário."
          threadDelay 1200000
        else do
          adicionaSessaoJSON sessao
          putStrLn "Sessão cadastrada com sucesso!!"
          threadDelay 1200000
