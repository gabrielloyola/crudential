# ADR-002: PostgreSQL como banco principal

## Status

Aceita.

## Contexto

O domínio do Crudential envolve pessoas, eventos, inscrições, credenciais, confirmações por e-mail e registros de acesso. Esses dados exigem integridade relacional, consultas confiáveis e capacidade de evoluir regras com segurança.

Embora bancos mais simples sejam suficientes para protótipos locais, o projeto tem intenção de portfólio e deve se aproximar de uma arquitetura plausível para produção.

## Decisão

Usaremos PostgreSQL como banco de dados principal da aplicação.

O PostgreSQL será a fonte de verdade para os dados transacionais do sistema, incluindo entidades centrais como eventos, participantes, credenciais, confirmações e registros de acesso.

## Trade-offs

### Benefícios

- PostgreSQL oferece integridade referencial forte, constraints, transações e bom suporte a índices.
- É amplamente usado em aplicações Rails em produção, o que fortalece o valor do projeto como estudo e portfólio.
- Permite modelar regras de unicidade importantes, como e-mail por evento, códigos de credencial e identificadores públicos.
- Escala melhor que SQLite para ambientes compartilhados, concorrência e deploys reais.
- Facilita uso futuro de recursos como JSONB, índices parciais, busca textual e auditoria.

### Custos e riscos

- A configuração local exige um serviço adicional, o que aumenta a complexidade em relação a SQLite.
- Ambientes de desenvolvimento e CI precisam de PostgreSQL disponível e corretamente configurado.
- O uso inadequado de recursos específicos do PostgreSQL pode dificultar eventual migração para outro banco.
- Consultas complexas e índices mal planejados podem causar problemas de performance conforme o volume crescer.

## Consequências

- Migrations devem expressar constraints importantes no banco, não apenas validações em models.
- A configuração com Docker Compose deve incluir PostgreSQL para desenvolvimento local.
- Testes devem rodar contra PostgreSQL para reduzir diferenças entre teste, desenvolvimento e produção.
- Agentes de IA não devem propor SQLite como banco definitivo, exceto para exemplos descartáveis ou protótipos isolados.
