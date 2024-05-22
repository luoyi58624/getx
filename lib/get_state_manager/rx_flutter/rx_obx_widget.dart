part of '../../mini_getx.dart';

/// The [_ObxWidget] is the base for all GetX reactive widgets
///
/// See also:
/// - [Obx]
/// - [_ObxValue]
abstract class _ObxWidget extends _ObxStatelessWidget {
  const _ObxWidget({super.key});
}

/// The simplest reactive widget in GetX.
///
/// Just pass your Rx variable in the root scope of the callback to have it
/// automatically registered for changes.
///
/// final _name = "GetX".obs;
/// Obx(() => Text( _name.value )),... ;
class Obx extends _ObxWidget {
  final Widget Function() builder;

  const Obx(this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return builder();
  }
}
