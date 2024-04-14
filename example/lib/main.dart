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

class MyController extends GetxController {
  static MyController get of => Get.find();
  final count = 0.obs;
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
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Child()));
          },
          child: const Text('子页面'),
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
    final MyController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('二级子页面'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await 2.delay();
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
