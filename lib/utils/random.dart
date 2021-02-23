import 'dart:math';

const _pool = 'abcdefghijklmnopqrstuvwxyz0987654321ABCDEFGHIJKLMNOPQRSTUVWXYZ';

final _rnd = Random.secure();

String randomString(int length) {
  return String.fromCharCodes(
    Iterable<int>.generate(
      length,
      (i) => _pool.codeUnitAt(_rnd.nextInt(_pool.length)),
    ),
  );
}

int randomInt(int max) {
  return _rnd.nextInt(max);
}
