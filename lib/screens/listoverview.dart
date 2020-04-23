import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';

final double _cardElevation = 10.0; // for ease of "tweaking", remove later

class ListOverview extends StatelessWidget {
  final List<ShoppingListEntity> lists;

  ListOverview(this.lists);

  Widget _buildListOverview(BuildContext context, ShoppingListEntity list) {
    List<Widget> overview = List<Widget>();
    overview.add(Text(list.title));
    //overview.add(Spacer());
    list.collection.forEach((item) {
      overview.add(Text(item.title));
    });
    return Material(
      child: InkWell(
        onTap: () {
          print('picked list with id ${list.id}');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ListViewer(list.id);
          }));
        },
        child: Card(
          elevation: _cardElevation,
          child: Column(
            children: overview,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listPreview = List<Widget>.from((lists).map((list) {
      return _buildListOverview(context, list);
    }));

    listPreview.add(CreateList());
    return Swiper(
      control: SwiperControl(),
      itemBuilder: (BuildContext context, int idx) {
        return listPreview[idx];
      },
      itemCount: listPreview.length,
      viewportFraction: 0.8,
      scale: 0.8,
    );
  }
}

class CreateList extends StatefulWidget {
  @override
  _CreateListState createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  bool isEditing;
  String listTitle;
  final SnackBar snackBar = SnackBar(content: Text('Creating a new list...'));
  final _formKey = GlobalKey<FormState>();

  void submitForm() {
    var form = _formKey.currentState;
    if (form.validate()) {
      FocusScope.of(context).unfocus();
      form.save();
      BlocProvider.of<ShoppingListBloc>(context).add(CreateNewList(listTitle));
      print('saved list title of $listTitle');
    }
  }

  Widget _newListForm(BuildContext context) {
    ShoppingListBloc bloc = BlocProvider.of<ShoppingListBloc>(context);
    return Card(
        elevation: _cardElevation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'List name',
                  ),
                  onSaved: (value) {
                    setState(() {
                      listTitle = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a title to create a new list';
                    }
                    return null;
                  },
                ),
                Divider(height: 100),
                RaisedButton(
                  onPressed: () => submitForm(),
                  child: Text('Create new list'),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _createNewList() {
    return Material(
      child: InkWell(
        splashColor: Colors.blue,
        child: Card(
          elevation: _cardElevation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Create a new list',
                onPressed: () {
                  print('create new list button pushed');
                },
              ),
              Text('Create a new list'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _newListForm(context);
  }
}
