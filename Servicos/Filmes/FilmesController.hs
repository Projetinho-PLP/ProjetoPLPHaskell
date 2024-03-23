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

instance FromJSON Filme
instance ToJSON Filme


--- Constante Utilizadas
constantePATH:: String
constantePATH = "./BancoDeDados/Filme.json"

constanteTempPATH:: String
constanteTempPATH = "./BancoDeDados/TempFilme.json"

interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"
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
adicionarFilmeJSON administrador = do
  let conteudo = getAllFilmesJSON
  listaAdmins <- retornaLista conteudo administrador

  B.writeFile constanteTempPATH $ encode listaAdmins
  removeFile constantePATH
  renameFile constanteTempPATH constantePATH

---------------------------------------------------

loadMovies :: IO ()
loadMovies = do
    filmes <- getAllFilmesJSON
    atualizaFilmes filmes

--loadMovies :: IO ()
--loadMovies = do
  --  base <- readFile "./Interfaces/Compras/MenuComprasBase.txt"
   -- writeFile interfaceMenuCompra base
   -- let position = getMoviePosition 2
   -- writeMatrixValue interfaceMenuCompra " Outro Aqui " (head position) (last position)


atualizaFilmes :: [Filme] -> IO ()
atualizaFilmes [] = return ()
atualizaFilmes (x:xs) = do
    let id = ident x
    atualizaFilmeNaInterface id (titulo x)
    atualizaFilmes xs

atualizaFilmeNaInterface :: Int -> String -> IO ()
atualizaFilmeNaInterface  id titulo = do
    let posicao = getMoviePosition id
    writeMatrixValue interfaceMenuCompra titulo (head posicao) (last posicao)

-- Pega um filme pelo seu id
getFilmeByID :: Int -> IO Filme
getFilmeByID id = do
    filmes <- getAllFilmesJSON  -- Obter a lista de filmes
    return $ fromMaybe (Filme (-1) "" "" "") (getFilmeAuxiliar id filmes)

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