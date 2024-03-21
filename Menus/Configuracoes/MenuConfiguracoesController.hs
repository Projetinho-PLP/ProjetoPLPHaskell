-- O sistema possui um menu de configurações onde é possível cadastrar um administrador. 
-- Administradores possuem um user e uma senha.

-- Todas as user stories associadas a administradores exigem autorização, 
-- que é realizada via user e a senha de algum administrador.

module Menus.Configuracoes.MenuConfiguracoesController where
import System.IO ( hFlush, stdout )
import Servicos.Matriz.MatrizServices ( printMatrix )
import Data.Char (toUpper)
import Control.Concurrent ( threadDelay )
import Modelos.Administrador
import Servicos.MenuConfiguracoes.Administrador.ManipulaAdministrador ( adicionarAdministradorJSON, validarAdministradorJSON  )
import Menus.Configuracoes.MenuAdministradorController ( startMenuAdmin )

startMenuConfiguracao :: IO()
startMenuConfiguracao = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoes.txt"
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    let userChoiceUpper = map toUpper userChoice
    escolhaMenu userChoiceUpper

escolhaMenu :: String -> IO()
escolhaMenu userChoice
    | userChoice == "L" = loginAdministrador
    | otherwise = do
        putStrLn "\nOpção inválida!"
        threadDelay 700000
        startMenuConfiguracao


loginAdministrador :: IO()
loginAdministrador = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"
    putStr "Digite seu user: "
    hFlush stdout
    user <- getLine
    putStr "Digite sua senha: "
    hFlush stdout
    senha <- getLine
    let administrador = Administrador 0 user senha
    validacao <- validarAdministradorJSON administrador
    if (validacao == True)
        then startMenuAdmin
        else loginAdministrador
    
    

