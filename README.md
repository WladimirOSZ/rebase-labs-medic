## Descrição

Projeto desenvolvido para o Rebase Labs.

A proposta da aplicação é lidar com dados médicos usando Ruby, processamento assíncrono e desenvolver uma API.

## Tecnologias Utilizadas

A aplicação Rebase Labs é construída utilizando as seguintes tecnologias:

- Ruby
- Sinatra
- PostgreSQL
- Sidekiq
- JavaScript
- Node
- Tailwind
- RSpec e Capybara
- Docker


## Instalação

Para executar a aplicação Rebase Labs, é necessário ter o Docker instalado em sua máquina. Siga os seguintes passos:

1. Clone o repositório do GitHub: `git clone https://github.com/seu_usuario/rebase-labs.git`
2. Acesse a pasta do projeto: `cd rebase-labs`
3. Inicie os contêineres Docker com o comando: 

```bash
docker-compose up web db sidekiq redis frontend
```

O comando acima iniciará todos os serviços necessários para executar a aplicação.

Para executar os testes automatizados, utilize o seguinte comando:

```bash
docker-compose run test
```


## Uso

Para acessar o frontend da aplicação, é necessário abrir a pasta frontend e abrir o arquivo o index.html

## Banco de dados


