import 'package:flutter/material.dart';

class MedioPago extends StatelessWidget {
  const MedioPago({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0D9F5),

      appBar: AppBar(
        title: const Text(
          "Medio de Pago",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF60B5FF),
        foregroundColor: Colors.black,
      ),

      body: ListView(
        children: [
          ListTile(
            tileColor: const Color(0xFFFFEBDD),
            leading: const Icon(Icons.credit_card, color: Colors.orange),
            title: const Text(
              "Tarjeta de Crédito o Débito",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            onTap: () {
              print("Seleccionó tarjeta");
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet,
              color: Colors.orange,
            ),

            title: const Text(
              "PayPal",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            onTap: () {
              print("Seleccionó PayPal");
            },
          ),

          ListTile(
            leading: const Icon(Icons.account_balance, color: Colors.orange),

            title: const Text(
              "Transferencia Bancaria",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            onTap: () {
              print("Seleccionó transferencia");
            },
          ),
        ],
      ),
    );
  }
}
