module Menus.Compras.MenuCompraController where
import System.IO ( hFlush, stdout )
import Servicos.Matriz.MatrizServices (printMatrix, writeMatrixValue)
import Servicos.Filmes.FilmesController (loadMovies)

interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"

startMenuCompra :: IO()
startMenuCompra = do
    loadMovies
    printMatrix interfaceMenuCompra
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    print userChoice


