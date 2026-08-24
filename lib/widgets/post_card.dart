import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool curtiu = false;
  bool carregandoCurtida = false;
  bool carregandoComentario = false;
  

  @override
  void initState() {
    super.initState();

    // Usa o estado de curtida informado pela API
    curtiu = widget.post.youLiked;
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao curtir post: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          carregandoCurtida = false;
        });
      }
    }
  }

void _abrirComentario() {
  final comentarioController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Novo comentário"),

            content: TextField(
              controller: comentarioController,
              maxLines: 3,
              enabled: !carregandoComentario,
              decoration: const InputDecoration(
                hintText: "Digite seu comentário",
                border: OutlineInputBorder(),
              ),
            ),

            actions: [
              TextButton(
                onPressed: carregandoComentario
                    ? null
                    : () {
                        Navigator.pop(dialogContext);
                      },
                child: const Text("Cancelar"),
              ),

              ElevatedButton(
                onPressed: carregandoComentario
                    ? null
                    : () async {
                        final comentario =
                            comentarioController.text.trim();

                        if (comentario.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Digite um comentário.",
                              ),
                            ),
                          );

                          return;
                        }

                        setDialogState(() {
                          carregandoComentario = true;
                        });

                        try {
                          final resposta =
                              await apiService.createReply(
                            widget.post.id,
                            comentario,
                          );

                          print(
                            'STATUS COMENTÁRIO: '
                            '${resposta.statusCode}',
                          );

                          print(
                            'BODY COMENTÁRIO: '
                            '${resposta.body}',
                          );

                          if (!mounted) return;

                          if (resposta.statusCode == 200 ||
                              resposta.statusCode == 201) {
                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Comentário enviado com sucesso!",
                                ),
                              ),
                            );

                            // Atualiza a tela do Feed
                            // posteriormente podemos atualizar
                            // também a quantidade de respostas.
                            setState(() {});
                          } else {
                            setDialogState(() {
                              carregandoComentario = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Não foi possível enviar "
                                  "o comentário. "
                                  "Código: ${resposta.statusCode}",
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (!mounted) return;

                          setDialogState(() {
                            carregandoComentario = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Erro ao enviar comentário: $e",
                              ),
                            ),
                          );
                        }
                      },

                child: carregandoComentario
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Enviar"),
              ),
            ],
          );
        },
      );
    },
  );
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
                      backgroundImage: NetworkImage(
                        post.profileImage!,
                      ),
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.person),
                    ),

              title: Text(
                post.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text('@${post.userLogin}'),
            ),

            Text(
              post.message,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                IconButton(
                  icon: carregandoCurtida
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          curtiu
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: curtiu ? Colors.red : Colors.grey,
                        ),
                  onPressed: carregandoCurtida
                      ? null
                      : _alternarCurtida,
                ),

                Text('${post.likesNumber}'),

                const SizedBox(width: 20),

                IconButton(
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                  ),
                  onPressed: _abrirComentario,
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