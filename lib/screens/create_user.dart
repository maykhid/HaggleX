import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haggle_x/extras/app_colors.dart';
import 'package:haggle_x/extras/buttons.dart';
import 'package:haggle_x/extras/validators.dart';
import 'package:haggle_x/extras/widgets.dart';
import 'package:haggle_x/main.dart';
import 'package:haggle_x/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CreateUserScreen extends StatefulWidget {
  final String currency, callingCode, flag, country;
  CreateUserScreen({this.currency, this.callingCode, this.flag, this.country});
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _phonenumber;
  String _username;
  int _verificationCode;

  final networkSvg = SvgPicture.network(
    'https://restcountries.eu/data/nga.svg',
    placeholderBuilder: (BuildContext context) => Container(
      padding: const EdgeInsets.all(30.0),
      child: const CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var verificationStatus = Provider.of<Auth>(context);
    
    //
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.purple,
        //
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 2.0.h, right: 2.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon button
                  buildAboveScreenIcon(),

                  (verificationStatus.status == Status.ignoreVerification)
                      ? _buildRegContainer() // registration container
                      : _verifyContainer(context), // verify card
                ],
              ),
            ),
          ),
        ));
  }

  AboveScreenIcon buildAboveScreenIcon() => AboveScreenIcon();

  Container _verifyContainer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 2.0.h,
              bottom: 4.0.h,
              left: 8.0.w,
            ),
            child: Text(
              'Verify your account',
              style: TextStyle(
                fontSize: 3.5.h,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // main card content
          Container(
            padding: EdgeInsets.only(
              bottom: 3.0.h,
              top: 1.0.h,
              left: 5.5.h,
              right: 5.5.h,
            ),
            height: 65.0.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5.0.h),

                // check icon
                Icon(
                  Icons.check_circle,
                  color: AppColors.purple.withOpacity(0.8),
                  size: 8.0.h,
                ),

                SizedBox(height: 5.0.h),

                // verify text
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text:
                            'We just a sent verification code to your email \n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8.0.sp,
                          fontFamily: 'OpenSans',
                          // fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Please enter the code',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8.0.sp,
                            ),
                          ),
                        ]),
                  ),
                ),

                SizedBox(height: 5.0.h),

                // verify code
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0.h),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'Verification code',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 2.0.h,
                        ),
                      ),
                      validator: PinValidator.validate,
                      onSaved: (String value) =>
                          _verificationCode = int.parse(value),
                      // color: Colors.black,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                ),

                // verify button
                Button.plain(
                    context: context,
                    buttonColor: AppColors.purple,
                    buttonTextColor: Colors.white,
                    buttonText: "Verify me".toUpperCase(),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();

                        Provider.of<Auth>(context, listen: false)
                            .verifyUser(_verificationCode);

                        print('onClick verify $_verificationCode');
                      }
                    }),

                SizedBox(
                  height: 5.0.h,
                ),

                Text(
                  'This code expire in 10 minutes',
                  style: TextStyle(color: Colors.black),
                ),

                SizedBox(
                  height: 5.0.h,
                ),

                Text(
                  'Resend Code',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontSize: 2.0.h,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildRegContainer() {

    String currency = widget.currency;
    String callingCode = widget.callingCode;
    String flag = widget.flag;
    String country = widget.country;

    return Form(
      key: formKey,

      //
      child: Container(
        padding: EdgeInsets.only(
          left: 6.0.w,
          bottom: 3.0.h,
          top: 2.0.h,
          right: 6.0.w,
        ),
        height: 82.0.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),

        //
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.0.h, bottom: 4.0.h),
              child: Text(
                'Create a new account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.5.h,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            //
            TextInputField(
              labelText: 'Email Address',
              validator: EmailFieldValidator.validate,
              onSaved: (String value) => _email = value,
              textColor: Colors.black,
              borderSideColor: Colors.black,
              useDefaultColor: false,
            ),

            //
            TextInputField(
              labelText: 'Password  Max: 8 characters',
              shouldObscureText: true,
              validator: PasswordFieldValidator.validate,
              onSaved: (String value) => _password = value,
              textColor: Colors.black,
              borderSideColor: Colors.black,
              useDefaultColor: false,
            ),

            //
            TextInputField(
              labelText: 'Create a username',
              validator: Username.validate,
              onSaved: (String value) => _username = value,
              textColor: Colors.black,
              borderSideColor: Colors.black,
              useDefaultColor: false,
            ),

            // phone number - country container
            Container(
              child: Row(
                children: [
                  // flag country code holder
                  FlagAndCountryCode(networkSvg: getLinkSvg(flag), callingCode: callingCode),

                  SizedBox(
                    width: 1.0.w,
                  ),

                  Expanded(
                    child: TextInputField(
                      labelText: 'Enter your phone number',
                      validator: MobileValidator.validate,
                      onSaved: (String value) => _phonenumber = value,
                      textColor: Colors.black,
                      borderSideColor: Colors.black,
                      useDefaultColor: false,
                    ),
                  ),
                ],
              ),
            ),

            //
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Referral code (optional)',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 2.0.h,
                ),
              ),
              // validator: Username.validate,
              // onSaved: (String value) => _password = value,
              // color: Colors.black,
            ),

            //
            SizedBox(
              height: 4.0.h,
            ),

            //
            Center(
              child: Text(
                'By signing in, you agree to HaggleX terms and privacy policy',
                style: TextStyle(color: Colors.black),
              ),
            ),

            //
            SizedBox(
              height: 5.0.h,
            ),

            //
            Center(
              child: Button.plain(
                context: context,
                buttonColor: AppColors.purple,
                buttonTextColor: Colors.white,
                buttonText: "Sign Up",
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();

                    await Provider.of<Auth>(context, listen: false)
                        .validateAndCreateUser(
                      formKey,
                      _email,
                      _username,
                      _password,
                      _phonenumber,
                      country,
                      currency,
                      callingCode,
                      flag,
                      context,
                    );
                    // Provider.of<Auth>(context, listen: false)
                    //     .updateStatus(Status.shouldVerify);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class async {}
