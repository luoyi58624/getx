part of '../../mini_getx.dart';

// This callback remove the listener on addListener function
typedef _Disposer = void Function();

// replacing StateSetter, return if the Widget is mounted for extra validation.
// if it brings overhead the extra call,
typedef _GetStateUpdate = void Function();

class _ListNotifier extends Listenable with _ListNotifierSingleMixin, _ListNotifierGroupMixin {}

/// A _Notifier with single listeners
class _ListNotifierSingle = _ListNotifier with _ListNotifierSingleMixin;

/// A notifier with group of listeners identified by id
class _ListNotifierGroup = _ListNotifier with _ListNotifierGroupMixin;

/// This mixin add to Listenable the addListener, removerListener and
/// containsListener implementation
mixin _ListNotifierSingleMixin on Listenable {
  List<_GetStateUpdate>? _updaters = <_GetStateUpdate>[];

  @override
  _Disposer addListener(_GetStateUpdate listener) {
    assert(_debugAssertNotDisposed());
    _updaters!.add(listener);
    return () => _updaters!.remove(listener);
  }

  bool containsListener(_GetStateUpdate listener) {
    return _updaters?.contains(listener) ?? false;
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _updaters!.remove(listener);
  }

  void refresh() {
    assert(_debugAssertNotDisposed());
    _notifyUpdate();
  }

  @protected
  void reportRead() {
    _Notifier.instance.read(this);
  }

  @protected
  void reportAdd(VoidCallback disposer) {
    _Notifier.instance.add(disposer);
  }

  void _notifyUpdate() {
    final list = _updaters?.toList() ?? [];

    for (var element in list) {
      element();
    }
  }

  bool get isDisposed => _updaters == null;

  bool _debugAssertNotDisposed() {
    assert(() {
      if (isDisposed) {
        throw FlutterError('''A $runtimeType was used after being disposed.\n
'Once you have called dispose() on a $runtimeType, it can no longer be used.''');
      }
      return true;
    }());
    return true;
  }

  int get listenersLength {
    assert(_debugAssertNotDisposed());
    return _updaters!.length;
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _updaters = null;
  }
}

mixin _ListNotifierGroupMixin on Listenable {
  HashMap<Object?, _ListNotifierSingleMixin>? _updatersGroupIds = HashMap<Object?, _ListNotifierSingleMixin>();

  void _notifyGroupUpdate(Object id) {
    if (_updatersGroupIds!.containsKey(id)) {
      _updatersGroupIds![id]!._notifyUpdate();
    }
  }

  @protected
  void notifyGroupChildren(Object id) {
    assert(_debugAssertNotDisposed());
    _Notifier.instance.read(_updatersGroupIds![id]!);
  }

  bool containsId(Object id) {
    return _updatersGroupIds?.containsKey(id) ?? false;
  }

  @protected
  void refreshGroup(Object id) {
    assert(_debugAssertNotDisposed());
    _notifyGroupUpdate(id);
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_updatersGroupIds == null) {
        throw FlutterError('''A $runtimeType was used after being disposed.\n
'Once you have called dispose() on a $runtimeType, it can no longer be used.''');
      }
      return true;
    }());
    return true;
  }

  void removeListenerId(Object id, VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    if (_updatersGroupIds!.containsKey(id)) {
      _updatersGroupIds![id]!.removeListener(listener);
    }
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _updatersGroupIds?.forEach((key, value) => value.dispose());
    _updatersGroupIds = null;
  }

  _Disposer addListenerId(Object? key, _GetStateUpdate listener) {
    _updatersGroupIds![key] ??= _ListNotifierSingle();
    return _updatersGroupIds![key]!.addListener(listener);
  }

  /// To dispose an [id] from future updates(), this ids are registered
  /// by `GetBuilder()` or similar, so is a way to unlink the state change with
  /// the Widget from the Controller.
  void disposeId(Object id) {
    _updatersGroupIds?[id]?.dispose();
    _updatersGroupIds!.remove(id);
  }
}

class _Notifier {
  _Notifier._();

  static _Notifier? _instance;
  static _Notifier get instance => _instance ??= _Notifier._();

  _NotifyData? _notifyData;

  void add(VoidCallback listener) {
    _notifyData?.disposers.add(listener);
  }

  void read(_ListNotifierSingleMixin updaters) {
    final listener = _notifyData?.updater;
    if (listener != null && !updaters.containsListener(listener)) {
      updaters.addListener(listener);
      add(() => updaters.removeListener(listener));
    }
  }

  T append<T>(_NotifyData data, T Function() builder) {
    _notifyData = data;
    final result = builder();
    if (data.disposers.isEmpty) {
      throw const _ObxError();
    }
    _notifyData = null;
    return result;
  }
}

class _NotifyData {
  const _NotifyData({required this.updater, required this.disposers});
  final _GetStateUpdate updater;
  final List<VoidCallback> disposers;
}

class _ObxError {
  const _ObxError();
  @override
  String toString() {
    return """
      [Get] the improper use of a GetX has been detected. 
      You should only use GetX or Obx for the specific widget that will be updated.
      If you are seeing this error, you probably did not insert any observable variables into GetX/Obx 
      or insert them outside the scope that GetX considers suitable for an update 
      (example: GetX => HeavyWidget => variableObservable).
      If you need to update a parent widget and a child widget, wrap each one in an Obx/GetX.
      """;
  }
}
