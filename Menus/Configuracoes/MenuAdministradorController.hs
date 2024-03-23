module Menus.Configuracoes.MenuAdministradorController where

import Servicos.Matriz.MatrizServices ( printMatrix )
import Servicos.MenuConfiguracoes.Administrador.ManipulaAdministrador ( adicionarAdministradorJSON  )
import System.IO ( hFlush, stdout )
import Control.Concurrent ( threadDelay )
import Data.Char (toUpper)

import Modelos.Administrador
import Modelos.Filme (Filme(duracao, Filme))
import Servicos.Filmes.FilmesController (adicionarFilmeJSON)



startMenuAdmin::IO()
startMenuAdmin = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoesAdmin.txt"
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    let userChoiceUpper = map toUpper userChoice
    escolhaMenu userChoiceUpper

escolhaMenu :: String -> IO()
escolhaMenu userChoice
    | userChoice == "A" = adicionarAdministrador
    | userChoice == "F" = adicionarFilmes
    | otherwise = do
        putStrLn "\nOpção inválida"
        threadDelay 700000
        startMenuAdmin

adicionarAdministrador :: IO()
adicionarAdministrador = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"
    putStr "Digite seu user: "
    hFlush stdout
    user <- getLine
    putStr "Digite sua senha: "
    hFlush stdout
    senha <- getLine
    let administrador = Administrador 0 user senha
   -- putStrLn $ show administrador
    adicionarAdministradorJSON administrador >>= \_ -> startMenuAdmin
    


-- Modifique como quiser essa função
adicionarFilmes :: IO()
adicionarFilmes = do
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
    startMenuAdmin