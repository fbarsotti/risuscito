import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/infrastructure/log/logger.dart';

class LoggerBlocDelegate extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    Logger.info('📟 [BLOC] $bloc Change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    Logger.info('📟 [BLOC] $bloc Event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Logger.info('📟 [BLOC] $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object e, StackTrace s) {
    late Object ex;
    if (e is Exception) {
    } else {
      ex = Exception(e.toString());
    }

    Logger.error(
      Exception(ex.toString()),
      s,
      text: '📟❌ [BLOC] $bloc',
    );
    super.onError(bloc, ex, s);
  }
}
