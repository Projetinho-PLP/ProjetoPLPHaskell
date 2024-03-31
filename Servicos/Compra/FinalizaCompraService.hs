{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Servicos.Compra.FinalizaCompraService where
import Modelos.Compra
import Servicos.Compra.AtualizaCompraInterfaceFinalizacao (loadFinalizacaoCompra)
import System.IO ( hFlush, stdout )
import Data.Char
import Control.Concurrent (threadDelay)
import Servicos.Compra.CompraController (adicionaCompraJSON)
import Servicos.Sessao.SessaoController
import Servicos.Sessao.SessaoController


finalizaCompraService :: IO() -> Compra -> IO()
finalizaCompraService startMenuCompra compra = do 
    loadFinalizacaoCompra compra
    putStr "Escolha uma opção: "
    hFlush stdout 
    userChoice <- getLine 
    verificaEscolhaUser startMenuCompra compra (map toUpper userChoice)

verificaEscolhaUser :: IO() -> Compra -> String -> IO ()
verificaEscolhaUser startMenuCompra compra userChoice 
 | userChoice == "F" = do
    adicionaCompraJSON compra
    let idSessao = getIdPrimeiraSessao compra
    case idSessao of
        Nothing -> print "Nada"
        Just id -> diminueCapacidadeSessao (numeroIngressos compra) id
    putStr "Compra Realizada!"
    threadDelay 1000000
    startMenuCompra
 | userChoice == "C" = do
    putStr "Compra Cancelada!"
    threadDelay 1000000
    startMenuCompra