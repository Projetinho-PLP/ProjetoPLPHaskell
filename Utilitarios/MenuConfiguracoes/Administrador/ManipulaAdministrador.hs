{-# LANGUAGE OverloadedStrings #-}

module Utilitarios.MenuConfiguracoes.Administrador.ManipulaAdministrador where

import Data.Aeson ( FromJSON, ToJSON, encode,decode )
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BC
import System.IO.Unsafe ( unsafePerformIO )
import System.Directory ( removeFile, renameFile )

import Modelos.Administrador
import Modelos.Administrador (Administrador (Administrador))
--import Menus.Configuracoes.MenuConfiguracoesController (startMenuConfiguracao)

instance FromJSON Administrador
instance ToJSON Administrador

constantePATH:: String
constantePATH = "./BancoDeDados/Administrador.json"

getAdministradorJSON::[Administrador]
getAdministradorJSON = do
    let file = unsafePerformIO( B.readFile constantePATH )
    let decodedFile = decode file :: Maybe [Administrador]
    case decodedFile of
        Nothing -> []
        Just out -> out

mudaId:: Int -> Administrador -> Administrador
mudaId newIdent administrador = administrador { ident = newIdent }


adicionarAdministradorJSON :: Administrador -> IO()
adicionarAdministradorJSON administrador = do
    -- let p = People identifier name
    -- let PATH = "./DancoDeDados/Administrador.json"
    --let conteudo = getAdministradorJSON
    let conteudos = (getAdministradorJSON) ++ [mudaId (length getAdministradorJSON) administrador]

    B.writeFile "./BancoDeDados/Temp.json" $ encode conteudos
    removeFile constantePATH
    renameFile "./BancoDeDados/Temp.json" constantePATH
