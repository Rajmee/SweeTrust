import 'dart:convert';

import 'package:sweet_trust/src/models/food_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:sweet_trust/src/models/carrier_model.dart';

class CarUserModel extends Model {
  List<CarUser> _caruser = [];
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<CarUser> get caruser {
    return List.from(_caruser);
  }

  int get userLength {
    return _caruser.length;
  }

  Future<bool> addCarUser(CarUser caruser) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> userData = {
        "user": caruser.username,
        "phone": caruser.phone,
        "nid": caruser.nid,
        "password": caruser.password,
        "usertype": caruser.userType,
      };
      final http.Response response = await http.put(
          "https://sweet-trust-43bcd.firebaseio.com/carrier/${caruser.phone}.json",
          body: json.encode(userData));

      final Map<String, dynamic> responeData = json.decode(response.body);

      CarUser userWithId = CarUser(
        id: responeData["username"],
        username: caruser.username,
        phone: caruser.phone,
        nid: caruser.nid,
        password: caruser.password,
        userType: caruser.userType,
      );

      _caruser.add(userWithId);
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

  Future<bool> fetchCarUser(Map<String, dynamic> userData, String phoneId,
      String userPassword) async {
    _isLoading = true;
    notifyListeners();

    // CarUser userData = getUserByPhone(phoneId);
    // int userIndex = _caruser.indexOf(userData);

    try {
      final http.Response response = await http.get(
          "https://sweet-trust-43bcd.firebaseio.com/carrier/${phoneId}.json");

      // print("Fecthing data: ${response.body}");
      final Map<String, dynamic> fetchedData = json.decode(response.body);
      print(fetchedData);

      final List<CarUser> userList = [];

      fetchedData.forEach(
        (String phoneId, dynamic userData) {
          CarUser userInfo = CarUser(
            phone: phoneId,
            username: userData["user"],
            password: userData["password"],
            nid: userData["nid"],
            userType: userData["userType"],
          );

          userList.add(userInfo);
        },
      );

      _caruser = userList;

      if (_caruser.elementAt(2) == userPassword) {
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

  // CarUser getUserByPhone(String phoneId) {
  //   CarUser userIn;
  //   for (int i = 0; i < _caruser.length; i++) {
  //     if (_caruser[i].phone == phoneId) {
  //       userIn = _caruser[i];
  //       break;
  //     }
  //   }
  //   return userIn;
  // }
}
