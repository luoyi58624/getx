part of '../../mini_getx.dart';

bool _conditional(dynamic condition) {
  if (condition == null) return true;
  if (condition is bool) return condition;
  if (condition is bool Function()) return condition();
  return true;
}

typedef WorkerCallback<T> = Function(T callback);

class Workers {
  Workers(this.workers);

  final List<Worker> workers;

  void dispose() {
    for (final worker in workers) {
      if (!worker._disposed) {
        worker.dispose();
      }
    }
  }
}

///
/// Called every time [listener] changes. As long as the [condition]
/// returns true.
///
/// Sample:
/// Every time increment() is called, ever() will process the [condition]
/// (can be a [bool] expression or a `bool Function()`), and only call
/// the callback when [condition] is true.
/// In our case, only when count is bigger to 5. In order to "dispose"
/// this Worker
/// that will run forever, we made a `worker` variable. So, when the count value
/// reaches 10, the worker gets disposed, and releases any memory resources.
///
/// ```
/// // imagine some counter widget...
///
/// class _CountController extends GetxController {
///   final count = 0.obs;
///   Worker worker;
///
///   void onInit() {
///     worker = ever(count, (value) {
///       print('counter changed to: $value');
///       if (value == 10) worker.dispose();
///     }, condition: () => count > 5);
///   }
///
///   void increment() => count + 1;
/// }
/// ```
Worker ever<T>(
  GetListenable<T> listener,
  WorkerCallback<T> callback, {
  dynamic condition = true,
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
  bool showLog = true,
}) {
  StreamSubscription sub = listener.listen(
    (event) {
      if (_conditional(condition)) callback(event);
    },
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  return Worker(sub.cancel, '[ever]', showLog);
}

/// Similar to [ever], but takes a list of [listeners], the condition
/// for the [callback] is common to all [listeners],
/// and the [callback] is executed to each one of them. The [Worker] is
/// common to all, so `worker.dispose()` will cancel all streams.
Worker everAll(
  List<RxInterface> listeners,
  WorkerCallback callback, {
  dynamic condition = true,
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
  bool showLog = true,
}) {
  final evers = <StreamSubscription>[];
  for (var i in listeners) {
    final sub = i.listen(
      (event) {
        if (_conditional(condition)) callback(event);
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
    evers.add(sub);
  }

  Future<void> cancel() async {
    for (var i in evers) {
      i.cancel();
    }
  }

  return Worker(cancel, '[everAll]', showLog);
}

/// `once()` will execute only 1 time when [condition] is met and cancel
/// the subscription to the [listener] stream right after that.
/// [condition] defines when [callback] is called, and
/// can be a [bool] or a `bool Function()`.
///
/// Sample:
/// ```
///  class _CountController extends GetxController {
///   final count = 0.obs;
///   Worker worker;
///
///   @override
///   Future<void> onInit() async {
///     worker = once(count, (value) {
///       print("counter reached $value before 3 seconds.");
///     }, condition: () => count() > 2);
///     3.delay(worker.dispose);
///   }
///   void increment() => count + 1;
/// }
///```
Worker once<T>(
  GetListenable<T> listener,
  WorkerCallback<T> callback, {
  dynamic condition = true,
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
  bool showLog = true,
}) {
  late Worker ref;
  StreamSubscription? sub;
  sub = listener.listen(
    (event) {
      if (!_conditional(condition)) return;
      ref._disposed = true;
      ref._printLog('called');
      sub?.cancel();
      callback(event);
    },
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  ref = Worker(sub.cancel, '[once]', showLog);
  return ref;
}

/// Ignore all changes in [listener] during [time] (1 sec by default) or until
/// [condition] is met (can be a [bool] expression or a `bool Function()`),
/// It brings the 1st "value" since the period of time, so
/// if you click a counter button 3 times in 1 sec, it will show you "1"
/// (after 1 sec of the first press)
/// click counter 3 times in 1 sec, it will show you "4" (after 1 sec)
/// click counter 2 times in 1 sec, it will show you "7" (after 1 sec).
///
/// Sample:
/// // wait 1 sec each time an event starts, only if counter is lower than 20.
/// worker = interval(
///    count,
///    (value) => print(value),
///    time: 1.seconds,
///    condition: () => count < 20,
/// );
/// ```
Worker interval<T>(
  GetListenable<T> listener,
  WorkerCallback<T> callback, {
  Duration time = const Duration(seconds: 1),
  dynamic condition = true,
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
  bool showLog = true,
}) {
  var debounceActive = false;
  StreamSubscription sub = listener.listen(
    (event) async {
      if (debounceActive || !_conditional(condition)) return;
      debounceActive = true;
      await Future.delayed(time);
      debounceActive = false;
      callback(event);
    },
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  return Worker(sub.cancel, '[interval]', showLog);
}

/// [debounce] is similar to [interval], but sends the last value.
/// Useful for Anti DDos, every time the user stops typing for 1 second,
/// for instance.
/// When [listener] emits the last "value", when [time] hits,
/// it calls [callback] with the last "value" emitted.
///
/// Sample:
///
/// ```
/// worker = debounce(
///      count,
///      (value) {
///        print(value);
///        if( value > 20 ) worker.dispose();
///      },
///      time: 1.seconds,
///    );
///  }
///  ```
Worker debounce<T>(
  GetListenable<T> listener,
  WorkerCallback<T> callback, {
  Duration? time,
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
  bool showLog = true,
}) {
  final newDebounce =
      Debounce(delay: time ?? const Duration(milliseconds: 800));
  StreamSubscription sub = listener.listen(
    (event) {
      newDebounce(() {
        callback(event);
      });
    },
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  return Worker(sub.cancel, '[debounce]', showLog);
}

/// 响应式变量副作用对象
///
/// 提示：如果你在控制器中创建一个副作用函数，你不需要在[onClose]中进行销毁，当控制器被删除后，
/// Getx会自动清理副作用函数。
///
/// 注意：开发者工具存在延迟现象，销毁后再进行一些操作才可能会刷新。
class Worker {
  Worker(this.worker, this.type, this.showLog);

  /// subscription.cancel() callback
  final Future<void> Function() worker;

  /// type of worker (debounce, interval, ever)..
  final String type;

  /// 是否显示日志
  final bool showLog;

  bool _disposed = false;

  void _printLog(String msg) {
    _getxLog('$runtimeType $type $msg', showLog: showLog);
  }

  /// 手动销毁副作用函数
  Future<void> dispose() async {
    if (_disposed) {
      _printLog('already disposed');
      return;
    }
    _disposed = true;
    await worker();
    _printLog('disposed');
  }
}
