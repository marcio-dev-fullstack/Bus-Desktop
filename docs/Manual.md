## Guia Técnico: Telas do Protótipo (v1.1)

### 1. Tela de Login: Acesso Restrito e Seguro [RNF-003]

A primeira camada de proteção do sistema. Não é apenas uma entrada, mas o ponto onde o dispositivo se identifica para o servidor da prefeitura.

* **O que demonstra:** Segurança e conformidade com a LGPD.
* **Destaque:** Preparada para autenticação via **Token JWT**, garantindo que apenas monitores autorizados acessem dados dos alunos.

### 2. Dashboard: O Centro de Comando [RF-001]

Após o login, o monitor visualiza o status do veículo e as ferramentas de preparação para a rota.

* **O que demonstra:** O conceito **Offline First**. Ao clicar em "Sincronizar", o app baixa a lista de alunos e os vetores de face para o banco SQLite interno.
* **Destaque:** Interface de alto contraste nas cores do município (**Verde, Azul e Amarelo**) para facilitar a leitura em tablets sob luz solar.

### 3. Validação Facial: Inteligência na Borda [RF-002 / RF-004]

A tela principal de operação. Utiliza a câmera para identificar o aluno automaticamente.

* **O que demonstra:** **Edge Computing**. O reconhecimento ocorre no dispositivo, sem precisar de internet na zona rural.
* **Destaque:** Ao confirmar o rosto, o sistema captura silenciosamente a **Latitude e Longitude (Geotagging)**, criando a prova de vida e de local exigida pelo FNDE/INEP para auditoria de repasses.

### 4. Chamada Manual: Fallback de Segurança [RF-003]

Uma lista de contingência para casos onde a biometria não seja possível (ex: câmera obstruída ou aluno ferido).

* **O que demonstra:** Resiliência do sistema. O monitor nunca fica "travado" se a tecnologia falhar.
* **Destaque:** Permite marcar o embarque com um clique, mantendo a integridade da lista de passageiros.

### 5. Resumo e Chegada: Geofencing e Auditoria [RF-005]

Exibe o total de alunos transportados e detecta a proximidade com a escola.

* **O que demonstra:** Automação de processos. O **Geofencing** avisa quando o ônibus entra no perímetro escolar.
* **Destaque:** O botão "Finalizar e Enviar" encerra a viagem e prepara o pacote de dados criptografados para ser enviado via Wi-Fi ou 4G assim que disponível, completando o ciclo de monitoramento.
