import 'package:client/data/providers/client_provider.dart';
import 'package:client/logic/models/client/client.dart';
import 'package:client/logic/models/sorting_value.dart';
import 'package:client/presentation/pages/clients/client_add_edit_page.dart';
import 'package:client/presentation/widgets/my_client_dialog.dart';
import 'package:client/presentation/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({Key? key, this.sortingValue = SortingValue.asc})
      : super(key: key);

  final SortingValue sortingValue;

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final _repository = const ClientProvider();
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MySearchBar(
            searchController: _searchController,
            onSearched: () {
              setState(() {
                _searchQuery = _searchController.text;
              });
            },
            hintText: 'Client name...',
          ),
          FutureBuilder<List<Client>?>(
            future: _repository.getAll(
              sortingInput: widget.sortingValue,
              searchInput: _searchQuery,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No clients found.'));
              } else {
                List<Client> clients = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      final item = clients[index];

                      return ListTile(
                        title: Text(
                          '${item.firstName} ${item.lastName}',
                        ),
                        subtitle: Text('ID: ${item.id}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) =>
                                      MyClientDialog(id: item.id),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.of(context)
                                    .push<Client?>(MaterialPageRoute(
                                  builder: (ctx) {
                                    return ClientAddEditPage(
                                      clientToEdit: item,
                                    );
                                  },
                                ));

                                setState(() {
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Client ${result.id} updated')));
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final response =
                                    await _repository.delete(item.id);

                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response)),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).push<Client?>(MaterialPageRoute(
            builder: (context) => const ClientAddEditPage(),
          ));

          setState(() {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Client ${result.firstName} ${result.lastName} created')));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
