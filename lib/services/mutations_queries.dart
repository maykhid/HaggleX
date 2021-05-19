import 'package:flutter/foundation.dart';

class MutationQuery {
  String createUser() {
    return """ 
  mutation(
  \$email: String!
  \$username: String!
  \$password: String!
  \$phonenumber: String!
  \$country: String!
  \$currency: String!
  \$flag: String!
  \$callingcode: String!
) {
  register(
    data: {
      email: \$email
      username: \$username
      password: \$password
      phonenumber: \$phonenumber
      phoneNumberDetails: {
        phoneNumber: \$phonenumber
        callingCode: \$callingcode
        flag: \$flag
      }
      country: \$country
      currency: \$currency
    }
  ) {
    user {
      _id
      username
      email
    }
    token
  }
}
     
    """;
  }

  String login() {
    return """ 
    mutation(\$email: String!, \$password: String!) {
    login(data: { input: \$email, password: \$password }) {
    user {
      _id
      username
      phonenumber
      emailVerified
     }
    token
    twoFactorAuth
  }
} 
    """;
  }

  String verifyUser(int code) {
    return """
    mutation ($code: Int!){
    verifyUser(data: {code: $code}){
    user{
      _id
      email
      username
    }
  }
}
    """;
  }

  String getActiveCountries() {
    return """
  query {
  getActiveCountries{
    _id
    name
    callingCode
    region
    flag
    currencyDetails {
      code
      name
      symbol
    }
  }
}
    """;
  }

  String resendVerificationCode(String email) {
    return """
    query ($email: String!){
    resendVerificationCode(data: {email: $email})
  }
    """;
  }

  String getUser(String userId) {
    return """

    """;
  }
}
