# App de fotos

Aplicativo desenvolvido em Flutter para registro e organização de momentos por meio de fotografias.

O aplicativo permite que o usuário tire fotos utilizando a câmera do próprio dispositivo, adicione uma anotação ao momento registrado e visualize suas fotos dentro do aplicativo.

---

## Sobre o projeto

O app de fotos foi desenvolvido como atividade prática do curso de Desenvolvimento de Sistemas.

A proposta do projeto é criar uma aplicação simples de registro de momentos, permitindo que o usuário:

- Tire fotografias utilizando a câmera do celular;
- Salve as fotografias registradas pelo aplicativo;
- Adicione uma anotação para cada foto;
- Visualize os momentos registrados;
- Consulte a data e o horário em que a foto foi tirada;
- Acesse os detalhes de cada momento;
- Exclua fotografias;
- Salve uma fotografia na galeria do dispositivo.

As fotografias que já estavam armazenadas na galeria do celular não são carregadas pelo aplicativo. Somente as fotos registradas e armazenadas pelo próprio aplicativo são exibidas.

---

##  Tecnologias utilizadas

- Flutter
- Dart
- Android
- Image Picker
- Gal
- Path Provider

---
## Prints
- Estão na pasta /assets.
---

## Estrutura do projeto

```text
lib/
├── main.dart
│
├── models/
│   └── foto.dart
│
├── services/
│   └── foto_service.dart
│
└── screens/
    ├── splash.dart
    ├── home.dart
    └── detalhes.dart
