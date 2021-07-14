import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogIllegalQrCode extends StatefulWidget {
  final String description;
  final String confirm;

  const DialogIllegalQrCode(
      {Key? key, required this.description, required this.confirm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogIllegalQrCode();
}

class _DialogIllegalQrCode extends State<DialogIllegalQrCode> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.confirm,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
