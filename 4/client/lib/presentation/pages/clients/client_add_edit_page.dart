import 'package:client/data/providers/client_provider.dart';
import 'package:client/logic/models/client/client.dart';
import 'package:flutter/material.dart';

class ClientAddEditPage extends StatefulWidget {
  const ClientAddEditPage({Key? key, this.clientToEdit}) : super(key: key);

  final Client? clientToEdit;

  @override
  _ClientAddEditPageState createState() => _ClientAddEditPageState();
}

class _ClientAddEditPageState extends State<ClientAddEditPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  final _repository = const ClientProvider();

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.clientToEdit?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.clientToEdit?.lastName ?? '');
    _phoneController =
        TextEditingController(text: widget.clientToEdit?.phone ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clientToEdit == null
            ? 'Add Client'
            : 'Edit Client № ${widget.clientToEdit!.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (widget.clientToEdit == null) {
                  final newClient = Client(
                    id: 0,
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    phone: _phoneController.text,
                  );
                  await _repository.create(newClient);
                } else {
                  final updatedClient = widget.clientToEdit!.copyWith(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    phone: _phoneController.text,
                  );
                  await _repository.update(updatedClient.id, updatedClient);
                }
                Navigator.of(context).pop();
              },
              child: Text(widget.clientToEdit == null ? 'Add' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
