import 'package:flutter/material.dart';
import 'package:flutter_alquiler_autos/widgets/detaelleVehiculoScreen.dart';
import 'package:flutter_alquiler_autos/widgets/menuDrawerPerfil.dart';


class MenuPrincipal extends StatelessWidget {
  final List<Map<String, dynamic>> autos;

  MenuPrincipal({super.key, required this.autos});

  final Color fondo = const Color(0xFFDAF7FD);
  final Color encabezado = const Color(0xFF60B5FF);
  final Color campos = const Color(0xFFEFFCCB);
  final Color boton = const Color(0xFFFF9149);
  final Color texto = const Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      drawer: MenuDrawerPerfil(),
      appBar: AppBar(
        title: const Text('Alquiler de Vehículos'),
        backgroundColor: encabezado,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: texto),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: encabezado),
                hintText: 'Buscar vehículo',
                hintStyle: TextStyle(color: texto.withOpacity(0.7)),
                filled: true,
                fillColor: campos,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              readOnly: true,
            ),

            const SizedBox(height: 16.0),
            Expanded(
              child: autos.isEmpty
                  ? const Center(child: Text('No hay vehículos para mostrar'))
                  : ListView.builder(
                      itemCount: autos.length,
                      itemBuilder: (context, index) {
                        final auto = autos[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),

                            child: Image.network(
                              auto['imageUrl'].toString(), 
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://picsum.photos/330/200',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          title: Text(
                            '${auto['marca']} ${auto['modelo']}',
                            style: TextStyle(
                              color: texto,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Año: ${auto['anio']}  •  Precio: ${auto['precio']}',
                            style: TextStyle(color: texto.withOpacity(0.7)),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: boton),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleVehiculoScreen(
                                  imagenUrl: auto['imageUrl'],
                                  marca: auto['marca'],
                                  modelo: auto['modelo'],
                                  anio: auto['anio'],
                                  disponibilidad: auto['disponibilidad'],
                                  precio: auto['precio'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: boton,
        unselectedItemColor: texto.withOpacity(0.6),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),

          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Alquiler',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuario'),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> autos = [
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Toyota',
    'modelo': 'Corolla',
    'anio': '2022',
    'disponibilidad': 1,
    'precio': '\$99.99/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Nissan',
    'modelo': 'Sentra',
    'anio': '2021',
    'disponibilidad': 1,
    'precio': '\$89.99/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Ford',
    'modelo': 'Mustang',
    'anio': '2023',
    'disponibilidad': 0,
    'precio': '\$199.99/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Chevrolet',
    'modelo': 'Camaro',
    'anio': '2020',
    'disponibilidad': 1,
    'precio': '\$150.00/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Honda',
    'modelo': 'Civic',
    'anio': '2022',
    'disponibilidad': 1,
    'precio': '\$95.99/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Hyundai',
    'modelo': 'Elantra',
    'anio': '2023',
    'disponibilidad': 1,
    'precio': '\$92.50/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Kia',
    'modelo': 'Sportage',
    'anio': '2024',
    'disponibilidad': 1,
    'precio': '\$120.00/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Volkswagen',
    'modelo': 'Jetta',
    'anio': '2021',
    'disponibilidad': 0,
    'precio': '\$85.99/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Mazda',
    'modelo': 'Mazda 3',
    'anio': '2023',
    'disponibilidad': 1,
    'precio': '\$110.00/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'BMW',
    'modelo': 'Serie 3',
    'anio': '2024',
    'disponibilidad': 1,
    'precio': '\$180.00/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Mercedes-Benz',
    'modelo': 'Clase C',
    'anio': '2023',
    'disponibilidad': 0,
    'precio': '\$210.00/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Audi',
    'modelo': 'A4',
    'anio': '2022',
    'disponibilidad': 1,
    'precio': '\$175.00/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Jeep',
    'modelo': 'Wrangler',
    'anio': '2023',
    'disponibilidad': 1,
    'precio': '\$160.00/día',
  },
  {
    'imageUrl': 'https://picsum.photos/330/200',
    'marca': 'Tesla',
    'modelo': 'Model 3',
    'anio': '2024',
    'disponibilidad': 1,
    'precio': '\$190.00/día',
  },
];