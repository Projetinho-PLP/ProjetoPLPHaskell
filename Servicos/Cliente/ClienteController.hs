{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
{-# HLINT ignore "Use when" #-}

module Servicos.Cliente.ClienteController where


import Control.Concurrent (threadDelay)
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import Data.Bool (Bool)
import qualified Data.ByteString.Lazy as B
import Data.List (delete)
import Data.Maybe
import Data.String (String)
import System.Directory

import Modelos.Filme (Filme)
import Modelos.Cliente (Cliente(filmesAssistidos,email))
import Modelos.Cliente
import GHC.Arr (listArray)

instance FromJSON Cliente
instance ToJSON Cliente

-- Constantes
constantePATH :: String
constantePATH = "./BancoDeDados/Cliente.json"
constanteTempPATH :: String
constanteTempPATH = "./BancoDeDados/ClienteTemp.json"

-- Função que comunica com Menu de compra para determinar se o Cliente existe na base de dados
compraCliente:: Cliente -> IO()
compraCliente cliente = do
    clienteLista <- getClienteJSON
    if verificaCliente cliente clienteLista
        then 
            adicionaFilmeCliente (email cliente) (filmesAssistidos cliente)
        else
            cadastraCliente cliente


--------------------------------------------------------------------------
-- FUNÇÕES INTERNAS

-- Adiciona um novo cliente ao banco
cadastraCliente:: Cliente -> IO()
cadastraCliente cliente = do
    let conteudo = getClienteJSON
    listaSessoes <- retornaLista conteudo cliente

    B.writeFile constanteTempPATH $ encode listaSessoes
    removeFile constantePATH
    renameFile constanteTempPATH constantePATH

-- Adiciona um novo filme ao um cliente que existe
adicionaFilmeCliente:: String -> [Filme] -> IO()
adicionaFilmeCliente email filme = do
    lista <- getClienteJSON
    let clienteBanco = getClienteByEmail email lista
    let filmesNovo = filme ++ (filmesAssistidos clienteBanco) 
    let novoCliente = Cliente email filmesNovo
    let listaClienteRemovido = removeCliente email lista
    let novaLista = listaClienteRemovido ++ [novoCliente]

    B.writeFile constanteTempPATH $ encode novaLista
    removeFile constantePATH
    renameFile constanteTempPATH constantePATH


-- Recebe um IO[Cliente] e um Cliente e retorna uma nova lista adicionando as duas
retornaLista :: IO [Cliente] -> Cliente -> IO [Cliente]
retornaLista clientesAtual cliente = do
  lista <- clientesAtual
  return (lista ++ [cliente])

-- Retorna uma lista de Clientes
getClienteJSON:: IO [Cliente]
getClienteJSON = do
    file <- B.readFile constantePATH
    let decodedFile = decode file :: Maybe [Cliente]
    case decodedFile of
        Nothing -> pure []
        Just out -> pure out

-- Verifica se o cliente existe 
verificaCliente :: Cliente -> [Cliente] -> Bool
verificaCliente  _ [] = False
verificaCliente cliente (clienteAtual: resto)
    | email cliente == email clienteAtual = True
    | otherwise = verificaCliente cliente resto

-- Retorna um cliente (caso ele existe), com base no seu email
getClienteByEmail:: String -> [Cliente] -> Cliente
getClienteByEmail _ [] = Cliente "" []
getClienteByEmail emailC (x:xs)
    | emailC == (email x) = x
    | otherwise = getClienteByEmail emailC xs

-- Remove um cliente com base no seu email
removeCliente:: String -> [Cliente] -> [Cliente]
removeCliente _ [] = []
removeCliente emailC (x:xs) 
    | emailC == (email x) = xs
    | otherwise = [x] ++ (removeCliente emailC xs)

