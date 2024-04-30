import 'package:flutter/material.dart';
import 'package:luoyi_dart_base/luoyi_dart_base.dart';
import 'package:mini_getx/mini_getx.dart';

class Controller extends GetxController {
  final count = 0.obs;
  final count2 = 100.obs;
}

class NestObxPage extends StatefulWidget {
  const NestObxPage({super.key});

  @override
  State<NestObxPage> createState() => _NestObxPageState();
}

class _NestObxPageState extends State<NestObxPage> {
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
        title: const Text('测试Obx重建范围'),
      ),
      body: Center(
        child: Obx(() {
          i('重建Column');
          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  c.count.value++;
                },
                child: Text('count: ${c.count.value} - 更新整个Column'),
              ),
              ElevatedButton(
                onPressed: () {
                  c.count2.value++;
                },
                child: Obx(() {
                  i('重建count2按钮文字');
                  return Text('count2: ${c.count2.value} - 只更新文字');
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
