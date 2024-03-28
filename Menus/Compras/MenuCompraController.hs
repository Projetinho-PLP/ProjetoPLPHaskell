module Menus.Compras.MenuCompraController where
import System.IO ( hFlush, stdout )
import Servicos.Matriz.MatrizServices (printMatrix, writeMatrixValue)
import Servicos.Filmes.FilmesController (loadMovies, getFilmeByID)
import Control.Concurrent (threadDelay)
import Modelos.Cliente 
import Servicos.Cliente.ClienteController (compraCliente)

interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"

startMenuCompra :: IO()
startMenuCompra = do
    loadMovies
    printMatrix interfaceMenuCompra
    putStr "Antes de fazer a compra, por favor informe o seu email: "
    hFlush stdout
    emailCliente <- getLine
    threadDelay 1000000
    putStr "Por favor, insira o número do filme e o número da sessão que deseja comprar\n"
    threadDelay 1000000
    hFlush stdout
    putStr "Número do Filme:"
    hFlush stdout
    numeroFilme <- readLn :: IO Int
    putStr "Número da Sessão:"
    hFlush stdout
    numeroSessao <- getLine
    filmeCompra <- getFilmeByID numeroFilme
    let cliente = Cliente emailCliente [filmeCompra]
    compraCliente cliente
    print numeroFilme
    print numeroSessao


