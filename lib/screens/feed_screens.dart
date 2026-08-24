import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
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

  List<Post> _posts = [];
  bool _carregandoPosts = true;
  String? _erroPosts;

  @override
  void initState() {
    super.initState();

    _carregarPosts();
  }

  Future<void> _carregarPosts() async {
    try {
      setState(() {
        _carregandoPosts = true;
        _erroPosts = null;
      });

      final posts = await apiService.getPosts();

      if (!mounted) return;

      setState(() {
        _posts = posts;
        _carregandoPosts = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erroPosts = e.toString();
        _carregandoPosts = false;
      });
    }
  }

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

      body: _carregandoPosts
          ? const Center(child: CircularProgressIndicator())
          : _erroPosts != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Não foi possível carregar os posts.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(_erroPosts!, textAlign: TextAlign.center),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _carregarPosts,
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _carregarPosts,

              child: ListView.builder(
                padding: const EdgeInsets.all(15),

                itemCount: _posts.length,

                itemBuilder: (context, index) {
                  final post = _posts[index];

                  return PostCard(post: post);
                },
              ),
            ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,

        icon: const Icon(Icons.add),

        label: const Text("Post"),

        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NovaPostagemScreens()),
          );

          if (resultado == true) {
            _carregarPosts();
          }
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
