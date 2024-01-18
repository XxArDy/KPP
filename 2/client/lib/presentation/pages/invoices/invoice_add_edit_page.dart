import 'package:client/data/providers/client_provider.dart';
import 'package:client/data/providers/invoice_provider.dart';
import 'package:client/data/providers/room_provider.dart';
import 'package:client/logic/models/client/client.dart';
import 'package:client/logic/models/invoice/invoice.dart';
import 'package:client/logic/models/room/room.dart';
import 'package:flutter/material.dart';

class InvoiceAddEditPage extends StatefulWidget {
  const InvoiceAddEditPage({Key? key, this.invoiceToEdit}) : super(key: key);

  final Invoice? invoiceToEdit;

  @override
  _InvoiceAddEditPageState createState() => _InvoiceAddEditPageState();
}

class _InvoiceAddEditPageState extends State<InvoiceAddEditPage> {
  late DateTime _selectedStartDate = DateTime.now();
  late DateTime _selectedEndDate = DateTime.now();
  int? _selectedClientId;
  int? _selectedRoomId;
  final _repository = const InvoiceProvider();
  final _clientProvider = const ClientProvider();
  final _roomProvider = const RoomProvider();

  @override
  void initState() {
    super.initState();
    _selectedClientId = widget.invoiceToEdit?.clientId;
    _selectedRoomId = widget.invoiceToEdit?.roomId;
    if (widget.invoiceToEdit != null) {
      _selectedStartDate = widget.invoiceToEdit!.dateStart;
      _selectedEndDate = widget.invoiceToEdit!.dateEnd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.invoiceToEdit == null
            ? 'Add Invoice'
            : 'Edit Invoice № ${widget.invoiceToEdit!.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(_selectedStartDate.toUtc().toIso8601String()),
                ),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedStartDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedStartDate = selectedDate;
                      });
                    }
                  },
                  child: const Text('Select Start Date'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedEndDate.toUtc().toIso8601String()),
                ),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedEndDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedEndDate = selectedDate;
                      });
                    }
                  },
                  child: const Text('Select End Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Client>?>(
              future: _clientProvider.getAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No clients found.');
                } else {
                  List<Client> clients = snapshot.data!;
                  return DropdownButton<int>(
                    value: _selectedClientId,
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                      });
                    },
                    items: clients
                        .map(
                          (client) => DropdownMenuItem<int>(
                            value: client.id,
                            child:
                                Text('${client.firstName} ${client.lastName}'),
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
            FutureBuilder<List<Room>?>(
              future: _roomProvider.getAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No rooms found.');
                } else {
                  List<Room> rooms = snapshot.data!;
                  return DropdownButton<int>(
                    value: _selectedRoomId,
                    onChanged: (value) {
                      setState(() {
                        _selectedRoomId = value;
                      });
                    },
                    items: rooms
                        .map(
                          (room) => DropdownMenuItem<int>(
                            value: room.id,
                            child: Text('${room.number}'),
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget.invoiceToEdit == null) {
                  final newInvoice = Invoice(
                    id: 0,
                    dateStart: _selectedStartDate,
                    dateEnd: _selectedEndDate,
                    amount: 0.0,
                    clientId: _selectedClientId ?? 0,
                    roomId: _selectedRoomId ?? 0,
                  );
                  await _repository.create(newInvoice);
                } else {
                  final updatedInvoice = widget.invoiceToEdit!.copyWith(
                    dateStart: _selectedStartDate,
                    dateEnd: _selectedEndDate,
                    amount: 0.0,
                    clientId: _selectedClientId ?? 0,
                    roomId: _selectedRoomId ?? 0,
                  );
                  await _repository.update(updatedInvoice.id, updatedInvoice);
                }
                Navigator.of(context).pop();
              },
              child:
                  Text(widget.invoiceToEdit == null ? 'Add' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
