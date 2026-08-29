import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'perfil_screens.dart';

class BuscaScreens extends StatefulWidget {
  const BuscaScreens({super.key});

  @override
  State<BuscaScreens> createState() => _BuscaScreensState();
}

class _BuscaScreensState extends State<BuscaScreens> {
  final TextEditingController _pesquisaController =
      TextEditingController();

  List<dynamic> _usuarios = [];
  List<dynamic> _posts = [];

  bool _carregando = false;
  String? _erro;

  Future<void> _buscar() async {
    final pesquisa = _pesquisaController.text.trim();

    if (pesquisa.isEmpty) {
      setState(() {
        _usuarios = [];
        _posts = [];
        _erro = null;
      });

      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final respostas = await Future.wait([
        apiService.searchUsers(pesquisa),
        apiService.searchPosts(pesquisa),
      ]);

      final respostaUsuarios = respostas[0];
      final respostaPosts = respostas[1];

      print(
        'STATUS BUSCA USUÁRIOS: ${respostaUsuarios.statusCode}',
      );
      print(
        'BODY BUSCA USUÁRIOS: ${respostaUsuarios.body}',
      );

      print(
        'STATUS BUSCA POSTS: ${respostaPosts.statusCode}',
      );
      print(
        'BODY BUSCA POSTS: ${respostaPosts.body}',
      );

      if (!mounted) return;

      if (respostaUsuarios.statusCode == 200 &&
          respostaPosts.statusCode == 200) {
        final usuarios = jsonDecode(respostaUsuarios.body);
        final posts = jsonDecode(respostaPosts.body);

        setState(() {
          _usuarios = usuarios;
          _posts = posts;
          _carregando = false;
        });
      } else {
        setState(() {
          _usuarios = [];
          _posts = [];
          _carregando = false;

          _erro =
              'Não foi possível realizar a busca.';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _usuarios = [];
        _posts = [];
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
                _buscar();
              },

              decoration: InputDecoration(
                labelText: "Buscar usuários ou posts",

                prefixIcon: const Icon(Icons.search),

                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscar,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: _carregando
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _erro != null
                      ? Center(
                          child: Text(
                            _erro!,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Usuários",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              if (_usuarios.isEmpty)
                                const Padding(
                                  padding:
                                      EdgeInsets.all(10),
                                  child: Text(
                                    "Nenhum usuário encontrado.",
                                  ),
                                )
                              else
                                ..._usuarios.map(
                                  (usuario) {
                                    final login =
                                        usuario['login'] ?? '';

                                    final nome =
                                        usuario['name'] ?? '';

                                    final imagem =
                                        usuario['profile_image'];

                                    return Card(
                                      child: ListTile(
                                        leading: imagem !=
                                                null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(
                                                  imagem,
                                                ),
                                              )
                                            : const CircleAvatar(
                                                child: Icon(
                                                  Icons.person,
                                                ),
                                              ),

                                        title: Text(nome),

                                        subtitle:
                                            Text('@$login'),

                                        trailing:
                                            ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    PerfilScreens(
                                                  login: login,
                                                ),
                                              ),
                                            );
                                          },
                                          child:
                                              const Text("Ver"),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              const SizedBox(height: 25),

                              const Text(
                                "Postagens",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              if (_posts.isEmpty)
                                const Padding(
                                  padding:
                                      EdgeInsets.all(10),
                                  child: Text(
                                    "Nenhuma postagem encontrada.",
                                  ),
                                )
                              else
                                ..._posts.map(
                                  (post) {
                                    final mensagem =
                                        post['message'] ?? '';

                                    final usuario =
                                        post['user'];

                                    final nomeUsuario =
                                        usuario?['name'] ??
                                            '';

                                    final loginUsuario =
                                        usuario?['login'] ??
                                            '';

                                    return Card(
                                      margin:
                                          const EdgeInsets
                                              .only(
                                        bottom: 10,
                                      ),

                                      child: Padding(
                                        padding:
                                            const EdgeInsets
                                                .all(15),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,

                                          children: [
                                            Text(
                                              nomeUsuario,
                                              style:
                                                  const TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),

                                            Text(
                                              '@$loginUsuario',
                                              style:
                                                  TextStyle(
                                                color: Colors
                                                    .grey[600],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),

                                            Text(
                                              mensagem,
                                              style:
                                                  const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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

  @override
  void dispose() {
    _pesquisaController.dispose();

    super.dispose();
  }
}