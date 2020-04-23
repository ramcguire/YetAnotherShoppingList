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
  String toString() => 'ListsLoaded { lists: $lists }';
}

class NewList extends ShoppingListState {
  final ShoppingListEntity newList;

  const NewList(this.newList);

  @override
  List<Object> get props => [newList];

  @override
  String toString() => 'NewList { newList: $newList }';
}

class ViewingList extends ShoppingListState {
  final String listId;
  final List<ShoppingListEntity> lists;

  const ViewingList(this.listId, this.lists);

  @override
  List<Object> get props => [listId, lists];

  @override
  String toString() => 'ViewingList { listId: $listId }';
}

class ListsNotLoaded extends ShoppingListState {}