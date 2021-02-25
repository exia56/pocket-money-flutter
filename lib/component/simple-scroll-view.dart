import 'package:flutter/material.dart';

class SimpleScrollView extends StatelessWidget {
  final Widget _child;
  SimpleScrollView({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: _child,
        ),
      ),
    );
  }
}
