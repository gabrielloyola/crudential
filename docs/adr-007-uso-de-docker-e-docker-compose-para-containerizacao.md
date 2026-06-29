# ADR-007: Uso de Docker e Docker Compose para containerização

## Status

Aceita.

## Contexto

O Crudential depende de serviços como aplicação Rails, PostgreSQL e workers de jobs. Como o projeto tem finalidade educacional e de portfólio, é importante que o ambiente seja reprodutível para desenvolvimento, testes e demonstrações.

Ambientes locais configurados manualmente tendem a divergir com o tempo, especialmente quando há colaboração com agentes de IA e execução frequente de comandos.

## Decisão

Usaremos Docker e Docker Compose para containerização e orquestração local dos serviços do projeto.

Docker será usado para empacotar a aplicação. Docker Compose será usado para subir a aplicação e serviços de apoio, como PostgreSQL e processos de fila, de forma previsível no ambiente de desenvolvimento.

## Trade-offs

### Benefícios

- Reduz diferenças entre máquinas de desenvolvimento.
- Facilita onboarding e execução do projeto por recrutadores, avaliadores ou colaboradores.
- Permite declarar serviços de infraestrutura em um arquivo versionado.
- Aproxima o ambiente local de uma configuração realista de deploy.
- Ajuda agentes de IA a trabalhar com comandos previsíveis e documentados.

### Custos e riscos

- Builds podem ficar lentos se o cache e os volumes forem mal configurados.
- Problemas de permissão, rede e volumes podem dificultar depuração.
- O ambiente containerizado pode mascarar diferenças do ambiente de produção se não for mantido com cuidado.
- Compose resolve bem o desenvolvimento local, mas não substitui uma estratégia completa de deploy.

## Consequências

- O projeto deve documentar comandos principais para build, setup, testes, servidor e workers.
- Serviços externos necessários ao desenvolvimento devem ser declarados no Docker Compose.
- Configurações sensíveis devem vir de variáveis de ambiente ou credenciais seguras, não de valores hardcoded.
- A imagem Docker deve ser mantida enxuta e coerente com o ambiente de execução.
- Agentes de IA devem preferir alterar documentação e configuração de containers de forma explícita, sem instalar dependências diretamente na máquina do usuário.
