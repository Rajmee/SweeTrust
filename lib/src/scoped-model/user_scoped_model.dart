import 'package:sweet_trust/src/enums/auth_mode.dart';
import 'package:sweet_trust/src/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserMode extends Model {
  List<User> _users = [];
  User _authenticatedUser;
  bool _isLoading = false;

  List<User> get users {
    return List.from(_users);
  }

  User get authtenticatedUser {
    return _authenticatedUser;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<bool> addUserInfo(Map<String, dynamic> userInfo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.post(
          "https://sweet-trust-43bcd.firebaseio.com/users.json",
          body: json.encode(userInfo));

      final Map<String, dynamic> responseData = json.decode(response.body);

      User userWithID = User(
          id: responseData['name'],
          phone: userInfo['phone'],
          username: userInfo['username'],
          password: userInfo['password'],
          userType: userInfo['usertype']);

      _users.add(userWithID);
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> fetchUserInfos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response =
          await http.get("https://sweet-trust-43bcd.firebaseio.com/users.json");

      // print("Fecthing data: ${response.body}");
      final Map<String, dynamic> fetchedData = json.decode(response.body);
      print(fetchedData);

      final List<User> userInfos = [];

      fetchedData.forEach((String id, dynamic userInfoData) {
        User foodItem = User(
          id: id,
          email: userInfoData['email'],
          userType: userInfoData['userType'],
          username: userInfoData['username'],
        );

        userInfos.add(foodItem);
      });

      _users = userInfos;
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

  Future<Map<String, dynamic>> authenticate(
      String phone, String password, String username, String userType,
      {AuthMode authMode = AuthMode.SignIn}) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> authData = {
      "phone": phone,
      "password": password,
      "returnSecureToken": true,
    };

    Map<String, dynamic> userInfo = {
      "phone": phone,
      "username": username,
      "password": password,
      "userType": userType,
    };

    String message;
    bool hasError = false;

    try {
      http.Response response;
      if (authMode == AuthMode.SignUp) {
        response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD81H9Wr3g1VTnnQ9bZ1UaKMaCna-5F1cE",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
        addUserInfo(userInfo);
      } else if (authMode == AuthMode.SignIn) {
        response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD81H9Wr3g1VTnnQ9bZ1UaKMaCna-5F1cE",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
      }

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('idToken')) {
        _authenticatedUser = User(
          id: responseBody['localId'],
          phone: responseBody['phone'],
          token: responseBody['idToken'],
        );

        if (authMode == AuthMode.SignUp) {
          message = "Sign up successfully";
        } else {
          message = "Sign in successfully";
        }
      } else {
        hasError = true;
        if (responseBody['error']['message'] == 'EMAIL_EXISTS') {
          message = "Email already exists";
        } else if (responseBody['error']['message'] == "EMAIL_NOT_FOUND") {
          message = "Email does not exist";
        } else if (responseBody['error']['message'] == "INVALID_PASSWORD") {
          message = "Password is incorrect";
        }
      }

      _isLoading = false;
      notifyListeners();
      return {
        'message': message,
        'hasError': hasError,
      };
    } catch (error) {
      print("The error: $error");
      _isLoading = false;
      notifyListeners();

      return {
        'message': 'Failed to sign up successfully',
        'hasError': !hasError,
      };
    }
  }
}
