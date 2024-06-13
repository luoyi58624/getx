import 'package:flutter/material.dart';
import '../global.dart';

class Controller extends GetxController {
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
