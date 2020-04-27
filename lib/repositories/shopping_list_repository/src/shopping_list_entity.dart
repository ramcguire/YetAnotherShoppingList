import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ShoppingListEntity {
  final String title;
  final String owner;
  final String id;
  final List<ShoppingListItem> collection;
  final List<String> authorized;
  final List<String> categories;
  final DateTime creationDate;
  DocumentReference reference;

  ShoppingListEntity(this.title, this.id, this.owner, this.collection,
      this.reference, this.authorized, this.categories, this.creationDate);

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
        categories = snapshot.data['categories'].map<String>((cat) {
          return cat.toString();
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
        categories = List<String>.generate(1, (int idx) => 'None'),
        id = null;

  ShoppingListEntity copyWith(String title) {
    return ShoppingListEntity(
      title ?? this.title,
      this.id,
      this.owner,
      this.collection,
      this.reference,
      this.authorized,
      this.categories,
      this.creationDate,
    );
  }

  Map toJson() => {
        'title': title,
        'owner': owner,
        'data': FieldValue.arrayUnion(collection.map((item) {
          return item.toJson();
        }).toList()),
        'authorized': FieldValue.arrayUnion(authorized),
        'created_at': creationDate.millisecondsSinceEpoch,
        'categories': FieldValue.arrayUnion(categories),
      };

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'owner': owner,
      'data': FieldValue.arrayUnion(collection.map((item) {
        return item.toJson();
      }).toList()),
      'authorized': FieldValue.arrayUnion(authorized),
      'created_at': Timestamp.fromDate(creationDate),
      'categories': FieldValue.arrayUnion(categories),
    };
  }
}

class ShoppingListItem {
  final String uid;
  String title;
  String category;
  String description;
  bool complete;

  ShoppingListItem(this.title, this.description, this.complete, this.uid);

  ShoppingListItem.fromMap(Map<String, dynamic> item)
      : title = item['title'],
        description = item['description'] ?? '',
        category = item['category'] ?? 'None',
        complete = item['complete'],
        uid = item['uid'];

  ShoppingListItem.createNew()
      : title = '',
        description = '',
        category = 'None',
        complete = false,
        uid = Uuid().v4();

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
      'category': category,
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
