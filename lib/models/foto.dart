import 'dart:convert';
import 'dart:typed_data';

class Foto {
  final Uint8List imagem;
  final String data;
  final String anotacao;

  Foto({
    required this.imagem,
    required this.data,
    required this.anotacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagem': base64Encode(imagem),
      'data': data,
      'anotacao': anotacao,
    };
  }

  factory Foto.fromMap(Map<String, dynamic> map) {
    return Foto(
      imagem: base64Decode(map['imagem'] ?? ''),
      data: map['data'] ?? '',
      anotacao: map['anotacao'] ?? '',
    );
  }
}