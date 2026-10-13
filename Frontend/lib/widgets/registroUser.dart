
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistroUser extends StatefulWidget {
  const RegistroUser({super.key});

  @override
  State<RegistroUser> createState() => _RegistroUserState();
}

class _RegistroUserState extends State<RegistroUser> {
  final Color fondo = const Color(0xFFB0D9F5);
  final Color campos = const Color(0xFFFFEBDD);
  final Color encabezado = const Color(0xFF60B5FF);
  final Color boton = const Color(0xFFFF9149);
  final Color texto = const Color(0xFF222222);

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController licenciaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();

  bool cargando = false;

  Future<void> registrarUsuario() async {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final numLic = licenciaController.text.trim();
    final password = passwordController.text;
    final confirmar = confirmarController.text;

    if (nombre.isEmpty ||
        correo.isEmpty ||
        numLic.isEmpty ||
        password.isEmpty ||
        confirmar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (password != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final respuesta = await http.post(
        Uri.parse('http://localhost:3000/api/clientes/registro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'correo': correo,
          'numLic': numLic,
          'password': password,
        }),
      );

      final datos = jsonDecode(respuesta.body);

      if (!mounted) return;

      if (respuesta.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. Ahora inicia sesión.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              datos['mensaje'] ?? 'No se pudo completar el registro',
            ),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo conectar con el servidor. Verifica que esté encendido.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    licenciaController.dispose();
    passwordController.dispose();
    confirmarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Icon(Icons.person_add, size: 80, color: encabezado),
              const SizedBox(height: 10),
              Text(
                'Empecemos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: encabezado,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Crear una nueva cuenta',
                style: TextStyle(fontSize: 15, color: texto),
              ),
              const SizedBox(height: 25),

              buildTextField(
                controller: nombreController,
                label: 'Nombre completo',
                icon: Icons.person,
              ),
              const SizedBox(height: 14),

              buildTextField(
                controller: correoController,
                label: 'Correo electrónico',
                icon: Icons.email,
                tipo: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),

              buildTextField(
                controller: licenciaController,
                label: 'Número de licencia',
                icon: Icons.card_membership,
              ),
              const SizedBox(height: 14),

              buildTextField(
                controller: passwordController,
                label: 'Contraseña',
                icon: Icons.lock,
                obscure: true,
              ),
              const SizedBox(height: 14),

              buildTextField(
                controller: confirmarController,
                label: 'Confirmar contraseña',
                icon: Icons.lock,
                obscure: true,
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cargando ? null : registrarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: boton,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: cargando
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Registrarme',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(color: texto),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(color: encabezado),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType tipo = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: tipo,
      style: TextStyle(color: texto),
      decoration: InputDecoration(
        filled: true,
        fillColor: campos,
        labelText: label,
        labelStyle: TextStyle(color: texto),
        prefixIcon: Icon(icon, color: encabezado),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
