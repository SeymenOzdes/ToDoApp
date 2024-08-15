import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator {
  static OverlayEntry? _overlayEntry;
  final BuildContext context;

  LoadingIndicator(
    this.context,
  );

  void show() {
    if (_overlayEntry != null) {
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        child: Material(
          color: Colors.black45,
          child: Center(
            child: SpinKitRing(
              color: Colors.white,
              size: 75,
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    if (_overlayEntry == null) {
      return;
    }

    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
