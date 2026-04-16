# Arquitetura do Sistema

```mermaid
flowchart TD

Tablet[Tablet do Monitor] --> App[Aplicativo Mobile]

App --> Facial[Reconhecimento Facial]
App --> GPS[Rastreamento GPS]
App --> Embarque[Registro de Embarque]

Facial --> ML[ML Kit / TensorFlow Lite]

App --> LocalDB[Banco Local SQLite]

LocalDB --> Queue[Fila de Sincronização]

Queue --> API[API REST]

API --> Backend[Servidor Backend]

Backend --> DB[(PostgreSQL)]

DB --> Relatorios[Relatórios e Auditoria]