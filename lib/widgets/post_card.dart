import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String nome;
  final String login;
  final String conteudo;
  final bool meuPost;

  const PostCard({
    super.key,
    required this.nome,
    required this.login,
    required this.conteudo,
    this.meuPost = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool curtiu = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),

              title: Text(widget.nome),

              subtitle: Text(widget.login),
            ),

            Text(widget.conteudo),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                IconButton(
                  icon: Icon(
                    curtiu ? Icons.favorite : Icons.favorite_border,

                    color: curtiu ? Colors.red : Colors.grey,
                  ),

                  onPressed: () {
                    setState(() {
                      curtiu = !curtiu;
                    });
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),

                  onPressed: () {
                    final TextEditingController comentarioController =
                        TextEditingController();

                    showDialog(
                      context: context,

                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Novo comentário"),

                          content: TextField(
                            controller: comentarioController,

                            decoration: const InputDecoration(
                              hintText: "Digite seu comentário",

                              border: OutlineInputBorder(),
                            ),
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text("Cancelar"),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Comentário: ${comentarioController.text}",
                                    ),
                                  ),
                                );

                                Navigator.pop(context);
                              },

                              child: const Text("Enviar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                if (widget.meuPost)
                  IconButton(
                    icon: const Icon(Icons.delete),

                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post excluído")),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
