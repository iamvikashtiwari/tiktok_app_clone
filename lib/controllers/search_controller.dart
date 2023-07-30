import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_app_clone/constants.dart';
import 'package:tiktok_app_clone/models/user_model.dart';

class SearchedController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  List<User> get searchedUsers => _searchedUsers.value;

  searchUser(String typeUser) async {
    _searchedUsers.bindStream(firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typeUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<User> retValue = [];
      for (var element in query.docs) {
        retValue.add(User.fromSnap(element));
      }
      return retValue;
    }));
  }
}
