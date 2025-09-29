-- DROP DATABASE OLIMPIADAS;

CREATE DATABASE IF NOT EXISTS OLIMPIADAS; -- Criação do BD
USE OLIMPIADAS; -- Aplicação no banco de dados criado

/*
========================================
CRIAÇÃO DAS TABELAS
========================================
*/

/*
=======================
Criação da tabela Pessoa
=======================
*/

CREATE TABLE Pessoa(
	ID_Participante INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(200) NOT NULL,
    Nacionalidade VARCHAR(100) NOT NULL,
    Data_Nascimento DATE,
	Modalidade INT NOT NULL,
    Email VARCHAR(200) NOT NULL UNIQUE
);

/*
=======================
Criação da Tabela Atleta
=======================
*/

CREATE TABLE Atleta(
	ID_Atleta INT AUTO_INCREMENT PRIMARY KEY,
	Peso DOUBLE NOT NULL,
    Altura DOUBLE NOT NULL,
    Modalidade VARCHAR(100) NOT NULL,
	Pessoa INT NOT NULL,
		CONSTRAINT FK_PessoaAt FOREIGN KEY (Pessoa) REFERENCES Pessoa(ID_Participante)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
);

/*
=======================
Criação da Tabela Árbitro 
=======================
*/

CREATE TABLE Arbitro(
	ID_Arbitro INT AUTO_INCREMENT PRIMARY KEY,
	Partidas_Arbitradas INT NOT NULL,
	Pessoa INT NOT NULL,
		CONSTRAINT FK_PessoaAb FOREIGN KEY (Pessoa) REFERENCES Pessoa(ID_Participante)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
);

/*
=======================
Criação da Tabela Modalidade
=======================
*/

CREATE TABLE Modalidade(
	ID_Modalidade INT AUTO_INCREMENT PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
    Tipo VARCHAR(100) NOT NULL,
    UNIQUE KEY Tipo_Modal (Tipo, ID_Modalidade),
    Regras_Basicas INT
);

/*
=======================
Criação da Tabela Equipe
=======================
*/

CREATE TABLE Equipe(
	ID_Equipe INT AUTO_INCREMENT PRIMARY KEY,
    Atleta INT NOT NULL,
		CONSTRAINT FK_Atleta FOREIGN KEY (Atleta) REFERENCES Atleta(ID_Atleta)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
	Tecnico INT NOT NULL,
		CONSTRAINT FK_Tenico FOREIGN KEY (Tecnico) REFERENCES Pessoa(ID_Participante)
				ON UPDATE CASCADE
				ON DELETE RESTRICT,
	Equipe_Tecnica INT NOT NULL,
    Modalidade INT NOT NULL,
		CONSTRAINT FK_ModalidadeE FOREIGN KEY (Modalidade) REFERENCES Modalidade(ID_Modalidade)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
	Cede_Numero INT NOT NULL,
	Cede_Quadra INT NOT NULL,
	Cede_Cidade INT NOT NULL
);
                
/*
=======================
Criação da Tabela Competição
=======================
*/

CREATE TABLE Competição(
	ID_Competição INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    Local_Numero INT NOT NULL,
	Local_Quadra INT NOT NULL,
	Local_Cidade INT NOT NULL,
    Entidade_Organizadora VARCHAR(200) NOT NULL,
    Ano YEAR NOT NULL,
    Temporada INT NOT NULL,
	Arbitro INT NOT NULL,
		CONSTRAINT FK_Arbitro FOREIGN KEY (Arbitro) REFERENCES Arbitro(ID_Arbitro)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
	Atleta INT NOT NULL,
		CONSTRAINT FK_AtletaR FOREIGN KEY (Atleta) REFERENCES Atleta(ID_Atleta)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
);

/*
=======================
Criação da Tabela Premiação
=======================
*/

CREATE TABLE Premiação(
	Tipo INT NOT NULL,
    Colocação INT NOT NULL,
	Valor DECIMAL(10, 2) NOT NULL,
    Competição INT NOT NULL,
		CONSTRAINT FK_Competição FOREIGN KEY (Competição) REFERENCES Competição(ID_Competição)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
);

/*
====================================
RELACIONAMENTOS
====================================
*/

/*
=======================
Relacionamento Atleta / Arbitro / Modalidade
=======================
*/

CREATE TABLE Tem(
	Atleta INT NOT NULL,
		CONSTRAINT FK_AtletaT FOREIGN KEY (Atleta) REFERENCES Atleta(ID_Atleta)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
    Arbitro INT NOT NULL,
		CONSTRAINT FK_ArbitroT FOREIGN KEY (Arbitro) REFERENCES Atleta(ID_Atleta)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
	Modalidade INT NOT NULL,
		CONSTRAINT FK_ModalidadeT FOREIGN KEY (Modalidade) REFERENCES Modalidade(ID_Modalidade)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
    UNIQUE KEY Modal_Atleta (Modalidade, Atleta),
    UNIQUE KEY Modal_Arbitro (Modalidade, Arbitro)
);

/*
=======================
Relacionamento Atleta / Equipe
=======================
*/

