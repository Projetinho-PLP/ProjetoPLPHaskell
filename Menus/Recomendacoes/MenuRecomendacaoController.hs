module Menus.Recomendacoes.MenuRecomendacaoController where

import System.IO ( hFlush, stdout )
import Data.Char (toUpper)
import Control.Concurrent ( threadDelay )
import Servicos.Matriz.MatrizServices ( printMatrix )

import Servicos.Cliente.ClienteController( contemCliente )
import Servicos.Recomendacao.RecomendacaoController (recomendacaoCliente)

startMenuRecomendacoes:: (IO()) -> IO()
startMenuRecomendacoes backToMain = do
    printMatrix "./Interfaces/Recomendacoes/MenuRecomendacoes.txt"
    putStr "Digite seu email: "
    hFlush stdout
    email <- getLine
    verificaCliente <- contemCliente email
    if (verificaCliente)
        then do
            printMatrix "./Interfaces/Recomendacoes/MenuRecomendacoesInterno.txt"
            recomendacaoCliente email backToMain
        else do
            putStr "Email não cadastrao em nosso banco de dados."
            hFlush stdout
            threadDelay 1500000
            backToMain

