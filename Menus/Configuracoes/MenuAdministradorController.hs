module Menus.Configuracoes.MenuAdministradorController where

import Servicos.Matriz.MatrizServices ( printMatrix )
import Servicos.MenuConfiguracoes.Administrador.ManipulaAdministrador ( adicionarAdministradorJSON  )
import System.IO ( hFlush, stdout )
import Control.Concurrent ( threadDelay )
import Data.Char (toUpper)
--import GHC.IO.FD (stdout)
--import GHC.IO.Handle (hFlush)

import Modelos.Administrador
import Modelos.Sessao
import Modelos.Filme (Filme(duracao, Filme))

import Servicos.Filmes.FilmesController (adicionarFilmeJSON,getFilmeByID,contemFilme,getAllFilmesJSON,checaNumeroMaximoDeFilmesAtingido)
import Servicos.Sessao.SessaoServico (adicionaSessaoJSON, getSessoesJSON, adicionaSessao, deletaSessao, contemSessao)



startMenuAdmin::IO () -> IO ()
startMenuAdmin startMenuPrincipal = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoesAdmin.txt"
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    let userChoiceUpper = map toUpper userChoice
    escolhaMenu userChoiceUpper startMenuPrincipal
    startMenuAdmin startMenuPrincipal


escolhaMenu :: String -> IO () -> IO ()
escolhaMenu userChoice startMenuPrincipal
    | userChoice == "A" = adicionarAdministrador startMenuPrincipal
    | userChoice == "F" = adicionarFilmes startMenuPrincipal
    | userChoice == "S" = adicionarSessao
    | userChoice == "DS" = deletarSessao
    | userChoice == "V" = startMenuPrincipal
    | otherwise = do
        putStrLn "\nOpção inválida"
        threadDelay 700000
        startMenuAdmin startMenuPrincipal


adicionarAdministrador :: IO () -> IO ()
adicionarAdministrador startMenuPrincipal = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"
    putStr "Digite seu user: "
    hFlush stdout
    user <- getLine
    putStr "Digite sua senha: "
    hFlush stdout
    senha <- getLine
    let administrador = Administrador 0 user senha
   -- putStrLn $ show administrador
    adicionarAdministradorJSON administrador >> startMenuAdmin startMenuPrincipal



-- Modifique como quiser essa função
adicionarFilmes :: IO () -> IO ()
adicionarFilmes startMenuPrincipal = do
    numeroDeFilmes <- checaNumeroMaximoDeFilmesAtingido
    if numeroDeFilmes
        then do
            putStr "Número maximo de filmes atingido"
            threadDelay 3000000
            startMenuAdmin startMenuPrincipal
    else do
        printMatrix "./Interfaces/Configuracoes/MenuCadastroDeFilmes.txt"
        putStr "Digite o título do filmes: "
        hFlush stdout
        titulo <- getLine
        putStr "Digite a duração do filme: "
        hFlush stdout
        duracao <- getLine
        putStr "Digite o genero do filme:"
        genero <- getLine
        let filme = Filme 0 titulo duracao genero
        adicionarFilmeJSON filme
        startMenuAdmin startMenuPrincipal

adicionarSessao :: IO()
adicionarSessao = do
    printMatrix "./Interfaces/Configuracoes/ManuCadastroSessao.txt"
    putStr "Digite o Identificador do filme: "
    hFlush stdout
    idFilme <- readLn:: IO Int
    filmes <- getAllFilmesJSON
    if contemFilme idFilme filmes then
        do
            filme <- getFilmeByID idFilme
            putStr "Digite o horario no formato (<hora>, <minutos>): "
            hFlush stdout
            horario <- readLn:: IO(Int, Int)
            putStr "Informe a capacidade: "
            hFlush stdout
            capacidade <- readLn::IO(Int)
            putStr "Informe o ID da sala: "
            hFlush stdout
            idSala <- readLn::IO(Int)
            let novaSessao = Sessao 0 filme horario capacidade idSala
            sessoesExistem <- getSessoesJSON
            adicionaSessao novaSessao
        else do
            putStrLn "Filme não registrado"
            threadDelay 1200000


deletarSessao :: IO ()
deletarSessao = do
    putStr "Digite o Identificador da Sessão: "
    hFlush stdout
    idSessao <- readLn:: IO Int
    sessoes <- getSessoesJSON
    if contemSessao idSessao sessoes then
        do
            deletaSessao idSessao
        else do
            putStrLn "Sessao não registrada"
            threadDelay 1200000