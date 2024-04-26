/// GetX is an extra-light and powerful multi-platform framework.
/// It combines high performance state management, intelligent dependency
/// injection, and route management in a quick and practical way.
library get;

import 'get_utils/platform/platform_web.dart' if (dart.library.io) 'get_utils/platform/platform_io.dart';
import 'dart:collection';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

// export 'get_core/get_core.dart';
// export 'get_instance/get_instance.dart';
// export 'get_rx/get_rx.dart';
// export 'get_state_manager/get_state_manager.dart';
// export 'get_utils/get_utils.dart';

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

part 'get_rx/rx_workers/utils/debouncer.dart';

part 'get_state_manager/rx_flutter/rx_notifier.dart';

part 'get_state_manager/rx_flutter/rx_obx_widget.dart';

part 'get_state_manager/rx_flutter/rx_ticket_provider_mixin.dart';

part 'get_state_manager/simple/get_controllers.dart';

part 'get_state_manager/simple/list_notifier.dart';

part 'get_state_manager/simple/simple_builder.dart';

part 'get_utils/equality/equality.dart';

part 'get_utils/extensions/context_extensions.dart';

part 'get_utils/extensions/num_extensions.dart';

part 'get_utils/extensions/string_extensions.dart';

part 'get_utils/get_utils/get_utils.dart';

part 'get_utils/platform/platform.dart';

typedef _Condition = bool Function();

/// GetInterface allows any auxiliary package to be merged into the "Get"
/// class through extensions
abstract class GetInterface {}

class _GetImpl extends GetInterface {}

// ignore: non_constant_identifier_names
final Get = _GetImpl();

/// default logger from GetX
void _log(String value, {bool enabledLog = true}) {
  if (enabledLog && kDebugMode) developer.log(value, name: 'GETX');
}
