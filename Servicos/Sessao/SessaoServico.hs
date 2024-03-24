{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
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
mudaId newIdent sessao = sessao { ident = newIdent }

-- Realiza as validações na sessao para adicionar ao JSON
adicionaSessao:: Sessao -> IO()
adicionaSessao sessao = do
    if not(validaHorario (horario sessao))
        then do
            print("Horario invalido(hora >= 0 e <=23, minuto >=0 e <= 59).")
            threadDelay 100000
        else do
            putStrLn ""
    
-- Adiciona uma sessao ao arquivo JSON
adicionaSessaoJSON:: Sessao -> IO()
adicionaSessaoJSON sessao = do
    let conteudo = getSessoesJSON
    listaSessoes <- retornaLista conteudo sessao
        
    B.writeFile constanteTempPATH $ encode listaSessoes
    removeFile constantePATH
    renameFile constanteTempPATH constantePATH


--validaSessao:: Sessao -> IO Bool
--validaSessao sessao = do

-- Verifica se o horario  esta no formato correto, hora >=0 e <=23 e minuto >=0 e <=59
validaHorario:: (Int, Int) -> Bool
validaHorario (hora, minuto) = (hora >= 0 && hora <= 23) && (minuto >=0 && minuto <= 59)