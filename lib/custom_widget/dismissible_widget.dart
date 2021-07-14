import 'package:flutter/material.dart';
import 'package:report1922/model/place_model.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final Place item;
  final Widget child;
  final DismissDirectionCallback onDismissed;
  final ConfirmDismissCallback confirmDismiss;
  final String textEdit;
  final String textDelete;

  const DismissibleWidget({
    Key? key,
    required this.item,
    required this.child,
    required this.onDismissed,
    required this.confirmDismiss,
    required this.textEdit,
    required this.textDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dismissible(
        key: Key(item.id.toString()),
        background: buildSwipeActionLeft(),
        secondaryBackground: buildSwipeActionRight(),
        child: child,
        onDismissed: onDismissed,
        confirmDismiss: confirmDismiss,
      );

  Widget buildSwipeActionLeft() => Container(
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.green,
            child: Icon(Icons.edit, color: Colors.white, size: 40),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              textEdit,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            color: Colors.green,
          )
        ],
      ));

  Widget buildSwipeActionRight() => Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.red,
              child: Icon(Icons.delete_forever, color: Colors.white, size: 40),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                textDelete,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Colors.red,
            )
          ],
        ),
      );
}
