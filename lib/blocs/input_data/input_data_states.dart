import 'package:flutter/material.dart';

@immutable
abstract class InputDataState {}

class InputDataInit extends InputDataState {}

class InputDataLoading extends InputDataState {}

class InputDataSaved extends InputDataState {
  //final AmountModel data;
  final int data;
  InputDataSaved(this.data);
}

class InputDataError extends InputDataState {}
