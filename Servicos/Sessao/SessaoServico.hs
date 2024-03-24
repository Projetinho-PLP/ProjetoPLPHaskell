{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
module Servicos.Sessao.SessaoServico where


import Modelos.Sessao
--import Modelos.Filme
import qualified Data.ByteString.Lazy as B
import Data.Aeson
import System.Directory
import Data.Maybe
import Data.Bool (Bool)
import Modelos.Sessao (Sessao(horario))

--instance FromJSON Sessao
--instance ToJSON Sessao

adicionaSessao:: Sessao -> IO()
adicionaSessao sessao = do
    if validaHorario (horario sessao)
        then
            print("horario valido")
        else
            print("hoario invalido")
    

--validaSessao:: Sessao -> IO Bool
--validaSessao sessao = do

validaHorario:: (Int, Int) -> Bool
validaHorario (hora, minuto) = (hora >= 0 && hora <= 23) && (minuto >=0 && minuto <= 59)
