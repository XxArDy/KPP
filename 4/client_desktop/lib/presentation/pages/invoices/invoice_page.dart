import 'package:client_desktop/data/providers/invoice_provider.dart';
import 'package:client_desktop/logic/models/invoice/invoice.dart';
import 'package:client_desktop/logic/models/sorting_value.dart';
import 'package:client_desktop/presentation/pages/invoices/invoice_add_edit_page.dart';
import 'package:client_desktop/presentation/widgets/my_invoice_dialog.dart';
import 'package:client_desktop/presentation/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key, this.sortingValue = SortingValue.asc})
      : super(key: key);

  final SortingValue sortingValue;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final _repository = const InvoiceProvider();
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
                return Expanded(
                  child: ListView.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final item = invoices[index];

                      return ListTile(
                        title: Text(
                          'Invoice ${item.id}',
                        ),
                        subtitle: Text('Client ID: ${item.clientId}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) =>
                                      MyInvoiceDialog(id: item.id),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.of(context)
                                    .push<Invoice?>(MaterialPageRoute(
                                  builder: (ctx) {
                                    return InvoiceAddEditPage(
                                      invoiceToEdit: item,
                                    );
                                  },
                                ));

                                setState(() {
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Invoice ${result.id} updated')));
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
}
