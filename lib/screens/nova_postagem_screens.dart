import 'package:flutter/material.dart';

class NovaPostagemScreens extends StatefulWidget {
  const NovaPostagemScreens({super.key});

  @override
  State<NovaPostagemScreens> createState() => _NovaPostagemScreensState();
}

class _NovaPostagemScreensState extends State<NovaPostagemScreens> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _postagemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Nova Postagem"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const CircleAvatar(
                radius: 35,
                child: Icon(Icons.person, size: 35),
              ),

              const SizedBox(height: 20),

              const Text(
                "No que você está pensando?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _postagemController,

                maxLines: 8,

                maxLength: 280,

                decoration: const InputDecoration(
                  hintText: "Digite sua postagem...",

                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Digite uma postagem.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),

                  label: const Text("Publicar"),

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Postagem publicada (simulação)"),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postagemController.dispose();

    super.dispose();
  }
}
