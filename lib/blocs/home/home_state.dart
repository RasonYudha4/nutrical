part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class ContentLoading extends HomeState {}

class ContentLoaded extends HomeState {
  final List<Content> contents;

  const ContentLoaded(this.contents);
}

class ContentLoadError extends HomeState {
  final String message;

  const ContentLoadError(this.message);
}
