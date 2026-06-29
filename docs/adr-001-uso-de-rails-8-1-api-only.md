# ADR-001: Uso de Rails 8.1 API-only

## Status

Aceita.

## Contexto

O Crudential será uma API REST para cadastro de pessoas em eventos, envio de e-mails de confirmação, validação de credenciais e controle de acesso. O projeto também tem objetivo educacional e de portfólio, com uso frequente de IA durante a concepção, documentação, implementação e revisão.

A aplicação não precisa entregar HTML renderizado pelo servidor no primeiro momento. O foco está em expor endpoints claros, testáveis e consumíveis por clientes externos, como frontends separados, ferramentas administrativas, scripts ou integrações futuras.

## Decisão

Usaremos Rails 8.1 em modo API-only como base da aplicação.

O modo API-only reduz a superfície inicial do framework, mantendo os componentes centrais necessários para uma API: roteamento, controllers, Active Record, Active Job, Action Mailer, validações, serialização de respostas e integração com middlewares essenciais.

## Trade-offs

### Benefícios

- Rails oferece alta produtividade para CRUDs, validações, migrations, jobs, mailers e testes.
- O modo API-only evita carregar componentes voltados a views, assets, helpers e sessões baseadas em cookies que não são prioridade neste produto.
- A convenção do Rails facilita colaboração com agentes de IA, porque a estrutura do projeto é previsível.
- Rails 8.1 mantém o projeto alinhado a uma versão moderna do ecossistema, útil para estudo e portfólio.
- A integração nativa com Active Job, Action Mailer e Active Record reduz a necessidade de decisões prematuras sobre bibliotecas externas.

### Custos e riscos

- Rails pode ser mais pesado que microframeworks como Sinatra, Roda ou Hanami API para APIs muito pequenas.
- O modo API-only remove conveniências de aplicações full-stack; se o projeto ganhar interface server-rendered, será necessário reintroduzir partes do stack.
- A adoção de Rails 8.1 pode exigir atenção a mudanças recentes do framework, compatibilidade de gems e documentação atualizada.
- A produtividade por convenção pode esconder decisões arquiteturais importantes se o projeto crescer sem documentação.

## Consequências

- A API será projetada em torno de recursos REST, respostas JSON e autenticação stateless.
- Views HTML, assets e sessões tradicionais não fazem parte do escopo inicial.
- Decisões futuras devem favorecer soluções idiomáticas de Rails antes de introduzir frameworks paralelos.
- Agentes de IA devem consultar estas ADRs antes de sugerir mudanças estruturais no framework ou no modo da aplicação.
