// ignore: prefer_mixin
import 'package:flutter/widgets.dart';

import '../../../instance_manager.dart';
import '../rx_flutter/rx_notifier.dart';
import 'list_notifier.dart';

// ignore: prefer_mixin
abstract class GetxController extends ListNotifier with GetLifeCycleMixin {}
