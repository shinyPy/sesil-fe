import 'package:flutter/material.dart';

class FormsScreen extends StatelessWidget {
  const FormsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {},
      ),
    );
  }
}
