
import 'package:flutter/material.dart';
import '../models/foto.dart';

class DetalhesScreen extends StatelessWidget {
  final Foto foto;

  final Future<void> Function() onExcluir;
  final Future<void> Function() onSalvarGaleria;
  final Future<void> Function() onCompartilhar;

  const DetalhesScreen({
    super.key,
    required this.foto,
    required this.onExcluir,
    required this.onSalvarGaleria,
    required this.onCompartilhar,
  });

  Future<void> confirmarExclusao(
    BuildContext context,
  ) async {
    final bool? confirmar =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Excluir foto?',
          ),
          content: const Text(
            'Deseja realmente excluir esta foto?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Excluir',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await onExcluir();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 62,
              decoration:
                  const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 26,
                      color: Colors.grey,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Detalhes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  28,
                  35,
                  28,
                  30,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Image.memory(
                        foto.imagem,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 75),
                    const Text(
                      'Anotação',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      foto.anotacao.isEmpty
                          ? 'Nenhuma anotação'
                          : foto.anotacao,
                      textAlign:
                          TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      foto.data,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        IconButton(
                          tooltip:
                              'Salvar na galeria',
                          onPressed: () async {
                            await onSalvarGaleria();
                          },
                          icon: const Icon(
                            Icons.download,
                            size: 27,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          tooltip:
                              'Compartilhar',
                          onPressed: () async {
                            await onCompartilhar();
                          },
                          icon: const Icon(
                            Icons.share,
                            size: 27,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          tooltip:
                              'Excluir',
                          onPressed: () {
                            confirmarExclusao(
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 29,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
