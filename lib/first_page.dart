import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_financial/blocs/input_data/input_data_blocs.dart';
import 'package:self_financial/input_data_page.dart';
import 'package:self_financial/services/database_helper.dart';
import 'package:self_financial/total_usage_page.dart';
import 'package:self_financial/widget/color.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final CustColors _custColor = CustColors();
  final InputDataBloc _inputDataBloc = InputDataBloc(DatabaseHelper());
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _barItemList = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.money_outlined),
      label: 'Input Data',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_rounded),
      label: 'Total Usage',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      BlocProvider<InputDataBloc>.value(
        value: _inputDataBloc,
        child: const InputDataPage(),
      ),
      BlocProvider<InputDataBloc>.value(
        value: _inputDataBloc,
        child: const TotalUsagePage(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_barItemList[_selectedIndex].label ?? ''),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: _barItemList,
      currentIndex: _selectedIndex,
      selectedItemColor: _custColor.primaryColor[0],
      onTap: _onItemTapped,
    );
  }
}
