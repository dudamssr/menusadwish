import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

import '../models/foto.dart';

class FotoService {
  Future<Directory> _pastaFotos() async {
    final pastaBase = await getApplicationDocumentsDirectory();

    final pasta = Directory(
      '${pastaBase.path}/meus_momentos',
    );

    if (!await pasta.exists()) {
      await pasta.create(recursive: true);
    }

    return pasta;
  }

  Future<List<Foto>> carregarFotos() async {
    try {
      final pasta = await _pastaFotos();

      final arquivos = await pasta.list().toList();

      final List<Foto> fotos = [];

      for (final arquivo in arquivos) {
        if (arquivo is! File) {
          continue;
        }

        if (!arquivo.path.endsWith('.jpg')) {
          continue;
        }

        final imagem = await arquivo.readAsBytes();

        final arquivoInfo = File(
          '${arquivo.path}.json',
        );

        String data = '';
        String anotacao = '';

        if (await arquivoInfo.exists()) {
          final dados = jsonDecode(
            await arquivoInfo.readAsString(),
          );

          data = dados['data'] ?? '';
          anotacao = dados['anotacao'] ?? '';
        }

        fotos.add(
          Foto(
            imagem: imagem,
            data: data,
            anotacao: anotacao,
          ),
        );
      }

      return fotos.reversed.toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> salvarFoto(
    Uint8List imagem,
    String anotacao,
  ) async {
    final agora = DateTime.now();

    final data =
        '${agora.day.toString().padLeft(2, '0')}/'
        '${agora.month.toString().padLeft(2, '0')}/'
        '${agora.year} '
        '${agora.hour.toString().padLeft(2, '0')}:'
        '${agora.minute.toString().padLeft(2, '0')}';

    final pasta = await _pastaFotos();

    final nome =
        'foto_${DateTime.now().millisecondsSinceEpoch}';

    final arquivo = File(
      '${pasta.path}/$nome.jpg',
    );

    await arquivo.writeAsBytes(imagem);

    final arquivoInfo = File(
      '${pasta.path}/$nome.jpg.json',
    );

    await arquivoInfo.writeAsString(
      jsonEncode({
        'data': data,
        'anotacao': anotacao,
      }),
    );
  }

  Future<void> excluirFoto(Foto foto) async {
    try {
      final pasta = await _pastaFotos();

      final arquivos = await pasta.list().toList();

      for (final arquivo in arquivos) {
        if (arquivo is! File ||
            !arquivo.path.endsWith('.jpg')) {
          continue;
        }

        final imagem = await arquivo.readAsBytes();

        if (_mesmasImagens(imagem, foto.imagem)) {
          await arquivo.delete();

          final arquivoInfo = File(
            '${arquivo.path}.json',
          );

          if (await arquivoInfo.exists()) {
            await arquivoInfo.delete();
          }

          break;
        }
      }
    } catch (_) {}
  }

  Future<void> salvarNaGaleria(Foto foto) async {
    final pastaTemporaria =
        await getTemporaryDirectory();

    final arquivo = File(
      '${pastaTemporaria.path}/'
      'meu_momento_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    await arquivo.writeAsBytes(foto.imagem);

    await Gal.putImage(
      arquivo.path,
      album: 'Meus momentos',
    );

    if (await arquivo.exists()) {
      await arquivo.delete();
    }
  }

  Future<void> compartilharFoto(Foto foto) async {
    // Não é necessário para gerar o APK.
  }

  bool _mesmasImagens(
    Uint8List primeira,
    Uint8List segunda,
  ) {
    if (primeira.length != segunda.length) {
      return false;
    }

    for (int i = 0; i < primeira.length; i++) {
      if (primeira[i] != segunda[i]) {
        return false;
      }
    }

    return true;
  }
}