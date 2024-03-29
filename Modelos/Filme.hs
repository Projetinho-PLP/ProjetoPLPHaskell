{-# LANGUAGE DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# LANGUAGE StrictData #-}
module Modelos.Filme where

import GHC.Generics ( Generic )
import Data.Aeson ( FromJSON, ToJSON )

data Filme = Filme {
    ident:: Int,
    titulo:: String,
    duracao:: String,
    genero:: String
} deriving (Show, Generic)

instance FromJSON Filme
instance ToJSON Filme