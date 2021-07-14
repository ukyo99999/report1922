import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report1922/model/place_model.dart';
import 'package:report1922/util/input_formatter_4_digit_space.dart';
import 'package:report1922/util/view_util.dart';

class DialogModifyFavoritePlace extends StatefulWidget {
  final String title;
  final String placeName;
  final String placeCode;
  final String confirm;
  final String cancel;

  const DialogModifyFavoritePlace(
      {Key? key,
      required this.title,
      required this.confirm,
      required this.placeName,
      required this.placeCode,
      required this.cancel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogModifyFavoritePlace();
}

class _DialogModifyFavoritePlace extends State<DialogModifyFavoritePlace> {
  late TextEditingController _controllerPlaceName;
  late TextEditingController _controllerPlaceCode;

  @override
  void initState() {
    super.initState();
    _controllerPlaceName = TextEditingController(text: widget.placeName);
    _controllerPlaceCode = TextEditingController(text: widget.placeCode);
  }

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
            TextField(
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
                        .edit_favorite_place_dialog_place_code,
                    hintText: AppLocalizations.of(context)!
                        .edit_favorite_place_dialog_place_code_hint)),
            SizedBox(
              height: 15,
            ),
            TextField(
                controller: _controllerPlaceName,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: Icon(Icons.receipt_long),
                    labelText: AppLocalizations.of(context)!
                        .edit_favorite_place_dialog_place_name,
                    hintText: AppLocalizations.of(context)!
                        .edit_favorite_place_dialog_place_name_hint)),
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
    } else if (_controllerPlaceName.text.isEmpty) {
      ViewUtil.showSnackBar(
          context, AppLocalizations.of(context)!.error_input_place_name);
    } else {
      ViewUtil.cleanSnackBar(context);
      Navigator.pop(
          context,
          Place(
              id: 0,
              name: _controllerPlaceName.text,
              code: _controllerPlaceCode.text,
              position: 0));
    }
  }
}
