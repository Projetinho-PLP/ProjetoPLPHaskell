{-# LANGUAGE DeriveGeneric #-}
module Modelos.Compra where

import GHC.Generics ( Generic )
import Modelos.Produto
import Modelos.Sessao (Sessao)

data Compra = Compra {
    ident:: Int,
    emailCliente:: String,
    produtosComprados:: [Produto],
    sessoesCompradas:: [Sessao]
} deriving (Show, Generic)

