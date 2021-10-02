import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:report1922/custom_widget/dialog_add_favorite_place.dart';
import 'package:report1922/custom_widget/dialog_confirm_send_sms.dart';
import 'package:report1922/custom_widget/dialog_illegal_qr_code.dart';
import 'package:report1922/custom_widget/dialog_modify_favorite_place.dart';
import 'package:report1922/custom_widget/dismissible_widget.dart';
import 'package:report1922/model/place_model.dart';
import 'package:report1922/util/view_util.dart';

import '../util/database_handler.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePage createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  late DatabaseHandler dbHandler;
  late Future<List<Place>> _listOfPlaces;
  int itemNumbers = 0;
  List<String> phoneNumbers = ["1922"];

  @override
  void initState() {
    super.initState();
    this.dbHandler = DatabaseHandler();
    this._listOfPlaces = getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String noFavoritePlace =
        AppLocalizations.of(context)!.no_favorite_place;
    final String noFavoritePlaceAdd1 =
        AppLocalizations.of(context)!.no_favorite_place_add_1;
    final String noFavoritePlaceAdd2 =
        AppLocalizations.of(context)!.no_favorite_place_add_2;
    final String noFavoritePlaceAdd3 =
        AppLocalizations.of(context)!.no_favorite_place_add_3;

    final String deleteFavoritePlaceDialogTitle =
        AppLocalizations.of(context)!.delete_favorite_place_dialog_title;
    final String deleteFavoritePlaceDialogMessage =
        AppLocalizations.of(context)!.delete_favorite_place_dialog_message;
    final String deleteFavoritePlaceDialogConfirm =
        AppLocalizations.of(context)!.delete_favorite_place_dialog_confirm;
    final String deleteFavoritePlaceDialogCancel =
        AppLocalizations.of(context)!.delete_favorite_place_dialog_cancel;

    final String dismissibleEdit =
        AppLocalizations.of(context)!.dismissible_edit;
    final String dismissibleDelete =
        AppLocalizations.of(context)!.dismissible_delete;

    final String placeCodeDeleted =
        AppLocalizations.of(context)!.place_code_has_been_deleted;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.app_title),
          ),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                child: FutureBuilder(
                  future: _listOfPlaces,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Place>> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else if (snapshot.hasData && snapshot.data!.length > 0) {
                      return ReorderableListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            return DismissibleWidget(
                              key: Key(item.id.toString()),
                              item: item,
                              child: buildListTile(item),
                              onDismissed: (direction) => {
                                dismissItem(context, index, item, direction,
                                    placeCodeDeleted),
                                if (direction == DismissDirection.endToStart)
                                  setState(() {
                                    snapshot.data?.removeAt(index);
                                  })
                              },
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          deleteFavoritePlaceDialogTitle,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                            deleteFavoritePlaceDialogMessage,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87)),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () => {
                                                    Navigator.of(context)
                                                        .pop(true),
                                                  },
                                              child: Text(
                                                  deleteFavoritePlaceDialogConfirm,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.red))),
                                          TextButton(
                                            onPressed: () => {
                                              Navigator.of(context).pop(false),
                                            },
                                            child: Text(
                                                deleteFavoritePlaceDialogCancel,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                if (direction == DismissDirection.startToEnd) {
                                  _showModifyFavoritePlaceDialog(
                                      context, item, index);
                                  return false;
                                }
                              },
                              textDelete: dismissibleDelete,
                              textEdit: dismissibleEdit,
                            );
                          },
                          itemCount: snapshot.data!.length,
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final item = snapshot.data!.removeAt(oldIndex);
                              snapshot.data?.insert(newIndex, item);
                              _reorderUpdateDbIndex(snapshot.data!);
                            });
                          });
                    } else {
                      return emptyPage(
                          context,
                          noFavoritePlace,
                          noFavoritePlaceAdd1,
                          noFavoritePlaceAdd2,
                          noFavoritePlaceAdd3);
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                child: Container(
                  width: size.width,
                  height: 80,
                  child: Stack(
                    children: [
                      Center(
                        child: FloatingActionButton.extended(
                          icon: Icon(
                            Icons.qr_code_scanner_outlined,
                            size: 32,
                          ),
                          onPressed: () {
                            scanQR();
                          },
                          label: Text(
                            AppLocalizations.of(context)!.scan_to_report,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  right: size.width * 0.03,
                  top: size.height * 0.65,
                  child: FloatingActionButton(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.add),
                    onPressed: () {
                      _showAddFavoritePlaceDialog(context);
                    },
                  ))
            ],
          )),
    );
  }

  Widget emptyPage(
      BuildContext context,
      String noFavoritePlace,
      String noFavoritePlaceAdd1,
      String noFavoritePlaceAdd2,
      String noFavoritePlaceAdd3) {
    return ListView(
      children: [
        Container(
          height: 40,
        ),
        Icon(
          Icons.announcement,
          size: 200,
          color: Colors.blueGrey,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Text(
            noFavoritePlace,
            textAlign: TextAlign.center,
            // style: TextStyle(fontSize: 32,color: Colors.blueGrey),
            style:
                TextStyle(fontSize: 32, color: Color.fromARGB(255, 43, 64, 74)),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 22, 40, 0),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: noFavoritePlaceAdd1,
                  style: TextStyle(
                      color: Color.fromARGB(255, 43, 64, 74), fontSize: 24)),
              WidgetSpan(
                  child: Icon(
                Icons.add_circle,
                color: Colors.teal,
                size: 26,
              )),
              TextSpan(
                  text: noFavoritePlaceAdd2,
                  style: TextStyle(
                      color: Color.fromARGB(255, 43, 64, 74), fontSize: 24)),
            ]),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(40, 8, 40, 0),
            child: RichText(
                text: TextSpan(
              text: noFavoritePlaceAdd3,
              style: TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 43, 64, 74)),
            )))
      ],
    );
  }

  void dismissItem(BuildContext context, int index, Place item,
      DismissDirection direction, String textDelete) async {
    switch (direction) {
      case DismissDirection.endToStart:
        await this.dbHandler.delete(item.id);
        ViewUtil.showSnackBar(context, textDelete);
        break;
      default:
        break;
    }
  }

  Widget buildListTile(Place place) => Card(
      elevation: 3,
      child: ListTile(
        onTap: () => {_showConfirmSendSmsDialog(context, place)},
        contentPadding: EdgeInsets.all(8.0),
        title: Text(
          place.name,
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
        subtitle: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.teal,
                ),
                Padding(
                  child: Text(
                    place.code.toString(),
                    style: TextStyle(fontSize: 15, color: Colors.teal),
                  ),
                  padding: EdgeInsets.only(left: 6),
                ),
              ],
            )),
      ));

  _addPlace(Place place) async {
    await addPlace(place);
    setState(() {
      _listOfPlaces = getPlaces();
    });
  }

  Future<void> addPlace(Place place) async {
    await DatabaseHandler().insert(place);
  }

  _modifyPlace(Place place) async {
    await modifyPlace(place);
    setState(() {
      _listOfPlaces = getPlaces();
    });
  }

  Future<void> modifyPlace(Place place) async {
    await DatabaseHandler().update(place);
  }

  void _reorderUpdateDbIndex(List<Place> list) {
    for (int i = 0; i < list.length; i++) {
      Place place = Place(
          id: list[i].id, name: list[i].name, code: list[i].code, position: i);
      _modifyPlacePosition(place);
    }
  }

  _modifyPlacePosition(Place place) async {
    await modifyPlacePosition(place);
  }

  Future<void> modifyPlacePosition(Place place) async {
    await DatabaseHandler().updateIndex(place);
  }

  Future<List<Place>> getPlaces() async {
    List<Place> places = await this.dbHandler.getList();
    itemNumbers = places.length;
    return places;
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', '', true, ScanMode.QR);
      print("scanQR() scaned code=>" + barcodeScanRes);
      _verifyCode(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

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
      var message = code.replaceAll(regExp, "");
      print("message=>$message");

      _sendSMS(message);
    }
  }

  Future<void> _sendSMS(String message) async {
    try {
      print("message=>$message");
      await sendSMS(message: message, recipients: phoneNumbers);
    } catch (error, stacktrace) {
      print("Send SMS Error:" + error.toString());
    }
  }

  Future<void> _tapSendSms(String placeCode) async {
    var message = "場所代碼：" + placeCode + "\n本簡訊是簡訊實聯制發送，限防疫目的使用。";
    try {
      await sendSMS(message: message, recipients: phoneNumbers);
    } catch (error, stacktrace) {
      print("Send SMS Error:" + error.toString());
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
            ));
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _showAddFavoritePlaceDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogAddFavoritePlace(
            title:
                AppLocalizations.of(context)!.add_favorite_place_dialog_title,
            confirm:
                AppLocalizations.of(context)!.add_favorite_place_dialog_confirm,
            cancel: AppLocalizations.of(context)!
                .add_favorite_place_dialog_cancel)).then((value) {
      if (value != null) {
        Place place = Place(
          id: DateTime.now().millisecondsSinceEpoch,
          name: value.name,
          code: value.code,
          position: itemNumbers,
        );
        _addPlace(place);
      }
    });
  }

  _showModifyFavoritePlaceDialog(
      BuildContext context, Place item, int index) async {
    Place? place = await this.dbHandler.select(item.id);

    if (place != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => DialogModifyFavoritePlace(
              title: AppLocalizations.of(context)!
                  .edit_favorite_place_dialog_title,
              placeName: place.name,
              placeCode: place.code,
              confirm: AppLocalizations.of(context)!
                  .edit_favorite_place_dialog_confirm,
              cancel: AppLocalizations.of(context)!
                  .edit_favorite_place_dialog_cancel)).then((value) {
        if (value != null) {
          Place place = Place(
            id: item.id,
            name: value.name,
            code: value.code,
            position: index,
          );
          _modifyPlace(place);
        }
      });
    }
  }

  _showConfirmSendSmsDialog(BuildContext context, Place place) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogConfirmSendSms(
              title: AppLocalizations.of(context)!.send_sms_dialog_title,
              placeName: place.name,
              confirm: AppLocalizations.of(context)!.send_sms_dialog_confirm,
              cancel: AppLocalizations.of(context)!.send_sms_dialog_cancel,
            )).then((value) {
      if (value != null && value == true) {
        print("_showConfirmSendSmsDialog true");
        _tapSendSms(place.code);
      }
    });
  }
}
