import 'package:flutter/material.dart';
import 'package:save_money/database/database.dart';
import 'package:save_money/widget/custom_textfield.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<StatefulWidget> createState() {
    return AlertState();
  }
}

class AlertState extends State<Alert> {
  String _tipo = 'ingreso';
  final List<String> _categoriasGasto = [
    'Comida',
    'Transporte',
    'Vivienda',
    'Servicios',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Otros',
  ];

  final List<String> _categoriasIngreso = [
    'Sueldo',
    'Freelance',
    'Venta',
    'Otros',
  ];

  final TextEditingController _monto = TextEditingController();
  String? _categoriaSeleccinoda;
  bool _isIngreso = true;

  @override
  void dispose() {
    _monto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Llena las casillas con los datos correspondientes'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButton(
              value: _tipo,
              items: [
                DropdownMenuItem(
                  value: 'ingreso',
                  child: const Text('Ingreso'),
                ),
                DropdownMenuItem(value: 'gasto', child: const Text('Gasto')),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _tipo = value;
                  _isIngreso = value == 'ingreso';
                  _categoriaSeleccinoda = null;
                });
              },
            ),
            const SizedBox(height: 10),
            CustomTextfield(
              controller: _monto,
              typeKey: TextInputType.number,
              text: 'Ingresa el monto',
              icon: Icon(Icons.money),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _categoriaSeleccinoda,
              items: _isIngreso
                  ? _categoriasIngreso.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList()
                  : _categoriasGasto.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSeleccinoda = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_tipo == '' ||
                _monto.text.isEmpty ||
                _categoriaSeleccinoda == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Llena todos los capos requeridos'),
                ),
              );
            } else {
              await DatabaseHelper.instance.insertarMovimiento({
                'tipo': _tipo,
                'monto': double.tryParse(_monto.text) ?? 0,
                'categoria': _categoriaSeleccinoda,
                'fecha': DateTime.now().toIso8601String(),
              });
              // ignore: use_build_context_synchronously
              Navigator.pop(context, true);
            }
          },
          child: const Text('Aceptar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
