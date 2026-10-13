import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/core/config/app_config.dart';
import 'package:swingmate/core/network/dio_provider.dart';

class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final Dio dio = ref.watch(dioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 설정'),
        leading: IconButton(
          tooltip: '뒤로',
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ConfigItem(label: '환경', value: config.environmentLabel),
          const SizedBox(height: 16),
          _ConfigItem(label: 'API 주소', value: dio.options.baseUrl),
        ],
      ),
    );
  }
}

class _ConfigItem extends StatelessWidget {
  const _ConfigItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            SelectableText(value),
          ],
        ),
      ),
    );
  }
}
