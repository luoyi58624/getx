import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  final list = [1, 2, 3].obs;

  /// 清空数据，之所以list可以不用加.value，是因为getx做了拦截，基础类型没法拦截所以必须添加.value
  clear() => list.clear();

  // 你也可以直接操作.value
  // clear() => list.value = [];

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
