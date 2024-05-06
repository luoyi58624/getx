import 'package:flutter/material.dart';
import '../global.dart';

class Controller extends GetxController {
  final list = [1, 2, 3].obs;

  /// 清空数据
  clear() => list.clear();

  /// 添加数据
  add(int value) => list.add(value);

  /// 更新指定下标数据
  updateList(int index) => list[index]++;
}

class TypeListBasePage extends StatefulWidget {
  const TypeListBasePage({super.key});

  @override
  State<TypeListBasePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypeListBasePage> {
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
        title: const Text('响应式List - 基础类型'),
        actions: [
          IconButton(
            onPressed: () {
              c.add(c.list.length + 1);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              c.clear();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: c.list.length,
          itemBuilder: (context, i) => ListTile(
            onTap: () {
              c.updateList(i);
            },
            title: Text(c.list[i].toString()),
          ),
        ),
      ),
    );
  }
}
