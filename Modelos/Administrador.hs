module Modelos.Administrador where

import GHC.Generics ( Generic )

data Administrador = Administrador {
    ident:: Int,
    login:: String,
    senha:: String
} deriving (Show, Generic)