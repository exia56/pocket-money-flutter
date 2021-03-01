import 'package:flutter/material.dart';

typedef ChildBuilder = Widget Function();

abstract class StateWithOverlay<T extends StatefulWidget> extends State<T> {
  @protected
  OverlayEntry? _overly;

  @protected
  void showOverlay() {
    this._overly?.remove();
    this._overly = OverlayEntry(
        builder: (context) => Material(
              elevation: 4.0,
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
                child: childBuilder(),
              ),
            ));
    Overlay.of(context)?.insert(this._overly!);
  }

  @protected
  void hideOverlay() {
    this._overly?.remove();
  }

  @protected
  Widget childBuilder();
}
