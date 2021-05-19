import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum keyStatus { FoundToken, NoToken, Inititalizing }

class KeyStore with ChangeNotifier {
  FlutterSecureStorage storage = FlutterSecureStorage();
  keyStatus _keyStat = keyStatus.Inititalizing;

  KeyStore.instance() {
    // storage.delete(key: 'tokenKey');
    tokenState();
  }

  KeyStore();

  keyStatus get keyStat => _keyStat;

  Future<String> get retrieveToken async => await storage.read(key: 'tokenKey');

  Future<String> tokenState() async {
    String token = await retrieveToken;
    // updateKeyStatus(keyStatus.Inititalizing);
    try {
      if (token == null || token.isEmpty) {
        print('$token form store');
        updateKeyStatus(keyStatus.NoToken);
      } else {
        updateKeyStatus(keyStatus.FoundToken);
      }
    } catch (e) {
      print("Token deoesn't exist $e");
    }

    print('token outside of getToken bracket: $token');
    return token;
  }

  Future storeToken(String token) async {
    if (token == null || token.isEmpty) {
      throw NullThrownError();
    } else {
      await storage.write(key: 'tokenKey', value: token);
      // updateKeyStatus(keyStatus.FoundToken);
    }
  }

  updateKeyStatus(keyStatus status) {
    _keyStat = status;
    print('current status: $_keyStat');
    notifyListeners();
  }

  Future<String> get userId async => await storage.read(key: 'userId');

  Future storeUserId(String userId) async {
    if (userId == null) {
      throw NullThrownError();
    } else {
      await storage.write(key: 'userId', value: userId);
    }
  }
}