CREATE TABLE Compoe(
	Atleta INT NOT NULL,
		CONSTRAINT FK_AtletaC FOREIGN KEY (Atleta) REFERENCES Atleta(ID_Atleta)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
    Equipe INT NOT NULL,
		CONSTRAINT FK_EquipeC FOREIGN KEY (Equipe) REFERENCES Equipe(ID_Equipe)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
    UNIQUE KEY Atleta_Equipe (Atleta, Equipe)
);

/*
=======================
Relacionamento/Objeto Partida/Disputa
=======================
*/

CREATE TABLE Partida_Disputa(
	ID_Partida INT AUTO_INCREMENT PRIMARY KEY,
    Local_Numero INT NOT NULL,
	Local_Quadra INT NOT NULL,
	Local_Cidade INT NOT NULL,
    Data_Partida DATE,
    Hora TIME,
    Equipe INT NOT NULL,
		CONSTRAINT FK_EquipePartida FOREIGN KEY (Equipe) REFERENCES Equipe(ID_Equipe)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
	Modalidade INT NOT NULL,
		CONSTRAINT FK_ModalidadePartida FOREIGN KEY (Modalidade) REFERENCES Modalidade(ID_Modalidade)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
	Arbitro INT UNIQUE,
		CONSTRAINT FK_ArbitroPartida FOREIGN KEY (Arbitro) REFERENCES Arbitro(ID_Arbitro)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
    Ganhador INT,
		CONSTRAINT FK_GanhadorPartida FOREIGN KEY (Ganhador) REFERENCES Equipe(ID_Equipe)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
);

/*
=======================
Relacionamento Partida / Competição
=======================
*/

CREATE TABLE Pertece(
	Partida INT NOT NULL,
		CONSTRAINT FK_PartidaP FOREIGN KEY (Partida) REFERENCES Partida_Disputa(ID_Partida)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
    Competição INT NOT NULL,
		CONSTRAINT FK_CompetiçãoP FOREIGN KEY (Competição) REFERENCES Competição(ID_Competição)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
);

/*
====================================
ATRIBUTOS MULTIVALORADOS
====================================
*/

/*
=======================
Criação do Atributo E-mail
=======================
*/

CREATE TABLE Email_Participantes(
	ID_Registro INT AUTO_INCREMENT PRIMARY KEY,
	Email VARCHAR(200) NOT NULL,
    Participante INT NOT NULL,
			CONSTRAINT FK_Participante FOREIGN KEY (Participante) REFERENCES Pessoa(ID_Participante)
				ON UPDATE CASCADE
				ON DELETE RESTRICT,
	UNIQUE KEY unico_email (Participante, Email)
);

/*
=======================
Criação do Atributo Regras_Modalidade
=======================
*/

CREATE TABLE Regras_Modalidade(
	Codigo_Regra INT AUTO_INCREMENT PRIMARY KEY,
    Inciso VARCHAR(50) NOT NULL,
	Regra VARCHAR(710) NOT NULL,
    Modalidade INT NOT NULL,
			CONSTRAINT FK_Modalidade FOREIGN KEY (Modalidade) REFERENCES Modalidade(ID_Modalidade)
				ON UPDATE CASCADE
				ON DELETE RESTRICT,
	UNIQUE KEY Inciso_Regra_Modalidade (Inciso, Regra, Modalidade)
);

/*
=======================
Criação do Atributo Regras_Modalidade
=======================
*/

CREATE TABLE Equipe_Tecnica(
	ID_ETecnico INT AUTO_INCREMENT PRIMARY KEY,
    Equipe INT NOT NULL,
		CONSTRAINT FK_Equipe FOREIGN KEY (Equipe) REFERENCES Equipe(ID_Equipe)
			ON UPDATE CASCADE
			ON DELETE RESTRICT,
    Membros INT NOT NULL,
			CONSTRAINT FK_Membros FOREIGN KEY (Membros) REFERENCES Pessoa(ID_Participante)
				ON UPDATE CASCADE
				ON DELETE RESTRICT,
	UNIQUE KEY Equipe_Membros (Equipe, Membros)
);

/*
=======================
Criação do Atributo Tipo_Premiação
=======================
*/

CREATE TABLE Tipo_Premiação(
	ID_TPremiação INT AUTO_INCREMENT PRIMARY KEY,
    Medalha BOOLEAN NOT NULL,
    Valor BOOLEAN NOT NULL,
    Acessorio BOOLEAN NOT NULL,
    Bandeira BOOLEAN NOT NULL,
    Hino_Cantado BOOLEAN NOT NULL,
	UNIQUE KEY Premiação (Medalha, Valor, Acessorio, Bandeira, Hino_Cantado)
);

/*
====================================
ALTERs POSTERIORES
====================================
*/

/*
=======================
Criação da FK_ModalidadeP e o UNIQUE
=======================
*/

ALTER TABLE Pessoa
	ADD CONSTRAINT FK_ModalidadeP FOREIGN KEY (Modalidade) REFERENCES Modalidade(ID_Modalidade)
				ON UPDATE CASCADE
				ON DELETE RESTRICT;
