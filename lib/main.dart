import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador de Contraseñas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const PasswordGeneratorPage(),
    );
  }
}

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  double _longitud = 8;
  bool _incluirMayusculas = true;
  bool _incluirNumeros = true;
  bool _incluirSimbolos = false;

  String _contrasenaGenerada = '';
  String _fortaleza = '';

  final String _minusculas = 'abcdefghijklmnopqrstuvwxyz';
  final String _mayusculas = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String _numeros = '0123456789';
  final String _simbolos = '!@#\$%^&*()_-+=?';

  void _generarContrasena() {
    String caracteresDisponibles = _minusculas; // siempre incluidas

    if (_incluirMayusculas) caracteresDisponibles += _mayusculas;
    if (_incluirNumeros) caracteresDisponibles += _numeros;
    if (_incluirSimbolos) caracteresDisponibles += _simbolos;

    // 2. Elegir caracteres al azar
    final random = Random();
    String resultado = '';
    for (int i = 0; i < _longitud.round(); i++) {
      int indiceAleatorio = random.nextInt(caracteresDisponibles.length);
      resultado += caracteresDisponibles[indiceAleatorio];
    }

    setState(() {
      _contrasenaGenerada = resultado;
      _fortaleza = _calcularFortaleza();
    });
  }

  String _calcularFortaleza() {
    int tiposActivos = 1; // minúsculas siempre cuenta
    if (_incluirMayusculas) tiposActivos++;
    if (_incluirNumeros) tiposActivos++;
    if (_incluirSimbolos) tiposActivos++;

    if (_longitud < 8 || tiposActivos <= 1) {
      return 'Débil';
    } else if (_longitud < 12 || tiposActivos <= 2) {
      return 'Media';
    } else {
      return 'Fuerte';
    }
  }

  Color _colorFortaleza() {
    switch (_fortaleza) {
      case 'Débil':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Fuerte':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de Contraseñas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Longitud: ${_longitud.round()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _longitud,
              min: 4,
              max: 16,
              divisions: 12,
              label: _longitud.round().toString(),
              onChanged: (double valor) {
                setState(() {
                  _longitud = valor;
                });
              },
            ),
            const SizedBox(height: 10),

            CheckboxListTile(
              title: const Text('Incluir mayúsculas (A-Z)'),
              value: _incluirMayusculas,
              onChanged: (bool? valor) {
                setState(() {
                  _incluirMayusculas = valor ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Incluir números (0-9)'),
              value: _incluirNumeros,
              onChanged: (bool? valor) {
                setState(() {
                  _incluirNumeros = valor ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Incluir símbolos (!@#...)'),
              value: _incluirSimbolos,
              onChanged: (bool? valor) {
                setState(() {
                  _incluirSimbolos = valor ?? false;
                });
              },
            ),
            const SizedBox(height: 20),

            // --- Botón generar ---
            ElevatedButton(
              onPressed: _generarContrasena,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Generar Contraseña',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),

            // --- Resultado ---
            if (_contrasenaGenerada.isNotEmpty) ...[
              const Text(
                'Tu contraseña:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SelectableText(
                  _contrasenaGenerada,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fortaleza: $_fortaleza',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _colorFortaleza(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}