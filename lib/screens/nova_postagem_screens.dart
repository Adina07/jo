import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NovaPostagemScreens extends StatefulWidget {
  const NovaPostagemScreens({super.key});

  @override
  State<NovaPostagemScreens> createState() => _NovaPostagemScreensState();
}

class _NovaPostagemScreensState extends State<NovaPostagemScreens> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _postagemController = TextEditingController();
  bool _carregando = false;
  Future<void> _publicar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final mensagem = _postagemController.text.trim();

      final resposta = await apiService.createPost(mensagem);

      print('STATUS POST: ${resposta.statusCode}');
      print('BODY POST: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Postagem publicada com sucesso!")),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Não foi possível publicar a postagem. "
              "Código: ${resposta.statusCode}",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao conectar com a API: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

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
                  icon: _carregando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),

                  label: Text(_carregando ? "Publicando..." : "Publicar"),

                  onPressed: _carregando ? null : _publicar,
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
