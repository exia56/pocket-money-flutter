enum NamedRouter {
  signUp,
  signIn,
  splash,
  setting,
  main,
}

extension NamedRouterEX on NamedRouter {
  String get name {
    return this.toString().replaceAll(RegExp(r'NamedRouter\.'), '');
  }
}
