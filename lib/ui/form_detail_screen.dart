import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:sesil_fe/config.dart';

class FormDetailScreen extends StatefulWidget {
  final Map form;

  const FormDetailScreen({Key? key, required this.form}) : super(key: key);

  @override
  State<FormDetailScreen> createState() => _FormDetailScreenState();
}

class _FormDetailScreenState extends State<FormDetailScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.form['title']),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Title', widget.form['title']),
                  _buildDetailRow('Description',
                      widget.form['description'] ?? 'No description'),
                  _buildDetailRow('Status', widget.form['status']),
                                    _buildDetailRow('Rejection Note', widget.form['rejection_note'] ?? 'No rejection found'),
                  _buildDetailRow(
                    'User',
                    '${widget.form['user']['name']} (${widget.form['user']['email']})',
                  ),
                  _buildDetailRow(
                    'Supervisor',
                    '${widget.form['supervisor']?['name'] ?? 'N/A'} (${widget.form['supervisor']?['email'] ?? 'N/A'})',
                  ),
                  if (widget.form['manager'] != null)
                    _buildDetailRow(
                      'Manager',
                      '${widget.form['manager']['name']} (${widget.form['manager']['email']})',
                    ),
                  if (widget.form['ktt'] != null)
                    _buildDetailRow(
                      'KTT',
                      '${widget.form['ktt']['name']} (${widget.form['ktt']['email']})',
                    ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleApproval(context),
                        child: const Text('Approve'),
                      ),
                      ElevatedButton(
                        onPressed: () => _handleRejection(context),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _handleApproval(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await http.post(
        Uri.parse('$apiBaseUrl/forms-approve/${widget.form['id']}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form approved successfully')),
        );
      } else {
        _showError(context, 'Failed to approve form: ${response.body}');
      }
    } catch (e) {
      _showError(context, 'An error occurred while approving the form: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRejection(BuildContext context) async {
    final rejectionNoteController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Form'),
          content: TextField(
            controller: rejectionNoteController,
            decoration: const InputDecoration(
              hintText: 'Enter rejection reason',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _submitRejection(context, rejectionNoteController.text);
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitRejection(
      BuildContext context, String rejectionNote) async {
    if (rejectionNote.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rejection note is required')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await http.post(
        Uri.parse('$apiBaseUrl/forms-reject/${widget.form['id']}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rejection_note': rejectionNote,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form rejected successfully')),
        );
      } else {
        _showError(context, 'Failed to reject form: ${response.body}');
      }
    } catch (e) {
      _showError(context, 'An error occurred while rejecting the form: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
