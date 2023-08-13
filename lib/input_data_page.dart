import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:self_financial/blocs/input_data/input_data_blocs.dart';
import 'package:self_financial/blocs/input_data/input_data_states.dart';
import 'package:self_financial/services/database_helper.dart';
import 'package:self_financial/widget/color.dart';
import 'package:self_financial/widget/cust_text_field.dart';

import 'Model/Request/amount_model.dart';
import 'blocs/input_data/input_data_events.dart';
import 'widget/cust_elevated_button.dart';

class InputDataPage extends StatefulWidget {
  const InputDataPage({Key? key}) : super(key: key);

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  final CustColors _custColors = CustColors();
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

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  List<AmountModel> amountList = [];
  void _loadData() async {
    final data = await DatabaseHelper.getAllAmount();
    setState(() {
      amountList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InputDataBloc, InputDataState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is InputDataInit) {
          _initAction();
          //_custAlertDialog();
          return _initPage();
        }
        if (state is InputDataLoading) {
          return _loadingPage();
        }
        if (state is InputDataSaved) {
          _initAction();
          return _initPage();
        }
        return _errorpage();
      },
    );
  }

  Widget _initPage() {
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
            const SizedBox(
              height: 30,
            ),
            CustElevatedButton(
              text: "Confirm",
              onPressed: () {
                AmountModel amountData = AmountModel(
                  id: amountList.length + 1,
                  title: _textEditingControllerList[0].text,
                  amount: double.parse(_textEditingControllerList[1].text),
                  createdAt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                );
                _confirmButtonPress(amountData);
                _custAlertDialog();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorpage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Opps, You got some problem!"),
      ),
    );
  }

  Widget _loadingPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: _custColors.primaryColor[0],
        ),
      ),
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

  void _confirmButtonPress(AmountModel data) {
    BlocProvider.of<InputDataBloc>(context).add(InputData(data));
  }

  void _initAction() {
    //clear text
    for (int i = 0; i < _textEditingControllerList.length; i++) {
      _textEditingControllerList[i].clear();
    }
    _textEditingControllerList[1].text = "0";
  }

  Future<void> _custAlertDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Record Saved"),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
          content: const Text("Saved successfully"),
        );
      },
    );
  }
}
