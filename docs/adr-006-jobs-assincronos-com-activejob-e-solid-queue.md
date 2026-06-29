# ADR-006: Jobs assíncronos com ActiveJob e Solid Queue

## Status

Aceita.

## Contexto

O Crudential precisará executar tarefas que não devem bloquear a resposta HTTP principal. O caso mais evidente é o envio de e-mails de confirmação, mas também podem surgir tarefas como geração de credenciais, auditoria, notificações e rotinas recorrentes.

Como o projeto usa Rails moderno, faz sentido começar com a abstração padrão do framework antes de adotar infraestrutura externa mais pesada.

## Decisão

Usaremos Active Job como interface para jobs assíncronos e Solid Queue como backend de filas.

Jobs devem ser usados para tarefas que podem ser executadas fora do ciclo síncrono da requisição. O fluxo principal da API deve persistir o estado necessário e delegar o trabalho demorado ou externo para a fila.

## Trade-offs

### Benefícios

- Active Job oferece uma API padrão do Rails para enfileirar e executar tarefas.
- Solid Queue reduz a necessidade inicial de Redis ou outro serviço dedicado de filas.
- A solução combina bem com deploys pequenos e médios, mantendo a operação mais simples.
- Jobs tornam endpoints mais rápidos e resilientes contra lentidão de serviços externos, como provedores de e-mail.
- A separação facilita testes e observabilidade de tarefas assíncronas.

### Custos e riscos

- Filas baseadas em banco aumentam carga no banco principal ou nos bancos auxiliares.
- Para volumes altos, uma solução especializada pode ser necessária no futuro.
- Jobs assíncronos exigem cuidado com idempotência, retries e efeitos colaterais duplicados.
- Falhas em jobs podem passar despercebidas sem monitoramento adequado.
- O comportamento assíncrono torna alguns fluxos mais difíceis de testar e depurar.

## Consequências

- Envio de e-mails deve ser executado por jobs, não diretamente no controller.
- Jobs devem ser idempotentes sempre que possível.
- Erros, retries e estados intermediários devem ser considerados nas regras de negócio.
- O ambiente Docker Compose deve prever processo de worker quando a aplicação começar a usar filas.
- Agentes de IA devem evitar acoplar tarefas externas demoradas ao ciclo HTTP principal.
