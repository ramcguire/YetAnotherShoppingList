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
  final String newListId;

  const NewList(this.newListId);

  @override
  List<Object> get props => [newListId];

  @override
  String toString() => 'NewList { newList: $newListId }';
}

class ViewingList extends ShoppingListState {
  final List<ShoppingListEntity> lists;
  final String listId;

  const ViewingList(this.lists, this.listId);

  @override
  List<Object> get props => [lists, listId];

  @override
  String toString() => 'ViewingList { lists: $lists, listId: $listId }';
}

class ListsNotLoaded extends ShoppingListState {}