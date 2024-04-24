import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  final map = <String, dynamic>{'name': 'hihi', 'age': 20}.obs;

  updateList() => map.value = {'name': 'eeee', 'age': 0};

  updateName() {
    map.update('name', (value) => value == 'hihi' ? 'hello' : 'hihi');
  }

  updateAge() {
    // 你可以value + 1、value += 1、++value，就是不能value++
    map.update('age', (value) => value += 10);
  }

  /// Map响应式对象可以像原始Map一样，直接通过key修改value，这样也可以自动更新页面
  updateAge2() {
    map['age'] = 1000;
  }
}

class TypeMapPage extends StatefulWidget {
  const TypeMapPage({super.key});

  @override
  State<TypeMapPage> createState() => _TypePageState();
}

class _TypePageState extends State<TypeMapPage> {
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
              onPressed: c.updateList,
              child: Obx(() => Text('map type: ${c.map}')),
            ),
            ElevatedButton(
              onPressed: c.updateName,
              child: Obx(() => Text('update map name: ${c.map}')),
            ),
            ElevatedButton(
              onPressed: c.updateAge,
              onLongPress: c.updateAge2,
              child: Obx(() => Text('update map age: ${c.map}')),
            ),
          ],
        ),
      ),
    );
  }
}
