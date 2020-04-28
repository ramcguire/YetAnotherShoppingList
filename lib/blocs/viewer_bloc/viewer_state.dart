import 'package:equatable/equatable.dart';

abstract class ViewerState extends Equatable {
  const ViewerState();
}

class InitialViewerState extends ViewerState {
  @override
  List<Object> get props => [];
}
