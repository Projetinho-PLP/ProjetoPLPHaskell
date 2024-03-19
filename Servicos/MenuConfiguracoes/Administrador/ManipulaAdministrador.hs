{-# LANGUAGE OverloadedStrings #-}

module Servicos.MenuConfiguracoes.Administrador.ManipulaAdministrador where

import Data.Aeson ( FromJSON, ToJSON, encode,decode )
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC
import System.IO.Unsafe ( unsafePerformIO )
import System.Directory ( removeFile, renameFile )
import System.IO.Error (catchIOError)

import Modelos.Administrador
import Modelos.Administrador (Administrador (Administrador))
import Data.String (String)
import GHC.Arr (listArray)
import Control.Concurrent (addMVarFinalizer)
import Data.Foldable (Foldable(length))

instance FromJSON Administrador
instance ToJSON Administrador

constantePATH:: String
constantePATH = "./BancoDeDados/Administrador.json"

constanteTempPATH:: String
constanteTempPATH = "./BancoDeDados/TempAdministrador.json"

retornaLista :: IO [Administrador] -> Administrador -> IO [Administrador]
retornaLista acaoLista admin = do
    lista <- acaoLista
    return (lista ++ [mudaId (length lista + 1) admin])

getAdministradorJSON :: IO [Administrador]
getAdministradorJSON = do
  file <- B.readFile constantePATH
  let decodedFile = decode file :: Maybe [Administrador]
  case decodedFile of
    Nothing -> pure []
    Just out -> pure out


mudaId:: Int -> Administrador -> Administrador
mudaId newIdent administrador = administrador { ident = newIdent }


adicionarAdministradorJSON :: Administrador -> IO()
adicionarAdministradorJSON administrador = do
    let conteudo = getAdministradorJSON
    listaAdmins <- retornaLista conteudo administrador
    
    B.writeFile constanteTempPATH $ encode listaAdmins
    removeFile constantePATH
    renameFile constanteTempPATH constantePATH
    