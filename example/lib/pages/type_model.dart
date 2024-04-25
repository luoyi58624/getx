import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class User {
  User({required this.name, required this.age});

  String name;
  int age;

  @override
  String toString() {
    return 'User{name: $name, age: $age}';
  }
}

class Controller extends GetxController {
  final model = User(name: 'hihi', age: 20).obs;

  updateModel() => model.value = User(name: 'hihi', age: Random().nextInt(100));

  /// 更新对象单个属性，手动调用 refresh 刷新
  updateName() {
    model.value.name = model.value.name == 'hello' ? 'hihi' : 'hello';
    model.refresh();
  }

  /// 更新对象单个属性，利用getx提供的[update]方法更新
  updateAge() {
    model.update((user) {
      user.age += 10;
    });
  }
}

class TypeModelPage extends StatefulWidget {
  const TypeModelPage({super.key});

  @override
  State<TypeModelPage> createState() => _TypePageState();
}

class _TypePageState extends State<TypeModelPage> {
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
        title: const Text('响应式变量 - Model对象'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: c.updateModel,
              child: Obx(() => Text('model type: ${c.model}')),
            ),
            ElevatedButton(
              onPressed: c.updateName,
              child: Obx(() => Text('model map name: ${c.model}')),
            ),
            ElevatedButton(
              onPressed: c.updateAge,
              child: Obx(() => Text('model map age: ${c.model}')),
            ),
          ],
        ),
      ),
    );
  }
}
