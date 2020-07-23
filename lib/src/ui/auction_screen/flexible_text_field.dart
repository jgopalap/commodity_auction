import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlexibleTextField extends StatefulWidget {
  final double minWidth;
  final TextEditingController controller;

  const FlexibleTextField({
    Key key,
    this.controller,
    this.minWidth: 30,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new FlexibleTextFieldState();
}

class FlexibleTextFieldState extends State<FlexibleTextField> {
  // 2.0 is the default from TextField class
  static const _CURSOR_WIDTH = 2.0;
  final myController = TextEditingController();
  // We will use this text style for the TextPainter used to calculate the width
  // and for the TextField so that we calculate the correct size for the text
  // we are actually displaying
  TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 40,
  );

  @override
  Widget build(BuildContext context) {
    // TextField merges given textStyle with text style from current theme
    // Do the same to get final TextStyle
    //final ThemeData themeData = Theme.of(context);
    //final TextStyle style = themeData.textTheme.subtitle1.merge(textStyle);
    final TextStyle style = textStyle;

    // Use TextPainter to calculate the width of our text
    //TextSpan ts = new TextSpan(style: style, text: widget.controller.text);
    /*TextPainter tp = new TextPainter(
      text: ts,
      textDirection: TextDirection.ltr,
    );
    tp.layout();*/

    // Enforce a minimum width
    //final textWidth = max(widget.minWidth, tp.width + _CURSOR_WIDTH);

    return Container(
      //width: textWidth,
      child: TextFormField(
        maxLength: 4,
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
      inputFormatters: [WhitelistingTextInputFormatter(
          RegExp(r'^[0-9]+\.?[0-9]?[0-9]?$'))],
      cursorColor: Colors.black,
      //textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      //cursorWidth: _CURSOR_WIDTH,
      style: style,
      controller: widget.controller
      ),
    );
  }
}