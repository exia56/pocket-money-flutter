class DependencyNotFoundException implements Exception {
  final String key;

  DependencyNotFoundException(this.key);

  @override
  String toString() {
    final errorString = 'DependencyNotFoundException: ${key} key is not found';
    return '$errorString\n${super.toString()}';
  }
}

class DependencyTypeNotMatchException implements Exception {
  final String key;
  final Type expectType;
  final Type genericType;

  DependencyTypeNotMatchException(this.key, this.genericType, this.expectType);

  @override
  String toString() {
    final errorString =
        'DependencyTypeNotMatchException: ${key} is expected as $expectType type, but really is $genericType';
    return '$errorString\n${super.toString()}';
  }
}

class _DIMapValue {
  final List<String> dependencyList;
  final Map<String, String> dependencyNamed;
  final dynamic builder;
  final Type type;
  final bool alwaysNew;
  _DIMapValue(
    this.builder,
    this.dependencyList,
    this.dependencyNamed,
    this.type,
    this.alwaysNew,
  );
}

class DI {
  static DI _instance;

  static DI get instance {
    _instance ??= DI._();
    return _instance;
  }

  DI._();

  factory DI.newInstance() => DI._();

  final _dependencyMap = <String, _DIMapValue>{};
  final _createdMap = <String, Object>{};

  void register<T>(
    String key,
    Function builder, {
    List<String> positionalParameter,
    Map<String, String> namedParameter,
    bool alwaysNew = false,
  }) {
    _dependencyMap[key] =
        _DIMapValue(builder, positionalParameter, namedParameter, T, alwaysNew);
  }

  _DIMapValue _getDependencyValue(String key) {
    final value = _dependencyMap[key];
    if (value == null) {
      throw DependencyNotFoundException(key);
    }
    return value;
  }

  Object _createObjInstance(String key) {
    final value = _getDependencyValue(key);

    final dependencys =
        value.dependencyList?.map((dependencyKey) => get(dependencyKey)) ?? [];
    final dependencyNamed = value.dependencyNamed?.map(
        (key, value) => MapEntry<Symbol, dynamic>(Symbol(key), get(value)));
    final objInstance =
        Function.apply(value.builder, dependencys.toList(), dependencyNamed);
    if (!value.alwaysNew) {
      _createdMap[key] = objInstance;
    }
    return objInstance;
  }

  T get<T>(String key) {
    var obj = _createdMap[key] ?? _createObjInstance(key);
    if (obj is! T) {
      throw DependencyTypeNotMatchException(key, obj.runtimeType, T);
    }
    return obj as T;
  }
}
