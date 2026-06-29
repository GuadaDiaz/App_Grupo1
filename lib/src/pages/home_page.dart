import 'package:flutter/material.dart';
import 'package:gestion_de_matriculas/src/pages/login.dart';
import 'package:gestion_de_matriculas/src/widgets/novedades.dart';
import 'package:gestion_de_matriculas/src/widgets/principal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión Escolar'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            tabs: [
              Tab(icon: Icon(Icons.school), text: 'Principal'),
              Tab(icon: Icon(Icons.login), text: 'Inicio'),
              Tab(icon: Icon(Icons.newspaper), text: 'Novedades'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // --- Pantalla Principal ---
            const Principal(),

            // --- Pantalla de inicio (Formulario de Login) ---
            const FormularioLogin(),

            // --- Pantalla de novedades ---
            const Novedades(),
          ],
        ),

        // --- REDES SOCIALES FIJAS ABAJO ---
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. UBICACIÓN
              IconButton(
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => _trazadoRuta(context),
              ),
              // 2. EMAIL (Abre el cliente de correo con el destinatario precargado)
              IconButton(
                icon: const Icon(Icons.email, color: Colors.white, size: 28),
                onPressed: () =>
                    _abrirEnlace('https://webmail.unsj.edu.ar/', context),
              ),
              // 3. INSTAGRAM (Nota: Usamos un icono nativo aproximado para no inflar la app)
              IconButton(
                icon: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => _abrirEnlace(
                  'https://www.instagram.com/eclgsm.unsj/',
                  context,
                ),
              ),
              // 4. WHATSAPP (Abre el chat directo. El formato es 54 9 + código de área sin el 15)
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.white, size: 28),
                onPressed: () =>
                    _abrirEnlace('https://wa.me/5492640000000', context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _abrirEnlace(String url, BuildContext context) async {
  final Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir la aplicación externa.')),
    );
  }
}

Future<void> _trazadoRuta(BuildContext context) async {
  final double latEscuela = -31.537444; // 31°32'14.8"S
  final double lngEscuela = -68.518277; // 68°31'05.8"W
// 1. Verificamos si el GPS del celular está encendido
  bool gpsActivo = await Geolocator.isLocationServiceEnabled();
  if (!gpsActivo) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Por favor, enciende el GPS de tu celular.')),
    );
    return;
  }

// 2. Revisamos el estado de los permisos de ubicación
  LocationPermission permiso = await Geolocator.checkPermission();
  if (permiso == LocationPermission.denied ||
      permiso == LocationPermission.deniedForever) {
    // Pedimos el permiso al usuario (Aquí salta el cartel de Android)
    permiso = await Geolocator.requestPermission();

    if (permiso != LocationPermission.whileInUse &&
        permiso != LocationPermission.always) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'Necesitamos el permiso para calcular la distancia.')),
      );
      return;
    }
  }
  // 3. ¡Permiso concedido! Le avisamos al usuario que estamos trabajando
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Calculando ruta... abriendo mapas.')),
  );

  // Obtenemos la ubicación actual exacta
  Position posicionActual = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high, // Alta precisión
  );

  // 4. Construimos la URL especial para Google Maps (Modo Direcciones)
  // origin = Ubicación del usuario | destination = La Escuela
  final String urlMapa = 'https://www.google.com/maps/dir/?api=1'
      '&origin=${posicionActual.latitude},${posicionActual.longitude}'
      '&destination=$latEscuela,$lngEscuela'
      '&travelmode=driving';

  // 5. Lanzamos la aplicación externa usando la misma lógica de url_launcher
  final Uri uri = Uri.parse(urlMapa);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir Google Maps.')),
    );
  }
}