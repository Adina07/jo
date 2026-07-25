import 'package:flutter/material.dart';

import '../widgets/post_card.dart';
import 'busca_screens.dart';
import 'nova_postagem_screens.dart';
import 'perfil_screens.dart';

class FeedScreens extends StatefulWidget {
  const FeedScreens({super.key});

  @override
  State<FeedScreens> createState() => _FeedScreensState();
}

class _FeedScreensState extends State<FeedScreens> {
  int _paginaAtual = 0;

  void _trocarPagina(int index) {
    setState(() {
      _paginaAtual = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BuscaScreens()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PerfilScreens()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Papacapim"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),

        children: [
          const Text(
            "Seguindo",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const PostCard(
            nome: "Ádina Souza",
            login: "@adina",
            conteudo: "Hoje comecei a aprender Flutter!",
            meuPost: true,
          ),

          const PostCard(
            nome: "Carlos Lima",
            login: "@carlos",
            conteudo: "Alguém conhece bons cursos de Flutter?",
          ),

          const SizedBox(height: 25),

          const Text(
            "Descobrir",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const PostCard(
            nome: "Maria Souza",
            login: "@maria",
            conteudo: "Bom dia, pessoal!",
          ),

          const PostCard(
            nome: "Ana Paula",
            login: "@ana",
            conteudo: "Projeto Mobile quase finalizado.",
          ),

          const SizedBox(height: 80),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,

        icon: const Icon(Icons.add),

        label: const Text("Post"),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const NovaPostagemScreens()),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,

        selectedItemColor: Colors.green,

        onTap: _trocarPagina,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),

          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
