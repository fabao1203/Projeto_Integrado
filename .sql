SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE DATABASE IF NOT EXISTS lar_patas DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE lar_patas;

-- ===========================

CREATE TABLE IF NOT EXISTS animais (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  especie VARCHAR(50) NOT NULL,
  raca VARCHAR(50) DEFAULT NULL,
  idade VARCHAR(20) DEFAULT NULL,
  sexo ENUM('Macho', 'Fêmea') NOT NULL,
  castrado TINYINT(1) DEFAULT 0,
  vacinado TINYINT(1) DEFAULT 0,
  data_entrada DATE NOT NULL,
  status ENUM('Disponível', 'Adotado', 'Em tratamento') DEFAULT 'Disponível',
  descricao TEXT DEFAULT NULL,
  foto VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_animais_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ===========================

CREATE TABLE IF NOT EXISTS pessoas (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefone VARCHAR(20) DEFAULT NULL,
  cpf VARCHAR(14) DEFAULT NULL,
  endereco VARCHAR(200) DEFAULT NULL,
  cidade VARCHAR(50) DEFAULT NULL,
  estado CHAR(2) DEFAULT NULL,
  data_cadastro DATE DEFAULT NULL,
  tipo ENUM('voluntario', 'adotante', 'doador') NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (email),
  UNIQUE (cpf),
  INDEX idx_pessoas_tipo (tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ===========================

CREATE TABLE IF NOT EXISTS usuarios (
  id INT NOT NULL AUTO_INCREMENT,
  pessoa_id INT NOT NULL,
  login VARCHAR(50) NOT NULL,
  senha VARCHAR(255) NOT NULL,
  nivel_acesso ENUM('admin', 'colaborador', 'visitante') DEFAULT 'visitante',
  ativo TINYINT(1) DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE (pessoa_id),
  UNIQUE (login),
  FOREIGN KEY (pessoa_id) REFERENCES pessoas (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ===========================

CREATE TABLE IF NOT EXISTS adocoes (
  id INT NOT NULL AUTO_INCREMENT,
  animal_id INT NOT NULL,
  pessoa_id INT NOT NULL,
  data_adocao DATE NOT NULL,
  aprovado_por INT DEFAULT NULL,
  status ENUM('Pendente', 'Aprovada', 'Rejeitada', 'Finalizada') DEFAULT 'Pendente',
  termo_assinado TINYINT(1) DEFAULT 0,
  observacoes TEXT DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_animal (animal_id),
  INDEX idx_pessoa (pessoa_id),
  INDEX idx_aprovado_por (aprovado_por),
  INDEX idx_adocoes_status (status),
  FOREIGN KEY (animal_id) REFERENCES animais (id) ON DELETE RESTRICT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoas (id) ON DELETE RESTRICT,
  FOREIGN KEY (aprovado_por) REFERENCES usuarios (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ===========================

CREATE TABLE IF NOT EXISTS dim_pessoa (
  id_pessoa INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) DEFAULT NULL,
  telefone VARCHAR(20) DEFAULT NULL,
  tipo ENUM('Funcionário', 'Voluntário', 'Adotante', 'Doador') NOT NULL,
  cidade VARCHAR(50) DEFAULT NULL,
  estado CHAR(2) DEFAULT NULL,
  data_cadastro DATE DEFAULT NULL,
  ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_pessoa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ===========================
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

---------------------------------

POPULAR AS TABLES

---------------------------------


-- Populando tabela animais
INSERT INTO animais (nome, especie, raca, idade, sexo, castrado, vacinado, data_entrada, status, descricao, foto) VALUES
('Bob', 'Cachorro', 'Labrador', '3 anos', 'Macho', 1, 1, '2023-01-10', 'Disponível', 'Cachorro muito amigável e brincalhão.', 'bob.jpg'),
('Mimi', 'Gato', 'Siames', '2 anos', 'Fêmea', 0, 1, '2023-03-15', 'Em tratamento', 'Gata com problema renal, em tratamento.', 'mimi.jpg'),
('Thor', 'Cachorro', 'Pitbull', '4 anos', 'Macho', 1, 1, '2022-12-01', 'Adotado', 'Ótimo companheiro, muito protetor.', 'thor.jpg'),
('Luna', 'Gato', 'Persa', '1 ano', 'Fêmea', 0, 0, '2023-04-20', 'Disponível', 'Gatinha dócil e tranquila.', 'luna.jpg'),
('Zeus', 'Cachorro', 'Vira-lata', '5 anos', 'Macho', 0, 1, '2023-02-05', 'Disponível', 'Cachorro ativo, gosta de passear.', 'zeus.jpg');

-- Populando tabela pessoas
INSERT INTO pessoas (nome, email, telefone, cpf, endereco, cidade, estado, data_cadastro, tipo) VALUES
('Ana Silva', 'ana.silva@gmail.com', '11999990000', '123.456.789-00', 'Rua A, 123', 'São Paulo', 'SP', '2023-01-05', 'voluntario'),
('Carlos Souza', 'carlos.souza@gmail.com', '21988887777', '987.654.321-00', 'Av. B, 456', 'Rio de Janeiro', 'RJ', '2023-02-10', 'adotante'),
('Mariana Lima', 'mariana.lima@gmail.com', '31977776666', '321.654.987-00', 'Rua C, 789', 'Belo Horizonte', 'MG', '2023-03-12', 'doador'),
('João Pedro', 'joao.pedro@gmail.com', '41966665555', '456.789.123-00', 'Av. D, 101', 'Curitiba', 'PR', '2023-04-01', 'adotante'),
('Fernanda Costa', 'fernanda.costa@gmail.com', '51955554444', '789.123.456-00', 'Rua E, 202', 'Porto Alegre', 'RS', '2023-04-15', 'voluntario');

-- Populando tabela usuarios
INSERT INTO usuarios (pessoa_id, login, senha, nivel_acesso, ativo) VALUES
(1, 'ana_silva', '$2y$10$e0NRn6/Eddz8H0W7XjGxveWZrQkYmN54h6K6c67aUrKxzJqKpmFe6', 'admin', 1), -- senha criptografada exemplo (bcrypt)
(5, 'fernanda_costa', '$2y$10$e0NRn6/Eddz8H0W7XjGxveWZrQkYmN54h6K6c67aUrKxzJqKpmFe6', 'colaborador', 1);

INSERT INTO adocoes (animal_id, pessoa_id, data_adocao, aprovado_por, status, termo_assinado, observacoes) VALUES
(3, 2, '2023-02-20', 1, 'Finalizada', 1, 'Adotado por Carlos, processo tranquilo.'),
(1, 4, '2023-03-25', 2, 'Aprovada', 0, 'Adoção pendente assinatura do termo.');


-- Populando tabela dim_pessoa
INSERT INTO dim_pessoa (id_pessoa, nome, email, telefone, tipo, cidade, estado, data_cadastro) VALUES
(1, 'Ana Silva', 'ana.silva@gmail.com', '11999990000', 'Voluntário', 'São Paulo', 'SP', '2023-01-05'),
(2, 'Carlos Souza', 'carlos.souza@gmail.com', '21988887777', 'Adotante', 'Rio de Janeiro', 'RJ', '2023-02-10'),
(3, 'Mariana Lima', 'mariana.lima@gmail.com', '31977776666', 'Doador', 'Belo Horizonte', 'MG', '2023-03-12'),
(4, 'João Pedro', 'joao.pedro@gmail.com', '41966665555', 'Adotante', 'Curitiba', 'PR', '2023-04-01'),
(5, 'Fernanda Costa', 'fernanda.costa@gmail.com', '51955554444', 'Voluntário', 'Porto Alegre', 'RS', '2023-04-15');

