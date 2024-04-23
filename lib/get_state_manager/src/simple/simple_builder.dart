import 'dart:async';

import 'package:flutter/widgets.dart';

import 'list_notifier.dart';

class ObxElement = StatelessElement with StatelessObserverComponent;

/// A StatelessWidget than can listen reactive changes.
abstract class ObxStatelessWidget extends StatelessWidget {
  /// Initializes [key] for subclasses.
  const ObxStatelessWidget({Key? key}) : super(key: key);
  @override
  StatelessElement createElement() => ObxElement(this);
}

/// a Component that can track changes in a reactive variable
mixin StatelessObserverComponent on StatelessElement {
  List<Disposer>? disposers = <Disposer>[];

  void getUpdate() {
    if (disposers != null) {
      scheduleMicrotask(markNeedsBuild);
    }
  }

  @override
  Widget build() {
    return Notifier.instance.append(NotifyData(disposers: disposers!, updater: getUpdate), super.build);
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