ALTER TABLE Pessoa
	ADD CONSTRAINT UQ_Pessoa_Modal UNIQUE KEY Pessoa_Modal (ID_Participante, Modalidade);
    
/*
=======================
Criação da FK_Regras
=======================
*/

ALTER TABLE Modalidade
	ADD CONSTRAINT FK_Regras FOREIGN KEY (Regras_Basicas) REFERENCES Regras_Modalidade(Codigo_Regra)
				ON UPDATE CASCADE
				ON DELETE RESTRICT;
                
/*
=======================
Criação da FK_ETecnica
=======================
*/

ALTER TABLE Equipe
	ADD CONSTRAINT FK_ETecnica FOREIGN KEY (Equipe_Tecnica) REFERENCES Equipe_Tecnica(ID_ETecnico)
		ON UPDATE CASCADE
		ON DELETE RESTRICT;


/*
=======================
Criação da FK_Competição
=======================
*/

ALTER TABLE Arbitro
	ADD COLUMN Competicoes_Participando INT NULL,
	ADD CONSTRAINT FK_CompetiçãoA FOREIGN KEY (Competicoes_Participando) REFERENCES Competição(ID_Competição)
				ON UPDATE CASCADE
				ON DELETE RESTRICT;
                
/*
=======================
Criação da FK_Tipo
=======================
*/

ALTER TABLE Premiação
	ADD CONSTRAINT FK_Tipo FOREIGN KEY (Tipo) REFERENCES Tipo_Premiação(ID_TPremiação)
				ON UPDATE CASCADE
				ON DELETE RESTRICT;
                


/*
===========================================================
INSERÇÃO DE DADOS
===========================================================
*/

/*
=======================
Dados da tabela Tipo_Premiação
=======================
*/

INSERT INTO Tipo_Premiação (Medalha, Valor, Acessorio, Bandeira, Hino_Cantado)
VALUES (TRUE, TRUE, TRUE, TRUE, TRUE); -- Prêmio para o 1º colocado
INSERT INTO Tipo_Premiação (Medalha, Valor, Acessorio, Bandeira, Hino_Cantado)
VALUES (TRUE, TRUE, TRUE, TRUE, FALSE); -- Premio para o 2º ao 3º colocado
INSERT INTO Tipo_Premiação (Medalha, Valor, Acessorio, Bandeira, Hino_Cantado)
VALUES (FALSE, TRUE, TRUE, TRUE, FALSE); -- Premio para o 4º ao 5º colocado
INSERT INTO Tipo_Premiação (Medalha, Valor, Acessorio, Bandeira, Hino_Cantado)
VALUES (FALSE, TRUE, TRUE, FALSE, FALSE); -- Premio para o 6º ao 10º colocado
INSERT INTO Tipo_Premiação (Medalha, Valor, Acessorio, Bandeira, Hino_Cantado)
VALUES (FALSE, FALSE, TRUE, FALSE, FALSE); -- Premio para o 11º colocado adiante

/*
=======================
Dados da tabela Regras_Modalidade
=======================
*/

INSERT INTO Modalidade (Nome, Tipo) VALUES ('Futebol de Campo', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Basquete', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Vôlei', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Natação', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Atletismo', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Judô', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Tênis de Mesa', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Handebol', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Futsal', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Ginástica Rítmica', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Xadrez', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Ciclismo', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Rúgbi', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Skate', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Surfe', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Escalada Esportiva', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Beisebol', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Softbol', 'Coletivo');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Tênis', 'Individual');
INSERT INTO Modalidade (Nome, Tipo) VALUES ('Esgrima', 'Individual');

/*
=======================
Dados da tabela Regras_Modalidade
=======================
*/

-- Futebol (ID 1)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo é disputado entre duas equipes de 11 jogadores.', 1),
('II', 'A partida tem dois tempos de 45 minutos cada, com intervalo de 15 minutos.', 1),
('III', 'O jogo termina ao final dos dois tempos regulamentares, podendo haver acréscimos.', 1),
('IV', 'O objetivo é marcar gols no gol adversário.', 1),
('V', 'O uso das mãos é permitido apenas pelo goleiro dentro da área.', 1),
('VI', 'Faltas resultam em tiros livres, pênaltis ou cartões amarelo/vermelho.', 1),
('VII', 'O impedimento ocorre quando um jogador recebe a bola em posição irregular.', 1),
('VIII', 'O reinício do jogo ocorre após gols, faltas e saídas de bola.', 1),
('IX', 'Substituições são limitadas a 5 por equipe por partida.', 1),
('X', 'Jogos empatados em fases eliminatórias podem ir para prorrogação e pênaltis.', 1);

