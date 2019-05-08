import 'package:flutter/material.dart';

import 'package:core/core.dart';

class CGButton extends StatelessWidget {
  CGButton({
    @required this.onPressed,
    @required this.text,
    this.icon,
    this.primary = false,
    this.loading = false,
    this.customColor,
  });
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final bool primary, loading;
  final Color customColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        padding: const EdgeInsets.all(14.0),
        onPressed: onPressed,
        child: loading
            ? Container(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        primary ? Colors.white : Colors.black54)))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  icon != null ? Icon(icon) : Container(),
                  Padding(
                    padding: EdgeInsets.only(left: icon != null ? 12.0 : 0.0),
                    child: Text(text),
                  ),
                ],
              ),
        color: customColor != null
            ? customColor
            : primary ? Theme.of(context).primaryColor : Color(lightGray.asInt),
        textColor: primary ? Colors.white : Colors.black54,
      ),
    );
  }
}
