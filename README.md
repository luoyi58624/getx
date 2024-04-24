精简getx，仅包含响应式状态管理、以及一些很方便工具扩展函数，移除路由、依赖绑定、http请求、GetBuilder、Getx等api

# 计数器示例

- 1.创建控制器

```dart
class Controller extends GetxController {
  /// 通过[Controller.of]的方式获取控制器实例，它不存在任何副作用，同时对性能基本没有影响，
  /// 但推荐你在偶尔需要用到控制器的地方使用它
  static Controller get of => Get.find();

  final count = 0.obs;

  addCount() => count.value++;
}
```

- 2.在页面上绑定控制器，与Getx官方示例不同的是，你必须在dispose生命周期中手动销毁控制器，
  因为我们已经移除了Getx路由相关的api，它无法自动感知何时销毁控制器

```dart
class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
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
        title: const Text('计数器示例'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // 通过of获取控制器
                Controller.of.addCount();
              },
              child: Obx(() => Text('count: ${c.count.value}')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Child()));
              },
              child: const Text('子页面'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- 3.其他页面若需要访问全局状态，只需通过Get.find()获取之前注册的控制器，或者通过定义的of静态方法直接访问控制器

```dart
class Child extends StatelessWidget {
  Child({super.key});

  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    // 不管在哪定义都没关系，看自己喜好
    // Controller c = Get.find();
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
              // 通过of获取控制器
              child: Obx(() => Text('count: ${Controller.of.count.value}')),
            ),
          ],
        ),
      ),
    );
  }
}

```

# 操作各种类型的响应式变量

- 基础响应式变量
```dart
class Controller extends GetxController {
  final intType = 0.obs;
  final doubleType = 0.0.obs;
  final stringType = 'hello'.obs;
  final boolType = false.obs;

  updateIntType() => intType.value++;

  updateDoubleType() => doubleType.value += 0.5;

  updateStringType() => stringType.value = stringType.value == 'hello' ? '你好' : 'hello';

  updateBoolType() => boolType.value = !boolType.value;
}

void page(){
  Column(
    children: [
      ElevatedButton(
        onPressed: c.updateIntType,
        child: Obx(() => Text('int type: ${c.intType.value}')),
      ),
      ElevatedButton(
        onPressed: c.updateDoubleType,
        child: Obx(() => Text('double type: ${c.doubleType.value}')),
      ),
      ElevatedButton(
        onPressed: c.updateStringType,
        child: Obx(() => Text('string type: ${c.stringType.value}')),
      ),
      ElevatedButton(
        onPressed: c.updateBoolType,
        child: Obx(() => Text('bool type: ${c.boolType.value}')),
      ),
    ],
  );
}
```

- Map响应式变量
```dart
class Controller extends GetxController {
  final mapType = <String, dynamic>{'name': 'hihi', 'age': 20}.obs;

  /// 更新整个Map对象
  updateMapType() => mapType.value = {'name': 'eeee', 'age': 0};

  /// 更新单个Map属性
  updateMapName() {
    mapType.update('name', (value) => value == 'hihi' ? 'hello' : 'hihi');
  }

  updateMapAge() {
    // 你可以value + 1、value += 1、++value，就是不能value++
    mapType.update('age', (value) => ++value); 
  }

  /// 经过实测，Map响应式对象可以像原始Map一样，直接通过key修改value，这样也可以自动更新页面
  updateMapAge2() {
    mapType['age'] = 1000;
  }
}

void page(){
  Column(
    children: [
      ElevatedButton(
        onPressed: c.updateMapType,
        child: Obx(() => Text('map type: ${c.mapType}')),
      ),
      ElevatedButton(
        onPressed: c.updateMapName,
        child: Obx(() => Text('update map name: ${c.mapType}')),
      ),
      ElevatedButton(
        onPressed: c.updateMapAge,
        onLongPress: c.updateMapAge2,
        child: Obx(() => Text('update map age: ${c.mapType}')),
      ),
    ],
  );
}
```

- List响应式变量(基础类型)
```dart
class Controller extends GetxController {
  final listType = [1, 2, 3].obs;

  /// 清空数据，之所以list可以不用加.value，是因为getx做了拦截，基础类型没法拦截所以必须添加.value
  clearListType() => listType.clear();
  // 你也可以直接操作.value
  // clearListType() => listType.value = [];
  
  /// 添加数据
  addListType(int value) => listType.add(value);

  /// 更新指定下标数据
  updateListType(int index) => listType[index]++;
}

void page() {
  IconButton(
    onPressed: () {
      c.addListType(c.listType.length + 1);
    },
    icon: const Icon(Icons.add),
  );
  Obx(() =>
      ListView.builder(
        itemCount: c.listType.length,
        itemBuilder: (context, i) =>
            ListTile(
              onTap: () {
                c.updateListType(i);
              },
              title: Text(c.listType[i].toString()),
            ),
      ));
}
```

- List响应式变量(Map类型)
```dart
class Controller extends GetxController {
  final listMapType = <Map<String, dynamic>>[
    {'name': 'hihi', 'age': 20}
  ].obs;

  /// 清空数据
  clearListMapType() => listMapType.clear();

  /// 添加数据
  addListMapType() => listMapType.add({'name': 'hihi', 'age': 20});

  /// 更新指定下标数据
  updateListMapType(int index) => listMapType[index] = {'name': 'hello', 'age': 100};

  /// 更新指定下标Map对象的部分数据
  partListMapType(int index) => listMapType[index] = {...listMapType[index], 'age': 1000};

  /// 注意：此处有一个坑，直接操作列表对象的内部属性是不会生效的，因为getx仅仅对list做拦截，它拦截不到Map对象内部属性，
  /// 若你直接这样操作，那么你必须手动调用[refresh]函数才能刷新页面。
  /// 
  /// 实际原理是，你当前操作的[]运算符是getx重写的，dart允许你对一些运算符重写，它有一个关键字：[operator]，
  /// listMapType[index]赋值之所以能生效，是因为getx通过[operator]重写了 "[]=" 运算符，当你设置新的值后会在内部调用[refresh]函数
  partListMapType2(int index) {
    listMapType[index]['age'] = 1000;
    listMapType.refresh();
  }
}

void page() {
  IconButton(
    onPressed: () {
      c.addListType(c.listType.length + 1);
    },
    icon: const Icon(Icons.add),
  );
  Obx(() =>
      ListView.builder(
        itemCount: c.listType.length,
        itemBuilder: (context, i) =>
            ListTile(
              onTap: () {
                c.updateListType(i);
              },
              title: Text(c.listType[i].toString()),
            ),
      ));
}
```