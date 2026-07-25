import 'package:flutter/material.dart';

class BuscaScreens extends StatefulWidget {
  const BuscaScreens({super.key});

  @override
  State<BuscaScreens> createState() => _BuscaScreensState();
}

class _BuscaScreensState extends State<BuscaScreens> {
  final TextEditingController _pesquisaController = TextEditingController();

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

              decoration: const InputDecoration(
                labelText: "Buscar usuários ou postagens",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
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

            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text("Ádina  Souza"),
                subtitle: const Text("@adina"),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Ver"),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text("Maria Souza"),
                subtitle: const Text("@maria"),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Ver"),
                ),
              ),
            ),

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
