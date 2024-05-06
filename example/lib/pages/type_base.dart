import 'package:flutter/material.dart';
import '../global.dart';

class Controller extends GetxController {
  final intType = 0.obs;
  final doubleType = 0.0.obs;
  final stringType = 'hello'.obs;
  final boolType = false.obs;

  updateIntType() => intType.value++;

  updateDoubleType() => doubleType.value += 0.5;

  updateStringType() => stringType.value = stringType.value == 'hello' ? '你好' : 'hello';

  updateBoolType() => boolType.value = !boolType.value;

  void demo() {}
}

class TypeBasePage extends StatefulWidget {
  const TypeBasePage({super.key});

  @override
  State<TypeBasePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypeBasePage> {
  final c = Get.put(Controller());

  @override
  void dispose() {
    super.dispose();
    Get.delete<Controller>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('响应式变量类型示例'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: c.updateIntType,
              child: Obx(() => Text('int type: ${c.intType.value}')),
            ),
            ElevatedButton(
              onPressed: c.updateDoubleType,
              child: Obx(() => Text('double type: ${c.doubleType.value}')),
            ),
            ElevatedButton(
              onPressed: c.updateStringType,
              child: Obx(() => Text('string type: ${c.stringType.value}')),
            ),
            ElevatedButton(
              onPressed: c.updateBoolType,
              child: Obx(() => Text('bool type: ${c.boolType.value}')),
            ),
          ],
        ),
      ),
    );
  }
}
