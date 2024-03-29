{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use <$>" #-}
{-# HLINT ignore "Use when" #-}
module Servicos.Bomboniere.BomboniereService where

import Control.Concurrent (threadDelay)
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import Data.Bool (Bool)
import Data.ByteString.Lazy qualified as B
import Data.List (delete)
import Data.Maybe
import Data.String (String)
import Modelos.Administrador qualified
import Modelos.Produto
import System.Directory

constantePATH :: String
constantePATH = "./BancoDeDados/Produtos.json"

constanteTempPATH :: String
constanteTempPATH = "./BancoDeDados/ProdutosTemp.json"

-- Retorna uma lista com todos os produtos cadastrados
getProdutosJSON :: IO [Produto]
getProdutosJSON = do
  file <- B.readFile constantePATH
  let decodedFile = decode file :: Maybe [Produto]
  case decodedFile of
    Nothing -> pure []
    Just out -> pure out

-- Recebe um IO[Sessao] e uma sessao e retorna uma nova lista adicionando as duas
retornaLista :: IO [Produto] -> Produto -> IO [Produto]
retornaLista acaoLista produto = do
  lista <- acaoLista
  return (lista ++ [mudaId (length lista + 1) produto])

-- Muda o id de umma sessao de acordo com a quantidade de produtos
mudaId :: Int -> Produto -> Produto
mudaId newIdent produto = produto {Modelos.Produto.ident = newIdent}

-- Adiciona uma produto ao arquivo JSON
adicionaProdutoJSON :: Produto -> IO ()
adicionaProdutoJSON produto = do
  let conteudo = getProdutosJSON
  listaProdutos <- retornaLista conteudo produto

  B.writeFile constanteTempPATH $ encode listaProdutos
  removeFile constantePATH
  renameFile constanteTempPATH constantePATH

-- Deleta uma produto do arquivo JSON a partir do identificador
deletaProduto :: Int -> IO ()
deletaProduto identificador = do
  produtos <- getProdutosJSON
  let novaLista = deleteProdutoPorIdentificador identificador produtos
  if length novaLista /= length produtos
    then do
      B.writeFile constanteTempPATH $ encode novaLista
      removeFile constantePATH
      renameFile constanteTempPATH constantePATH
      putStrLn "Produto deletado com sucesso!"
      threadDelay 1200000
    else do
      putStrLn "Não foi encontrado um produto com o identificador fornecido."
      threadDelay 1200000

-- Remove uma produto da lista com base no identificador
deleteProdutoPorIdentificador :: Int -> [Produto] -> [Produto]
deleteProdutoPorIdentificador _ [] = []
deleteProdutoPorIdentificador identificador (produto : outrosProdutos)
  | Modelos.Produto.ident produto == identificador = outrosProdutos
  | otherwise = produto : deleteProdutoPorIdentificador identificador outrosProdutos

-- Verifica se uma sessao foi cadastrado a partir do id
contemProduto :: Int -> [Produto] -> Bool
contemProduto _ [] = False
contemProduto idProduto (produto:outrosProdutos)
    | Modelos.Produto.ident produto == idProduto = True
    | otherwise = contemProduto idProduto outrosProdutos

-- Funções que se comunicam com o Controller
-- Realiza as validações na sessao para adicionar ao JSON
adicionaProduto :: Produto -> IO ()
adicionaProduto produto = do
    adicionaProdutoJSON produto
    putStrLn "Produto cadastrado com sucesso!!"
    threadDelay 1200000
