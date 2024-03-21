{-# LANGUAGE DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# LANGUAGE StrictData #-}
module Modelos.Filme where

import GHC.Generics ( Generic )

data Filme = Filme {
    ident:: Int,
    name:: String,
    duracao:: String
} deriving (Show, Generic)