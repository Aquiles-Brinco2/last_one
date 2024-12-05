part of 'api_bloc.dart';

abstract class ApiBlocState {}

class ApiInitialState extends ApiBlocState {}

class ApiLoadingState extends ApiBlocState {}

class ApiLoadedState extends ApiBlocState {
  final List<dynamic> data;
  ApiLoadedState({required this.data});
}

class ApiErrorState extends ApiBlocState {
  final String error;
  ApiErrorState({required this.error});
}
