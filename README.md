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

## API

Documentação das Rotas de API:

1. POST /api/v1/async_import:
   - Descrição: Importa um arquivo CSV assincronamente.
   - Parâmetros: Arquivo CSV com os dados.

2. GET /api/v1/exams:
   - Descrição: Retorna a lista de todos os exames.
   - Dados de Resposta:
     - result_date (Data do exame)
     - exam_id (ID do exame)
     - result_token (Token do resultado do exame)
     - cpf (CPF do paciente)
     - name (Nome do paciente)
     - birthday (Data de nascimento do paciente)
     - doctor_name (Nome do médico)

3. GET /api/v1/exams/:id:
   - Descrição: Retorna detalhes de um exame por ID.
   - Parâmetros: id (ID do exame).
   - Dados de Resposta:
     - result_date (Data do exame)
     - result_token (Token do resultado do exame)
     - cpf (CPF do paciente)
     - name (Nome do paciente)
     - email (Email do paciente)
     - birthday (Data de nascimento do paciente)
     - doctor (Detalhes do médico):
       - crm (CRM do médico)
       - crm_state (Estado do CRM do médico)
       - name (Nome do médico)
       - email (Email do médico)
     - tests (Lista de testes realizados):
       - type (Tipo do teste)
       - limits (Limites do teste)
       - result (Resultado do teste)

4. GET /api/v1/exams/token/:token:
   - Descrição: Retorna detalhes de um exame por token.
   - Parâmetros: token (Token do exame).
   - Dados de Resposta: (Mesmos dados da rota GET /api/v1/exams/:id)

## Busca de Exames
A busca de exames na aplicação frontend busca por nome do paciente, CPF do paciente, nome do médico e código do exame via Javascript.

## Banco de dados
Diagrama:
![DIAGRAM](https://github.com/WladimirOSZ/rebase-labs-medic/assets/61012948/ae446070-efc2-4bb9-b506-321074a9c57c)

