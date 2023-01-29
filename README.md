# BOL Interpreter

## Como executar

Execute o comando abaixo:

```
  lua interpreter.lua program.bol
```


## Desenvolvedores

- Luiz Fernando de Freitas Oliveira
- Pedro Augusto Serafim Belo
- Ryan Fernandes Auder Lopes

## Descrição

- Trabalho desenvolvido em grupo durante a disciplina de Linguagens e Paradigmas de Programação (6º período do curso de Ciência da Computação)
- O programa consiste em um interpretador da linguagem fictícia BOL (Bruno's Object-Oriented Language)
- Linguagem utilizada para a implementação do interpretador: Lua 5.4

## Detalhes de Implementação

### Sobre o retorno de métodos

Todo método por padrão tem o retorno de um valor númerico igual a 0

### Sobre a meta-ação

A meta-ação somente tem efeito na função quando é realizada uma chamada nova sobre ela.

### Sobre referências

Os objetos sempre são enviados na atribuição por referência.
Os valores númericos são enviados por valor.