import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haggle_x/extras/store.dart';

class GraphQlConfig {
  Link link;
  KeyStore _keyStore = KeyStore();

  static HttpLink httpLink =
      HttpLink("https://hagglex-backend-staging.herokuapp.com/graphql");

  AuthLink getToken() {
    AuthLink authLink = AuthLink(
        getToken: () async => 'Bearer ${await _keyStore.retrieveToken}');
    return authLink;
  }

  Link _link;

  GraphQlConfig() {
    _link = getToken().concat(httpLink);
  }

  // String createLink(String token) {
  //   if (token != null && token.isNotEmpty) {
  //     final AuthLink authLink = AuthLink(
  //       getToken: () => 'Bearer $token',
  //     );
  //     link = authLink.concat(httpLink);
  //   } else {
  //     link = httpLink;
  //   }
  // }

  // Future<bool> tokenExists() async {
  //   String token = await _keyStore.retrieveToken;
  //   if (token != null) {
  //     return Future<bool>.value(true);
  //   }
  //   return Future<bool>.value(false);
  // }

  // Future<Link> buildLink() async {
  //   // try {
  //   String token = await _keyStore.retrieveToken;
  //   if (token != null && token.isNotEmpty) {
  //     final AuthLink authLink = AuthLink(getToken: () => 'Bearer $token');

  //     return link = authLink.concat(httpLink);
  //   }
  //   // } catch {

  //   // }
  //   else {
  //     return link = httpLink;
  //   }
  // }

  // isTokenAvailable() async {
  //   bool tokenExist = await tokenExists();
  //   return tokenExist ? _link : httpLink;
  // }

  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: HiveStore()),
  ));

  GraphQLClient qlClient() {
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    );
  }

  /// Ideally this should have been dynamic
  /// i.e change url based on availability of token,
  /// but i have done them separately (statically).
  /// Would work on it later. So this is temporary
  GraphQLClient qlClientWithToken() {
    return GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: HiveStore()),
    );
  }
}
