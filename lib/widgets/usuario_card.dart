import 'package:flutter/material.dart';

class UsuarioCard extends StatelessWidget {
  final String nome;
  final String login;

  const UsuarioCard({super.key, required this.nome, required this.login});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),

      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),

        title: Text(nome),

        subtitle: Text(login),

        trailing: ElevatedButton(onPressed: () {}, child: const Text("Ver")),
      ),
    );
  }
}
