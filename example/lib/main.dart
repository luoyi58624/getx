import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class User {
  User(this.age);

  int age;
}

class MyController extends GetxController {
  static MyController get of => Get.find();
  final count = 0.obs;
  final demoList = [User(10)].obs;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Center(
        child: Column(
          children: [
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

class Child extends StatefulWidget {
  const Child({super.key});

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {
  MyController controller = Get.put(MyController());

  @override
  void dispose() {
    super.dispose();
    Get.delete<MyController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('子页面'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                controller.count.value++;
              },
              child: Obx(() => Text('count: ${controller.count.value}')),
            ),
            ElevatedButton(
              onPressed: () {
                controller.demoList.value[0] = User(Random().nextInt(10000));
                // controller.demoList.refresh();
                // TabScaffoldController.of.demoList.refresh();
              },
              child: Obx(() => Text('demoList: ${controller.demoList[0].age} ')),
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
                MyController.of.count.value++;
              },
              child: Obx(() => Text('count: ${MyController.of.count.value}')),
            ),
          ],
        ),
      ),
    );
  }
}
