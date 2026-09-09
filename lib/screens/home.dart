import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/foto.dart';
import '../services/foto_service.dart';
import 'detalhes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final FotoService _service = FotoService();

  List<Foto> fotos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarFotos();
  }

  Future<void> carregarFotos() async {
    final lista =
        await _service.carregarFotos();

    if (!mounted) return;

    setState(() {
      fotos = lista;
      carregando = false;
    });
  }

  Future<void> tirarFoto() async {
    try {
      final XFile? arquivo =
          await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (arquivo == null) return;

      final Uint8List imagem =
          await arquivo.readAsBytes();

      final String? anotacao =
          await mostrarAnotacao();

      if (!mounted) return;

      await _service.salvarFoto(
        imagem,
        anotacao ?? '',
      );

      await carregarFotos();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível tirar a foto: $e',
          ),
        ),
      );
    }
  }

  Future<String?> mostrarAnotacao() {
    final controller =
        TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Anotação',
          ),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration:
                const InputDecoration(
              hintText:
                  'Digite uma anotação...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  '',
                );
              },
              child: const Text(
                'Pular',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text,
                );
              },
              child: const Text(
                'Salvar',
              ),
            ),
          ],
        );
      },
    );
  }

  void abrirDetalhes(Foto foto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalhesScreen(
          foto: foto,
          onExcluir: () async {
            await _service.excluirFoto(foto);

            if (!mounted) return;

            Navigator.pop(context);

            await carregarFotos();
          },
          onSalvarGaleria: () async {
            await _service
                .salvarNaGaleria(foto);
          },
          onCompartilhar: () async {
            await _service
                .compartilharFoto(foto);
          },
        ),
      ),
    );
  }

  void abrirMenu() {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Menu',
      barrierDismissible: true,
      barrierColor:
          Colors.black.withOpacity(0.08),
      transitionDuration:
          const Duration(milliseconds: 180),
      pageBuilder:
          (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Material(
              color: Colors.white,
              elevation: 8,
              child: SizedBox(
                width: 190,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    _itemMenu(
                      'Splash',
                      Icons.chevron_right,
                      () {
                        Navigator.pop(context);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SplashScreenTemp(),
                          ),
                        );
                      },
                    ),
                    _itemMenu(
                      'Home',
                      Icons.chevron_right,
                      () {
                        Navigator.pop(context);
                      },
                    ),
                    _itemMenu(
                      'Sair',
                      Icons.chevron_right,
                      () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _itemMenu(
    String texto,
    IconData icone,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(
                icone,
                size: 22,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget criarCard(
    Foto foto,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        abrirDetalhes(foto);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.18),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      10,
                      10,
                      10,
                      0,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(2),
                      child: Image.memory(
                        foto.imagem,
                        width:
                            double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 5,
                    bottom: 7,
                  ),
                  child: Text(
                    foto.anotacao.isEmpty
                        ? 'Anotação'
                        : foto.anotacao,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 4,
              right: 6,
              child: GestureDetector(
                onTap: () async {
                  await _service
                      .excluirFoto(foto);

                  await carregarFotos();
                },
                child: const Icon(
                  Icons.close,
                  size: 25,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    onPressed: abrirMenu,
                    icon: const Icon(
                      Icons.menu,
                      size: 32,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Meus momentos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      right: 16,
                    ),
                    child: GestureDetector(
                      onTap: tirarFoto,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration:
                            const BoxDecoration(
                          color: Colors.white,
                          shape:
                              BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black26,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: carregando
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : fotos.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum momento ainda.',
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            24,
                            22,
                            24,
                            22,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio:
                                0.90,
                          ),
                          itemCount:
                              fotos.length,
                          itemBuilder:
                              (context, index) {
                            return criarCard(
                              fotos[index],
                              index,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreenTemp
    extends StatelessWidget {
  const SplashScreenTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Splash',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}