-- Basquete (ID 2)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo é disputado por duas equipes de 5 jogadores cada.', 2),
('II', 'A partida tem quatro períodos de 10 minutos cada.', 2),
('III', 'O jogo termina após os quatro períodos, podendo haver prorrogação.', 2),
('IV', 'O objetivo é marcar pontos lançando a bola na cesta adversária.', 2),
('V', 'O drible é obrigatório para movimentação com a bola.', 2),
('VI', 'Faltas são marcadas e podem resultar em lances livres.', 2),
('VII', 'O cronômetro para em todas as paralisações do jogo.', 2),
('VIII', 'O time que marcar mais pontos vence a partida.', 2),
('IX', 'O time tem um tempo limitado para realizar a posse de bola.', 2),
('X', 'Substituições são ilimitadas durante o jogo.', 2);

-- Vôlei (ID 3)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo é disputado por duas equipes de 6 jogadores.', 3),
('II', 'A partida é dividida em sets; vence quem fizer 3 sets primeiro.', 3),
('III', 'Cada set é disputado até 25 pontos, com vantagem mínima de 2 pontos.', 3),
('IV', 'No set decisivo, a disputa vai até 15 pontos.', 3),
('V', 'O jogo termina ao final do set decisivo.', 3),
('VI', 'A bola deve ser tocada no máximo três vezes antes de passar para o campo adversário.', 3),
('VII', 'O saque inicia o ponto.', 3),
('VIII', 'Faltas incluem toque na rede, invasão de quadra e duplo toque.', 3),
('IX', 'A equipe que vencer o último ponto do set vence o set.', 3),
('X', 'Substituições são permitidas conforme regulamento.', 3);

-- Natação (ID 4)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'As provas podem ser de estilos livre, costas, peito e borboleta.', 4),
('II', 'Cada prova tem distância pré-definida, como 50m, 100m, 200m, etc.', 4),
('III', 'O nadador deve completar o percurso no menor tempo possível.', 4),
('IV', 'O jogo termina com a chegada do nadador à borda da piscina na distância estipulada.', 4),
('V', 'Partidas podem ser disputadas em piscina olímpica (50m) ou semi-olímpica (25m).', 4),
('VI', 'As largadas são feitas a partir de blocos de partida.', 4),
('VII', 'Toques nas bordas da piscina devem ser conforme o estilo da prova.', 4),
('VIII', 'Faltas incluem saídas antecipadas ou movimentos incorretos.', 4),
('IX', 'O uso de equipamentos auxiliares não é permitido.', 4),
('X', 'O vencedor é o nadador que completar a distância no menor tempo.', 4);

-- Atletismo (ID 5)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'As provas são divididas em corridas, saltos e arremessos.', 5),
('II', 'Cada prova tem regras específicas para execução e tempo.', 5),
('III', 'Corridas podem ser de velocidade, meio-fundo, fundo e revezamento.', 5),
('IV', 'O jogo termina quando o atleta cruza a linha de chegada.', 5),
('V', 'Saltos são medidos pela altura ou distância alcançada.', 5),
('VI', 'Arremessos são medidos pela distância da projeção do objeto.', 5),
('VII', 'O atleta deve cumprir regras específicas de cada modalidade para não ser desclassificado.', 5),
('VIII', 'Falsas largadas em corridas podem resultar em advertência ou desclassificação.', 5),
('IX', 'Os tempos e marcas são registrados oficialmente para classificação.', 5),
('X', 'Vence quem obtiver o melhor desempenho conforme cada prova.', 5);

-- Tênis de Mesa (ID 6)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo é disputado entre dois (simples) ou quatro (duplas) jogadores.', 6),
('II', 'O objetivo é marcar pontos fazendo a bola tocar o lado adversário da mesa.', 6),
('III', 'Cada set é disputado até 11 pontos, com vantagem mínima de 2 pontos.', 6),
('IV', 'O jogo termina quando um jogador vence melhor de 5 ou 7 sets, conforme regulamento.', 6),
('V', 'O saque alterna a cada dois pontos entre os jogadores.', 6),
('VI', 'A bola deve quicar primeiro do lado do sacador e depois do recebedor.', 6),
('VII', 'Faltas incluem não devolver a bola ou tocar a rede com a raquete.', 6),
('VIII', 'Pontuação é contabilizada a cada erro do adversário.', 6),
('IX', 'Os jogadores mudam de lado a cada set.', 6),
('X', 'Substituições são permitidas apenas nas duplas.', 6);

-- Tênis de Campo (ID 7)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo pode ser simples (1x1) ou duplas (2x2).', 7),
('II', 'A pontuação avança de 0, 15, 30, 40 e game.', 7),
('III', 'O objetivo é ganhar sets, que são compostos por games.', 7),
('IV', 'Um set é ganho ao vencer 6 games com diferença de pelo menos 2.', 7),
('V', 'Em caso de 6-6, joga-se tie-break para decidir o set.', 7),
('VI', 'O jogo termina quando um jogador ou dupla vence o número de sets pré-determinado.', 7),
('VII', 'O saque deve ser feito atrás da linha de base e diagonalmente.', 7),
('VIII', 'A bola deve passar por cima da rede e cair dentro da área válida.', 7),
('IX', 'Toques na bola são limitados a uma vez por lado, exceto no voleio.', 7),
('X', 'Faltas no saque são marcadas e podem resultar em ponto para o adversário.', 7);

