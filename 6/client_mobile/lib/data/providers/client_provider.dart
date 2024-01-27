import 'dart:convert';

import 'package:client_mobile/data/constants/string_constants.dart';
import 'package:client_mobile/data/providers/data_provider.dart';
import 'package:client_mobile/logic/models/client/client.dart';
import 'package:client_mobile/logic/models/sorting_value.dart';
import 'package:http/http.dart' as http;

class ClientProvider implements DataProvider<Client> {
  final String link = "${mobileHostname}api/Client";

  const ClientProvider();

  @override
  Future<Client?> create(Client data) async {
    final response = await http.post(
      Uri.parse(link),
      body: jsonEncode(data.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Client.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<String> delete(int id) async {
    final response = await http.delete(Uri.parse("$link/$id"));
    if (response.statusCode == 204) {
      return "Client deleted successfully";
    }
    if (response.statusCode == 404) {
      return "Client not found";
    }
    return "Error while deleting";
  }

  @override
  Future<List<Client>?> getAll({
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
      List<Client> clients = data.map((json) => Client.fromJson(json)).toList();
      return clients;
    }
    return null;
  }

  @override
  Future<Client?> getById(int id) async {
    final response = await http.get(Uri.parse("$link/$id"));

    if (response.statusCode == 200) {
      return Client.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Client?> update(int id, Client newData) async {
    final response = await http.put(
      Uri.parse("$link/$id"),
      body: jsonEncode(newData.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Client.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
