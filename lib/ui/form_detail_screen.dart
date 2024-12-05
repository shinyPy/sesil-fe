import 'package:flutter/material.dart';

class FormDetailScreen extends StatelessWidget {
  final Map form;

  const FormDetailScreen({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(form['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              form['title'],
            ),
            const SizedBox(height: 16.0),
            Text(
              form['description'] ?? 'No description',
            ),
          ],
        ),
      ),
    );
  }
}
