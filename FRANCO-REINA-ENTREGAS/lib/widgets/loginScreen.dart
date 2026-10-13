
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_alquiler_autos/widgets/menuPrincipal.dart';
import 'package:flutter_alquiler_autos/widgets/registroUser.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color fondo = const Color(0xFFAFDDFF);
  final Color encabezado = const Color(0xFF60B5FF);
  final Color campos = const Color(0xFFFFECDB);
  final Color boton = const Color(0xFFFF9149);
  final Color texto = const Color(0xFF222222);

  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool cargando = false;

  Future<void> iniciarSesion() async {
    final correo = correoController.text.trim();
    final password = passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa tu correo y contraseña'),
        ),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final respuesta = await http.post(
        Uri.parse('http://localhost:3000/api/clientes/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': correo,
          'password': password,
        }),
      );

      final datos = jsonDecode(respuesta.body);

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        final preferencias = await SharedPreferences.getInstance();
        await preferencias.setString('token', datos['token']);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPrincipal(autos: autos),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              datos['mensaje'] ?? 'No se pudo iniciar sesión',
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
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Icon(Icons.person_pin, size: 80, color: encabezado),
            const SizedBox(height: 16),
            Text(
              'Bienvenido',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: encabezado,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inicia sesión para continuar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: texto.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 60),
            TextField(
              controller: correoController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: 'Correo electrónico',
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.email, color: encabezado),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                filled: true,
                fillColor: campos,
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: texto),
                prefixIcon: Icon(Icons.password, color: encabezado),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cargando ? null : iniciarSesion,
              style: ElevatedButton.styleFrom(
                backgroundColor: boton,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: texto),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'La recuperación de contraseña aún no está configurada',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Recuperar',
                    style: TextStyle(
                      color: encabezado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No tienes una cuenta?',
                  style: TextStyle(color: texto),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistroUser(),
                      ),
                    );
                  },
                  child: Text(
                    'Regístrate',
                    style: TextStyle(
                      color: encabezado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
