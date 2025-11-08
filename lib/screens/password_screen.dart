import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  final String activityName;
  final String correctPassword;

  const PasswordScreen({
    super.key,
    required this.activityName,
    required this.correctPassword,
  });

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String _enteredPassword = '';

  void _onNumberPressed(String number) {
    setState(() {
      if (_enteredPassword.length < 4) {
        _enteredPassword += number;
      }
      _checkPassword();
    });
  }

  void _checkPassword() {
    if (_enteredPassword.length == 4) {
      if (_enteredPassword == widget.correctPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña correcta! Accediendo...')),
        );
        Navigator.pop(context);
        // Aquí puedes agregar la navegación a la pantalla de la actividad
        // específica, por ejemplo:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ActividadScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña incorrecta. Inténtalo de nuevo.')),
        );
        setState(() {
          _enteredPassword = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activityName),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'INGRESE CÓDIGO DE ACCESO',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // Muestra los números ingresados como asteriscos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        index < _enteredPassword.length ? '*' : '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 50),
              // Teclado numérico con la nueva disposición
              _buildNumberPad(),
              const SizedBox(height: 20),
              // Botón de borrar
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_enteredPassword.isNotEmpty) {
                        _enteredPassword = _enteredPassword.substring(0, _enteredPassword.length - 1);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Icon(Icons.backspace),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget separado para construir el teclado con un layout personalizado
  Widget _buildNumberPad() {
    final List<List<String>> rows = [
      ['7', '8', '9'],
      ['4', '5', '6'],
      ['1', '2', '3'],
    ];

    return Column(
      children: [
        ...rows.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((number) {
                return _buildNumberButton(number);
              }).toList(),
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
        // Fila para el cero
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Los botones de borrar y el cero
            _buildNumberButton(''), // Botón en blanco
            _buildNumberButton('0'),
            _buildNumberButton(''), // Botón en blanco
          ],
        ),
      ],
    );
  }

  // Widget para crear un botón de número
  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: number.isNotEmpty ? () => _onNumberPressed(number) : null,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        child: Text(
          number,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}