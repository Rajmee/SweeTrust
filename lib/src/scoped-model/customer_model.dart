import 'dart:convert';

import 'package:sweet_trust/src/models/food_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:sweet_trust/src/models/user_model.dart';

class UserModel extends Model {
  List<User> _user = [];
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<User> get user {
    return List.from(_user);
  }

  int get userLength {
    return _user.length;
  }

  Future<bool> addUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> userData = {
        "user": user.username,
        "phone": user.phone,
        "password": user.password,
        "usertype": user.userType,
      };
      final http.Response response = await http.put(
          "https://sweet-trust-43bcd.firebaseio.com/customer/${user.phone}.json",
          body: json.encode(userData));

      final Map<String, dynamic> responeData = json.decode(response.body);

      User userWithId = User(
        id: responeData["username"],
        username: user.username,
        phone: user.phone,
        password: user.password,
        userType: user.userType,
      );

      _user.add(userWithId);
      _isLoading = false;
      notifyListeners();
      // fetchFoods();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
      // print("Connection error: $e");
    }
  }

  Future<bool> fetchUser(Map<String, dynamic> userData, String phoneId,
      String userPassword) async {
    _isLoading = true;
    notifyListeners();

    // User userData = getUserByPhone(phoneId);
    // int userIndex = _user.indexOf(userData);

    try {
      final http.Response response = await http.get(
          "https://sweet-trust-43bcd.firebaseio.com/customer/${phoneId}.json");

      // print("Fecthing data: ${response.body}");
      final Map<String, dynamic> fetchedData = json.decode(response.body);
      print(fetchedData);

      final List<User> userList = [];

      fetchedData.forEach(
        (String phoneId, dynamic userData) {
          User userInfo = User(
            phone: phoneId,
            username: userData["user"],
            password: userData["password"],
            userType: userData["userType"],
          );

          userList.add(userInfo);
        },
      );

      _user = userList;

      if (_user.elementAt(2) == userPassword) {
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("The errror: $error");
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  // Future<bool> updateFood(Map<String, dynamic> userData, String phone) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   // get the food by id
  //   Food theFood = getFoodItemById(userId);

  //   // get the index of the food
  //   int foodIndex = _foods.indexOf(theFood);
  //   try {
  //     await http.put(
  //         "https://sweet-trust-43bcd.firebaseio.com/foods/${userId}.json",
  //         body: json.encode(userData));

  //     Food updateFoodItem = Food(
  //       id: foodId,
  //       name: foodData["title"],
  //       category: foodData["category"],
  //       discount: foodData['discount'],
  //       price: foodData['price'],
  //       description: foodData['description'],
  //     );

  //     _foods[foodIndex] = updateFoodItem;

  //     _isLoading = false;
  //     notifyListeners();
  //     return Future.value(true);
  //   } catch (error) {
  //     _isLoading = false;
  //     notifyListeners();
  //     return Future.value(false);
  //   }
  // }

  // User getUserByPhone(String phoneId) {
  //   User userIn;
  //   for (int i = 0; i < _user.length; i++) {
  //     if (_user[i].phone == phoneId) {
  //       userIn = _user[i];
  //       break;
  //     }
  //   }
  //   return userIn;
  // }
}
