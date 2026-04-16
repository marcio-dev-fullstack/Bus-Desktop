# Fluxo de Embarque do Aluno

```mermaid
flowchart TD

Aluno[Aluno entra no ônibus] --> Camera[Tablet ativa câmera]

Camera --> Validacao{Reconhecimento facial}

Validacao -->|Reconhecido| Confirmacao[Confirmar identidade]

Validacao -->|Não reconhecido| Manual[Registro manual]

Confirmacao --> Registro[Registrar embarque]

Manual --> Registro

Registro --> Local[Salvar no banco local]

Local --> Internet{Internet disponível}

Internet -->|Sim| API[Enviar para API]

Internet -->|Não| Fila[Fila de sincronização]

Fila --> Sync[Sincronizar quando houver rede]

API --> BancoCentral[Atualizar banco central]