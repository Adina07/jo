import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'perfil_editar_screens.dart';

class PerfilScreens extends StatefulWidget {
  final String? login;

  const PerfilScreens({super.key, this.login});

  @override
  State<PerfilScreens> createState() => _PerfilScreensState();
}

class _PerfilScreensState extends State<PerfilScreens> {
  // true = perfil do usuário logado
  // false = perfil de outro usuário
  bool get meuPerfil => widget.login == null;

  bool seguindo = false;
  bool _carregandoSeguir = false;

  bool _carregando = true;
  String? _erro;

  String _nome = '';
  String _login = '';
  String? _imagem;

  int _seguidores = 0;
  int _seguindo = 0;

  Future<void> _alternarSeguir() async {
    if (_carregandoSeguir) return;

    setState(() {
      _carregandoSeguir = true;
    });

    try {
      // Usa o login real do usuário exibido no perfil
      final login = _login;

      final resposta = seguindo
          ? await apiService.unfollowUser(login)
          : await apiService.followUser(login);

      print('STATUS SEGUIR: ${resposta.statusCode}');
      print('BODY SEGUIR: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200 ||
          resposta.statusCode == 201 ||
          resposta.statusCode == 204) {
        setState(() {
          seguindo = !seguindo;

          if (seguindo) {
            _seguidores++;
          } else if (_seguidores > 0) {
            _seguidores--;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              seguindo
                  ? 'Você começou a seguir $_login.'
                  : 'Você deixou de seguir $_login.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível alterar o seguimento. '
              'Código: ${resposta.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao seguir usuário: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _carregandoSeguir = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final resposta = widget.login == null
          ? await apiService.getMe()
          : await apiService.getUser(widget.login!);

      print('STATUS PERFIL: ${resposta.statusCode}');
      print('BODY PERFIL: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        setState(() {
          _nome = dados['name'] ?? '';
          _login = dados['login'] ?? '';
          _imagem = dados['profile_image'];

          _seguidores = dados['followers_number'] ?? 0;
          _seguindo = dados['following_number'] ?? 0;

          seguindo = dados['you_follow'] ?? false;

          _carregando = false;
        });
      } else {
        setState(() {
          _erro =
              'Não foi possível carregar o perfil. '
              'Código: ${resposta.statusCode}';

          _carregando = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = 'Erro ao carregar perfil: $e';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Perfil"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    Text(_erro!, textAlign: TextAlign.center),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: _carregarPerfil,
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _carregarPerfil,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    // FOTO DO PERFIL
                    _imagem != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(_imagem!),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            child: Icon(Icons.person, size: 60),
                          ),

                    const SizedBox(height: 20),

                    // NOME
                    Text(
                      _nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // LOGIN
                    Text(
                      "@$_login",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),

                    const SizedBox(height: 30),

                    // ESTATÍSTICAS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        Column(
                          children: const [
                            Text(
                              "35",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Posts"),
                          ],
                        ),

                        Column(
                          children: [
                            Text(
                              '$_seguindo',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("Seguindo"),
                          ],
                        ),

                        Column(
                          children: [
                            Text(
                              '$_seguidores',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("Seguidores"),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    if (meuPerfil)
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),

                          label: const Text("Editar Perfil"),

                          onPressed: () async {
                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PerfilEditarScreens(),
                              ),
                            );

                            if (resultado == true) {
                              _carregarPerfil();
                            }
                          },
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: _carregandoSeguir ? null : _alternarSeguir,

                          child: _carregandoSeguir
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(seguindo ? "Deixar de seguir" : "Seguir"),
                        ),
                      ),

                    const SizedBox(height: 30),

                    const Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "Postagens",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
    );
  }
}
