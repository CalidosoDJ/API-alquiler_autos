import 'package:flutter/material.dart';
import 'package:flutter_alquiler_autos/widgets/medio_Pago.dart';


class DetalleVehiculoScreen extends StatelessWidget {
  final String imagenUrl;
  final String marca;
  final String modelo;
  final dynamic anio;
  final dynamic disponibilidad;
  final dynamic precio;

  const DetalleVehiculoScreen({
    super.key,
    required this.imagenUrl,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.disponibilidad,
    required this.precio,
  });

  @override
  Widget build(BuildContext context) {
    final Color fondo = const Color(0xFFAFDDFF);
    final Color encabezado = const Color(0xFF60B5FF);
    final Color campos = const Color(0xFFFFECDB);
    final Color boton = const Color(0xFFFF9149);
    final Color texto = const Color(0xFF222222);

    final bool estaDisponible = disponibilidad == 0;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: encabezado,
        foregroundColor: Colors.white,
        title: Text('$marca $modelo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: campos,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagenUrl.toString(),
                    height: 160,
                    width: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://picsum.photos/330/200',
                        height: 160,
                        width: 260,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$marca $modelo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Año: $anio',
                  style: TextStyle(fontSize: 18, color: texto.withOpacity(0.8)),
                ),
                const SizedBox(height: 8),
                Chip(
                  avatar: Icon(
                    estaDisponible ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    estaDisponible ? 'Disponible' : 'No disponible',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: estaDisponible ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  'Precio \$${precio}/dia',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: boton,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: boton,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: estaDisponible
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedioPago(),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.directions_car),
                  label: const Text(
                    'Solicitar alquiler',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
