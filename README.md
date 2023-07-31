## Descrição

Projeto desenvolvido para o Rebase Labs.

Aplicação de dados médicos usando Ruby com Sinatra, processamento assíncrono e desenvolvendo API.

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
Diagrama:
![DIAGRAM](https://github.com/WladimirOSZ/rebase-labs-medic/assets/61012948/ae446070-efc2-4bb9-b506-321074a9c57c)

