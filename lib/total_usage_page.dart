import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:self_financial/Model/Request/amount_model.dart';
import 'package:self_financial/blocs/input_data/input_data_blocs.dart';
import 'package:self_financial/blocs/input_data/input_data_events.dart';
import 'package:self_financial/services/database_helper.dart';
import 'package:self_financial/widget/cust_text_field.dart';
import 'package:self_financial/widget/font_size.dart';

class TotalUsagePage extends StatefulWidget {
  const TotalUsagePage({Key? key}) : super(key: key);

  @override
  State<TotalUsagePage> createState() => _TotalUsagePageState();
}

class _TotalUsagePageState extends State<TotalUsagePage> {
  final CustFontSize _custFontSize = CustFontSize();
  List<AmountModel> amountList = [];
  final List<TextEditingController> _textEditingControllerList = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _focusNodeList = [
    FocusNode(),
    FocusNode(),
  ];
  final List<String> _textLabelList = ["Title", "Amount"];
  final List<bool> _decimalOnlyList = [false, true];
  final List<List<TextInputFormatter>> _textInputFormatterList = [
    [],
    [
      //LengthLimitingTextInputFormatter(12), //max length of 12 characters
      //FilteringTextInputFormatter.digitsOnly, //Only numbers
      FilteringTextInputFormatter.singleLineFormatter, //No line break
      FilteringTextInputFormatter.allow(
        RegExp("^([0-9]+(.?[0-9]?[0-9]?)?)"),
      ) //only double values
    ],
  ];

  bool _switchListChart = false;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    final data = await DatabaseHelper.getAllAmount();
    setState(() {
      amountList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
          flex: 1,
          child: _topRow(amountList),
        ),
        // Expanded(
        //   flex: 1,
        //   child: _totalAmtRow(amountList),
        // ),
        Expanded(
          flex: 20,
          child: _switchListChart ? _chartView() : _listView(),
        ),
      ],
    );
  }

  Widget _listView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: amountList.length,
      itemBuilder: (context, index) {
        final amount = amountList[index];
        return Dismissible(
          key: Key(amount.id.toString()),
          direction: DismissDirection.endToStart,
          background: const SizedBox(width: 0),
          onDismissed: (direction) {
            setState(() {
              _deleteItem(amountList[index]);
              amountList.removeAt(index);
            });
          },
          secondaryBackground: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.delete),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: _listViewCard(index),
              onLongPress: () {
                //handle update
                //it should be show dialog to update data
                print(amountList[index].id.toString());
                _showUpdataDataDialog(amountList[index], index);
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }

  Widget _chartView() {
    return Container();
  }

  Widget _listViewCard(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Text(amountList[index].id.toString()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amountList[index].title,
                  style: TextStyle(
                    fontSize: _custFontSize.primaryFontSize[6],
                  ),
                ),
                Text(amountList[index].createdAt),
              ],
            ),
            Text(
              '\$${amountList[index].amount}',
              style: TextStyle(fontSize: _custFontSize.primaryFontSize[6]),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(AmountModel data) {
    BlocProvider.of<InputDataBloc>(context).add(DeleteData(data));
  }

  void _updateItem(AmountModel data) {
    BlocProvider.of<InputDataBloc>(context).add(UpdateData(data));
  }

  Future<void> _showUpdataDataDialog(AmountModel data, int index) async {
    _textEditingControllerList[0].text = data.title;
    _textEditingControllerList[1].text = data.amount.toString();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Data"),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          content: SizedBox(
            height: 200,
            child: _columnContent(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                AmountModel updatedData = AmountModel(
                  id: data.id,
                  title: _textEditingControllerList[0].text,
                  amount: double.parse(_textEditingControllerList[1].text),
                  createdAt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                );
                _updateItem(updatedData);
                amountList[index] = updatedData;
                Navigator.of(context).pop(context);
                setState(() {});
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _columnContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _editTextField(
                _textLabelList[0],
                _textEditingControllerList[0],
                _focusNodeList[0],
                true,
                _textInputFormatterList[0],
                _decimalOnlyList[0]),
            const SizedBox(
              height: 30,
            ),
            _editTextField(
                _textLabelList[1],
                _textEditingControllerList[1],
                _focusNodeList[1],
                false,
                _textInputFormatterList[1],
                _decimalOnlyList[1]),
          ],
        ),
      ),
    );
  }

  Widget _totalAmtRow(List<AmountModel> amountList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Total Amount: ${_totalAmt(amountList)}"),
      ],
    );
  }

  double _totalAmt(List<AmountModel> amountList) {
    double totalAmount = 0;
    for (int i = 0; i < amountList.length; i++) {
      totalAmount += amountList[i].amount;
    }
    return totalAmount;
  }

  Widget _topRow(List<AmountModel> amountList) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: _filterButton(),
          ),
          Expanded(
            flex: 5,
            child: _totalAmtRow(amountList),
          ),
          Expanded(
            flex: 3,
            child: _custSwitch(),
          ),
        ],
      ),
    );
  }

  Widget _custSwitch() {
    return Row(
      children: [
        const Icon(Icons.list_outlined),
        Switch(
          value: _switchListChart,
          onChanged: (bool value) {
            setState(() {
              _switchListChart = value;
            });
          },
        ),
        const Icon(Icons.add_chart_outlined),
      ],
    );
  }

  Widget _filterButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {});
      },
      child: const Text("Filter"),
    );
  }

  Widget _editTextField(
      String label,
      TextEditingController controller,
      FocusNode focusNode,
      bool autoFocus,
      List<TextInputFormatter> inputformatterList,
      bool? decimalOnly) {
    return CustTextField(
      text: label,
      controller: controller,
      focusNode: focusNode,
      autoFocus: autoFocus,
      textInputForrmaterList: inputformatterList,
      decimalOnly: decimalOnly,
    );
  }
}
