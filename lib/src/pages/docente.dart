import 'package:flutter/material.dart'; // Importa tu archivo de rutas

class PantallaDocente extends StatelessWidget {
  const PantallaDocente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Docente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              // Esto destruye el stack actual y te devuelve al inicio
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Layer
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/descarga.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xDD000033),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Foreground Layer: Interactivity and Navigation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'Gestión Académica',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Panel de gestión de alumnos y cursos',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),

                // Navigation Button 1: Inscribir Alumno
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text(
                    'Inscribir Alumno',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/registro');
                  },
                ),

                const SizedBox(height: 20),

                // Navigation Button 2: Ver Dashboard
                OutlinedButton.icon(
                  icon: const Icon(Icons.dashboard, color: Colors.white),
                  label: const Text(
                    'Ver Matrículas',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
