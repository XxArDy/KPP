import 'package:client_mobile/data/providers/client_provider.dart';
import 'package:client_mobile/logic/models/client/client.dart';
import 'package:client_mobile/logic/models/sorting_value.dart';
import 'package:client_mobile/logic/view_type.dart';
import 'package:client_mobile/presentation/pages/clients/client_add_edit_page.dart';
import 'package:client_mobile/presentation/widgets/my_client_dialog.dart';
import 'package:client_mobile/presentation/widgets/my_search_bar.dart';
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
  ViewType _currentView = ViewType.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentView = _currentView == ViewType.list
                        ? ViewType.cards
                        : ViewType.list;
                  });
                },
                child: Text(
                  _currentView == ViewType.list ? 'Cards View' : 'List View',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
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
                return _buildListView(clients);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<Client?>(
            MaterialPageRoute(
              builder: (context) => const ClientAddEditPage(),
            ),
          );

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

  Widget _buildListView(List<Client> clients) {
    if (_currentView == ViewType.list) {
      return Expanded(
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final item = clients[index];
            return ListTile(
              title: Text('${item.firstName} ${item.lastName}'),
              subtitle: Text('ID: ${item.id}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) => MyClientDialog(id: item.id),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.of(context).push<Client?>(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return ClientAddEditPage(clientToEdit: item);
                          },
                        ),
                      );

                      setState(() {
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Client ${result.id} updated')));
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final response = await _repository.delete(item.id);

                      setState(() {
                        ScaffoldMessenger.of(context).clearSnackBars();
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
    } else {
      return Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final item = clients[index];
            return InkWell(
              onTap: () {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) => MyClientDialog(id: item.id),
                );
              },
              child: Card(
                elevation: 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${item.firstName} ${item.lastName}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text('ID: ${item.id}', textAlign: TextAlign.center),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final result =
                                await Navigator.of(context).push<Client?>(
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return ClientAddEditPage(clientToEdit: item);
                                },
                              ),
                            );
                            setState(() {
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Client ${result.id} updated',
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final response = await _repository.delete(item.id);
                            setState(() {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
