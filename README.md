# ProjetoPLPHaskell

 CineLogic
 Sistema de automação de vendas para cinemas

### Componentes:
- pedro.braz@ccc.ufcg.edu.br
- fernando.lima@ccc.ufcg.edu.br
- alexandre.souto.medeiros@ccc.ufcg.edu.br
- carlos.henriche.goncalves@ccc.ufcg.edu.br
- gabriel.santos.alves@ccc.ufcg.edu.br

### Introdução
O cinelogic é uma solução projetada para simplificar e aprimorar todas as operações relacionadas à gestão de vendas de um cinema moderno, pensado para atender tanto às necessidades dos administradores quanto dos clientes.
O sistema permite aos administradores realizar atividades como: o cadastro e controle de filmes e produtos da bomboniere, a criação e gestão de sessões em salas específicas e ainda, a criação de combos que unificam a venda de ingressos e itens de bomboniere no mesmo pedido. 
Além disso, o sistema oferece recursos adicionais, como um menu de recomendações que sugere filmes com base no histórico de compras do cliente, e um menu de configurações que permite o cadastro de administradores com autorizações específicas.
Para os clientes, o sistema visa uma experiência de compra simplificada e personalizada. Os usuários podem explorar e adquirir ingressos, escolher assentos disponíveis e ainda ter acesso a combos que combinam produtos da bomboniere com ingressos de filmes.


### User Stories

#### Enquanto Administrador:
Filmes:
Cadastro\Remoção de filmes. Cada filme possui, título, duração, diretor, gênero e faixa etária.
Sessões:
As sessões criam a associação entre um filme, os horários que este vai ser exibido e uma sala específica.
O sistema permite a criação/edição de sessões. Cada sessão possui: um filme, um ou mais horários, um número de sala e a lotação máxima desta sala.
O sistema não permite a criação de uma sessão se já existe alguma sessão criada com aquela sala naquele/s horário/s.
Ingressos:
O sistema permite a Definição\Edição do valor do ingresso padrão. O cálculo do valor da meia entrada é realizado pelo sistema.
Bomboniere:
Definição\edição\remoção de produtos de bomboniere. Cada produto tem seu nome, categoria e valor.
Combos:
O sistema permite o cadastramento de combos. Em cada combo é possível associar produtos da bomboniere e ingressos de filmes. O valor total do combo vai ser calculado a partir da soma dos valores de seus produtos decrescido de alguma porcentagem (desconto) cadastrada pelo administrador.

#### Enquanto cliente:
Compras:
O sistema deve permitir a compra de 3 tipos de produtos no mesmo pedido: ingressos, bombonieres e combos. 
Na compra de ingressos é apresentado para o cliente a opção de cadastro de email. Esta feature serve para o menu de recomendação de filmes poder realizar recomendações de filmes para o cliente futuramente. Quando o cliente se cadastra com email, os filmes que ele assistiu vão ser armazenados, assim a recomendação vai criar uma relação considerando os diretores e gêneros de filmes assistidos pelo usuário com os filmes que estão atualmente em cartaz.
Ainda na compra de ingressos, o cliente tem a opção de selecionar não apenas a quantidade de ingressos desejados, mas também pode realizar uma pesquisa por dias específicos de exibição de um filme. Esta funcionalidade permite que o cliente escolha uma data específica para assistir ao filme (data de validade do ingresso). Além disso, é possível reservar poltronas específicas para um determinado número de pessoas. O sistema foi projetado para garantir que não haja venda de ingressos para assentos já ocupados no mesmo filme.
O sistema ainda possui um controle de lotação máxima. Não permitindo a venda de ingressos após o limite de poltronas ser atingido.

### Menus
#### Menu de compras:
O Menu de compras é o principal menu de interação com o usuário, sendo dividido em submenus que possuem todos os produtos vendidos no cinema. 
Submenus:
Ingressos: Escolha filmes, horários e assentos.
Bomboniere: Adicione petiscos e bebidas ao seu pedido.
Combos: Economize em combos sugeridos.
Finalizar Compra:  Revisão e pagamento.

#### Menu de recomendações:
O sistema possui um menu de recomendações que sugere filmes a clientes que já realizaram compras no cinema.
Essa recomendação é possível caso o cliente tenha cadastrado previamente o seu email no momento da compra de algum produto no cinema. Baseado neste email e nos filmes assistidos pelo usuário, o sistema tentará sugerir filmes de diretores ou gêneros próximos aos já assistidos que estão em cartaz naquele momento.

#### Menu de Relatório:
O sistema foi aprimorado para oferecer aos administradores um dashboard de controle abrangente em vez de apenas um menu de relatório simples. Neste dashboard, além das informações de faturamento bruto e ingressos vendidos, os administradores podem acessar diversas estatísticas relevantes.
Entre as estatísticas disponíveis estão os filmes com maior lotação, proporcionando entendimento sobre a popularidade de determinados filmes junto ao público. Também são destacadas as sessões mais disputadas, indicando os horários e datas de maior demanda, o que pode orientar decisões sobre estratégias de programação e promoção.
Esse dashboard fornece uma visão abrangente e detalhada do desempenho do cinema, possibilitando que os administradores tomem decisões mais informadas

#### Menu de Configurações:
O sistema possui um menu de configurações onde é possível cadastrar um administrador. Administradores possuem um user e uma senha.
Esse menu é o acesso dos administradores para as configurações que eles podem realizar no sistema (cadastros\edições\remoções). 
Todas as user stories associadas a administradores exigem autorização, que é realizada via user e a senha de algum administrador.





