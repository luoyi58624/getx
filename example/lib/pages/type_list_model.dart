import 'package:flutter/material.dart';
import 'package:mini_getx/mini_getx.dart';

class User {
  User({required this.name, required this.age});

  String name;
  int age;

  User copyWith({
    String? name,
    int? age,
  }) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  @override
  String toString() {
    return 'User{name: $name, age: $age}';
  }
}

class Controller extends GetxController {
  final list = <User>[
    User(name: 'hihi', age: 20),
  ].obs;

  clear() => list.clear();

  add() => list.add(User(name: 'hihi', age: 20));

  updateList(int index) => list[index] = User(name: 'hihi', age: list[index].age + 1);

  part(int index) => list[index] = list[index].copyWith(age: 1000);

  /// 原理一样，直接修改内部属性需要手动刷新
  part2(int index) {
    list[index].age = 1000;
    list.refresh();
  }
}

class TypeListModelPage extends StatefulWidget {
  const TypeListModelPage({super.key});

  @override
  State<TypeListModelPage> createState() => _TypePageState();
}

class _TypePageState extends State<TypeListModelPage> {
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
        title: const Text('响应式List - Model类型'),
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