-- Handebol (ID 8)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo é disputado por duas equipes de 7 jogadores cada (6 jogadores de linha e 1 goleiro).', 8),
('II', 'A partida tem dois tempos de 30 minutos cada, com intervalo de 10 a 15 minutos.', 8),
('III', 'O jogo termina ao final dos dois tempos regulamentares, considerando acréscimos do árbitro.', 8),
('IV', 'Os jogadores podem dar até três passos segurando a bola, ou quicar a bola (drible) para avançar.', 8),
('V', 'É proibido agarrar, empurrar ou segurar o adversário; faltas são marcadas e podem resultar em exclusão temporária.', 8),
('VI', 'O gol é marcado quando a bola ultrapassa totalmente a linha de gol dentro da área delimitada.', 8),
('VII', 'O goleiro pode usar qualquer parte do corpo para defender a bola dentro da área do gol.', 8),
('VIII', 'Substituições são ilimitadas e podem ser feitas a qualquer momento durante o jogo.', 8),
('IX', 'O reinício após gol é feito pelo time que sofreu o gol, com bola ao centro.', 8),
('X', 'Infrações graves podem resultar em exclusão definitiva do jogador da partida.', 8);

-- Futsal (ID 9)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'A quadra de futsal mede 40 × 20 metros, com áreas delimitadas de tiro livre e gol.', 9),
('II', 'Cada equipe joga com 5 jogadores em quadra, um dos quais é o goleiro; substituições são ilimitadas.', 9),
('III', 'O jogo é dividido em dois tempos de 20 minutos de tempo efetivo (o relógio para nas interrupções).', 9),
('IV', 'O jogo termina ao final dos dois tempos regulamentares, considerando paradas (tempo efetivo).', 9),
('V', 'O início e reinício do jogo são feitos com bola ao centro (tiro de saída).', 9),
('VI', 'A bola está em jogo enquanto não ultrapassar totalmente as linhas laterais ou de fundo.', 9),
('VII', 'Faltas são marcadas por condutas antirregulares (empurrar, segurar, carrinho imprudente etc.).', 9),
('VIII', 'As equipes acumulam faltas e, após um limite (normalmente 5 faltas por período), cada falta adicional resulta em tiro livre direto sem barreira.', 9),
('IX', 'O goleiro pode usar as mãos somente dentro da sua área penal; fora dela, trata-se como jogador de linha.', 9),
('X', 'Reinícios de jogo incluem arremesso lateral, tiro de meta, escanteio e tiro livre, conforme infração ou saída de bola.', 9);

-- Ginástica Rítmica (ID 10)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'As atletas competem com aparelhos como corda, arco, bola, maças e fita.', 10),
('II', 'A rotina deve combinar elementos de dança, equilíbrio, flexibilidade e manipulação do aparelho.', 10),
('III', 'A pontuação é baseada na dificuldade, execução técnica e expressão artística.', 10),
('IV', 'O tempo máximo para cada rotina individual é de 1 minuto e 30 segundos.', 10),
('V', 'No caso de queda do aparelho, a rotina pode continuar, mas será descontado na pontuação.', 10),
('VI', 'As atletas devem realizar movimentos coordenados com a música escolhida.', 10),
('VII', 'As rotinas são avaliadas por um painel de juízes oficiais da modalidade.', 10),
('VIII', 'Penalizações podem ocorrer por saídas da área delimitada ou uso incorreto do aparelho.', 10),
('IX', 'O uso de qualquer aparelho não autorizado implica desclassificação.', 10),
('X', 'A competição termina após a execução das rotinas previstas para cada categoria.', 10);

-- Xadrez (ID 11)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O tabuleiro é composto por 64 casas, alternadamente claras e escuras.', 11),
('II', 'Cada jogador inicia com 16 peças: 1 rei, 1 rainha, 2 torres, 2 bispos, 2 cavalos e 8 peões.', 11),
('III', 'O objetivo do jogo é dar xeque-mate no rei adversário, situação em que o rei está sob ataque e não pode escapar.', 11),
('IV', 'Cada jogador move uma peça por vez, obedecendo os movimentos permitidos para cada tipo de peça.', 11),
('V', 'O jogo termina quando há xeque-mate, empate ou desistência de um jogador.', 11),
('VI', 'O empate pode ocorrer por acordo entre os jogadores, repetição de movimentos, ou insuficiência de material para dar xeque-mate.', 11),
('VII', 'Existe um relógio para controlar o tempo de cada jogador, podendo variar conforme o tipo de partida.', 11),
('VIII', 'Movimentos ilegais devem ser corrigidos assim que detectados, podendo haver penalização.', 11),
('IX', 'O roque é um movimento especial que envolve o rei e a torre para proteção do rei.', 11),
('X', 'O peão pode ser promovido a qualquer outra peça (exceto rei) ao atingir a última linha do tabuleiro.', 11);

