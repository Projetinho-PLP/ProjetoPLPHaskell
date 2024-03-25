{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
module Servicos.Filmes.FilmesController where

import Servicos.Matriz.MatrizServices (writeMatrixValue)
import Modelos.Filme
import qualified Data.ByteString.Lazy as B
import Data.Aeson
import System.Directory
import Data.Maybe
import Data.Bool (Bool)
import Data.Int (Int)

--instance FromJSON Filme
--instance ToJSON Filme


--- Constante Utilizadas
constantePATH:: String
constantePATH = "./BancoDeDados/Filme.json"

constanteTempPATH:: String
constanteTempPATH = "./BancoDeDados/TempFilme.json"

interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"

interfaceMenuCompraBase :: String
interfaceMenuCompraBase = "./Interfaces/Compras/MenuComprasBase.txt"
------------------------------------------------------

getAllFilmesJSON :: IO [Filme]
getAllFilmesJSON = do
  file <- B.readFile constantePATH
  let decodedFile = decode file :: Maybe [Filme]
  case decodedFile of
    Nothing -> pure []
    Just out -> pure out

retornaLista :: IO [Filme] -> Filme -> IO [Filme]
retornaLista acaoLista admin = do
    lista <- acaoLista
    return (lista ++ [mudaId (length lista + 1) admin])

mudaId:: Int -> Filme -> Filme
mudaId newIdent filme = filme { ident = newIdent }

adicionarFilmeJSON :: Filme -> IO()
adicionarFilmeJSON filme = do
  let conteudo = getAllFilmesJSON
  listaFilmes <- retornaLista conteudo filme

  B.writeFile constanteTempPATH $ encode listaFilmes
  removeFile constantePATH
  renameFile constanteTempPATH constantePATH

checaNumeroMaximoDeFilmesAtingido :: IO Bool
checaNumeroMaximoDeFilmesAtingido = do
    listaFilmes <- getAllFilmesJSON
    if length listaFilmes == 5
        then return True
        else return False

---------------------------------------------------

loadMovies :: IO ()
loadMovies = do
    conteudoBase <- readFile interfaceMenuCompraBase
    writeFile interfaceMenuCompra conteudoBase
    filmes <- getAllFilmesJSON
    atualizaFilmes filmes

atualizaFilmes :: [Filme] -> IO ()
atualizaFilmes [] = return ()
atualizaFilmes (x:xs) = do
    let id = ident x
    atualizaNomeFilmeNaInterface id (titulo x)
    atualizaDuracaoFilmeNaInterface id (duracao x)
    atualizaGeneroFilmesNaInterface id (genero x)
    atualizaFilmes xs

atualizaNomeFilmeNaInterface :: Int -> String -> IO ()
atualizaNomeFilmeNaInterface  id titulo = do
    let posicao = getMoviePosition id
    writeMatrixValue interfaceMenuCompra titulo (head posicao) (last posicao)

atualizaDuracaoFilmeNaInterface :: Int -> String -> IO ()
atualizaDuracaoFilmeNaInterface  id duracao  = do
    let posicao = getMoviePosition id
    writeMatrixValue interfaceMenuCompra ("Duração: " ++ duracao) (head posicao + 1) (last posicao)

atualizaGeneroFilmesNaInterface :: Int -> String -> IO ()
atualizaGeneroFilmesNaInterface id genero = do 
    let posicao = getMoviePosition id 
    writeMatrixValue interfaceMenuCompra ("Gênero: " ++ genero) (head posicao + 2) (last posicao) 


-- Pega um filme pelo seu id
getFilmeByID :: Int -> IO Filme
getFilmeByID id = do
    filmes <- getAllFilmesJSON  -- Obter a lista de filmes
    return $ fromMaybe (Filme (-1) "" "" "") (getFilmeAuxiliar id filmes)

-- Verifica se um filme foi cadastrado a partir do id
contemFilme :: Int -> [Filme] -> Bool
contemFilme _ [] = False
contemFilme idFilme (x:xs)
    | ident x == idFilme = True
    | otherwise = contemFilme idFilme xs

-- Função auxiliar para obter um filme da lista pelo ID
getFilmeAuxiliar :: Int -> [Filme] -> Maybe Filme
getFilmeAuxiliar _ [] = Nothing
getFilmeAuxiliar identifierS (x:xs)
    | ident x == identifierS = Just x
    | otherwise = getFilmeAuxiliar identifierS xs

getMoviePosition :: Int -> [Int]
getMoviePosition id
    | id == 1 = [12, 5]
    | id == 2 = [17, 5]
    | id == 3 = [22, 5]
    | id == 4 = [27, 5]
    | id == 5 = [32, 5]