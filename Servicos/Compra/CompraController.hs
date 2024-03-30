{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
{-# HLINT ignore "Redundant bracket" #-}
module Servicos.Compra.CompraController where
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import Modelos.Compra (Compra (ident, Compra))
import qualified Data.ByteString.Lazy as B
import System.Directory ( removeFile, renameFile )
import Data.Maybe

instance FromJSON Compra

instance ToJSON Compra

constantePATH :: String
constantePATH = "./BancoDeDados/Compra.json"

constanteTempPATH :: String
constanteTempPATH = "./BancoDeDados/CompraTemp.json"

-- Retorna uma lista com todas as compras cadastradas
getComprasJSON :: IO [Compra]
getComprasJSON = do
  file <- B.readFile constantePATH
  let decodedFile = decode file :: Maybe [Compra]
  case decodedFile of
    Nothing -> pure []
    Just out -> pure out

-- Recebe um IO[Compra] e uma compra e retorna uma nova lista adicionando as duas
retornaLista :: IO [Compra] -> Compra -> IO [Compra]
retornaLista acaoLista compra = do
  lista <- acaoLista
  return (lista ++ [mudaId (length lista + 1) compra])


-- Muda o id de umma compra de acordo com a quantidade de compras
mudaId :: Int -> Compra -> Compra
mudaId newIdent compra = compra {Modelos.Compra.ident = newIdent}

-- Adiciona uma compra ao BD
adicionaCompraJSON :: Compra -> IO ()
adicionaCompraJSON compra = do
  let conteudo = getComprasJSON
  listaSessoes <- retornaLista conteudo compra

  B.writeFile constanteTempPATH $ encode listaSessoes
  removeFile constantePATH
  renameFile constanteTempPATH constantePATH

-- Pega uma compra pelo seu id
getCompraByID :: Int -> IO Compra
getCompraByID id = do
    compras <- getComprasJSON 
    let compraFake = Compra (-1) " " [] [] 
    let compra = fromMaybe compraFake (getCompraAuxiliar id compras)
    return compra


-- Função auxiliar para obter uma compra da lista pelo ID
getCompraAuxiliar :: Int -> [Compra] -> Maybe Compra
getCompraAuxiliar _ [] = Nothing
getCompraAuxiliar identifierS (x:xs)
    | ident x == identifierS = Just x
    | otherwise = getCompraAuxiliar identifierS xs