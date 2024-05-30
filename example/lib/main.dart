import 'package:device_preview/device_preview.dart';
import 'package:example/pages/count.dart';
import 'package:example/pages/nest_obx.dart';
import 'package:example/pages/type_base.dart';
import 'package:example/pages/worker_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'global.dart';
import 'pages/type_list_base.dart';
import 'pages/type_list_map.dart';
import 'pages/type_list_model.dart';
import 'pages/type_map.dart';
import 'pages/type_model.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: kIsWeb,
      builder: (context) => const MainApp(), // Wrap your app
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Getx示例'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CountPage()));
              },
              child: const Text('计数器示例'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TypeBasePage()));
              },
              child: const Text('响应式变量类型示例 - 基本类型'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TypeMapPage()));
              },
              child: const Text('响应式变量类型示例 - Map类型'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TypeModelPage()));
              },
              child: const Text('响应式变量类型示例 - Model类型'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TypeListBasePage()));
              },
              child: const Text('响应式变量类型示例 - List类型 - base'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TypeListMapPage()));
              },
              child: const Text('响应式变量类型示例 - List类型 - map'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TypeListModelPage()));
              },
              child: const Text('响应式变量类型示例 - List类型 - model'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WorkerTestPage()));
              },
              child: const Text('Worker测试'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NestObxPage()));
              },
              child: const Text('Obx重建范围测试'),
            ),
          ],
        ),
      ),
    );
  }
}
