# Contexto do projeto para agentes de IA

## Visão geral

Crudential é um projeto de estudo e portfólio pessoal construído como uma API REST em Rails. O objetivo é criar um CRUD para eventos, participantes e credenciais, permitindo cadastrar pessoas, enviar e-mails de confirmação, validar credenciais e registrar acesso de participantes a eventos.

O projeto será implementado com uso frequente de IA, mas as decisões arquiteturais devem ser documentadas antes de mudanças relevantes no código. Este arquivo existe para orientar agentes de IA sobre o produto, as decisões já tomadas e os limites de colaboração.

## Objetivos do produto

- Cadastrar e gerenciar eventos.
- Cadastrar participantes em eventos.
- Enviar e-mails de confirmação.
- Gerar ou associar credenciais de acesso.
- Validar credenciais apresentadas na entrada de eventos.
- Registrar tentativas e confirmações de acesso.
- Expor tudo por APIs REST com respostas JSON.

## Objetivos de estudo e portfólio

- Demonstrar domínio progressivo de Rails moderno em modo API-only.
- Praticar documentação arquitetural com ADRs.
- Usar IA como apoio para planejamento, implementação, revisão e testes.
- Manter decisões explícitas para que o histórico do projeto seja compreensível.
- Priorizar código simples, testável e alinhado ao ecossistema Rails.

## Decisões arquiteturais aceitas

- Rails 8.1 API-only como base da aplicação.
- PostgreSQL como banco principal.
- RSpec como framework de testes.
- Service Objects para organizar casos de uso e regras de negócio.
- Autenticação stateless com JWT.
- Active Job com Solid Queue para tarefas assíncronas.
- Docker e Docker Compose para containerização e ambiente local.

## Diretrizes para agentes de IA

- Ler as ADRs antes de propor mudanças estruturais.
- Respeitar as decisões já aceitas, mesmo quando houver alternativas válidas.
- Criar ou atualizar documentação antes de mudanças arquiteturais relevantes.
- Não instalar gems, escrever código ou alterar configuração quando a tarefa pedir apenas documentação.
- Preferir soluções idiomáticas de Rails antes de introduzir novas camadas ou dependências.
- Manter controllers focados em HTTP e delegar regras de aplicação para services quando apropriado.
- Incluir ou sugerir testes quando alterar comportamento de negócio.
- Tratar autenticação, credenciais, tokens e dados pessoais como áreas sensíveis.
- Evitar overengineering: o projeto deve ser didático, claro e evolutivo.

## Modelo mental do domínio

Entidades prováveis do domínio:

- Evento: representa uma ocasião com nome, data, local, capacidade e status.
- Participante: representa uma pessoa inscrita ou convidada.
- Inscrição: relaciona participante e evento, com estado de confirmação.
- Credencial: representa o meio usado para validar acesso, como código, token ou QR Code.
- Acesso: registra validações de entrada, incluindo sucesso, falha, horário e motivo.
- Usuário administrativo: representa quem gerencia eventos e consulta registros.

Esses nomes ainda podem evoluir durante a modelagem, mas mudanças devem preservar a clareza do domínio.

## Fluxos principais esperados

1. Um administrador cria um evento.
2. Um participante é cadastrado em um evento.
3. A aplicação envia um e-mail de confirmação.
4. O participante confirma presença ou recebe uma credencial.
5. Na entrada do evento, a credencial é validada pela API.
6. A aplicação registra o resultado da tentativa de acesso.

## Critérios de qualidade

- APIs devem ter contratos claros, status HTTP adequados e mensagens de erro consistentes.
- Regras de negócio críticas devem ter testes automatizados.
- Operações externas, como envio de e-mail, devem ser assíncronas.
- Dados sensíveis não devem aparecer em logs, payloads públicos ou tokens JWT.
- Migrations devem refletir integridade de dados com constraints e índices quando necessário.
- Documentação deve acompanhar decisões que mudem a arquitetura ou o comportamento central.

## Observação sobre o estado inicial

O repositório pode começar com configurações geradas pelo scaffold padrão do Rails. As ADRs documentam as decisões arquiteturais desejadas para a evolução do projeto. Quando código e configuração forem alterados, eles devem convergir gradualmente para estas decisões, com commits pequenos e verificáveis.
