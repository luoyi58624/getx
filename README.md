- 精简getx，仅包含响应式状态管理、以及一些很方便工具扩展函数，移除路由、依赖绑定、http请求、GetBuilder、Getx等api
- getx是一款很优秀的状态管理库，但是它太庞杂了，很多时候我们往往只需要一个能够保存全局状态的库罢了，所以，此库仅仅包含了
  getx的obs响应式状态相关的api

# 使用

- 1.创建控制器

```dart
class Controller extends GetxController {
  final count = 0.obs;

  addCount() => count++;
}
```

- 2.在页面上绑定控制器，与Getx官方示例不同的是，你必须在dispose生命周期中手动销毁控制器，
  因为我们已经移除了Getx路由相关的api，它无法自动感知何时销毁控制器

```dart
class GetxPage extends StatefulWidget {
  const GetxPage({super.key});

  @override
  State<GetxPage> createState() => _GetxPageState();
}

class _GetxPageState extends State<GetxPage> {
  final c = Get.put(Controller());

  @override
  void dispose() {
    super.dispose();
    Get.delete<Controller>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            c.addCount();
          },
          child: Obx(() => Text('count: ${c.count.value}')),
        ),
      ),
    );
  }
}
```

- 3.其他页面访问全局状态，通过Get.find()获取之前注册的控制器

```dart
class ChildPage extends StatelessWidget {
  const ChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    Controller c = Get.find();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            c.addCount();
          },
          child: Obx(() => Text('count: ${c.count.value}')),
        ),
      ),
    );
  }
}
```

以上就是精简后的Getx状态管理全部内容了，所谓的状态管理就是管理应用的全局状态，你实际上不需要将它想象得有多复杂，
你只需要记得三点：
- 定义控制器 - extends GetxController
- 注入控制器 - Get.put()
- 拿到控制器 - Get.find()