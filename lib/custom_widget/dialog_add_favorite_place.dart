import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report1922/model/place_model.dart';
import 'package:report1922/util/input_formatter_4_digit_space.dart';
import 'package:report1922/util/view_util.dart';

import 'dialog_illegal_qr_code.dart';

class DialogAddFavoritePlace extends StatefulWidget {
  final String title;
  final String confirm;
  final String cancel;

  const DialogAddFavoritePlace(
      {Key? key,
      required this.title,
      required this.confirm,
      required this.cancel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogAddFavoritePlace();
}

class _DialogAddFavoritePlace extends State<DialogAddFavoritePlace> {
  TextEditingController _controllerPlaceTitle = TextEditingController();
  TextEditingController _controllerPlaceCode = TextEditingController();

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
            Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: _controllerPlaceCode,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        new InputFormatter4DigitSpace()
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          prefixIcon: Icon(Icons.location_on),
                          labelText: AppLocalizations.of(context)!
                              .add_favorite_place_dialog_place_code,
                          hintText: AppLocalizations.of(context)!
                              .add_favorite_place_dialog_place_code_hint)),
                ),
                Container(
                  padding: const EdgeInsets.all(0.0),
                  width: 30.0,
                  child: IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      print("掃QR code");
                      scanQR();
                    },
                  ),
                ), // Icon(Icons.qr_code_scanner)
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                controller: _controllerPlaceTitle,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: Icon(Icons.receipt_long),
                    labelText: AppLocalizations.of(context)!
                        .add_favorite_place_dialog_place_name,
                    hintText: AppLocalizations.of(context)!
                        .add_favorite_place_dialog_place_name_hint)),
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
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
                        checkTextField(context);
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

  void checkTextField(BuildContext context) {
    if (_controllerPlaceCode.text.isEmpty) {
      ViewUtil.showSnackBar(
          context, AppLocalizations.of(context)!.error_input_place_code);
    } else if (_controllerPlaceTitle.text.isEmpty) {
      ViewUtil.showSnackBar(
          context, AppLocalizations.of(context)!.error_input_place_name);
    } else {
      ViewUtil.cleanSnackBar(context);
      Navigator.pop(
          context,
          Place(
            id: 0,
            name: _controllerPlaceTitle.text,
            code: _controllerPlaceCode.text,
            position: 0,
          ));
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', '', true, ScanMode.QR);
      print("scanQR() scaned code=>" + barcodeScanRes);
      _verifyCode(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  _verifyCode(String code) {
    if (code == "-1") {
      return;
    }
    RegExp regExp = RegExp("SMSTO:1922:", caseSensitive: false);

    if (!code.startsWith(regExp)) {
      _showIllegalQrCodeDialog();
    } else {
      _controllerPlaceCode.text = _getPlaceCode(code);
    }
  }

  _showIllegalQrCodeDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => DialogIllegalQrCode(
              description:
                  AppLocalizations.of(context)!.illegal_qrcode_dialog_title,
              confirm:
                  AppLocalizations.of(context)!.illegal_qrcode_dialog_confirm,
            )).then((value) => {
          // enableScan = true
        });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  String _getPlaceCode(code) {
    RegExp regExp = RegExp("SMSTO:1922:場所代碼：", caseSensitive: false);
    String placeCode = code.replaceAll(regExp, "");
    return placeCode.split("\n")[0];
  }
}
