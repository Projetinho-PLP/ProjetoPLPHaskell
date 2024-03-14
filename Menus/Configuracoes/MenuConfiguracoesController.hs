-- O sistema possui um menu de configurações onde é possível cadastrar um administrador. 
-- Administradores possuem um user e uma senha.

-- Todas as user stories associadas a administradores exigem autorização, 
-- que é realizada via user e a senha de algum administrador.

module Menus.Configuracoes.MenuConfiguracoesController where
import System.IO ( hFlush, stdout )
import Utilitarios.Matriz.MatrizServices ( printMatrix )

startMenuConfiguracao :: IO()
startMenuConfiguracao = do
    printMatrix "./Interfaces/Configuracoes/menuConfiguracoes.txt"
    putStr "Informe seu usuario: "
    hFlush stdout
    userChoice <- getLine
    print userChoice