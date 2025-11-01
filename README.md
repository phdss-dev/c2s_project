# README.md - Sistema de Processamento de E-mails (.eml)

## Sumário

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Execução (Docker)](#instalação-e-execução-docker)
- [Upload de Arquivo .eml](#upload-de-arquivo-eml)
- [Visualizar Clientes](#visualizar-clientes)
- [Visualizar Logs de Processamento](#visualizar-logs-de-processamento)
- [Testes](#testes)
- [Logs e Monitoramento](#logs-e-monitoramento)
- [Limpeza de Logs](#limpeza-de-logs)
- [Vídeo Explicativo](#vídeo-explicativo)

---

## Visão Geral

Este projeto é um sistema Rails que processa arquivos `.eml` de diferentes remetentes (Fornecedor A e Parceiro B), extrai informações de contato e produto, cria registros de clientes e mantém logs detalhados de todos os processamentos.

---

## Arquitetura

```bash
app/
├── processors/
│   └── email_processor.rb              # Decide qual parser usar
├── models/
│   ├── parsers/
│   │   ├── parser_registry.rb          # Seleciona o parser correto
│   │   ├── parser.rb                   # Classe base abstrata
│   │   ├── partner_b_parser.rb         # Parser do Parceiro B
│   │   └── supplier_a_parser.rb        # Parser do Fornecedor A
│   ├── customer.rb                     # Model para clientes
│   ├── eml_file.rb                     # Wrapper para o arquivo .eml
│   ├── eml_processor.rb                # Service object, orquestra o processamento
│   └── processing_log.rb               # Model para logs de processamento
├── jobs/
│   ├── cleanup_processing_job.rb       # Job que limpa periodicamente os logs
│   └── process_eml_job.rb              # Job que processa o arquivo .eml
└── controllers/
    ├── processing_logs_controller.rb
    ├── customers_controller.rb
    └── process_eml_controller.rb
```

> **Extensibilidade**: Para adicionar um novo fornecedor, basta criar uma nova classe em `app/models/parsers/` herdando de `Parser`, inclui-la na lista de registry em `app/models/parsers/parser_registry.rb` e implementar os métodos necessários. Nenhum outro arquivo precisa ser alterado.

---

## Pré-requisitos

- Docker
- Docker compose
- Git
- Rails

---

## Instalação e Execução (Docker)

```bash
# 1. Clone o repositório
git clone https://github.com/phdss-dev/c2s_project
cd c2s_project

# 2. Crie e preencha o arquivo .env de acordo com o .env.example

# 3. Suba os containers
docker compose up -d

# 3. Crie os bancos e execute migrações
rails db:create
rails db:migrate

# 4. Rode os testes
bundle exec rspec

# 5. Rodando a aplicação
rails server
```

Acesse: [http://localhost:3000]

### Serviços Ativos

| Serviço    | Descrição                       | Porta |
| ---------- | ------------------------------- | ----- |
| `web`      | Aplicação Rails + Puma          | 3000  |
| `redis`    | Cache e filas (Sidekiq)         | 6379  |
| `db`       | Banco de dados PostgreSQL       | 5432  |
| `loki`     | Armazenamento de logs           | 3100  |
| `promtail` | Coletor e envio de logs ao Loki | —     |
| `grafana`  | Visualização e monitoramento    | 3030  |

---

## Uso do Sistema

### Upload de Arquivo .eml

1. Acesse `http://localhost:3000`
2. Selecione um arquivo `.eml` (ex: da pasta `spec/emails/`)
3. Clique em **"Processar E-mail"**

> O arquivo será salvo, enfileirado no Sidekiq e processado em background.

### Visualizar Clientes

- Acesse: **`/customers`**
- Lista todos os clientes extraídos com sucesso.

### Visualizar Logs de Processamento

- Acesse: **`/processing_logs`**
- Exibe as informações sobre todos os processamentos de logs

---

## Testes
Antes de rodar os testes rode o seguinte script para gerar os arquivos "expected".

```bash
ruby script/generate_expected.rb
bundle exec rspec
```

Cobertura:
- [x] Processador escolhe parser correto
- [x] Parsers extraem dados corretamente
- [x] Falha quando não há contato
- [x] Worker enfileira e processa
- [x] Criação de logs de sucesso e falha
---

## Logs e Monitoramento
Em relação aos logs e monitoramentos, cobri dois tipos nesse projeto. Podemos acompanhar os logs relacionados ao processamentos na própria aplicação. E podemos acompanhar os logs do Rails e do sistema através do grafana, para isso basta acessar: `http://localhost:3030`. Fazer login com as credenciais, user: `admin` e senha: `c2s@grafana`.

Será necessários os seguintes passos:

1. Configurar uma "data source" que nesse caso será o loki.
Para isso abra o menu lateral, selecione `connections`
* como os serviços estão rodando no docker, basta apontar a url do data source para: http://nome_do_container_loki:3100
2. Com a conexão criada, vá na opção `Dashboard`, depois em `New` e importe o dashboard de código `13639`.
3. Ainda na tela de criação do dashboard, selecione o Loki como datasource.
4. Pronto. Isso deverá bastar para que você acesse os logs no dashboard.
---

## Limpeza de Logs

Tarefa agendada através do Sidekiq Cron
Executada por padrão a cada 10 minutos, caso deseje alterar, pode ser feito atravès do arquivo `schedule.yml`

---

## CI/CD

Configurado com **GitHub Actions** (`.github/workflows/ci.yml`):

```yaml
- name: Testes
  run: bundle exec rspec
```

Executa em todo `push` e `pull request`.

---

## Vídeo Explicativo

> **Link**: [https://youtu.be/xxxxxxx](https://youtu.be/xxxxxxx)
---
