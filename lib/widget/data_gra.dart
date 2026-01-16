import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficaPie extends StatelessWidget {
  final List<Map<String, dynamic>> movimientos;

  const GraficaPie({super.key, required this.movimientos});

  @override
  Widget build(BuildContext context) {
    if (movimientos.isEmpty) {
      return const Center(child: Text('Sin datos'));
    }

    double ingresos = 0;
    double gastos = 0;

    for (final m in movimientos) {
      final valor = (m['total'] as num).toDouble();
      if (valor > 0) {
        ingresos += valor;
      } else {
        gastos += valor.abs();
      }
    }

    return PieChart(
      PieChartData(
        sections: [
          if (ingresos > 0)
            PieChartSectionData(
              value: ingresos,
              color: Colors.green,
              radius: 80,
              title: 'Ingresos',
            ),
          if (gastos > 0)
            PieChartSectionData(
              value: gastos,
              color: Colors.red,
              radius: 80,
              title: 'Gastos',
            ),
        ],
      ),
    );
  }
}
