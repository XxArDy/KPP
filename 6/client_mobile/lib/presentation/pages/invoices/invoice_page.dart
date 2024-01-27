import 'package:client_mobile/data/providers/invoice_provider.dart';
import 'package:client_mobile/logic/models/invoice/invoice.dart';
import 'package:client_mobile/logic/models/sorting_value.dart';
import 'package:client_mobile/presentation/pages/invoices/invoice_add_edit_page.dart';
import 'package:client_mobile/presentation/widgets/my_invoice_dialog.dart';
import 'package:client_mobile/presentation/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key, this.sortingValue = SortingValue.asc})
      : super(key: key);

  final SortingValue sortingValue;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

enum ViewType { list, cards }

class _InvoicePageState extends State<InvoicePage> {
  final _repository = const InvoiceProvider();
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
            hintText: 'Client ID...',
          ),
          FutureBuilder<List<Invoice>?>(
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
                return const Center(child: Text('No invoices found.'));
              } else {
                List<Invoice> invoices = snapshot.data!;
                return _buildListView(invoices);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).push<Invoice?>(MaterialPageRoute(
            builder: (context) => const InvoiceAddEditPage(),
          ));

          setState(() {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invoice ${result.id} created')));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView(List<Invoice> invoices) {
    if (_currentView == ViewType.list) {
      return Expanded(
        child: ListView.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final item = invoices[index];
            return ListTile(
              title: Text('Invoice ${item.id}'),
              subtitle: Text('Client ID: ${item.clientId}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) => MyInvoiceDialog(id: item.id),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.of(context)
                          .push<Invoice?>(MaterialPageRoute(
                        builder: (ctx) {
                          return InvoiceAddEditPage(invoiceToEdit: item);
                        },
                      ));

                      setState(() {
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Invoice ${result.id} updated')));
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
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final item = invoices[index];
            return InkWell(
              onTap: () {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) => MyInvoiceDialog(id: item.id),
                );
              },
              child: Card(
                elevation: 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Invoice ${item.id}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text('Client ID: ${item.clientId}',
                        textAlign: TextAlign.center),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final result =
                                await Navigator.of(context).push<Invoice?>(
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return InvoiceAddEditPage(
                                      invoiceToEdit: item);
                                },
                              ),
                            );
                            setState(() {
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Invoice ${result.id} updated',
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
