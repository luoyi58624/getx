import 'dart:math';

import 'package:flutter/material.dart';
import '../global.dart';

class Controller extends GetxController {
  /// 通过[Controller.of]的方式获取控制器实例，它不存在任何副作用，同时对性能基本没有影响，
  /// 但推荐你在偶尔需要用到控制器的地方使用它
  static Controller get of => Get.find();

  final count = 0.obs;

  addCount() => count.value++;
}

class Controller2 extends GetxController {
  /// 通过[Controller.of]的方式获取控制器实例，它不存在任何副作用，同时对性能基本没有影响，
  /// 但推荐你在偶尔需要用到控制器的地方使用它
  static Controller get of => Get.find();

  final count = 0.obs;

  addCount() => count.value++;
}

class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  late int tag;
  late final Controller c;
  late final Controller2 c2;

  @override
  void initState() {
    super.initState();
    tag = Random().nextInt(100);
    c = Get.put(Controller(), tag: tag.toString());
    c2 = Get.put(Controller2(), tag: tag.toString());
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<Controller>(tag: tag.toString());
    Get.delete<Controller2>(tag: tag.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计数器示例'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // 通过of获取控制器
                Controller.of.addCount();
              },
              child: Obx(() => Text('count: ${c.count.value}')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Child()));
              },
              child: const Text('子页面'),
            ),
          ],
        ),
      ),
    );
  }
}

class Child extends StatelessWidget {
  Child({super.key});

  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    // 不管在哪定义都没关系，看自己喜好
    // Controller c = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('子页面'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                c.count.value++;
              },
              // 通过of获取控制器
              child: Obx(() => Text('count: ${Controller.of.count.value}')),
            ),
          ],
        ),
      ),
    );
  }
}
