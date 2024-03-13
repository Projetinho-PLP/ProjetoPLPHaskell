module Menus.Principal.MenuPrincipalController where

import System.IO ( hFlush, stdout )
import Data.Char (toUpper)
import Control.Concurrent ( threadDelay )
import Menus.Compras.MenuCompraController ( startMenuCompra )
import Utilitarios.Matriz.MatrizServices ( printMatrix )

startMenu :: IO ()
startMenu = do
    printMatrix "./Interfaces/Principal/MenuPrincipal.txt"
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    let upperUserChoice = map toUpper userChoice
    optionsStartMenu upperUserChoice  

--A partir da letra selecionada, chama o controller especifico de algum menu
optionsStartMenu :: String -> IO ()
optionsStartMenu userChoice
    | userChoice == "C" = startMenuCompra 
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        startMenu
