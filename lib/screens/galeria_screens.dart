import 'package:flutter/material.dart';

class GaleriaScreens extends StatelessWidget {
  const GaleriaScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Galeria"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Text(
              "Escolha uma foto",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,

                children: List.generate(6, (index) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Foto ${index + 1} selecionada (simulação)",
                          ),
                        ),
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.green),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Icon(
                            Icons.image,
                            size: 60,
                            color: Colors.green,
                          ),

                          const SizedBox(height: 10),

                          Text("Foto ${index + 1}"),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Voltar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
