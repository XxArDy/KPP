import 'package:client_desktop/data/providers/client_provider.dart';
import 'package:client_desktop/logic/models/client/client.dart';
import 'package:flutter/material.dart';

class MyClientDialog extends StatefulWidget {
  const MyClientDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<MyClientDialog> createState() => _MyClientDialogState();
}

class _MyClientDialogState extends State<MyClientDialog> {
  final _repository = const ClientProvider();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints.tightFor(width: 200, height: 170),
        child: FutureBuilder(
          future: _repository.getById(widget.id),
          builder: (context, AsyncSnapshot<Client?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final Client client = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Client',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Text('ID: ${client.id}'),
                    Text('First name: ${client.firstName}'),
                    Text('Last name: ${client.lastName}'),
                    Text('Phone: ${client.phone}'),
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
                return const Text('Client not found.');
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
