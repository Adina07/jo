import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/post.dart';
import '../services/api_service.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool curtiu = false;
  int numeroCurtidas = 0;
  bool carregandoCurtida = false;
  bool carregandoComentario = false;
  String? _meuLogin;
  bool _carregandoExclusao = false;

  @override
  void initState() {
    super.initState();

    curtiu = widget.post.youLiked;
    numeroCurtidas = widget.post.likesNumber;

    _carregarMeuUsuario();
  }

  Future<void> _carregarMeuUsuario() async {
    try {
      final resposta = await apiService.getMe();

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        setState(() {
          _meuLogin = dados['login'];
        });
      }
    } catch (e) {
      print('ERRO AO CARREGAR USUÁRIO: $e');
    }
  }

  Future<void> _excluirPost() async {
    if (_carregandoExclusao) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir postagem"),
          content: const Text("Tem certeza que deseja excluir esta postagem?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    setState(() {
      _carregandoExclusao = true;
    });

    try {
      final resposta = await apiService.deletePost(widget.post.id);

      print('STATUS EXCLUSÃO POST: ${resposta.statusCode}');
      print('BODY EXCLUSÃO POST: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200 || resposta.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Postagem excluída com sucesso!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Não foi possível excluir a postagem. "
              "Código: ${resposta.statusCode}",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao excluir postagem: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _carregandoExclusao = false;
        });
      }
    }
  }

  Future<void> _alternarCurtida() async {
    if (carregandoCurtida) return;

    setState(() {
      carregandoCurtida = true;
    });

    try {
      final resposta = curtiu
          ? await apiService.unlikePost(widget.post.id)
          : await apiService.likePost(widget.post.id);

      print('STATUS CURTIDA: ${resposta.statusCode}');
      print('BODY CURTIDA: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200 ||
          resposta.statusCode == 201 ||
          resposta.statusCode == 204) {
        setState(() {
  if (curtiu) {
    numeroCurtidas--;
  } else {
    numeroCurtidas++;
  }

  curtiu = !curtiu;
});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível alterar a curtida. '
              'Código: ${resposta.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao curtir post: $e')));
    } finally {
      if (mounted) {
        setState(() {
          carregandoCurtida = false;
        });
      }
    }
  }

  Future<void> _carregarComentarios() async {
    try {
      final resposta = await apiService.getReplies(widget.post.id);

      print('STATUS COMENTÁRIOS: ${resposta.statusCode}');
      print('BODY COMENTÁRIOS: ${resposta.body}');

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (!mounted) return;

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                final comentarioController = TextEditingController();
                bool enviando = false;

                return Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Comentários',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Expanded(
                          child: dados.isEmpty
                              ? const Center(
                                  child: Text('Nenhum comentário ainda.'),
                                )
                              : ListView.builder(
                                  itemCount: dados.length,
                                  itemBuilder: (context, index) {
                                    final comentario = dados[index];

                                    final usuario = comentario['user'] ?? {};

                                    final nome = usuario['name'] ?? 'Usuário';

                                    final login = usuario['login'] ?? '';

                                    final mensagem =
                                        comentario['message'] ?? '';

                                    final imagem = usuario['profile_image'];

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                        leading: imagem != null
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  imagem,
                                                ),
                                              )
                                            : const CircleAvatar(
                                                child: Icon(Icons.person),
                                              ),
                                        title: Text(
                                          nome,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('@$login'),
                                            const SizedBox(height: 5),
                                            Text(mensagem),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: comentarioController,
                          enabled: !enviando,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'Digite um comentário',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: enviando
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(
                              enviando ? 'Enviando...' : 'Enviar comentário',
                            ),
                            onPressed: enviando
                                ? null
                                : () async {
                                    final mensagem = comentarioController.text
                                        .trim();

                                    if (mensagem.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Digite um comentário.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    setModalState(() {
                                      enviando = true;
                                    });

                                    try {
                                      final resposta = await apiService
                                          .createReply(
                                            widget.post.id,
                                            mensagem,
                                          );

                                      print(
                                        'STATUS COMENTÁRIO: '
                                        '${resposta.statusCode}',
                                      );

                                      print(
                                        'BODY COMENTÁRIO: '
                                        '${resposta.body}',
                                      );

                                      if (resposta.statusCode == 200 ||
                                          resposta.statusCode == 201) {
                                        comentarioController.clear();

                                        final novaResposta = await apiService
                                            .getReplies(widget.post.id);

                                        if (novaResposta.statusCode == 200) {
                                          final novosDados = jsonDecode(
                                            novaResposta.body,
                                          );

                                          setModalState(() {
                                            dados.clear();
                                            dados.addAll(novosDados);
                                            enviando = false;
                                          });
                                        }
                                      } else {
                                        setModalState(() {
                                          enviando = false;
                                        });

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Não foi possível enviar '
                                              'o comentário. '
                                              'Código: ${resposta.statusCode}',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      setModalState(() {
                                        enviando = false;
                                      });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Erro ao enviar comentário: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }
    } catch (e) {
      print('ERRO COMENTÁRIOS: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar comentários: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,

              leading: post.profileImage != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(post.profileImage!),
                    )
                  : const CircleAvatar(child: Icon(Icons.person)),

              title: Text(
                post.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text('@${post.userLogin}'),

              trailing: _meuLogin == post.userLogin
                  ? IconButton(
                      icon: _carregandoExclusao
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete, color: Colors.red),
                      onPressed: _carregandoExclusao ? null : _excluirPost,
                    )
                  : null,
            ),

            Text(post.message, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            Row(
              children: [
                IconButton(
                  icon: carregandoCurtida
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          curtiu ? Icons.favorite : Icons.favorite_border,
                          color: curtiu ? const Color.fromARGB(255, 29, 28, 28) : Colors.grey,
                        ),
                  onPressed: carregandoCurtida ? null : _alternarCurtida,
                ),

                Text('$numeroCurtidas'),

                const SizedBox(width: 20),

                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: _carregarComentarios,
                ),

                Text('${post.repliesNumber}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
