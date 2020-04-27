import 'dart:async';
import './shopping_list_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListRepository {
  final Firestore _firestore;

  const ShoppingListRepository(this._firestore);

  Stream<List<ShoppingListEntity>> shoppingLists(String user) {
    return _firestore
        .collectionGroup('lists')
        .where('authorized', arrayContains: user)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((snapshot) {
        return ShoppingListEntity.fromSnapshot(snapshot);
      }).toList();
    });
  }

  Future<String> createNewShoppingList(String listTitle, String user) async {
    DocumentReference newList = await _firestore
        .collection('lists')
        .add(ShoppingListEntity.createNew(listTitle, user).toDocument());
    print('created a new Document with ID: ${newList.documentID}');
    return newList.documentID;
  }

  Future<String> removeShoppingList(ShoppingListEntity list) async {
    await list.reference.delete();
    return list.id;
  }

   void updateShoppingList(ShoppingListEntity list, String field) {
    print('updating $field field');
    list.reference.setData(list.toDocument());
  }
}