-- Ciclismo (ID 12)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'As competições podem ser em estrada, pista, mountain bike ou BMX.', 12),
('II', 'Os ciclistas devem completar o percurso determinado no menor tempo possível.', 12),
('III', 'Em corridas de estrada, o vencedor é quem cruza a linha de chegada primeiro.', 12),
('IV', 'Em provas de pista, há diferentes formatos como contrarrelógio, perseguição e corrida por pontos.', 12),
('V', 'O uso de equipamento autorizado e seguro é obrigatório para todos os competidores.', 12),
('VI', 'O contato físico entre ciclistas é proibido e pode acarretar penalizações.', 12),
('VII', 'O abandono da prova deve ser comunicado à organização.', 12),
('VIII', 'As infrações podem resultar em advertências, penalizações de tempo ou desclassificação.', 12),
('IX', 'O tempo máximo para a prova é definido pelo regulamento específico de cada evento.', 12),
('X', 'A competição termina com a chegada do último competidor ou encerramento do tempo máximo previsto.', 12);

-- Rúgbi (ID 13)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo é disputado por duas equipes de 15 jogadores cada.', 13),
('II', 'A partida tem dois tempos de 40 minutos, com intervalo de 10 a 15 minutos.', 13),
('III', 'O jogo termina após os dois tempos regulamentares, podendo haver prorrogação em caso de empate.', 13),
('IV', 'O objetivo é marcar pontos através de tries, conversões, penais e drops.', 13),
('V', 'O avanço da bola é feito carregando-a ou chutando-a para frente.', 13),
('VI', 'O passe só pode ser feito para trás ou lateralmente, nunca para frente.', 13),
('VII', 'Tackles são permitidos para parar o avanço do adversário, desde que sejam legais.', 13),
('VIII', 'Faltas graves podem resultar em cartão amarelo (exclusão temporária) ou vermelho (expulsão).', 13),
('IX', 'O reinício do jogo ocorre com scrums, line-outs ou chutes, dependendo da situação.', 13),
('X', 'Substituições são limitadas e regulamentadas conforme a competição.', 13);

-- Skate (ID 14)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'A competição é dividida em categorias como street e park.', 14),
('II', 'Os atletas realizam manobras em um tempo determinado, geralmente 45 segundos a 1 minuto.', 14),
('III', 'Cada manobra é avaliada pela dificuldade, execução, originalidade e fluidez.', 14),
('IV', 'Quedas e erros durante as manobras resultam em perda de pontos.', 14),
('V', 'Os atletas têm um número limitado de tentativas para realizar as manobras.', 14),
('VI', 'O uso de equipamentos de proteção é obrigatório durante as competições.', 14),
('VII', 'As pontuações são dadas por um painel de juízes oficiais.', 14),
('VIII', 'O vencedor é o atleta com a maior pontuação acumulada ao final das tentativas.', 14),
('IX', 'Empates podem ser decididos por uma rodada extra ou maior nota em manobras específicas.', 14),
('X', 'A competição termina após a última rodada de manobras de todos os atletas.', 14);

-- Surfe (ID 15)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'As competições ocorrem em ondas naturais, com tempo limitado para cada bateria.', 15),
('II', 'Cada bateria tem duração variável, geralmente entre 20 e 30 minutos.', 15),
('III', 'Os atletas são avaliados em suas manobras, estilo, controle e grau de dificuldade.', 15),
('IV', 'Cada atleta pode pegar um número limitado de ondas na bateria.', 15),
('V', 'Somente as duas melhores ondas de cada atleta são consideradas para a pontuação final.', 15),
('VI', 'Quedas ou erros nas manobras resultam em pontuação menor.', 15),
('VII', 'Prioridade na escolha da onda é dada ao atleta com melhor pontuação atual.', 15),
('VIII', 'A pontuação é atribuída por juízes especializados em surfe.', 15),
('IX', 'Empates podem ser resolvidos pela melhor nota na melhor onda.', 15),
('X', 'A bateria termina quando o tempo limite é alcançado.', 15);

-- Escalada Esportiva (ID 16)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'Existem três disciplinas principais: velocidade, dificuldade e boulder.', 16),
('II', 'Na velocidade, o objetivo é chegar ao topo da parede no menor tempo possível.', 16),
('III', 'Na dificuldade, vence quem alcançar a maior altura ou completar o percurso.', 16),
('IV', 'No boulder, os atletas realizam sequências curtas de movimentos sem uso de corda.', 16),
('V', 'Cada atleta tem um número limitado de tentativas em cada rota.', 16),
('VI', 'Os competidores usam equipamentos de segurança, como arnês e mosquetões.', 16),
('VII', 'Faltas incluem queda, saída da rota e uso incorreto dos apoios.', 16),
('VIII', 'A pontuação é atribuída com base no desempenho, tempo e número de tentativas.', 16),
('IX', 'Empates são decididos pelo tempo gasto ou número de tentativas.', 16),
('X', 'A competição termina após o término das rotas estipuladas para cada disciplina.', 16);

