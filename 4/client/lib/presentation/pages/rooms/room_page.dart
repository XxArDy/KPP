import 'dart:convert';
import 'dart:typed_data';

import 'package:client/data/providers/room_provider.dart';
import 'package:client/logic/models/room/room.dart';
import 'package:client/logic/models/sorting_value.dart';
import 'package:client/presentation/pages/rooms/room_add_edit_page.dart';
import 'package:client/presentation/widgets/my_room_dialog.dart';
import 'package:client/presentation/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key, this.sortingValue = SortingValue.asc})
      : super(key: key);

  final SortingValue sortingValue;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final _repository = const RoomProvider();
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
            hintText: 'Room number...',
          ),
          FutureBuilder<List<Room>?>(
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
                return const Center(child: Text('No rooms found.'));
              } else {
                List<Room> rooms = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final item = rooms[index];

                      return ListTile(
                        leading: item.image != null
                            ? Image.memory(
                                Uint8List.fromList(base64Decode(item.image!)),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey,
                              ),
                        title: Text(
                          'Room ${item.number}',
                        ),
                        subtitle: FutureBuilder(
                          future: _repository.isAvailableToday(item.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                  'ID: ${item.id} ${snapshot.data ?? false ? "Available" : "Not available"}');
                            }
                            return const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) =>
                                      MyRoomDialog(id: item.id),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.of(context)
                                    .push<Room?>(MaterialPageRoute(
                                  builder: (ctx) {
                                    return RoomAddEditPage(
                                      roomToEdit: item,
                                    );
                                  },
                                ));

                                setState(() {
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Room ${result.id} updated')));
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
              await Navigator.of(context).push<Room?>(MaterialPageRoute(
            builder: (context) => const RoomAddEditPage(),
          ));

          setState(() {
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Room ${result.number} created')));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
