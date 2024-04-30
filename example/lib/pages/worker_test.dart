import 'package:flutter/material.dart';
import 'package:luoyi_dart_base/luoyi_dart_base.dart';
import 'package:mini_getx/mini_getx.dart';

class Controller extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(
      count,
      (v) {
        debugPrint(v.toString());
      },
      condition: () => count.value > 5,
    );
  }
}

class WorkerTestPage extends StatefulWidget {
  const WorkerTestPage({super.key});

  @override
  State<WorkerTestPage> createState() => _WorkerTestPageState();
}

class _WorkerTestPageState extends State<WorkerTestPage> {
  Controller c = Get.put(Controller());

  @override
  void dispose() {
    super.dispose();
    Get.delete<Controller>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker测试'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                i(Get.instances);
              },
              child: const Text('获取所有controller'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.put(Controller());
              },
              child: const Text('注入controller'),
            ),
            ElevatedButton(
              onPressed: () {
                c = Get.find<Controller>();
                i(c.count.value);
              },
              child: const Text('获取controller'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.delete<Controller>();
              },
              child: const Text('销毁controller'),
            ),
            ElevatedButton(
              onPressed: () {
                c.count.value++;
              },
              child: Obx(() {
                return Text('count: ${c.count.value}');
              }),
            ),
          ],
        ),
      ),
    );
  }
}
