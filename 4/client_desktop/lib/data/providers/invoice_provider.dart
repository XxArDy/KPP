import 'dart:convert';

import 'package:client_desktop/data/constants/string_constants.dart';
import 'package:client_desktop/data/providers/data_provider.dart';
import 'package:client_desktop/logic/models/invoice/invoice.dart';
import 'package:client_desktop/logic/models/sorting_value.dart';
import 'package:http/http.dart' as http;

class InvoiceProvider implements DataProvider<Invoice> {
  final String link = "${hostname}api/Invoice";

  const InvoiceProvider();

  @override
  Future<Invoice?> create(Invoice data) async {
    final response = await http.post(
      Uri.parse(link),
      body: jsonEncode(data.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Invoice.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<String> delete(int id) async {
    final response = await http.delete(Uri.parse("$link/$id"));
    if (response.statusCode == 204) {
      return "Invoice deleted successfully";
    }
    if (response.statusCode == 404) {
      return "Invoice not found";
    }
    return "Error while deleting";
  }

  @override
  Future<List<Invoice>?> getAll({
    String? searchInput,
    SortingValue? sortingInput,
  }) async {
    final Map<String, String> queryParams = {};

    if (sortingInput != null) {
      queryParams['_order'] = sortingInput == SortingValue.asc ? 'asc' : 'desc';
    }

    if (searchInput != null && searchInput.isNotEmpty) {
      queryParams['_search'] = searchInput;
    }

    final Uri uri = Uri.parse(link).replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Invoice> invoices =
          data.map((json) => Invoice.fromJson(json)).toList();
      return invoices;
    }
    return null;
  }

  @override
  Future<Invoice?> getById(int id) async {
    final response = await http.get(Uri.parse("$link/$id"));

    if (response.statusCode == 200) {
      return Invoice.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Invoice?> update(int id, Invoice newData) async {
    final response = await http.put(
      Uri.parse("$link/$id"),
      body: jsonEncode(newData.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Invoice.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
