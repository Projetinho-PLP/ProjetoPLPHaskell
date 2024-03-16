module Filme.FilmeCRUD (
    Filme(..),
    criarFilme,
    lerFilme,
    atualizarFilme,
    deletarFilme
) where


data Filme = Filme { diretor :: String,
                     titulo :: String,
                     genero :: String
                     } deriving (Show, Eq)

type BancoDeDados = [Filme]

criarFilme :: BancoDeDados -> Filme -> BancoDeDados
criarFilme banco filme = filme : banco

lerFilme :: BancoDeDados -> String -> Maybe Filme
lerFilme [] _ = Nothing
lerFilme (filme:resto) titulo
    | titulo == titulo = Just filme
    | otherwise = lerFilme resto titulo

atualizarFilme :: BancoDeDados -> String -> Filme -> BancoDeDados
atualizarFilme [] _ _ = []
atualizarFilme (filme:resto) tituloNovo novoFilme
    | tituloNovo == titulo filme = novoFilme : resto
    | otherwise = filme : atualizarFilme resto tituloNovo novoFilme

deletarFilme :: BancoDeDados -> String -> BancoDeDados
deletarFilme [] _ = []
deletarFilme (filme:resto) titulo
    | titulo == titulo = resto
    | otherwise = filme : deletarFilme resto titulo

