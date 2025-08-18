import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  static const routeName = '/statistics';
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: const Center(
        child: Text(
          'No statistics yet.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
