import 'perfil_screens.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';

class BuscaScreens extends StatefulWidget {
  const BuscaScreens({super.key});

  @override
  State<BuscaScreens> createState() => _BuscaScreensState();
}

class _BuscaScreensState extends State<BuscaScreens> {
  final TextEditingController _pesquisaController = TextEditingController();
  List<dynamic> _usuarios = [];
  bool _carregando = false;
  String? _erro;

  Future<void> _buscarUsuarios() async {
    final pesquisa = _pesquisaController.text.trim();

    if (pesquisa.isEmpty) {
      setState(() {
        _usuarios = [];
        _erro = null;
      });
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final resposta = await apiService.searchUsers(pesquisa);

      print('STATUS BUSCA: ${resposta.statusCode}');
      print('BODY BUSCA: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        setState(() {
          _usuarios = dados;
          _carregando = false;
        });
      } else {
        setState(() {
          _usuarios = [];
          _carregando = false;
          _erro =
              'Não foi possível realizar a busca. '
              'Código: ${resposta.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _usuarios = [];
        _carregando = false;
        _erro = 'Erro ao realizar busca: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Buscar"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: _pesquisaController,

              textInputAction: TextInputAction.search,

              onSubmitted: (_) {
                _buscarUsuarios();
              },

              decoration: InputDecoration(
                labelText: "Buscar usuários",
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarUsuarios,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Usuários",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            if (_carregando)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              )
            else if (_erro != null)
              Text(_erro!, style: const TextStyle(color: Colors.red))
            else if (_usuarios.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("Nenhum usuário encontrado."),
              )
            else
              ..._usuarios.map((usuario) {
                final login = usuario['login'] ?? '';
                final nome = usuario['name'] ?? '';
                final imagem = usuario['profile_image'];

                return Card(
                  child: ListTile(
                    leading: imagem != null
                        ? CircleAvatar(backgroundImage: NetworkImage(imagem))
                        : const CircleAvatar(child: Icon(Icons.person)),

                    title: Text(nome),

                    subtitle: Text('@$login'),

                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PerfilScreens(login: usuario['login']),
                          ),
                        );
                      },
                      child: const Text("Ver"),
                    ),
                  ),
                );
              }),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Postagens",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.article),

                title: const Text("Aprendendo Flutter no projeto Papacapim."),

                subtitle: const Text("Publicado por @adina"),

                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.article),

                title: const Text("Quem conhece bons cursos de Flutter?"),

                subtitle: const Text("Publicado por @maria"),

                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }
}
