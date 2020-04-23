import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';


class ShoppingListEntity {
  final String title;
  final String owner;
  final String id;
  final List<ShoppingListItem> collection;
  DocumentReference reference;

  ShoppingListEntity(
      this.title, this.id, this.owner, this.collection, this.reference);

  // construct a shopping list from DocumentSnapshot
  ShoppingListEntity.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot.data['title'],
        id = snapshot.documentID,
        owner = snapshot.data['owner'],
        reference = snapshot.reference,
        collection = snapshot.data['data'].map<ShoppingListItem>((entries) {
          print('in shoppinglist contructor for title ${snapshot['title']}');
          return ShoppingListItem.fromMap(entries);
        }).toList();

  ShoppingListEntity.createNew(String title, String owner)
    : title = title,
      owner = owner,
      collection = List<ShoppingListItem>.generate(1, (int idx) => ShoppingListItem.createNew()),
      id = null;

  Map toJson() => {
        'title': title,
        'owner': owner,
        'data': FieldValue.arrayUnion(collection.map((item) {
          return item.toJson();
        }).toList()),
      };

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'owner': owner,
      'data': FieldValue.arrayUnion(collection.map((item) {
        return item.toJson();
      }).toList()),
    };
  }
}

class ShoppingListItem {
  String title;
  String description;
  bool complete;

  ShoppingListItem(this.title, this.description, this.complete);

  ShoppingListItem.fromMap(Map<String, dynamic> item)
      : title = item['title'],
        description = item['id'] ?? '',
        complete = item['complete'];

  ShoppingListItem.createNew()
      : title = '',
        description = '',
        complete = false;

  @override
  int get hashCode =>
      complete.hashCode ^ title.hashCode ^ description.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListItem &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          title == other.title &&
          description == other.description;

  Map<String, dynamic> toJson() {
    return {
      'complete': complete,
      'title': title,
      'description': description,
    };
  }

  static ShoppingListItem fromJson(Map<String, Object> json) {
    return ShoppingListItem(
      json['title'] as String,
      json['description'] as String,
      json['complete'] as bool,
    );
  }
}
