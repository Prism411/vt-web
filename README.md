# vtweb

Parte web para visualização dos dados do projeto Visage Track

## WEB

Os repositórios web estão disponíveis em:

- **Repositório Web:** [vt-web](https://github.com/visagetrack-project/vt-web.git) - Ambiente web desenvolvido em Flutter, incluindo sistema de autenticação e banco de dados Firebase.
- **API Primária:** [vt-api](https://github.com/visagetrack-project/vt-api.git) - Escrita em Go, essa API faz a comunicação direta com a web e é essencial para o funcionamento do projeto.

## Comunicação

### API Primária

A API primária, cujo repositório pode ser encontrado em [vt-api](https://github.com/visagetrack-project/vt-api.git), gerencia as requisições do servidor web e recebe dados processados da API secundária.

### API Secundária

Localizada em [vt-model](https://github.com/visagetrack-project/vt-model), esta API é responsável pelo processamento das imagens. O arquivo [api_communication.py](https://github.com/visagetrack-project/vt-model/blob/main/api_communication.py) é utilizado para capturar, transformar os dados e enviá-los para a API primária. Importante destacar que `main.py` não chama esse arquivo diretamente; em vez disso, uma API terciária gerencia essa comunicação automaticamente, além de gerar gráficos.

### API Terciária

Esta API, escrita em C# e hospedada em um repositório privado, é responsável por gerar as imagens e enviá-las para serem processadas pela IA. Ela também recebe as imagens processadas de volta da API secundária. Além disso, essa API é responsável por criar um novo ambiente Unity a cada requisição através do endpoint `/createNewAmbient{params1}/{params2}/{params3}`, preparando o cenário para as operações das demais APIs.

Após isso esperar algum tempo até o ambiente unity ser criado e os dados atualizados para a api em GO lançar a web todas
as imagens.
