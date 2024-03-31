{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use :" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# HLINT ignore "Redundant if" #-}
module Menus.Compras.MenuCompraController where
import System.IO ( hFlush, stdout )
import Servicos.Matriz.MatrizServices (printMatrix, writeMatrixValue)
import Servicos.Filmes.FilmesController (loadMovies, getFilmeByID)
import Control.Concurrent (threadDelay)
import Modelos.Cliente 
import Servicos.Cliente.ClienteController (compraCliente)
import Servicos.Compra.CompraController (adicionaCompraJSON, adicionaFilmeACOmpra)
import Modelos.Compra (Compra(Compra, emailCliente, numeroIngressos, sessoesCompradas))
import Servicos.Sessao.SessaoServico (getSessaoByID, getSessaoByNumeroDaInterface)
import Modelos.Filme (Filme(titulo))
import Data.Char
import Modelos.Sessao (Sessao(Sessao, ident))
import Servicos.Compra.AtualizaCompraInterfaceFinalizacao (loadFinalizacaoCompra)
import Servicos.Compra.FinalizaCompraService

interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"

startMenuCompra:: IO () -> IO ()
startMenuCompra startMenuPrincipal = do
    loadMovies
    printMatrix interfaceMenuCompra
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    let userChoiceUpper = map toUpper userChoice
    escolhaMenu userChoiceUpper startMenuPrincipal


escolhaMenu :: String -> IO () -> IO ()
escolhaMenu userChoice startMenuPrincipal
    | userChoice == "C" = getEmailComprador startMenuPrincipal
    | userChoice == "V" = startMenuPrincipal
    | otherwise = do
        putStrLn "\nOpção inválida"
        threadDelay 700000
        startMenuCompra startMenuPrincipal

getEmailComprador :: IO () -> IO ()
getEmailComprador startMenuPrincipal = do
    putStr "Antes de fazer a compra, por favor informe o seu email: "
    hFlush stdout
    emailComprador <- getLine
    startCompra (startMenuCompra startMenuPrincipal) emailComprador 
    


startCompra :: IO() -> String -> IO()
startCompra startMenuCompra emailComprador = do 
    printMatrix interfaceMenuCompra
    putStrLn "Por favor, insira o número do filme e o número da sessão que deseja comprar"
    hFlush stdout
    putStr "Número do Filme:"
    hFlush stdout
    numeroFilme <- readLn :: IO Int
    putStr "Número da Sessão:"
    hFlush stdout
    numeroSessao <- readLn :: IO Int
    filmeCompra <- getFilmeByID numeroFilme
    sessaoEValida <- isSessaoValida numeroSessao (titulo filmeCompra)
    if sessaoEValida  then do
        sessaoCompra <- getSessaoByNumeroDaInterface numeroSessao (titulo filmeCompra)
        putStr "Quantidade de Ingressos:"
        hFlush stdout
        numeroIngressos <- readLn :: IO Int
        hFlush stdout 
        let valorTotal = fromIntegral $ numeroIngressos *  5 ---Alterar para utilizar valor do ingresso!
        let compra = Compra (-1) emailComprador numeroIngressos [] [sessaoCompra]  valorTotal
        associaCompraACliente emailComprador filmeCompra
        finalizaCompraService startMenuCompra compra 
    else do 
        putStr "Sessao ou filme Invalidos"
        threadDelay 2000000
        startCompra startMenuCompra emailComprador


isSessaoValida :: Int -> String -> IO (Bool)
isSessaoValida numeroSessao tituloFilme = do
    sessaoCompra <- getSessaoByNumeroDaInterface numeroSessao tituloFilme
    if Modelos.Sessao.ident sessaoCompra == 0
        then return False
        else return True

getSessoesCompradas :: Int -> String -> IO (Maybe Sessao)
getSessoesCompradas numeroSessao tituloFilme = do
    sessaoCompra <- getSessaoByNumeroDaInterface numeroSessao tituloFilme
    if Modelos.Sessao.ident sessaoCompra == 0
        then do return Nothing
        else return $ Just sessaoCompra

associaCompraACliente :: String -> Filme -> IO()
associaCompraACliente emailCliente filmeCompra = do 
    let cliente = Cliente emailCliente [filmeCompra]
    compraCliente cliente




