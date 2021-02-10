import 'dart:math';

const _pool = 'abcdefghijklmnopqrstuvwxyz0987654321ABCDEFGHIJKLMNOPQRSTUVWXYZ';

String randomString(int length) {
  final _rnd = Random(DateTime.now().millisecondsSinceEpoch);
  return String.fromCharCodes(
    Iterable<int>.generate(
      length,
      (i) => _pool.codeUnitAt(_rnd.nextInt(_pool.length)),
    ),
  );
}
