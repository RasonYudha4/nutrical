import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

class AppBlocObserver extends BlocObserver {
  final Logger _logger = Logger('AppBlocObserver');

  AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.fine('${bloc.runtimeType} $event');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.severe('${bloc.runtimeType}', error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.fine('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    _logger.fine('${bloc.runtimeType} $transition');
  }
}
