import 'package:flutter/material.dart';

class ResponderPostagem extends StatefulWidget {
  const ResponderPostagem({super.key});

  @override
  State<ResponderPostagem> createState() =>
      _NovaPostagemScreensState();
}

class _NovaPostagemScreensState
    extends State<ResponderPostagem> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _postagemController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Responder"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const CircleAvatar(
                radius: 35,
                child: Icon(
                  Icons.person,
                  size: 35,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "No que você está pensando?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(

                controller: _postagemController,

                maxLines: 5,

                maxLength: 280,

                decoration: const InputDecoration(

                  hintText: "Escreva um comentario:",

                  border: OutlineInputBorder(),

                ),

                validator: (value) {

                  if (value == null || value.trim().isEmpty) {

                    return "Digite uma postagem.";

                  }

                  return null;

                },

              ),

              const SizedBox(height: 25),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton.icon(

                  icon: const Icon(Icons.send),

                  label: const Text("Enviar"),

                  onPressed: () {

                    if (_formKey.currentState!.validate()) {

                      ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(

                          content: Text(
                            "Comentario enviado (simulação)"
                          ),

                        ),

                      );

                      Navigator.pop(context);

                    }

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

    _postagemController.dispose();

    super.dispose();

  }

}