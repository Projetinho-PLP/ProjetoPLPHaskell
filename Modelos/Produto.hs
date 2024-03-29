{-# LANGUAGE DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# LANGUAGE StrictData #-}
module Modelos.Produto where

import GHC.Generics ( Generic )
import Data.Aeson ( FromJSON, ToJSON )

data Produto = Produto {
    ident:: Int,
    nome:: String,
    categoria:: String,
    valor:: String
} deriving (Show, Generic)

instance FromJSON Produto
instance ToJSON Produto