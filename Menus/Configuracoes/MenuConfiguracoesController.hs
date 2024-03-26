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

startMenuConfiguracao :: IO () -> IO ()
startMenuConfiguracao startMenuPrincipal = do
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
        then startMenuAdmin startMenuPrincipal
        else loginInvalido startMenuPrincipal

loginInvalido :: IO () -> IO ()
loginInvalido startMenuPrincipal = do
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
        then startMenuAdmin startMenuPrincipal
        else loginInvalido startMenuPrincipal
