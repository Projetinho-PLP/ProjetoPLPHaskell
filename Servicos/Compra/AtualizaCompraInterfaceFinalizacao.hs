{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Move brackets to avoid $" #-}
module Servicos.Compra.AtualizaCompraInterfaceFinalizacao where
import Modelos.Compra
import System.Directory
import Servicos.Matriz.MatrizServices


loadFinalizacaoCompra :: Compra -> IO()
loadFinalizacaoCompra compra = do
    conteudoBase <- readFile "./Interfaces/Compras/MenuFinalizacaoCompraBase.txt"
    writeFile "./Interfaces/Compras/MenuFinalizacaoCompra.txt" conteudoBase
    writeMatrixValue "./Interfaces/Compras/MenuFinalizacaoCompra.txt" ("* Email Comprador: "++ emailCliente compra) 12 24
    writeMatrixValue "./Interfaces/Compras/MenuFinalizacaoCompra.txt" ("* Número Ingressos Comprados: "++ (show $ numeroIngressos compra)) 15 24
    writeMatrixValue "./Interfaces/Compras/MenuFinalizacaoCompra.txt" ("* Valor da Compra: "++  (show $ valorComprado compra)) 18 24
    printMatrix "./Interfaces/Compras/MenuFinalizacaoCompra.txt"

