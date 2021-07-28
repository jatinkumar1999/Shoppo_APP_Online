import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shoppo/modal/httpException.dart';

class AuthService with ChangeNotifier {
  late String _token;
   DateTime ?_expireDate;

  late String _userId;

  bool get isAuth {
    // ignore: unnecessary_null_comparison
    return token.isEmpty;
  }

  String get token {
    // ignore: unnecessary_null_comparison
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        // ignore: unnecessary_null_comparison
        _token != null) {
      return _token;
    }
    return "";
  }

 String  get userId {
    return _userId;
  }

  buildauthenticate(String email, String password, String auth) async {
    try {
      final String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$auth?key=AIzaSyCgTpv1lo3OJUbTLE8-Wl7RNnaQb9hdUig";
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      final resp = await json.decode(response.body);
      print(resp);
      print(resp["error"]["message"]);
      if (resp["error"] != null) {
        throw HttpException(message: resp["error"]["message"]);
      }
      _token = resp["idToken"];
      _userId = resp["localId"];
      _expireDate =
          DateTime.now().add(Duration(seconds: int.parse(resp["expiresIn"])));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    await buildauthenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    await buildauthenticate(email, password, "signInWithPassword");
  }
}
