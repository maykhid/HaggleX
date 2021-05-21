import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class TextInputField extends StatelessWidget {
  final String labelText;
  final FormFieldValidator<String> validator;
  final bool shouldObscureText;
  final FormFieldSetter<String> onSaved;
  final Color borderSideColor;
  final Color textColor;
  final bool useDefaultColor;
  TextInputField(
      {@required this.labelText,
      this.validator,
      this.shouldObscureText = false,
      this.useDefaultColor = true,
      this.onSaved,
      this.textColor,
      this.borderSideColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0.h),
      child: TextFormField(
        decoration: _getTextFieldDeco(
          labelText: labelText,
          borderSideColor: borderSideColor,
          textColor: textColor,
        ),
        style: useDefaultColor ? null : TextStyle(color: textColor),
        validator: validator,
        obscureText: shouldObscureText,
        onSaved: onSaved,
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome!',
      style: TextStyle(
          color: Colors.white, fontSize: 5.0.h, fontWeight: FontWeight.w600),
    );
  }
}

InputDecoration _getTextFieldDeco(
    {String labelText, Color borderSideColor, Color textColor}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: textColor,
      fontSize: 2.0.h,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderSideColor,
      ),
    ),
    // focusColor: Colors.black,
    // hoverColor: Colors.black,
    // disabledBorder: InputBorder()
  );
}

class BottomText extends StatefulWidget {
  final String firstText, secondText;
  final Function onPressed;
  BottomText({
    @required this.firstText,
    @required this.secondText,
    this.onPressed,
  });
  @override
  _BottomTextState createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {
  TapGestureRecognizer _tapRecognizer;
  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()..onTap = widget.onPressed;
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
            text: '${widget.firstText}?  ',
            style: TextStyle(color: Colors.white, fontSize: 8.0.sp),
            children: [
              TextSpan(
                  text: '${widget.secondText} ',
                  style: TextStyle(color: Colors.white),
                  recognizer: _tapRecognizer),
            ]),
      ),
    );
  }
}

// Icon above screen
class AboveScreenIcon extends StatelessWidget {
  const AboveScreenIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 6.0.w, right: 6.0.h, top: 2.0.h, bottom: 3.0.h),
      child: Container(
        height: 4.5.h,
        width: 10.0.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.all(
            Radius.circular(24.0),
          ),
        ),
        child: IconButton(
          // padding and constraints prpperty help remove default padding
          // in IconButton
          padding: EdgeInsets.only(left: 1.5.w),
          constraints: BoxConstraints(),
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
      ),
    );
  }
}

class FlagContainer extends StatelessWidget {
  const FlagContainer({
    Key key,
    @required this.networkSvg,
  }) : super(key: key);

  final SvgPicture networkSvg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      // color: Colors.black,
      child: networkSvg,
    );
  }
}

class FlagAndCountryCode extends StatelessWidget {
  const FlagAndCountryCode({
    Key key,
    @required this.networkSvg,
    @required this.callingCode,
  }) : super(key: key);

  final SvgPicture networkSvg;
  final String callingCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(3.0),
        ),
        border: Border.all(color: Colors.black, width: 0.5),
      ),

      // flag - country code container
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // flag
          FlagContainer(networkSvg: networkSvg),

          // country code
          Text(
            '(+$callingCode)',
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      )),
    );
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 5.0.h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.white.withOpacity(0.2),
      ),
      //
      child: Row(
        children: [
          //
          SizedBox(
            width: 2.5.h,
          ),
          //
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 2.5.h, bottom: 1.5.h),
                border: InputBorder.none,
                // focusedBorder: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // errorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
                hintText: "Search for country",
              ),
            ),
          ),

          SizedBox(
            width: 10.0.w,
            child: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