-- Beisebol (ID 17)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'Cada equipe possui nove jogadores em campo.', 17),
('II', 'O jogo consiste em nove entradas (innings), podendo haver prorrogação.', 17),
('III', 'O objetivo é marcar corridas (runs) ao percorrer as quatro bases.', 17),
('IV', 'Cada entrada tem duas fases: ataque (rebatedores) e defesa (arremessadores).', 17),
('V', 'O jogo termina após as nove entradas, salvo empate que leva à prorrogação.', 17),
('VI', 'O rebatedor deve tentar acertar a bola lançada para avançar nas bases.', 17),
('VII', 'O arremessador tenta eliminar o rebatedor por strikeout ou bolas rebatidas fáceis.', 17),
('VIII', 'Eliminações ocorrem por strikeout, bola pega no ar ou toque na base.', 17),
('IX', 'Substituições são permitidas durante o jogo, respeitando regras específicas.', 17),
('X', 'Jogos podem ser interrompidos ou cancelados por condições climáticas adversas.', 17);

-- Softbol (ID 18)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'Cada equipe tem nove jogadores em campo.', 18),
('II', 'O jogo é dividido em sete entradas (innings), podendo haver prorrogação.', 18),
('III', 'O objetivo é marcar corridas ao percorrer as quatro bases.', 18),
('IV', 'O arremesso deve ser feito por baixo, em movimento circular.', 18),
('V', 'O jogo termina após as sete entradas, salvo empate que leva à prorrogação.', 18),
('VI', 'O rebatedor tenta acertar a bola para avançar nas bases.', 18),
('VII', 'Eliminações ocorrem por strikeout, bola pega no ar ou toque na base.', 18),
('VIII', 'Substituições são permitidas durante o jogo.', 18),
('IX', 'Jogos podem ser suspensos por condições climáticas.', 18),
('X', 'O tempo máximo de duração pode ser estipulado pela competição.', 18);

-- Tênis (ID 19)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'O jogo pode ser simples (1x1) ou duplas (2x2).', 19),
('II', 'A pontuação avança de 0, 15, 30, 40 e game.', 19),
('III', 'O objetivo é ganhar sets, que são compostos por games.', 19),
('IV', 'Um set é ganho ao vencer 6 games com diferença de pelo menos 2.', 19),
('V', 'Em caso de 6-6, joga-se tie-break para decidir o set.', 19),
('VI', 'O jogo termina quando um jogador ou dupla vence o número de sets pré-determinado.', 19),
('VII', 'O saque deve ser feito atrás da linha de base e diagonalmente.', 19),
('VIII', 'A bola deve passar por cima da rede e cair dentro da área válida.', 19),
('IX', 'Toques na bola são limitados a uma vez por lado, exceto no voleio.', 19),
('X', 'Faltas no saque são marcadas e podem resultar em ponto para o adversário.', 19);

-- Esgrima (ID 20)
INSERT INTO Regras_Modalidade (Inciso, Regra, Modalidade) VALUES
('I', 'Existem três armas principais: florete, sabre e espada.', 20),
('II', 'O objetivo é tocar o adversário com a ponta ou lâmina da arma para marcar pontos.', 20),
('III', 'As partidas são disputadas em três períodos de 3 minutos ou até 15 pontos.', 20),
('IV', 'O jogo termina ao final do tempo ou quando um competidor alcança 15 pontos.', 20),
('V', 'Toques válidos são aqueles realizados dentro da área permitida para cada arma.', 20),
('VI', 'Regras de prioridade (direito de ataque) determinam quem marca o ponto no florete e sabre.', 20),
('VII', 'O uso correto do equipamento de proteção é obrigatório.', 20),
('VIII', 'Penalizações podem resultar em advertências, exclusões temporárias ou desqualificação.', 20),
('IX', 'Os árbitros controlam a pontuação e tempo da partida.', 20),
('X', 'Empates são resolvidos com prorrogação de um minuto e vantagem na próxima ação.', 20);

UPDATE Modalidade SET Regras_Basicas = 1 WHERE ID_Modalidade = 1;   -- Futebol de Campo
UPDATE Modalidade SET Regras_Basicas = 11 WHERE ID_Modalidade = 2;  -- Basquete
UPDATE Modalidade SET Regras_Basicas = 21 WHERE ID_Modalidade = 3;  -- Vôlei
UPDATE Modalidade SET Regras_Basicas = 31 WHERE ID_Modalidade = 4;  -- Natação
UPDATE Modalidade SET Regras_Basicas = 41 WHERE ID_Modalidade = 5;  -- Atletismo
UPDATE Modalidade SET Regras_Basicas = 51 WHERE ID_Modalidade = 6;  -- Judô
UPDATE Modalidade SET Regras_Basicas = 61 WHERE ID_Modalidade = 7;  -- Tênis de Mesa
UPDATE Modalidade SET Regras_Basicas = 71 WHERE ID_Modalidade = 8;  -- Handebol
UPDATE Modalidade SET Regras_Basicas = 81 WHERE ID_Modalidade = 9;  -- Futsal
UPDATE Modalidade SET Regras_Basicas = 91 WHERE ID_Modalidade = 10; -- Ginástica Rítmica
UPDATE Modalidade SET Regras_Basicas = 101 WHERE ID_Modalidade = 11; -- Xadrez
UPDATE Modalidade SET Regras_Basicas = 111 WHERE ID_Modalidade = 12; -- Ciclismo
UPDATE Modalidade SET Regras_Basicas = 121 WHERE ID_Modalidade = 13; -- Rúgbi
UPDATE Modalidade SET Regras_Basicas = 131 WHERE ID_Modalidade = 14; -- Skate
UPDATE Modalidade SET Regras_Basicas = 141 WHERE ID_Modalidade = 15; -- Surfe
UPDATE Modalidade SET Regras_Basicas = 151 WHERE ID_Modalidade = 16; -- Escalada Esportiva
UPDATE Modalidade SET Regras_Basicas = 161 WHERE ID_Modalidade = 17; -- Beisebol
UPDATE Modalidade SET Regras_Basicas = 171 WHERE ID_Modalidade = 18; -- Softbol
UPDATE Modalidade SET Regras_Basicas = 181 WHERE ID_Modalidade = 19; -- Tênis
UPDATE Modalidade SET Regras_Basicas = 191 WHERE ID_Modalidade = 20; -- Esgrima


