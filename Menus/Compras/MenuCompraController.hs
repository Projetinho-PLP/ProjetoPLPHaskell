module Menus.Compras.MenuCompraController where
import System.IO ( hFlush, stdout )
import Utilitarios.Matriz.MatrizServices (printMatrix)


startMenuCompra :: IO()
startMenuCompra = do
    printMatrix "./Interfaces/Compras/MenuCompras.txt"
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    print userChoice
