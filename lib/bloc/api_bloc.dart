import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'api_event.dart';
part 'api_state.dart';

class ApiBlocBloc extends Bloc<ApiBlocEvent, ApiBlocState> {
  final String _apiUrl =
      'https://674869495801f5153590c2a3.mockapi.io/api/v1/pokemon';

  ApiBlocBloc() : super(ApiInitialState()) {
    on<FetchApiDataEvent>(_onFetchData);
    on<CreateApiDataEvent>(_onCreateData);
    on<UpdateApiDataEvent>(_onUpdateData);
    on<DeleteApiDataEvent>(_onDeleteData);
  }

  Future<void> _onFetchData(
      FetchApiDataEvent event, Emitter<ApiBlocState> emit) async {
    emit(ApiLoadingState());
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        emit(ApiLoadedState(data: data));
      } else {
        emit(ApiErrorState(error: 'Error fetching data'));
      }
    } catch (e) {
      emit(ApiErrorState(error: e.toString()));
    }
  }

  Future<void> _onCreateData(
      CreateApiDataEvent event, Emitter<ApiBlocState> emit) async {
    emit(ApiLoadingState());
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: json.encode(event.data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        add(FetchApiDataEvent());
      } else {
        emit(ApiErrorState(error: 'Error creating data'));
      }
    } catch (e) {
      emit(ApiErrorState(error: e.toString()));
    }
  }

  Future<void> _onUpdateData(
      UpdateApiDataEvent event, Emitter<ApiBlocState> emit) async {
    emit(ApiLoadingState());
    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/${event.id}'),
        body: json.encode(event.updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        add(FetchApiDataEvent());
      } else {
        emit(ApiErrorState(error: 'Error updating data'));
      }
    } catch (e) {
      emit(ApiErrorState(error: e.toString()));
    }
  }

  Future<void> _onDeleteData(
      DeleteApiDataEvent event, Emitter<ApiBlocState> emit) async {
    emit(ApiLoadingState());
    try {
      final response = await http.delete(
        Uri.parse('$_apiUrl/${event.id}'),
      );

      if (response.statusCode == 200) {
        add(FetchApiDataEvent());
      } else {
        emit(ApiErrorState(error: 'Error deleting data'));
      }
    } catch (e) {
      emit(ApiErrorState(error: e.toString()));
    }
  }
}
