
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenuDrawerPerfil extends StatefulWidget {
  const MenuDrawerPerfil({super.key});

  @override
  State<MenuDrawerPerfil> createState() => _MenuDrawerPerfilState();
}

class _MenuDrawerPerfilState extends State<MenuDrawerPerfil> {
  Map<String, dynamic>? usuario;
  bool cargando = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    try {
      final preferencias = await SharedPreferences.getInstance();
      final token = preferencias.getString('token');

      if (token == null || token.isEmpty) {
        setState(() {
          cargando = false;
          error = 'Inicia sesión para consultar tu perfil';
        });
        return;
      }

      final respuesta = await http.get(
        Uri.parse('http://localhost:3000/api/clientes/perfil'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (!mounted) return;

      if (respuesta.statusCode == 200) {
        setState(() {
          usuario = jsonDecode(respuesta.body);
          cargando = false;
        });
      } else {
        setState(() {
          error = 'No se pudo cargar el perfil. Inicia sesión nuevamente.';
          cargando = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'No se pudo conectar con el servidor';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF60B5FF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://picsum.photos/330/200',
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (cargando)
            const Center(child: CircularProgressIndicator())
          else if (error.isNotEmpty)
            Center(
              child: Column(
                children: [
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        cargando = true;
                        error = '';
                      });
                      cargarPerfil();
                    },
                    child: const Text('Intentar nuevamente'),
                  ),
                ],
              ),
            )
          else ...[
            Center(
              child: Column(
                children: [
                  Text(
                    usuario?['nombre']?.toString() ?? 'Usuario',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    usuario?['correo']?.toString() ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(
                Icons.badge,
                color: Color(0xFF60B5FF),
              ),
              title: const Text('Número de licencia'),
              subtitle: Text(
                usuario?['numLic']?.toString() ?? 'No disponible',
              ),
            ),
          ],

          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.lock,
              color: Color(0xFF60B5FF),
            ),
            title: const Text('Cambiar contraseña'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.search_rounded,
              color: Color(0xFFFF9149),
            ),
            title: const Text('Revisar alquiler'),
            onTap: () {
              // Aquí agregaremos la consulta de alquileres.
            },
          ),
        ],
      ),
    );
  }
}
