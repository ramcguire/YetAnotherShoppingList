import 'package:equatable/equatable.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';

abstract class ShoppingListState extends Equatable {
  const ShoppingListState();

  @override
  List<Object> get props => [];
}


class ListsLoading extends ShoppingListState {}

class ListsLoaded extends ShoppingListState {
  final List<ShoppingListEntity> lists;

  const ListsLoaded([this.lists = const []]);

  @override
  List<Object> get props => [lists];

  @override
  String toString() => 'ListsLoaded {lists: $lists }';
}

class ListsNotLoaded extends ShoppingListState {}