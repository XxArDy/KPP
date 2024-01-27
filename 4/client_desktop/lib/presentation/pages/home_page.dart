import 'package:client_desktop/presentation/pages/clients/client_page.dart';
import 'package:client_desktop/presentation/pages/invoices/invoice_page.dart';
import 'package:client_desktop/presentation/pages/rooms/room_page.dart';
import 'package:flutter/material.dart';

import '../../logic/models/sorting_value.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  SortingValue _sortingValue = SortingValue.asc;
  final List<Widget> _pages = [
    const ClientPage(),
    const RoomPage(),
    const InvoicePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onSortPressed() {
    setState(() {
      _sortingValue = _sortingValue == SortingValue.asc
          ? SortingValue.desc
          : SortingValue.asc;
    });

    _pages[_currentIndex] =
        _updatePageSorting(_pages[_currentIndex], _sortingValue);
  }

  Widget _updatePageSorting(Widget page, SortingValue sortingValue) {
    if (page is ClientPage) {
      return ClientPage(sortingValue: sortingValue);
    } else if (page is RoomPage) {
      return RoomPage(sortingValue: sortingValue);
    } else if (page is InvoicePage) {
      return InvoicePage(sortingValue: sortingValue);
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students API Client'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _onSortPressed,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: 'Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_score),
            label: 'Invoice',
          ),
        ],
      ),
    );
  }
}
