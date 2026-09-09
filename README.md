# App de fotos

Aplicativo desenvolvido em Flutter como atividade prática do curso de Desenvolvimento de Sistemas.
O projeto consiste em um aplicativo de galeria pessoal, no qual o usuário pode tirar fotos pelo próprio aplicativo, adicionar uma anotação e visualizar os momentos registrados.

## Funcionalidades

- Tela de abertura (Splash Screen)
- Tela principal do aplicativo
- Captura de fotos utilizando a câmera do dispositivo
- Armazenamento das fotos tiradas pelo próprio aplicativo
- Visualização das fotos salvas
- Registro da data e horário da foto
- Adição de anotações aos momentos registrados
- Visualização dos detalhes de uma foto
- Exclusão de fotos salvas
- Salvamento de uma foto na galeria do dispositivo

> As fotos que já estavam salvas anteriormente na galeria do celular não são carregadas pelo aplicativo. A galeria exibida pelo aplicativo contém somente as fotos registradas pelo próprio aplicativo.

## Tecnologias utilizadas

- Flutter
- Dart
- Android
- image_picker
- gal
- path_provider

## Estrutura do projeto

```text
lib/
├── main.dart
├── models/
│   └── foto.dart
├── services/
│   └── foto_service.dart
└── screens/
    ├── splash.dart
    ├── home.dart
    └── detalhes.dart

## Prints
- Estão dentro da pasta /assets.
