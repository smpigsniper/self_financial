import 'package:self_financial/Model/Request/amount_model.dart';

abstract class InputDataEvent {}

class InputData extends InputDataEvent {
  final AmountModel data;
  InputData(this.data);
}

class DeleteData extends InputDataEvent {
  final AmountModel data;
  DeleteData(this.data);
}

class UpdateData extends InputDataEvent {
  final AmountModel data;
  UpdateData(this.data);
}
