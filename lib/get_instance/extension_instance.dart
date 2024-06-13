part of '../mini_getx.dart';

extension GetInstance on GetInterface {
  /// Holds references to every registered Instance when using
  /// `Get.put()`
  static final Map<String, InstanceBuilderFactory> _instances = {};

  /// 注入控制器
  /// * dependency 控制器对象
  /// * tag 当需要注入多个相同对象控制器时，你应当设置标签用于区分
  /// * showLog 是否在控制台打印日志
  S put<S>(
    S dependency, {
    String? tag,
    bool showLog = true,
  }) {
    _insert(
        isSingleton: true,
        name: tag,
        showLog: showLog,
        builder: (() => dependency));
    return find<S>(tag: tag, showLog: showLog);
  }

  /// Injects the Instance [S] builder into the `_singleton` HashMap.
  void _insert<S>({
    bool? isSingleton,
    String? name,
    required InstanceBuilderCallback<S> builder,
    bool fenix = false,
    bool showLog = true,
  }) {
    final key = _getKey(S, name);

    InstanceBuilderFactory<S>? dep;
    if (_instances.containsKey(key)) {
      final newDep = _instances[key];
      if (newDep == null || !newDep.isDirty) {
        return;
      } else {
        dep = newDep as InstanceBuilderFactory<S>;
      }
    }
    _instances[key] = InstanceBuilderFactory<S>(
      isSingleton: isSingleton,
      builderFunc: builder,
      isInit: false,
      tag: name,
      lateRemove: dep,
      showLog: showLog,
    );
  }

  /// Initializes the dependencies for a Class Instance [S] (or tag),
  /// If its a Controller, it starts the lifecycle process.
  /// Optionally associating the current Route to the lifetime of the instance,
  /// if `Get.smartManagement` is marked as [SmartManagement.full] or
  /// [SmartManagement.keepFactory]
  /// Only flags `isInit` if it's using `Get.create()`
  /// (not for Singletons access).
  /// Returns the instance if not initialized, required for Get.create() to
  /// work properly.
  S? _initDependencies<S>({String? name, required bool showLog}) {
    final key = _getKey(S, name);
    final isInit = _instances[key]!.isInit;
    S? i;
    if (!isInit) {
      final isSingleton = _instances[key]?.isSingleton ?? false;
      if (isSingleton) {
        _instances[key]!.isInit = true;
      }
      i = _startController<S>(tag: name, showLog: showLog);
    }
    return i;
  }

  InstanceBuilderFactory? _getDependency<S>({String? tag, String? key}) {
    final newKey = key ?? _getKey(S, tag);

    if (!_instances.containsKey(newKey)) {
      _getxLog('Instance "$newKey" is not registered.');
      return null;
    } else {
      return _instances[newKey];
    }
  }

  /// Initializes the controller
  S _startController<S>({String? tag, required bool showLog}) {
    final key = _getKey(S, tag);
    final i = _instances[key]!.getDependency(showLog) as S;
    if (i is GetLifeCycleMixin) {
      i.onStart();
      if (tag == null) {
        _getxLog('Instance "$S" has been initialized', showLog: showLog);
      } else {
        _getxLog('Instance "${S}_$tag" has been initialized', showLog: showLog);
      }
    }
    return i;
  }

  /// if already put controller，then return controller，or put controller
  S putOrFind<S>(InstanceBuilderCallback<S> dep,
      {String? tag, required bool showLog}) {
    final key = _getKey(S, tag);

    if (_instances.containsKey(key)) {
      return _instances[key]!.getDependency(showLog) as S;
    } else {
      return put(dep(), tag: tag);
    }
  }

  /// Finds the registered type <[S]> (or [tag])
  /// In case of using Get.[create] to register a type <[S]> or [tag],
  /// it will create an instance each time you call [find].
  /// If the registered type <[S]> (or [tag]) is a Controller,
  /// it will initialize it's lifecycle.
  S find<S>({String? tag, bool showLog = true}) {
    final key = _getKey(S, tag);
    if (isRegistered<S>(tag: tag)) {
      final dep = _instances[key];
      if (dep == null) {
        if (tag == null) {
          throw 'Class "$S" is not registered';
        } else {
          throw 'Class "$S" with tag "$tag" is not registered';
        }
      }

      final i = _initDependencies<S>(name: tag, showLog: showLog);
      return i ?? dep.getDependency(showLog) as S;
    } else {
      // ignore: lines_longer_than_80_chars
      throw '"$S" not found. You need to call "Get.put($S())" or "Get.lazyPut(()=>$S())"';
    }
  }

  /// The findOrNull method will return the instance if it is registered;
  /// otherwise, it will return null.
  S? findOrNull<S>({String? tag}) {
    if (isRegistered<S>(tag: tag)) {
      return find<S>(tag: tag);
    }
    return null;
  }

  /// Generates the key based on [type] (and optionally a [name])
  /// to register an Instance Builder in the hashmap.
  String _getKey(Type type, String? name) {
    return name == null ? type.toString() : '${type}_$name';
  }

