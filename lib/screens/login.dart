import 'package:flutter/material.dart';
import 'package:haggle_x/extras/app_colors.dart';
import 'package:haggle_x/extras/buttons.dart';
import 'package:haggle_x/extras/store.dart';
import 'package:haggle_x/extras/validators.dart';
import 'package:haggle_x/extras/widgets.dart';
import 'package:haggle_x/screens/create_user.dart';
import 'package:haggle_x/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  KeyStore store;

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {

    //
    return Consumer<Auth>(builder: (context, auth, _) {

      //
      return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        backgroundColor: AppColors.purple,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.h, right: 4.0.h, top: 20.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.0.h),
                    child: WelcomeText(),
                  ),

                  //
                  _buildForm(),

                  //
                  Button.plain(
                    context: context,
                    buttonColor: AppColors.brown,
                    buttonTextColor: Colors.black,
                    buttonText: "Log In",
                    width: double.infinity,

                    //
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        // context
                        //     .read<Auth>()
                        //     .validateAndSubmit(formKey, _email, _password);
                        await auth.validateAndLogin(
                            formKey, _email, _password, context);
                      }
                    },
                  ),

                  //
                  SizedBox(height: 3.0.h),

                  //
                  Center(
                    child: BottomText(
                      firstText: 'New User',
                      secondText: 'Create a new account',

                      onPressed: () {

                        //
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CreateUserScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    // child:
  }

  Form _buildForm() {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          children: [

            //
            TextInputField(
              labelText: 'Email Address',
              validator: EmailFieldValidator.validate,
              onSaved: (String value) => _email = value,
              borderSideColor: Colors.white,
              textColor: Colors.white,
            ),

            //
            TextInputField(
              labelText: 'Password  Min: 8 characters',
              shouldObscureText: true,
              validator: PasswordFieldValidator.validate,
              onSaved: (String value) => _password = value,
              borderSideColor: Colors.white,
              textColor: Colors.white,
            ),

            //
            SizedBox(height: 3.0.h),

            //
            Align(
              child: Text(
                'Forgot password?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              alignment: Alignment.centerRight,
            ),

            //
            SizedBox(height: 5.0.h),
          ],
        ),
      ),
    );
  }

  void _goto() {
    // This updates Status to NewUser so it can move to the SignUpScreen
    Provider.of<KeyStore>(context, listen: false)
        .updateKeyStatus(keyStatus.FoundToken);
  }
}
