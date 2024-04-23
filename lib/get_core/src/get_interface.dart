import 'log.dart';

/// GetInterface allows any auxiliary package to be merged into the "Get"
/// class through extensions
abstract class GetInterface {
  LogWriterCallback log = defaultLogWriterCallback;
}
