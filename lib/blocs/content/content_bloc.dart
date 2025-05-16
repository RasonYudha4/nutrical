import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/content.dart';
import '../../data/repositories/content_repo.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepo _contentRepo = ContentRepo();

  ContentBloc() : super(ContentInitial()) {
    on<LoadContents>(_onLoadContents);
  }

  Future<void> _onLoadContents(
    LoadContents event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    try {
      final contents = await _contentRepo.fetchContents();
      emit(ContentLoaded(contents));
    } catch (e) {
      emit(ContentLoadError(e.toString()));
    }
  }
}
