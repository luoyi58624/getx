import 'package:flutter/material.dart';
import '../global.dart';

class Controller extends GetxController {
  final list = <Map<String, dynamic>>[
    {'name': 'hihi', 'age': 20}
  ].obs;

  /// 清空数据
  clear() => list.clear();

  /// 添加数据
  add() => list.add({'name': 'hihi', 'age': 20});

  /// 更新指定下标数据
  updateList(int index) => list[index] = {'name': 'hello', 'age': 100};

  /// 更新指定下标Map对象的部分数据
  part(int index) => list[index] = {...list[index], 'age': 1000};

  /// 直接修改内部属性，需要调用refresh手动刷新页面
  part2(int index) {
    list[index]['age'] = 1000;
    list.refresh();
  }
}

class TypeListMapPage extends StatefulWidget {
  const TypeListMapPage({super.key});

  @override
  State<TypeListMapPage> createState() => _TypePageState();
}

class _TypePageState extends State<TypeListMapPage> {
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
        title: const Text('响应式List - Map类型'),
        actions: [
          IconButton(
            onPressed: () {
              c.add();
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
            onLongPress: () {
              c.part2(i);
            },
            title: Text(c.list[i].toString()),
          ),
        ),
      ),
    );
  }
}
