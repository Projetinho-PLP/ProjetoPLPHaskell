{-# LANGUAGE DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# LANGUAGE StrictData #-}

module Modelos.Sessao where

import Modelos.Filme 

import GHC.Generics ( Generic )

data Sessao = Sessao {
    ident:: Int,
    filme:: Filme,
    horario:: (Int, Int),
    capacidade:: Int,
    idSala:: Int
} deriving (Show, Generic)
