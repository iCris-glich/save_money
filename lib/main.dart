import 'package:flutter/material.dart';
import 'package:save_money/go_router.dart';
import 'package:save_money/widget/theme/theme.dart';

void main() {
  runApp(const SaveMoney());
}

class SaveMoney extends StatelessWidget {
  const SaveMoney({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Save Money',
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.ligth,
    );
  }
}
