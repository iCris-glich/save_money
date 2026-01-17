import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:save_money/widget/movimientos.dart';

class ExpensesStatistics extends StatelessWidget {
  final List<Movimiento> movimientos;

  const ExpensesStatistics({super.key, required this.movimientos});

  Map<String, double> _gastoPorCategoria(List<Movimiento> movimientos) {
    final Map<String, double> data = {};

    for (final m in movimientos) {
      if (m.tipo == 'gasto') {
        data[m.categoria] = (data[m.categoria] ?? 0) + m.monto;
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final data = _gastoPorCategoria(movimientos);

    if (data.isEmpty) {
      return const Center(child: Text('Sin gastos para actualizar'));
    }

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxY = entries.first.value * 1.2;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: maxY,
          barGroups: List.generate(entries.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: entries[i].value,
                  width: 18,
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  return Text(
                    'Q${value.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      entries[value.toInt()].key,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
