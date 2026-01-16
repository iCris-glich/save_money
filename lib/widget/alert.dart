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
  final TextEditingController _monto = TextEditingController();
  final TextEditingController _categoria = TextEditingController();

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
            CustomTextfield(
              controller: _categoria,
              text: 'Ingresa la categoria',
              icon: Icon(Icons.money),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_tipo == '' || _monto.text.isEmpty || _categoria.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Llena todos los capos requeridos'),
                ),
              );
            } else {
              await DatabaseHelper.instance.insertarMovimiento({
                'tipo': _tipo,
                'monto': double.tryParse(_monto.text) ?? 0,
                'categoria': _categoria.text,
                'fecha': DateTime.now().toIso8601String(),
              });
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
