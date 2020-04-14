import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yetanothershoppinglist/repositories/repositories.dart';
import '../bloc.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final ShoppingListRepository _listRepository;
  StreamSubscription _listSubscription;

  ShoppingListBloc({@required ShoppingListRepository listRepository})
      : assert(listRepository != null),
        _listRepository = listRepository;

  @override
  ShoppingListState get initialState => ListsLoading();

  @override
  Stream<ShoppingListState> mapEventToState(ShoppingListEvent event) async* {
    if (event is LoadLists) {
      yield* _mapLoadListsToState();
    } else if (event is AddList) {
      yield* _mapAddListToState(event);
    } else if (event is UpdateList) {
      yield* _mapUpdateListToState(event);
    } else if (event is DeleteList) {
      yield* _mapDeleteListToState(event);
    } else if (event is ListsUpdated) {
      yield* _mapListsUpdatedToState(event);
    }
  }

  Stream<ShoppingListState> _mapLoadListsToState() async* {
    _listSubscription?.cancel();
    _listSubscription = _listRepository.shoppingLists().listen(
          (lists) => add(ListsUpdated(lists)),
        );
  }

  Stream<ShoppingListState> _mapAddListToState(AddList event) async* {
    // need to implement this in ShoppingListEntity and ShoppingListRepository
  }

  Stream<ShoppingListState> _mapUpdateListToState(UpdateList event) async* {
    _listRepository.updateShoppingList(event.updatedList);
  }

  Stream<ShoppingListState> _mapDeleteListToState(DeleteList event) async* {
    _listRepository.removeShoppingList(event.list);
  }

  Stream<ShoppingListState> _mapListsUpdatedToState(ListsUpdated event) async* {
    yield ListsLoaded(event.lists);
  }

  @override
  Future<void> close() {
    _listSubscription?.cancel();
    return super.close();
  }
}
