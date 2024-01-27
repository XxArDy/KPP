import 'dart:convert';

import 'package:client/data/constants/string_constants.dart';
import 'package:client/data/providers/data_provider.dart';
import 'package:client/logic/models/room/room.dart';
import 'package:client/logic/models/room/room_type.dart';
import 'package:client/logic/models/sorting_value.dart';
import 'package:http/http.dart' as http;

class RoomProvider implements DataProvider<Room> {
  final String link = "${hostname}api/Room";

  const RoomProvider();

  @override
  Future<Room?> create(Room data) async {
    final response = await http.post(
      Uri.parse(link),
      body: jsonEncode(data.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Room.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<String> delete(int id) async {
    final response = await http.delete(Uri.parse("$link/$id"));
    if (response.statusCode == 204) {
      return "Room deleted successfully";
    }
    if (response.statusCode == 404) {
      return "Room not found";
    }
    return "Error while deleting";
  }

  @override
  Future<List<Room>?> getAll({
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
      List<Room> rooms = data.map((json) => Room.fromJson(json)).toList();
      return rooms;
    }
    return null;
  }

  @override
  Future<Room?> getById(int id) async {
    final response = await http.get(Uri.parse("$link/$id"));

    if (response.statusCode == 200) {
      return Room.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Room?> update(int id, Room newData) async {
    final response = await http.put(
      Uri.parse("$link/$id"),
      body: jsonEncode(newData.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Room.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<RoomType>?> getAllTypes() async {
    final response = await http.get(Uri.parse("$link/allType"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<RoomType> types =
          data.map((json) => RoomType.fromJson(json)).toList();
      return types;
    }

    return null;
  }

  Future<bool> isAvailableToday(int id) async {
    final Map<String, String> queryParams = {};
    queryParams["_search"] = id.toString();
    final response = await http.get(Uri.parse("${hostname}api/Invoice")
        .replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      DateTime today = DateTime.now();
      for (var invoice in data) {
        DateTime startDate = DateTime.parse(invoice['dateStart']);
        DateTime endDate = DateTime.parse(invoice['dateEnd']);

        if (invoice['roomId'] == id &&
            today.isAfter(startDate) &&
            today.isBefore(endDate)) {
          return false;
        }
      }

      return true;
    }

    return false;
  }
}
