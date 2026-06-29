# ADR-005: Autenticação stateless com JWT

## Status

Aceita.

## Contexto

O Crudential será uma API REST consumida por clientes externos. A autenticação precisa funcionar bem sem depender de sessão de servidor ou cookies tradicionais, mantendo compatibilidade com frontends separados, integrações e clientes móveis ou administrativos.

Como o sistema lidará com acesso a eventos e credenciais, autenticação e autorização devem ser tratadas como áreas sensíveis desde o início.

## Decisão

Usaremos autenticação stateless com JWT.

Clientes autenticados receberão tokens assinados para acessar endpoints protegidos. A API deverá validar a assinatura, expiração e claims relevantes a cada requisição. Dados sensíveis não devem ser armazenados no payload do token.

## Trade-offs

### Benefícios

- Combina bem com APIs REST e clientes desacoplados.
- Reduz dependência de armazenamento de sessão no servidor.
- Facilita autenticação em múltiplos clientes, como SPA, mobile ou ferramentas internas.
- Tokens com expiração curta ajudam a limitar impacto em caso de vazamento.
- Claims podem carregar informações mínimas úteis, como identificador do usuário e tipo de acesso.

### Custos e riscos

- Revogação imediata de tokens é mais difícil em arquiteturas puramente stateless.
- Tokens vazados podem ser usados até expirarem, se não houver lista de bloqueio ou rotação.
- Implementações inseguras de JWT são comuns, especialmente com algoritmos, secrets e expiração mal configurados.
- Armazenamento do token no cliente exige cuidado contra XSS, vazamento em logs e exposição indevida.
- Pode ser necessário adicionar refresh tokens ou mecanismos de revogação conforme o produto amadurecer.

## Consequências

- Endpoints protegidos devem exigir token válido no cabeçalho de autorização.
- Tokens devem ter expiração e payload mínimo.
- Secrets e chaves de assinatura devem ser tratados como configuração sensível.
- Autorização de ações não deve depender apenas da presença de um token; regras de permissão continuam necessárias.
- Agentes de IA devem tratar autenticação como área crítica e incluir testes para cenários de token ausente, inválido, expirado e sem permissão.
