import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogConfirmSendSms extends StatefulWidget {
  final String title;
  final String placeName;
  final String confirm;
  final String cancel;

  const DialogConfirmSendSms(
      {Key? key,
      required this.title,
      required this.placeName,
      required this.confirm,
      required this.cancel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogConfirmSendSms();
}

class _DialogConfirmSendSms extends State<DialogConfirmSendSms> {
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
    return Wrap(children: [
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
              widget.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              AppLocalizations.of(context)!.send_sms_dialog_message +
                  widget.placeName,
              style: TextStyle(fontSize: 18),
              // textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        print("DialogConfirmSendSms 取消傳送SMS");
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        widget.cancel,
                        style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                      )),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        print("DialogConfirmSendSms 確認傳送SMS");
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        widget.confirm,
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}
