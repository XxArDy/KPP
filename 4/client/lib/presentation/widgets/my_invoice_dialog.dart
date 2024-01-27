import 'package:client/data/providers/client_provider.dart';
import 'package:client/data/providers/invoice_provider.dart';
import 'package:client/data/providers/room_provider.dart';
import 'package:client/logic/models/client/client.dart';
import 'package:client/logic/models/invoice/invoice.dart';
import 'package:client/logic/models/room/room.dart';
import 'package:flutter/material.dart';

class MyInvoiceDialog extends StatefulWidget {
  const MyInvoiceDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<MyInvoiceDialog> createState() => _MyInvoiceDialogState();
}

class _MyInvoiceDialogState extends State<MyInvoiceDialog> {
  final _repository = const InvoiceProvider();
  final _roomProvider = const RoomProvider();
  final _clientProvider = const ClientProvider();
  late Future<Invoice?> _invoiceFuture;
  late Future<Room?> _roomFuture;
  late Future<Client?> _clientFuture;

  @override
  void initState() {
    super.initState();
    _invoiceFuture = _repository.getById(widget.id);
    _roomFuture = _invoiceFuture.then((invoice) {
      if (invoice != null) {
        return invoice.roomId != null
            ? _roomProvider.getById(invoice.roomId)
            : null;
      }
      return null;
    });
    _clientFuture = _invoiceFuture.then((invoice) {
      if (invoice != null) {
        return invoice.clientId != null
            ? _clientProvider.getById(invoice.clientId)
            : null;
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints.tightFor(width: 250, height: 250),
        child: FutureBuilder(
          future: Future.wait([_invoiceFuture, _roomFuture, _clientFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final Invoice invoice = snapshot.data![0] as Invoice;
                final Room? room = snapshot.data![1] as Room?;
                final Client? client = snapshot.data![2] as Client?;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Invoice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text('ID: ${invoice.id}'),
                    if (room != null) Text('Room: ${room.number}'),
                    if (client != null)
                      Text('Client: ${client.firstName} ${client.lastName}'),
                    Text('Date Start: ${invoice.dateStart}'),
                    Text('Date End: ${invoice.dateEnd}'),
                    Text('Amount: ${invoice.amount}'),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Invoice not found.');
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
