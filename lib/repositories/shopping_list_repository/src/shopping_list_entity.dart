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

//  ShoppingListEntity.createNew(String title, String owner)
//    : title = title,
//      owner = owner,
//      collection = List<ShoppingListItem>(),
//      id = Uuid().v4();

  Map toJson() => {
        'title': title,
        'id': id,
        'items': jsonEncode(collection),
      };

  Map<String, Object> toDocument() {
    return {
      'title': title,
      'owner': owner,
      'collection': jsonEncode(collection),
    };
  }
}

class ShoppingListItem {
  final String title;
  final String id;
  final String description;
  final bool complete;

  ShoppingListItem(this.title, this.id, this.description, this.complete);

  ShoppingListItem.fromMap(Map<String, dynamic> item)
      : title = item['title'],
        id = item['id'],
        description = item['id'] ?? '',
        complete = item['complete'];

  ShoppingListItem.createNew(String title, String description, bool complete)
      : title = title,
        description = description,
        complete = complete,
        id = Uuid().v4().toString();

  @override
  int get hashCode =>
      complete.hashCode ^ title.hashCode ^ id.hashCode ^ description.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListItem &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          title == other.title &&
          id == other.id &&
          description == other.description;

  Map toJson() {
    return {
      'complete': complete,
      'title': title,
      'id': id ?? Uuid().v4().toString(),
      'description': description,
    };
  }

  static ShoppingListItem fromJson(Map<String, Object> json) {
    return ShoppingListItem(
      json['title'] as String,
      json['id'] as String,
      json['description'] as String,
      json['complete'] as bool,
    );
  }
}
