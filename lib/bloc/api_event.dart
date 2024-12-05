part of 'api_bloc.dart';

abstract class ApiBlocEvent {}

class FetchApiDataEvent extends ApiBlocEvent {}

class CreateApiDataEvent extends ApiBlocEvent {
  final Map<String, dynamic> data;
  CreateApiDataEvent({required this.data});
}

class UpdateApiDataEvent extends ApiBlocEvent {
  final String id;
  final Map<String, dynamic> updatedData;
  UpdateApiDataEvent({required this.id, required this.updatedData});
}

class DeleteApiDataEvent extends ApiBlocEvent {
  final String id;
  DeleteApiDataEvent({required this.id});
}
