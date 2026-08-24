import 'package:flutter/material.dart';
import 'feed_screens.dart';
import '../services/api_service.dart';
import 'cadastro_screens.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final TextEditingController usuarioController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],

      appBar: AppBar(
        title: const Text("Papacapim"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.flutter_dash, size: 100, color: Colors.green),

            const SizedBox(height: 30),

            TextField(
              controller: usuarioController,

              decoration: const InputDecoration(
                labelText: "Usuário",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: senhaController,

              obscureText: true,

              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: carregando
                    ? null
                    : () async {
                        final login = usuarioController.text.trim();

                        final senha = senhaController.text;

                        // Verifica campos vazios
                        if (login.isEmpty || senha.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Informe usuário e senha."),
                            ),
                          );

                          return;
                        }

                        setState(() {
                          carregando = true;
                        });

                        try {
                          // Faz login na API
                          final sucesso = await apiService.login(login, senha);

                          // Login realizado
                          if (sucesso) {
                            if (!mounted) return;

                            // Vai para o Feed
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FeedScreens(),
                              ),
                            );
                          } else {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Usuário ou senha incorretos."),
                              ),
                            );
                          }
                        } catch (e) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Erro ao conectar com a API: $e"),
                            ),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              carregando = false;
                            });
                          }
                        }
                      },

                child: carregando
                    ? const SizedBox(
                        height: 20,
                        width: 20,

                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Entrar"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(builder: (_) => const CadastroScreens()),
                  );
                },

                child: const Text("Criar conta"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    usuarioController.dispose();
    senhaController.dispose();

    super.dispose();
  }
}
