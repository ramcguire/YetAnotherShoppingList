import 'dart:async';
import './shopping_list_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListRepository {
  final Firestore _firestore;
  final String _user;

  const ShoppingListRepository(this._firestore, this._user);

  Stream<List<ShoppingListEntity>> shoppingLists() {
    return _firestore
        .collectionGroup('lists')
        .where('owner', isEqualTo: _user)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((snapshot) {
        return ShoppingListEntity.fromSnapshot(snapshot);
      }).toList();
    });
  }

  Future<void> createNewShoppingList(String listTitle) async {
    DocumentReference newList = await _firestore
        .collection('lists')
        .add(ShoppingListEntity.createNew(listTitle, _user).toDocument());
  }

  Future<String> removeShoppingList(ShoppingListEntity list) async {
    await list.reference.delete();
    return list.id;
  }

  Future<void> updateShoppingList(ShoppingListEntity list) async {
    await list.reference.updateData(list.toJson());
  }
}
