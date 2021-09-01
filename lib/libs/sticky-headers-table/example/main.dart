import 'package:flutter/material.dart';
import 'simple_table_page.dart';
import 'tap_handler_page.dart';
import '../example/decorated_table_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: LandingPage(),
    ),
  );
}

class LandingPage extends StatefulWidget {
  static final columns = 10;
  static final rows = 20;

  static List<List<String>> makeData() {
    final List<List<String>> output = [];
    for (int i = 0; i < columns; i++) {
      final List<String> row = [];
      for (int j = 0; j < rows; j++) {
        row.add('L$j : T$i');
      }
      output.add(row);
    }
    return output;
  }

  /// Simple generator for column title
  static List<String> makeTitleColumn() => List.generate(columns, (i) => 'Top $i');

  /// Simple generator for row title
  static List<String> makeTitleRow() => List.generate(rows, (i) => '$i.');

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  Widget _widgetOptions(int index) {
    switch (index) {
      case 0:
        return SimpleTablePage(
          titleColumn: LandingPage.makeTitleColumn(),
          titleRow: LandingPage.makeTitleRow(),
          data: LandingPage.makeData(),
        );
      case 1:
        return TapHandlerPage(
          titleColumn: LandingPage.makeTitleColumn(),
          titleRow: LandingPage.makeTitleRow(),
          data: LandingPage.makeData(),
        );
      case 2:
        return DecoratedTablePage(
          titleColumn: LandingPage.makeTitleColumn(),
          titleRow: LandingPage.makeTitleRow(),
          data: LandingPage.makeData(),
        );
      default:
        print('$index not supported');
        return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(),
            label: 'Simple',
          ),
          BottomNavigationBarItem(
            icon: Container(),
            label: 'Tap Handler',
          ),
          BottomNavigationBarItem(
            icon: Container(),
            label: 'Decorated',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
