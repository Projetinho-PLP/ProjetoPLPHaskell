module Menus.Bomboniere.MenuBomboniereController where
import Servicos.Matriz.MatrizServices
import System.IO (hFlush,stdout)
import Servicos.Bomboniere.BomboniereService (adicionaProduto)

interfaceMenuBomboniere :: String
interfaceMenuBomboniere = "./Interfaces/Compras/Bomboniere/MenuBomboniere.txt"

startMenuBomboniere :: IO()
startMenuBomboniere = do
    printMatrix interfaceMenuBomboniere
    putStr "Digite uma opção: "
    hFlush stdout
    userChoice <- getLine
    print userChoice