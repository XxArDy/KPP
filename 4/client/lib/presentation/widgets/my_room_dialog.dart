import 'package:client/data/providers/room_provider.dart';
import 'package:client/logic/models/room/room.dart';
import 'package:client/logic/models/room/room_type.dart';
import 'package:flutter/material.dart';

class MyRoomDialog extends StatefulWidget {
  const MyRoomDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<MyRoomDialog> createState() => _MyRoomDialogState();
}

class _MyRoomDialogState extends State<MyRoomDialog> {
  final _repository = const RoomProvider();
  late Future<Room?> _roomFuture;
  late Future<List<RoomType>?> _typesFuture;

  @override
  void initState() {
    super.initState();
    _roomFuture = _repository.getById(widget.id);
    _typesFuture = _repository.getAllTypes();
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
        constraints: const BoxConstraints.tightFor(width: 200, height: 250),
        child: FutureBuilder(
          future: Future.wait([_roomFuture, _typesFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final Room room = snapshot.data![0] as Room;
                final List<RoomType>? types =
                    snapshot.data![1] as List<RoomType>?;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Room',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text('ID: ${room.id}'),
                    Text('Number: ${room.number}'),
                    Text('Description: ${room.description ?? "N/A"}'),
                    Text('Price: ${room.price}'),
                    if (types != null)
                      Text('Type: ${_getRoomTypeName(room.typeId, types)}'),
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
                return const Text('Room not found.');
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  String _getRoomTypeName(int typeId, List<RoomType> types) {
    final roomType = types.firstWhere((type) => type.id == typeId, orElse: () {
      return RoomType(id: 0, name: 'Unknown');
    });

    return roomType.name ?? 'Unknown';
  }
}
