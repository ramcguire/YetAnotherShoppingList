import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ShoppingListEntity {
  final String title;
  final String owner;
  final String id;
  final List<ShoppingListItem> collection;
  final List<String> authorized;
  final DateTime creationDate;
  DocumentReference reference;

  ShoppingListEntity(this.title, this.id, this.owner, this.collection,
      this.reference, this.authorized, this.creationDate);

  // construct a shopping list from DocumentSnapshot
  ShoppingListEntity.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot.data['title'],
        id = snapshot.documentID,
        owner = snapshot.data['owner'],
        reference = snapshot.reference,
        creationDate = snapshot.data['created_at'].toDate(),
        collection = snapshot.data['data'].map<ShoppingListItem>((entries) {
          return ShoppingListItem.fromMap(entries);
        }).toList(),
        authorized = snapshot.data['authorized'].map<String>((user) {
          return user.toString();
        }).toList();

  ShoppingListEntity.createNew(String title, String owner)
      : title = title,
        owner = owner,
        collection = List<ShoppingListItem>(),
        authorized = List<String>.generate(1, (int idx) => owner),
        creationDate = DateTime.now(),
        id = null;

  ShoppingListEntity copyWith(
      {String title,
      String id,
      String owner,
      List<ShoppingListItem> collection,
      DocumentReference reference,
      List<String> authorized,
      DateTime creationDate}) {
    return ShoppingListEntity(
      title ?? this.title,
      id ?? this.id,
      owner ?? this.owner,
      collection ?? this.collection,
      reference ?? this.reference,
      authorized ?? this.authorized,
      creationDate ?? this.creationDate,
    );
  }

  // updates matching ShoppingListItem in place, then updates repository
  ShoppingListEntity updateInPlace(ShoppingListItem item) {
    List<ShoppingListItem> currentCollection = this.collection;
    int idx = currentCollection.indexWhere((i) => i.uid == item.uid);
    currentCollection[idx] = item;
    return this.copyWith(collection: currentCollection);
  }

  Map toJson() => {
        'title': title,
        'owner': owner,
        'data': FieldValue.arrayUnion(collection.map((item) {
          return item.toJson();
        }).toList()),
        'authorized': FieldValue.arrayUnion(authorized),
        'created_at': creationDate.millisecondsSinceEpoch,
      };

  FieldValue updateData() => FieldValue.arrayUnion(collection.map((item) {
    return item.toJson();
  }).toList());

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'owner': owner,
      'data': FieldValue.arrayUnion(collection.map((item) {
        return item.toJson();
      }).toList()),
      'authorized': FieldValue.arrayUnion(authorized),
      'created_at': Timestamp.fromDate(creationDate),
    };
  }
}

class ShoppingListItem {
  final String uid;
  String title;
  String description;
  bool complete;

  ShoppingListItem(this.title, this.description, this.complete, this.uid);

  ShoppingListItem.fromMap(Map<String, dynamic> item)
      : title = item['title'],
        description = item['description'] ?? '',
        complete = item['complete'],
        uid = item['uid'];

  ShoppingListItem.createNew()
      : title = '',
        description = '',
        complete = false,
        uid = Uuid().v4();

  ShoppingListItem copyWith(
      {String uid, String title, String description, bool complete}) {
    return ShoppingListItem(
      title ?? this.title,
      description ?? this.description,
      complete ?? this.complete,
      uid ?? this.uid,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ title.hashCode ^ description.hashCode ^ uid.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListItem &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          title == other.title &&
          uid == other.uid &&
          description == other.description;

  Map<String, dynamic> toJson() {
    return {
      'complete': complete,
      'title': title,
      'description': description,
      'uid': uid,
    };
  }

  static ShoppingListItem fromJson(Map<String, Object> json) {
    return ShoppingListItem(
      json['title'] as String,
      json['description'] as String,
      json['complete'] as bool,
      json['uid'] as String,
    );
  }
}
