part of 'content_bloc.dart';

sealed class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

final class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<Content> contents;

  const ContentLoaded(this.contents);

  @override
  List<Object> get props => [contents];
}

class ContentLoadError extends ContentState {
  final String message;

  const ContentLoadError(this.message);

  @override
  List<Object> get props => [message];
}