  /// Delete registered Class Instance [S] (or [tag]) and, closes any open
  /// controllers `DisposableInterface`, cleans up the memory
  ///
  /// /// Deletes the Instance<[S]>, cleaning the memory.
  //  ///
  //  /// - [tag] Optional "tag" used to register the Instance
  //  /// - [key] For internal usage, is the processed key used to register
  //  ///   the Instance. **don't use** it unless you know what you are doing.

  /// Deletes the Instance<[S]>, cleaning the memory and closes any open
  /// controllers (`DisposableInterface`).
  ///
  /// - [tag] Optional "tag" used to register the Instance
  /// - [key] For internal usage, is the processed key used to register
  ///   the Instance. **don't use** it unless you know what you are doing.
  /// - [force] Will delete an Instance even if marked as `permanent`.
  bool delete<S>({String? tag, String? key}) {
    final newKey = key ?? _getKey(S, tag);

    if (!_instances.containsKey(newKey)) return false;

    final dep = _instances[newKey];

    if (dep == null) return false;

    final InstanceBuilderFactory builder;
    if (dep.isDirty) {
      builder = dep.lateRemove ?? dep;
    } else {
      builder = dep;
    }

    final i = builder.dependency;

    if (i is GetLifeCycleMixin) {
      i.onDelete();
      _getxLog('"$newKey" onDelete() called', showLog: dep.showLog);
    }

    if (dep.lateRemove != null) {
      dep.lateRemove = null;
      _getxLog('"$newKey" deleted from memory');
      return false;
    } else {
      _instances.remove(newKey);
      if (_instances.containsKey(newKey)) {
        _getxLog('Error removing object "$newKey"');
      } else {
        _getxLog('"$newKey" deleted from memory', showLog: dep.showLog);
      }
      return true;
    }
  }

  /// Delete all registered Class Instances and, closes any open
  /// controllers `DisposableInterface`, cleans up the memory
  ///
  /// - [force] Will delete the Instances even if marked as `permanent`.
  void deleteAll() {
    final keys = _instances.keys.toList();
    for (final key in keys) {
      delete(key: key);
    }
  }

  void reloadAll({bool force = false}) {
    _instances.forEach((key, value) {
      value.dependency = null;
      value.isInit = false;
      _getxLog('Instance "$key" was reloaded.');
    });
  }

  void reload<S>({
    String? tag,
    String? key,
  }) {
    final newKey = key ?? _getKey(S, tag);

    final builder = _getDependency<S>(tag: tag, key: newKey);
    if (builder == null) return;

    final i = builder.dependency;
    if (i is GetLifeCycleMixin) {
      i.onDelete();
      _getxLog('"$newKey" onDelete() called', showLog: builder.showLog);
    }

    builder.dependency = null;
    builder.isInit = false;
    _getxLog('Instance "$newKey" was restarted.', showLog: builder.showLog);
  }

  /// Check if a Class Instance<[S]> (or [tag]) is registered in memory.
  /// - [tag] is optional, if you used a [tag] to register the Instance.
  bool isRegistered<S>({String? tag}) =>
      _instances.containsKey(_getKey(S, tag));

  /// Checks if a lazy factory callback `Get.lazyPut()` that returns an
  /// Instance<[S]> is registered in memory.
  /// - [tag] is optional, if you used a [tag] to register the lazy Instance.
  bool isPrepared<S>({String? tag}) {
    final newKey = _getKey(S, tag);

    final builder = _getDependency<S>(tag: tag, key: newKey);
    if (builder == null) {
      return false;
    }

    if (!builder.isInit) {
      return true;
    }
    return false;
  }
}

typedef InstanceBuilderCallback<S> = S Function();

/// Internal class to register instances with `Get.put<S>()`.
class InstanceBuilderFactory<S> {
  /// Marks the Builder as a single instance.
  /// For reusing [dependency] instead of [builderFunc]
  bool? isSingleton;

  /// Stores the actual object instance when [isSingleton]=true.
  S? dependency;

  /// Generates (and regenerates) the instance when [isSingleton]=false.
  /// Usually used by factory methods
  InstanceBuilderCallback<S> builderFunc;

  bool isInit = false;

  InstanceBuilderFactory<S>? lateRemove;

  bool isDirty = false;

  String? tag;

  bool showLog;

  InstanceBuilderFactory({
    required this.isSingleton,
    required this.builderFunc,
    required this.isInit,
    required this.tag,
    required this.lateRemove,
    required this.showLog,
  });

  void _showInitLog(bool showLog) {
    if (tag == null) {
      _getxLog('Instance "$S" has been created', showLog: showLog);
    } else {
      _getxLog('Instance "${S}_$tag" has been created', showLog: showLog);
    }
  }

  /// Gets the actual instance by it's [builderFunc] or the persisted instance.
  S getDependency(bool showLog) {
    if (isSingleton!) {
      if (dependency == null) {
        _showInitLog(showLog);
        dependency = builderFunc();
      }
      return dependency!;
    } else {
      return builderFunc();
    }
  }

  @override
  String toString() {
    return 'InstanceBuilderFactory{isSingleton: $isSingleton, dependency: $dependency, builderFunc: $builderFunc, isInit: $isInit, lateRemove: $lateRemove, isDirty: $isDirty, tag: $tag, showLog: $showLog}';
  }
}
