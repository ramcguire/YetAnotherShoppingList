import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yetanothershoppinglist/blocs/blocs.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import 'package:yetanothershoppinglist/screens/screens.dart';
import 'package:yetanothershoppinglist/widgets/widgets.dart';


class ListViewer extends StatefulWidget {
  final String listId;

  ListViewer(this.listId);

  @override
  _ListViewerState createState() => _ListViewerState(listId);
}

class _ListViewerState extends State<ListViewer> {
  final String listId;
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  _ListViewerState(this.listId);

  int _selectedIdx = 0;

  void onTabSelected(int idx) {
    setState(() {
      pageController.animateToPage(idx,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
      _selectedIdx = idx;
    });
  }

  Widget mainBody(BuildContext context, ShoppingListEntity selectedList) {

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            if (_selectedIdx == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddEditItem.add(selectedList);
              }));
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: AddUser(selectedList));

            }
          },
        ),
        appBar: AppBar(
          title: Text(selectedList.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.title),
              tooltip: 'Edit list title',
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: EditTitle(selectedList));
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightGreenAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              title: Text('Share'),
            ),
          ],
          currentIndex: _selectedIdx,
          selectedItemColor: Colors.blueAccent,
          onTap: onTabSelected,
        ),
        body: Material(
            child: PageView(
          onPageChanged: onTabSelected,
          controller: pageController,
          children: <Widget>[
            TileList(selectedList),
            ShareScreen(selectedList.id, AddUser(selectedList)),
          ],
        )));
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        if (state is ListsLoaded) {
          List<ShoppingListEntity> lists = state.lists;
          int idx = lists.indexWhere((i) => i.id == this.widget.listId);
          if (idx == -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
            return Scaffold(
              body: Loading(),
            );
          }
          return mainBody(context, lists[idx]);
        }
        return Container();
      },
    );
  }
}
