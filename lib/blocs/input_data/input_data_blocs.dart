import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_financial/blocs/input_data/input_data_events.dart';
import 'package:self_financial/blocs/input_data/input_data_states.dart';
import 'package:self_financial/services/database_helper.dart';

class InputDataBloc extends Bloc<InputDataEvent, InputDataState> {
  late int responseData;
  late DatabaseHelper databaseHelper;
  InputDataBloc(this.databaseHelper) : super(InputDataInit()) {
    on<InputDataEvent>((event, emit) async {
      if (event is InputData) {
        emit(InputDataLoading());
        responseData = await databaseHelper.addAmount(event.data);
        emit(InputDataSaved(responseData));
      }
      if (event is DeleteData) {
        emit(InputDataLoading());
        responseData = await databaseHelper.deleteAmount(event.data);
      }

      if (event is UpdateData) {
        responseData = await databaseHelper.updateAmount(event.data);
      }

      emit(InputDataInit());
    });
  }
}
