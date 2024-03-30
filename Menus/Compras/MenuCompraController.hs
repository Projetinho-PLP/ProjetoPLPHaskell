{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}
module Menus.Compras.MenuCompraController where
import System.IO ( hFlush, stdout )
import Servicos.Matriz.MatrizServices (printMatrix, writeMatrixValue)
import Servicos.Filmes.FilmesController (loadMovies, getFilmeByID)
import Control.Concurrent (threadDelay)
import Modelos.Cliente 
import Servicos.Cliente.ClienteController (compraCliente)
import Servicos.Compra.CompraController (adicionaCompraJSON)
import Modelos.Compra (Compra(Compra, emailCliente))
import Servicos.Sessao.SessaoServico (getSessaoByID, getSessaoByNumeroDaInterface)
import Modelos.Filme (Filme(titulo))
import Data.Char
import Modelos.Sessao (Sessao(Sessao, ident))

interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"


startMenuCompra :: IO ()
startMenuCompra = do
    loadMovies
    printMatrix interfaceMenuCompra
    putStr "Antes de fazer a compra, por favor informe o seu email: "
    hFlush stdout
    emailCliente <- getLine
    putStrLn "Por favor, insira o número do filme e o número da sessão que deseja comprar"
    hFlush stdout
    putStr "Número do Filme:"
    hFlush stdout
    numeroFilme <- readLn :: IO Int
    putStr "Número da Sessão:"
    hFlush stdout
    numeroSessao <- readLn :: IO Int
    filmeCompra <- getFilmeByID numeroFilme
    sessaoCompra <- getSessoesCompradas numeroSessao (titulo filmeCompra)
    let compra = Compra (-1) emailCliente [] (maybe [] (\sessao -> [sessao]) sessaoCompra)
    mostraOpcoesNaInterface compra
    hFlush stdout

getSessoesCompradas :: Int -> String -> IO (Maybe Sessao)
getSessoesCompradas numeroSessao tituloFilme = do
    sessaoCompra <- getSessaoByNumeroDaInterface numeroSessao tituloFilme
    if Modelos.Sessao.ident sessaoCompra == 0
        then do
            putStrLn "Número de sessão inválido, aguarde!"
            threadDelay 2000000
            startMenuCompra
            return Nothing
        else return $ Just sessaoCompra

mostraOpcoesNaInterface :: Compra -> IO()
mostraOpcoesNaInterface compra = do
    putStr ("Digite 'F' para finalizar a compra e 'C' para cancelar a compra: ")
    hFlush stdout
    resposta <- getLine
    verificaEscolha compra (map toUpper resposta)

verificaEscolha :: Compra -> String -> IO ()
verificaEscolha compra resposta
  | resposta == "F" = do
      print $ show compra  
  | resposta == "C" = do
    putStr "Compra Cancelada!"
    threadDelay 1005000
    startMenuCompra
  | otherwise = putStr  "Opção não disponível"

associaCompraACliente :: String -> Filme -> IO()
associaCompraACliente emailCliente filmeCompra = do 
    let cliente = Cliente emailCliente [filmeCompra]
    compraCliente cliente



