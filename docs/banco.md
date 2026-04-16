# Modelo de Banco de Dados

```mermaid
erDiagram

ALUNO {
int id
string nome
string matricula
string escola
}

VIAGEM {
int id
date data
string rota
}

EMBARQUE {
int id
int aluno_id
int viagem_id
datetime horario
string status
}

LOCALIZACAO {
int id
int viagem_id
float latitude
float longitude
datetime timestamp
}

ALUNO ||--o{ EMBARQUE : registra
VIAGEM ||--o{ EMBARQUE : possui
VIAGEM ||--o{ LOCALIZACAO : gera