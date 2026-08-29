import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'camera_screens.dart';
import 'galeria_screens.dart';

class PerfilEditarScreens extends StatefulWidget {
  const PerfilEditarScreens({super.key});

  @override
  State<PerfilEditarScreens> createState() => _PerfilEditarScreensState();
}

class _PerfilEditarScreensState extends State<PerfilEditarScreens> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController(
    text: "Ádina Souza",
  );

  final TextEditingController _senhaController = TextEditingController();
  bool _carregandoPerfil = true;
  bool _salvando = false;
  bool _excluindo = false;
  String? _fotoPerfil;

  @override
  void initState() {
    super.initState();

    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final resposta = await apiService.getMe();

      print('STATUS PERFIL EDIÇÃO: ${resposta.statusCode}');
      print('BODY PERFIL EDIÇÃO: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        setState(() {
          _nomeController.text = dados['name'] ?? '';
          _carregandoPerfil = false;
        });
      } else {
        setState(() {
          _carregandoPerfil = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível carregar o perfil. '
              'Código: ${resposta.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregandoPerfil = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar perfil: $e')));
    }
  }

  Future<void> _excluirPerfil() async {
    setState(() {
      _excluindo = true;
    });
    // TESTE: verificar se o token ainda está válido
    final testePerfil = await apiService.getMe();

    print('STATUS TESTE GET ME: ${testePerfil.statusCode}');
    print('BODY TESTE GET ME: ${testePerfil.body}');

    // EXCLUSÃO DA CONTA
    final resposta = await apiService.deleteMe();

    print('STATUS EXCLUSÃO PERFIL: ${resposta.statusCode}');
    print('BODY EXCLUSÃO PERFIL: ${resposta.body}');

    try {
      final resposta = await apiService.deleteMe();

      print('STATUS EXCLUSÃO PERFIL: ${resposta.statusCode}');
      print('BODY EXCLUSÃO PERFIL: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200 || resposta.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil excluído com sucesso.')),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível excluir o perfil. '
              'Código: ${resposta.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir perfil: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _excluindo = false;
        });
      }
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _salvando = true;
    });

    try {
      final nome = _nomeController.text.trim();
      final senha = _senhaController.text.trim();

      final resposta = await apiService.updateMe(
        name: nome,
        password: senha.isEmpty ? null : senha,
        imageData: _fotoPerfil,
      );

      print('STATUS ATUALIZAÇÃO PERFIL: ${resposta.statusCode}');
      print('BODY ATUALIZAÇÃO PERFIL: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível atualizar o perfil. '
              'Código: ${resposta.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar perfil: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Editar Perfil"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              CircleAvatar(
                radius: 60,

                backgroundImage: _fotoPerfil != null
                    ? MemoryImage(base64Decode(_fotoPerfil!))
                    : null,

                child: _fotoPerfil == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                child: OutlinedButton.icon(
                  icon: const Icon(Icons.photo),

                  label: const Text("Alterar Foto"),

                  onPressed: () {
                    showModalBottomSheet(
                      context: context,

                      builder: (context) {
                        return SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),

                                title: const Text("Tirar Foto"),

                                onTap: () async {
                                  Navigator.pop(context);

                                  final foto = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CameraScreens(),
                                    ),
                                  );

                                  if (foto != null) {
                                    setState(() {
                                      _fotoPerfil = foto;
                                    });
                                  }
                                },
                              ),

                              ListTile(
                                leading: const Icon(Icons.photo),

                                title: const Text("Escolher da Galeria"),

                                onTap: () async {
                                  Navigator.pop(context);

                                  final foto = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const GaleriaScreens(),
                                    ),
                                  );

                                  if (foto != null) {
                                    setState(() {
                                      _fotoPerfil = foto;
                                    });
                                  }
                                },
                              ),

                              ListTile(
                                leading: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),

                                title: const Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.red),
                                ),

                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _nomeController,

                decoration: const InputDecoration(
                  labelText: "Nome",

                  prefixIcon: Icon(Icons.person),

                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o nome";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _senhaController,

                obscureText: true,

                decoration: const InputDecoration(
                  labelText: "Nova Senha",

                  prefixIcon: Icon(Icons.lock),

                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return "A senha deve possuir pelo menos 6 caracteres";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),

                  label: const Text("Salvar Alterações"),

                  onPressed: _salvando ? null : _salvarAlteracoes,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),

                  icon: const Icon(Icons.delete),

                  label: const Text("Excluir Perfil"),

                  onPressed: () {
                    showDialog(
                      context: context,

                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Excluir Perfil"),

                          content: const Text(
                            "Deseja realmente excluir o perfil?",
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text("Cancelar"),
                            ),

                            ElevatedButton(
                              onPressed: _excluindo
                                  ? null
                                  : () async {
                                      Navigator.pop(context);

                                      await _excluirPerfil();
                                    },

                              child: const Text("Excluir"),
                            ),
                          ],
                        );
                      },
                    );
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
    _nomeController.dispose();
    _senhaController.dispose();

    super.dispose();
  }
}
