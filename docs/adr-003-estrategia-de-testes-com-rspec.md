# ADR-003: Estratégia de testes com RSpec

## Status

Aceita.

## Contexto

O Crudential terá regras de negócio que afetam confirmação de presença, validação de credenciais, envio de e-mails e autorização de acesso. Essas regras precisam ser documentadas por testes para evitar regressões e tornar o uso de IA mais seguro durante a evolução do código.

O projeto nasce de um scaffold Rails, mas a estratégia escolhida para testes será RSpec, por sua expressividade e ampla adoção na comunidade Ruby.

## Decisão

Usaremos RSpec como framework principal de testes automatizados.

A suíte deve cobrir models, requests, service objects, jobs, mailers e fluxos críticos de autenticação e credenciais. A prioridade será testar comportamento observável e regras de negócio, não detalhes internos frágeis.

## Trade-offs

### Benefícios

- RSpec tem DSL expressiva, adequada para descrever regras de domínio de forma legível.
- A comunidade Rails tem ampla documentação, exemplos e gems auxiliares para RSpec.
- Testes bem nomeados funcionam como documentação viva para humanos e agentes de IA.
- Request specs ajudam a validar contratos REST de ponta a ponta dentro da aplicação.
- Service specs permitem testar regras de negócio sem depender sempre de controllers.

### Custos e riscos

- RSpec adiciona dependências e configuração em relação ao Minitest padrão do Rails.
- Uma suíte mal organizada pode se tornar lenta, repetitiva ou excessivamente acoplada à implementação.
- O uso exagerado de mocks pode mascarar falhas reais de integração.
- A migração do scaffold inicial para RSpec exige remover ou ignorar padrões gerados para Minitest com cuidado.

## Consequências

- Novas funcionalidades devem vir acompanhadas de testes relevantes.
- Fluxos críticos devem priorizar request specs e testes de serviços.
- Testes devem ser escritos com nomes claros, refletindo comportamento esperado.
- Agentes de IA devem sugerir ou atualizar testes ao modificar regras de negócio, autenticação, jobs ou contratos de API.