-- Desabilita a verificação de chaves estrangeiras para resolver a dependência circular
SET FOREIGN_KEY_CHECKS=0;

/*
=======================
Dados da tabela Pessoa
=======================
*/
-- CORREÇÃO APLICADA AQUI: Removidos os IDs manuais. O BD vai gerar os IDs 1, 2, 3... automaticamente.
INSERT INTO Pessoa (Nome, Nacionalidade, Data_Nascimento, Modalidade, Email)
VALUES
('João Silva', 'Brasil', '1998-05-10', 1, 'joao.silva@gmail.com'),
('Maria Souza', 'Brasil', '2000-02-15', 1, 'maria.souza@gmail.com'),
('Carlos Pereira', 'Brasil', '1985-11-20', 1, 'carlos.tecnico@gmail.com'),
('Ana Costa', 'Portugal', '2002-07-30', 4, 'ana.costa@gmail.com'),
('Pedro Lima', 'Brasil', '2001-09-10', 4, 'pedro.lima@gmail.com'),
('Julia Alves', 'Argentina', '1990-04-05', 1, 'julia.alves@gmail.com'),
('Michael Smith', 'EUA', '1988-06-25', 4, 'msmith.ref@gmail.com'),
('Ricardo Gomes', 'Brasil', '1999-12-01', 1, 'ricardo.gomes@gmail.com'),
('Fernanda Lima', 'Brasil', '1982-01-18', 1, 'fernanda.tecnica@gmail.com');

/*
=======================
Dados da tabela Email_Participantes
=======================
*/
INSERT INTO Email_Participantes (Email, Participante)
VALUES
('joao.silva@gmail.com', 1),
('maria.souza@gmail.com', 2),
('carlos.tecnico@gmail.com', 3),
('ana.costa@gmail.com', 4),
('pedro.lima@gmail.com', 5),
('julia.alves@gmail.com', 6),
('msmith.ref@gmail.com', 7),
('ricardo.gomes@gmail.com', 8),
('fernanda.tecnica@gmail.com', 9);

/*
=======================
Dados da tabela Atleta
=======================
*/
INSERT INTO Atleta (Pessoa, Peso, Altura, Modalidade) VALUES
(1, 80.5, 1.82, 'Futebol de Campo'), -- João Silva
(2, 65.0, 1.70, 'Futebol de Campo'), -- Maria Souza
(4, 58.0, 1.75, 'Natação'), -- Ana Costa
(5, 75.0, 1.85, 'Natação'), -- Pedro Lima
(8, 78.0, 1.79, 'Futebol de Campo'); -- Ricardo Gomes

/*
=======================
Dados da tabela Arbitro
=======================
*/
INSERT INTO Arbitro (Pessoa, Partidas_Arbitradas) VALUES
(6, 0), -- Julia Alves
(7, 0); -- Michael Smith

/*
=======================
Dados da tabela Equipe e Equipe_Tecnica
=======================
*/
INSERT INTO Equipe (ID_Equipe, Atleta, Tecnico, Equipe_Tecnica, Modalidade, Cede_Numero, Cede_Quadra, Cede_Cidade) VALUES
(1, 1, 3, 1, 1, 10, 1, 1),
(2, 5, 9, 2, 1, 12, 1, 1);

INSERT INTO Equipe_Tecnica (ID_ETecnico, Equipe, Membros) VALUES
(1, 1, 3),
(2, 2, 9);

/*
=======================
Dados da tabela Competição
=======================
*/

INSERT INTO Competição (Nome, Local_Numero, Local_Quadra, Local_Cidade, Entidade_Organizadora, Ano, Temporada, Arbitro, Atleta) VALUES
('Copa das Nações de Futebol', 150, 1, 1, 'FIFA', 2025, 1, 1, 1),
('Torneio Aquático Internacional', 200, 3, 2, 'FINA', 2025, 1, 2, 2);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
SELECT * FROM Pessoa;
SELECT * FROM Atleta;
SELECT * FROM Arbitro;
SELECT * FROM Equipe;
SELECT * FROM Competição;
SELECT * FROM Modalidade;

-- drop database olimpiadas;
