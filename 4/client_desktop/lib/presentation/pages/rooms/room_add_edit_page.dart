import 'dart:convert';
import 'dart:typed_data';

import 'package:client_desktop/data/providers/room_provider.dart';
import 'package:client_desktop/logic/models/room/room.dart';
import 'package:client_desktop/logic/models/room/room_type.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RoomAddEditPage extends StatefulWidget {
  const RoomAddEditPage({Key? key, this.roomToEdit}) : super(key: key);

  final Room? roomToEdit;

  @override
  _RoomAddEditPageState createState() => _RoomAddEditPageState();
}

class _RoomAddEditPageState extends State<RoomAddEditPage> {
  late TextEditingController _numberController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  int? _selectedTypeId;
  final _repository = const RoomProvider();
  String? _imageBase64;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(Uint8List.fromList(bytes));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _numberController =
        TextEditingController(text: widget.roomToEdit?.number.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.roomToEdit?.description ?? '');
    _priceController =
        TextEditingController(text: widget.roomToEdit?.price.toString() ?? '');
    _selectedTypeId = widget.roomToEdit?.typeId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomToEdit == null
            ? 'Add Room'
            : 'Edit Room № ${widget.roomToEdit!.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: 'Room Number'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<RoomType>?>(
              future: _repository.getAllTypes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No room types found.');
                } else {
                  List<RoomType> roomTypes = snapshot.data!;
                  return DropdownButton<int>(
                    value: _selectedTypeId,
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeId = value;
                      });
                    },
                    items: roomTypes
                        .map(
                          (type) => DropdownMenuItem<int>(
                            value: type.id,
                            child: Text(type.name ?? ''),
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget.roomToEdit == null) {
                  final newRoom = Room(
                    id: 0,
                    number: int.tryParse(_numberController.text) ?? 0,
                    description: _descriptionController.text,
                    price: double.tryParse(_priceController.text) ?? 0.0,
                    typeId: _selectedTypeId ?? 0,
                    image: _imageBase64 ?? '',
                  );
                  await _repository.create(newRoom);
                } else {
                  final updatedRoom = widget.roomToEdit!.copyWith(
                    number: int.tryParse(_numberController.text) ?? 0,
                    description: _descriptionController.text,
                    price: double.tryParse(_priceController.text) ?? 0.0,
                    typeId: _selectedTypeId ?? 0,
                    image: _imageBase64 ?? '',
                  );
                  await _repository.update(updatedRoom.id, updatedRoom);
                }
                Navigator.of(context).pop();
              },
              child: Text(widget.roomToEdit == null ? 'Add' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
