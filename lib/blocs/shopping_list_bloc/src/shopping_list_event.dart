import 'package:equatable/equatable.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';

abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();

  @override
  List<Object> get props => [];
}

class LoadLists extends ShoppingListEvent {}

class AddList extends ShoppingListEvent {
  final ShoppingListEntity list;

  const AddList(this.list);

  @override
  List<Object> get props => [list];

  @override
  String toString() => 'AddList { list: $list }';
}

class UpdateList extends ShoppingListEvent {
  final ShoppingListEntity updatedList;

  const UpdateList(this.updatedList);

  @override
  List<Object> get props => [updatedList];

  @override
  String toString() => 'UpdateList { updatedList: $updatedList }';
}

class DeleteList extends ShoppingListEvent {
  final ShoppingListEntity list;

  const DeleteList(this.list);

  @override
  List<Object> get props => [list];

  @override
  String toString() => 'DeleteList { list: $list }';
}

class ListsUpdated extends ShoppingListEvent {
  final List<ShoppingListEntity> lists;

  const ListsUpdated(this.lists);

  @override
  List<Object> get props => [lists];
}
