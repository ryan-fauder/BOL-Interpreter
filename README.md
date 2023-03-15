# BOL Interpreter

<img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" /> <img src="https://img.shields.io/github/commit-status/PedroASB/bol-interpreter/main/c53fbfdf418d514adddbf65736bc11350b17ddf7?style=for-the-badge"> <img src="https://img.shields.io/github/license/PedroASB/bol-interpreter?color=blue&style=for-the-badge"> <img src="https://img.shields.io/badge/TOPICS-INTERPRETER%20--%20PARSE%20TREE%20--%20LEXICAL%20ANALYSIS%20--%20PARSER-red?style=for-the-badge&logo=acclaim" />

## Descrição

- Trabalho desenvolvido em grupo durante a disciplina de Linguagens e Paradigmas de Programação (curso de Ciência da Computação da Universidade Federal de Goiás - UFG)
- O programa consiste em um interpretador da linguagem BOL (Bruno's Object-Oriented Language)
- Linguagem utilizada para a implementação do interpretador: Lua 5.4

---

## Desenvolvedores

- <a href="https://github.com/luizfernandofo">Luiz Fernando de Freitas Oliveira (luizfernandofo)</a>
- <a href="https://github.com/PedroASB">Pedro Augusto Serafim Belo (PedroASB)</a>
- <a href="https://github.com/ryan-fauder">Ryan Fernandes Auder Lopes (ryan-fauder)</a>

---

## Como Executar

Faça um clone do repositório em sua máquina e entre na pasta `src` do projeto:

```bash
git clone https://github.com/PedroASB/BOL-Interpreter.git && cd ./BOL-Interpreter/src/
```

Em seguida, execute o comando abaixo para executar um exemplo de código em BOL:

```bash
lua interpreter.lua ../examples/program1.bol
```

Na pasta `examples`, estão disponíveis 4 (quatro) exemplos de códigos para teste. Para testá-los, substitua o arquivo na linha de comando.

---

## Sobre a Linguagem BOL

### Funcionalidades

O interpretador suporta as principais funcionalidades de uma linguagem, incluindo:
- Declaração de variáveis
- Operações matemáticas
- Estruturas de controle de fluxo (if/else)
- Definição de classes e métodos
- Herança entre objetos
- Instanciação de objetos com atributos
- Impressão de variáveis e de classes
- Meta-ação

### Retorno de métodos

Todo método por padrão tem o retorno de um valor númerico igual a 0.

### Herança

Todo objeto possui um atributo especial chamado “_prototype”, que pode apontar para um outro objeto, mas não para o próprio objeto.

Todo método possui um variável implícita chamada “self” que aponta para o objeto em que o
método foi chamado.

### Meta-ação

A meta-ação é um expressão que realiza a sobrescrita na implementação do método de uma classe em tempo de execução.

A meta-ação somente tem efeito na função quando é realizada uma chamada nova sobre ela.

### Referências

Os objetos sempre são enviados na atribuição por referência.
Os valores númericos são enviados por valor.

---
## Estrutura do Interpretador

Os principais módulos desenvolvidos para o interpretador:
- **Reader:** Realiza a leitura das linhas no arquivo de entrada.
- **Describer:** Descreve a estrutura das classes existentes em tabelas.
- **Executor:** Gerencia a execução de um bloco de código.
- **Env:** Armazena o ambiente de variáveis existentes no escopo de um bloco, como em métodos.
- **Parser:** Cria a estrutura ```ast``` que descreve os elementos de uma linha de código.
- **Eval:** Realiza a execução da estrutura ```ast``` gerada pela parser.

Um diagrama foi construído na plataforma Whimsical para representar graficamente a estrutura do interpretador. Para acessá-lo, clique <a href="https://whimsical.com/interpreter-TZg5aNNApiQZ9gXATLeqXu@7YNFXnKbYkRkMK52NJU7L">aqui</a>.

---

## Testes

Na pasta `tests`, estão presentes códigos criados para a realização de testes unitários sobre os principais módulos do interpretador.

---

## Contribuições

Contribuições são sempre bem-vindas! Para contribuir com o projeto, basta criar uma nova branch, realizar as alterações desejadas e submeter um pull request.

---

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.