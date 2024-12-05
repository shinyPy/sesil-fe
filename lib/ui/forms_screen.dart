import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../func/forms/fetch_forms.dart';
import '../func/forms/create_form.dart';
import '../func/forms/delete_form.dart';
import 'form_detail_screen.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({Key? key}) : super(key: key);

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  List forms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadForms();
  }

  Future<void> loadForms() async {
    forms = await fetchForms();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              const FlutterSecureStorage().delete(key: 'jwt_token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: forms.length,
              itemBuilder: (context, index) {
                final form = forms[index];
                return ListTile(
                  title: Text(form['title']),
                  subtitle: Text(form['description'] ?? 'No description'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormDetailScreen(form: form),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteForm(form['id']);
                      loadForms();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String title = '';
              String description = '';
              return AlertDialog(
                title: const Text('Create Form'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      onChanged: (value) => title = value,
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      onChanged: (value) => description = value,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await createForm(context, title, description);
                      loadForms();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
