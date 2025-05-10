import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/content.dart';
import '../../data/repositories/content_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ContentRepo _contentRepo = ContentRepo();

  HomeBloc() : super(HomeInitial()) {
    on<LoadContents>(_onLoadContents);
  }

  Future<void> _onLoadContents(
    LoadContents event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(ContentLoading());

      final List<Content> contents = await _contentRepo.fetchContents();

      emit(ContentLoaded(contents));
    } catch (e) {
      emit(ContentLoadError(e.toString()));
    }
  }
}
