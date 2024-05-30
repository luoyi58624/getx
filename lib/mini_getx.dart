/// GetX is an extra-light and powerful multi-platform framework.
/// It combines high performance state management, intelligent dependency
/// injection, and route management in a quick and practical way.
library mini_getx;

import 'dart:collection';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

part 'get_instance/extension_instance.dart';

part 'get_instance/lifecycle.dart';

part 'get_rx/rx_types/rx_core/rx_impl.dart';

part 'get_rx/rx_types/rx_core/rx_interface.dart';

part 'get_rx/rx_types/rx_core/rx_num.dart';

part 'get_rx/rx_types/rx_core/rx_string.dart';

part 'get_rx/rx_types/rx_iterables/rx_list.dart';

part 'get_rx/rx_types/rx_iterables/rx_map.dart';

part 'get_rx/rx_types/rx_iterables/rx_set.dart';

part 'get_rx/rx_workers/rx_workers.dart';

part 'get_rx/rx_workers/utils/debounce.dart';

part 'get_state_manager/rx_flutter/rx_notifier.dart';

part 'get_state_manager/rx_flutter/rx_obx_widget.dart';

part 'get_state_manager/rx_flutter/rx_ticket_provider_mixin.dart';

part 'get_state_manager/simple/list_notifier.dart';

part 'get_state_manager/simple/simple_builder.dart';

typedef _Condition = bool Function();

/// GetInterface allows any auxiliary package to be merged into the "Get"
/// class through extensions
abstract class GetInterface {}

class _GetImpl extends GetInterface {}

// ignore: non_constant_identifier_names
final Get = _GetImpl();

/// Getx控制器
abstract class GetxController extends _ListNotifier with GetLifeCycleMixin {}

/// default logger from GetX
void _getxLog(String value, {bool showLog = true}) {
  if (showLog && kDebugMode) developer.log(value, name: 'GETX');
}
