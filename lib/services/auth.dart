import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haggle_x/extras/store.dart';
import 'package:haggle_x/services/graphql_config.dart';
import 'package:haggle_x/services/mutations_queries.dart';
import 'package:provider/provider.dart';

enum Status { shouldVerify, ignoreVerification }

class Auth with ChangeNotifier {
  GraphQlConfig _graphQlConfig;
  MutationQuery _mutationQuery = MutationQuery();
  Status _status;
  KeyStore _keyStore = KeyStore();

  var storage = FlutterSecureStorage();

  Auth.instance(this._graphQlConfig, this._status);

  Status get status => _status;

  Future<String> createUser({
    @required String email,
    @required String username,
    @required String password,
    String referralCode,
    @required String phonenumber,
    @required String country,
    @required String currency,
    @required String callingcode,
    @required String flag,
  }) async {
    GraphQLClient _client = _graphQlConfig.qlClient();

    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(
          _mutationQuery.createUser(),
        ),
        variables: {
          'email': email,
          'username': username,
          'password': password,
          'phonenumber': phonenumber,
          'country': country,
          'currency': currency,
          'callingcode': callingcode,
          'flag': flag
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      print('Errors Code ${result.exception.graphqlErrors}');
    }

    // print(result.data.toString());
    else {
      // to store userId
      // await _keyStore.storeUserId(result.data['register']['user']['_id']);
      return result.data['register']['token'];
    }
  }

  // ignore: missing_return
  Future<String> login(String email, String password) async {
    GraphQLClient _client = _graphQlConfig.qlClient();

    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(
          _mutationQuery.login(),
        ),
        variables: {
          'email': email,
          'password': password,
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      print(
          'Errors Code ${result.exception.graphqlErrors[0].extensions['exception']['response']['statusCode']}');
    } else {
      // await _keyStore.storeUserId(userId);
      return result.data['login']['token'];
    }
  }

  // validate form and save
  bool validateAndSave(GlobalKey<FormState> formKey) {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // runs validateAndSave() and submits
  Future<void> validateAndLogin(GlobalKey<FormState> formKey, String email,
      String password, BuildContext context) async {
    // try {
    if (validateAndSave(formKey)) {
      String token = await login(email, password);
      print('Token is: $token');
      try {
        await _keyStore.storeToken(token);
        // This provider is just a temp fix. will correct later
        Provider.of<KeyStore>(context, listen: false)
            .updateKeyStatus(keyStatus.FoundToken);
      } catch (e) {
        print('Token is probably null: $e');
      }
    }
  }

  Future<void> validateAndCreateUser(
    GlobalKey<FormState> formKey,
    String email,
    String username,
    String password,
    String phonenumber,
    String country,
    String currency,
    String callingcode,
    String flag,
    BuildContext context,
  ) async {
    // try {
    if (validateAndSave(formKey)) {
      String token = await createUser(
        email: email,
        username: username,
        password: password,
        phonenumber: phonenumber,
        country: country,
        currency: currency,
        callingcode: callingcode,
        flag: flag,
      );
      print('Token is: $token');

      try {
        await _keyStore.storeToken(token);
        _status = Status.shouldVerify;
        notifyListeners();
      } catch (e) {
        print('Token is probably null: $e');
        _status = Status.ignoreVerification;
        notifyListeners();
      }
    }
  }

  updateStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  Future<List> getActiveCountries() async {
    GraphQLClient _client = _graphQlConfig.qlClientWithToken();

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(
          _mutationQuery.getActiveCountries(),
        ),
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      // print('Errors Code ${result.exception.graphqlErrors[0].extensions['exception']['response']['statusCode']}');
    } else
      print('The result of countries: ${result.data['getActiveCountries']}');
    return result.data['getActiveCountries'];
  }

  verifyUser(int verificationCode) async {
    GraphQLClient _client = _graphQlConfig.qlClientWithToken();
    bool isVerified = false;

    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(
          _mutationQuery.verifyUser(),
        ),
        variables: {
          'code': verificationCode,
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      // print('Errors Code ${result.exception.graphqlErrors[0].extensions['exception']['response']['statusCode']}');
      isVerified = false;
    } else {
      isVerified = true;
    }
    // print('The result of countries: ${result.data['getActiveCountries']}');
    return isVerified;
  }
}

/// "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDllY2FkMDk2YzUzYTAwMTU0YWFmNGIiLCJpYXQiOjE2MjEwMTkzNDUsImV4cCI6MTYyMTEwNTc0NX0.XVWE0yU-89Jrp_fg6MU1CYGGSU-qLZ3LH7PM1F6LWZM" */

class VerifyUser {}
