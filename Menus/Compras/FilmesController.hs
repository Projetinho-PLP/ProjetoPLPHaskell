{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Menus.Compras.FilmesController where

import Servicos.Matriz.MatrizServices (writeMatrixValue)


interfaceMenuCompra :: String
interfaceMenuCompra = "./Interfaces/Compras/MenuCompras.txt"

loadMovies :: IO ()
loadMovies = do
    base <- readFile "./Interfaces/Compras/MenuComprasBase.txt"
    writeFile interfaceMenuCompra base
    let position = getMoviePosition 2
    writeMatrixValue interfaceMenuCompra " Outro Aqui " (head position) (last position)

getMoviePosition :: Int -> [Int]
getMoviePosition id
    | id == 1 = [12, 5]
    | id == 2 = [17, 5]
    | id == 3 = [22, 5]
    | id == 4 = [27, 5]
    | id == 5 = [32, 5]    