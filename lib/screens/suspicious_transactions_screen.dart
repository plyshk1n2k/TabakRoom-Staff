import 'package:flutter/material.dart';

class SuspiciousTransactionsScreen extends StatefulWidget {
  const SuspiciousTransactionsScreen({super.key});

  @override
  State<SuspiciousTransactionsScreen> createState() =>
      _SuspiciousTransactionsScreenState();
}

class _SuspiciousTransactionsScreenState
    extends State<SuspiciousTransactionsScreen> {
  bool get _isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabakRoom'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text('HELLO WORLD!')],
          ),
        ),
      ),
    );
  }
}
