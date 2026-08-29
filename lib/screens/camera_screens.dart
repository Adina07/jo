import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreens extends StatelessWidget {
  const CameraScreens({super.key});

  Future<void> _tirarFoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? imagem = await picker.pickImage(
      source: ImageSource.camera,
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
        title: const Text("Câmera"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: double.infinity,
              height: 300,

              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),

              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Câmera do dispositivo",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text("Tirar Foto"),

                onPressed: () {
                  _tirarFoto(context);
                },
              ),
            ),

            const SizedBox(height: 15),

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
