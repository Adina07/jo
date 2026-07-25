import 'package:flutter/material.dart';
import 'perfil_editar_screens.dart';

class PerfilScreens extends StatefulWidget {
  const PerfilScreens({super.key});

  @override
  State<PerfilScreens> createState() => _PerfilScreensState();
}

class _PerfilScreensState extends State<PerfilScreens> {
  // true = perfil do usuário logado
  // false = perfil de outro usuário
  bool meuPerfil = true;

  bool seguindo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Perfil"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const CircleAvatar(radius: 60, child: Icon(Icons.person, size: 60)),

            const SizedBox(height: 20),

            const Text(
              "Ádina Souza",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              "@adina",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

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
                  children: const [
                    Text(
                      "180",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Seguindo"),
                  ],
                ),

                Column(
                  children: const [
                    Text(
                      "250",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Seguidores"),
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

                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const PerfilEditarScreens(),
                      ),
                    );
                  },
                ),
              )
            else
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      seguindo = !seguindo;
                    });
                  },

                  child: Text(seguindo ? "Deixar de seguir" : "Seguir"),
                ),
              ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "Postagens",

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.article),

                title: const Text("Primeira postagem no Papacapim!"),

                subtitle: const Text("Hoje às 10:30"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.article),

                title: const Text("Aprendendo Flutter."),

                subtitle: const Text("Ontem às 18:45"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.article),

                title: const Text("Projeto Mobile em andamento."),

                subtitle: const Text("Segunda-feira"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
