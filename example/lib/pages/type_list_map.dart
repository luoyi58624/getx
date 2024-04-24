import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  /// 注意：此处有一个坑，直接操作列表对象的内部属性是不会生效的，因为getx仅仅对list做拦截，它没有拦截Map对象内部属性，
  /// 若你直接这样操作，那么你必须手动调用[refresh]函数才能刷新页面。
  ///
  /// 实际原理是，你当前操作的[]运算符是getx重写的，dart允许你对一些运算符重写，它有一个关键字：[operator]，
  /// list[index]赋值之所以能生效，是因为getx通过[operator]重写了 "[]=" 运算符，当你设置新的值后会在内部调用[refresh]函数
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
