import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ViewerBloc extends Bloc<ViewerEvent, ViewerState> {
  @override
  ViewerState get initialState => InitialViewerState();

  @override
  Stream<ViewerState> mapEventToState(
    ViewerEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
