-- O sistema possui um menu de configurações onde é possível cadastrar um administrador. 
-- Administradores possuem um user e uma senha.

-- Todas as user stories associadas a administradores exigem autorização, 
-- que é realizada via user e a senha de algum administrador.

module Menus.Configuracoes.MenuConfiguracoesController where
import System.IO ( hFlush, stdout )
import Servicos.Matriz.MatrizServices ( printMatrix, writeMatrixValue )
import Data.Char (toUpper)
import Control.Concurrent ( threadDelay )
import Modelos.Administrador
import Servicos.MenuConfiguracoes.Administrador.ManipulaAdministrador ( adicionarAdministradorJSON, validarAdministradorJSON  )
import Menus.Configuracoes.MenuAdministradorController ( startMenuAdmin )
import Data.String (String)

interfaceLogin :: String
interfaceLogin = "./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"

startMenuConfiguracao :: IO()
startMenuConfiguracao = do
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
        else loginInvalido

loginInvalido :: IO()
loginInvalido = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoesLoginInvalido.txt"
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
        else loginInvalido
