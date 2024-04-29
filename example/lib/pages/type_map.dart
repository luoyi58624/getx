import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mini_getx/mini_getx.dart';

class Controller extends GetxController {
  final map = <String, dynamic>{'name': 'hihi', 'age': 20}.obs;

  /// 通过.value更新Map整个对象
  updateMap() => map.value = {'name': 'eeee', 'age': 0};

  /// 通过update更新单个属性
  updateName() {
    map.update('name', (value) => value == 'hihi' ? 'hello' : 'hihi');
  }

  /// 通过key直接修改value，getx对最外面一层修改做了拦截
  updateAge() {
    map['age']++;
  }

  /// 嵌套map
  final nestMap = <String, Map<String, dynamic>>{
    '001': {'name': 'hihi', 'age': 20},
    '002': {'name': 'dada', 'age': 18},
  }.obs;

  /// 原理和上面基础Map的[updateAge]一样，getx对最外面一层做了拦截
  updateNestMap(String key) => nestMap[key] = {'name': 'eeee', 'age': Random().nextInt(100)};

  /// 更新嵌套Map中的单个属性，你必须手动调用refresh方法进行刷新，因为getx仅做了一层拦截
  updateNestFirstMapName() {
    final key = nestMap.keys.first;
    // 你不能这样做，因为getx仅做了一层拦截，你现在操作的是第二层对象的属性
    // nestMap[key]!.update('name', (value) => (value) => value == 'hihi' ? 'hello' : 'hihi');
    nestMap[key]!['name'] = nestMap[key]!['name'] == 'hihi' ? 'hello' : 'hihi';
    nestMap.refresh();
  }

  /// 更新最后一条Map的age
  updateNestLastMapAge() {
    final key = nestMap.keys.last;
    nestMap[key]!['age']++;
    nestMap.refresh();
  }
}

class TypeMapPage extends StatefulWidget {
  const TypeMapPage({super.key});

  @override
  State<TypeMapPage> createState() => _TypePageState();
}

class _TypePageState extends State<TypeMapPage> {
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
        title: const Text('Map类型'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: c.updateMap,
              child: Obx(() => Text('update map: ${c.map}')),
            ),
            ElevatedButton(
              onPressed: c.updateName,
              child: Obx(() => Text('update map name: ${c.map}')),
            ),
            ElevatedButton(
              onPressed: c.updateAge,
              child: Obx(() => Text('update map age: ${c.map}')),
            ),
            const Divider(),
            const Text('更新嵌套Map'),
            Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: c.nestMap.values.map((v) => Text(v.toString())).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                c.updateNestMap(c.nestMap.keys.first);
              },
              child: const Text('update first nest map'),
            ),
            ElevatedButton(
              onPressed: () {
                c.updateNestFirstMapName();
              },
              child: const Text('update first nest map name'),
            ),
            ElevatedButton(
              onPressed: () {
                c.updateNestLastMapAge();
              },
              child: const Text('update last nest map age'),
            ),
          ],
        ),
      ),
    );
  }
}
