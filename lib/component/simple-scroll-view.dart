import 'package:flutter/material.dart';

class SimpleScrollView extends StatelessWidget {
  final Widget _child;
  final ScrollController? controller;
  SimpleScrollView(
      {Key? key, required Widget child, ScrollController? controller})
      : _child = child,
        this.controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        controller: this.controller,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight + 1,
          ),
          child: _child,
        ),
      ),
    );
  }
}
