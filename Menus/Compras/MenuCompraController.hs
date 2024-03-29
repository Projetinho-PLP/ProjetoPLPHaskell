module Menus.Compras.MenuCompraController where
import System.IO ( hFlush, stdout )
import Servicos.Matriz.MatrizServices (printMatrix, writeMatrixValue)
import Servicos.Filmes.FilmesController (loadMovies)
import Control.Concurrent (threadDelay)

interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"

startMenuCompra :: IO()
startMenuCompra = do
    loadMovies
    printMatrix interfaceMenuCompra
    putStr "Por favor, insira o número do filme e o número da sessão que deseja comprar\n"
    threadDelay 1000000
    hFlush stdout
    putStr "Número do Filme:"
    hFlush stdout
    numeroFilme <- getLine
    putStr "Número da Sessão:"
    hFlush stdout
    numeroSessao <- getLine
    print numeroFilme
    print numeroSessao


