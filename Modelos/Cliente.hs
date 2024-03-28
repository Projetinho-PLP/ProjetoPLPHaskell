{-# LANGUAGE DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# LANGUAGE StrictData #-}

module Modelos.Cliente where

import Modelos.Filme

import GHC.Generics ( Generic )


data Cliente = Cliente {
    email:: String,
    filmesAssistidos:: [Filme]
} deriving(Show, Generic) 