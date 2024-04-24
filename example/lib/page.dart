import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class GetxPage extends StatefulWidget {
  const GetxPage({super.key});

  @override
  State<GetxPage> createState() => _GetxPageState();
}

class _GetxPageState extends State<GetxPage> {
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
        title: const Text('Getx页面'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                c.addCount();
              },
              child: Obx(() => Text('count: ${c.count.value}')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Child()));
              },
              child: const Text('子页面'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.log(GetUtils.camelCase('xx dee') ?? '');
              },
              child: const Text('demo'),
            ),
          ],
        ),
      ),
    );
  }
}

class Child extends StatelessWidget {
  const Child({super.key});

  @override
  Widget build(BuildContext context) {
    Controller c = Get.find();
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
              child: Obx(() => Text('count: ${c.count.value}')),
            ),
            ElevatedButton(
              onPressed: () {
                // controller.demoList.value[0] = User(Random().nextInt(10000));
                // controller.demoList.refresh();
                // TabScaffoldController.of.demoList.refresh();
              },
              child: Obx(() => Text('demoList: ${c.userList[0].age} ')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SecondChildPage()));
              },
              child: const Text('二级子页面'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondChildPage extends StatelessWidget {
  const SecondChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('二级子页面'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Controller.of.count.value++;
              },
              child: Obx(() => Text('count: ${Controller.of.count.value}')),
            ),
          ],
        ),
      ),
    );
  }
}
