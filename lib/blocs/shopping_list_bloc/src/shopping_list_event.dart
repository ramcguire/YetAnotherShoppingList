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
  final String updatedField;
  final List<ShoppingListEntity> lists;

  const UpdateList(this.updatedList, this.updatedField, this.lists);

  @override
  List<Object> get props => [updatedList, updatedField];

  @override
  String toString() =>
      'UpdateList { updatedList: $updatedList, updatedField : $updatedField }';
}

class DeleteList extends ShoppingListEvent {
  final ShoppingListEntity list;
  final List<ShoppingListEntity> lists;

  const DeleteList(this.list, this.lists);

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
