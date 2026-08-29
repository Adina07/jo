import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GaleriaScreens extends StatelessWidget {
  const GaleriaScreens({super.key});

  Future<void> _escolherFoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? imagem = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagem == null) {
      return;
    }

    final bytes = await File(imagem.path).readAsBytes();

    final base64Imagem = base64Encode(bytes);

    if (!context.mounted) return;

    Navigator.pop(context, base64Imagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Galeria"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Text(
              "Escolha uma foto",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.photo_library,
                      size: 100,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Escolha uma foto da galeria do dispositivo",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.photo),
                        label: const Text("Abrir Galeria"),

                        onPressed: () {
                          _escolherFoto(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Voltar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

