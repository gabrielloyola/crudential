# ADR-004: Organização de regras de negócio com Service Objects

## Status

Aceita.

## Contexto

O domínio do Crudential tende a acumular operações que não pertencem confortavelmente a apenas um model ou controller. Exemplos incluem registrar uma inscrição, gerar uma credencial, confirmar um participante, validar entrada em um evento e disparar e-mails relacionados.

Controllers devem permanecer focados em HTTP. Models devem preservar invariantes e comportamento diretamente ligado aos dados. Regras de aplicação que coordenam múltiplos objetos precisam de um lugar explícito.

## Decisão

Organizaremos regras de negócio com Service Objects.

Service Objects devem representar casos de uso da aplicação e orquestrar models, validações, persistência, jobs e respostas de domínio quando necessário. Eles devem ter nomes orientados a ação e escopo claro.

## Trade-offs

### Benefícios

- Reduz controllers inchados e facilita manter endpoints simples.
- Evita concentrar toda a lógica em models que passam a conhecer responsabilidades demais.
- Torna casos de uso mais fáceis de testar isoladamente.
- Ajuda agentes de IA a localizar onde uma regra deve ser criada ou alterada.
- Favorece evolução incremental sem introduzir uma arquitetura complexa demais cedo.

### Custos e riscos

- Service Objects podem virar uma camada genérica sem padrão se cada um tiver interface diferente.
- O uso excessivo pode fragmentar lógica simples que caberia bem em models.
- Sem disciplina, regras podem ficar duplicadas entre services, models e controllers.
- Pode surgir ambiguidade sobre onde colocar validações, transações e tratamento de erros.

## Consequências

- Controllers devem delegar casos de uso relevantes para services.
- Models continuam responsáveis por validações, associações, scopes e invariantes próximas aos dados.
- Services devem ter entrada, saída e erros previsíveis.
- Operações que alteram múltiplos registros devem considerar transações.
- Agentes de IA devem evitar criar lógica de negócio complexa diretamente em controllers.
