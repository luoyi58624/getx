part of '../../mini_getx.dart';

class _ObxElement = StatelessElement with _StatelessObserverComponent;

/// A StatelessWidget than can listen reactive changes.
abstract class _ObxStatelessWidget extends StatelessWidget {
  /// Initializes [key] for subclasses.
  const _ObxStatelessWidget({super.key});
  @override
  StatelessElement createElement() => _ObxElement(this);
}

/// a Component that can track changes in a reactive variable
mixin _StatelessObserverComponent on StatelessElement {
  List<_Disposer>? disposers = <_Disposer>[];

  void getUpdate() {
    if (disposers != null) {
      scheduleMicrotask(markNeedsBuild);
    }
  }

  @override
  Widget build() {
    return _Notifier.instance.append(_NotifyData(disposers: disposers!, updater: getUpdate), super.build);
  }

  @override
  void unmount() {
    super.unmount();
    for (final disposer in disposers!) {
      disposer();
    }
    disposers!.clear();
    disposers = null;
  }
}
