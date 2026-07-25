import 'package:flutter/material.dart';
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
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
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

                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) => const CameraScreens(),
                                    ),
                                  );
                                },
                              ),

                              ListTile(
                                leading: const Icon(Icons.photo),

                                title: const Text("Escolher da Galeria"),

                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) => const GaleriaScreens(),
                                    ),
                                  );
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
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),

                  label: const Text("Salvar Alterações"),

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Alterações salvas (simulação)"),
                        ),
                      );
                    }
                  },
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
                              onPressed: () {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Perfil excluído (simulação)",
                                    ),
                                  ),
                                );
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
