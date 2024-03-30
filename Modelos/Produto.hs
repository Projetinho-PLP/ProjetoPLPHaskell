{-# LANGUAGE DeriveGeneric #-}
module Modelos.Produto where


import GHC.Generics ( Generic )
import Data.Aeson ( FromJSON, ToJSON )


data Produto = Produto {
    ident:: Int,
    nomeProduto:: String,
    precoProduto:: String
} deriving (Show, Generic)

instance FromJSON Produto

instance ToJSON Produto