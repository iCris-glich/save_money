import 'package:flutter/material.dart';
import 'package:save_money/database/database.dart';

class Movimiento {
  final int id;
  final String tipo;
  final double monto;
  final String categoria;
  final DateTime fecha;

  Movimiento({
    required this.id,
    required this.tipo,
    required this.monto,
    required this.categoria,
    required this.fecha,
  });

  factory Movimiento.fromMap(Map<String, dynamic> map) {
    return Movimiento(
      id: map['id'],
      tipo: map['tipo'],
      monto: (map['monto'] as num).toDouble(),
      categoria: map['categoria'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}

class ListaMovimientos extends StatelessWidget {
  final Future<List<Movimiento>> future;
  final VoidCallback actualizar;

  const ListaMovimientos({
    super.key,
    required this.future,
    required this.actualizar,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movimiento>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final movimientos = snapshot.data!;

        if (movimientos.isEmpty) {
          return const Center(child: Text("Sin movimientos"));
        }

        return ListView.builder(
          itemCount: movimientos.length,
          itemBuilder: (context, index) {
            final m = movimientos[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          '¿Seguro que quieres eliminar este movimiento?',
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await DatabaseHelper.instance.quitarMovimiento(
                                m.id,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              actualizar();
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListTile(
                  leading: Icon(
                    m.tipo == 'ingreso'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: m.tipo == 'ingreso' ? Colors.green : Colors.red,
                  ),
                  title: Text(m.categoria),
                  subtitle: Text('Q${m.monto.toStringAsFixed(2)}'),
                  trailing: Text(
                    "${m.fecha.day}/${m.fecha.month}/${m.fecha.year}",
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
