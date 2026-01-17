import 'package:flutter/material.dart';
import 'package:save_money/database/database.dart';
import 'package:save_money/widget/expenses_statistics.dart';
import 'package:save_money/widget/movimientos.dart';
import 'package:save_money/widget/alert.dart';
import 'package:save_money/widget/data_gra.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movimiento>> _movimientosFuturos;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    _movimientosFuturos = DatabaseHelper.instance.obtenerMovimientos().then(
      (data) => data.map(Movimiento.fromMap).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Movimiento>>(
        future: _movimientosFuturos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Sin datos todavía"));
          }

          final movimientos = snapshot.data!;

          final double saldoTotal = movimientos.fold(
            0.0,
            (sum, m) => m.tipo == 'ingreso' ? sum + m.monto : sum - m.monto,
          );

          final movimientosMap = movimientos.map((m) {
            return {'total': m.tipo == 'ingreso' ? m.monto : -m.monto};
          }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    Text(
                      'Saldo actual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    Text(
                      'Q${saldoTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: saldoTotal >= 0 ? Colors.green : Colors.red,
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 280,
                      child: Card(
                        child: GraficaPie(movimientos: movimientosMap),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 250,
                      child: Card(
                        child: ListaMovimientos(
                          future: _movimientosFuturos,
                          actualizar: () {
                            setState(_cargarDatos);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 250,
                      child: Card(
                        child: ExpensesStatistics(movimientos: movimientos),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final actualizar = await showDialog<bool>(
            context: context,
            builder: (_) => const Alert(),
          );

          if (actualizar == true) {
            setState(_cargarDatos);
          }
        },
      ),
    );
  }
}
