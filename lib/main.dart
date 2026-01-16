import 'package:flutter/material.dart';
import 'package:save_money/go_router.dart';

void main() {
  runApp(const SaveMoney());
}

class SaveMoney extends StatelessWidget {
  const SaveMoney({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Save Money',
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
