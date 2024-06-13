mini getx, only include state manager，remove '
router、binding、http、GetBuilder、Getx、ContextExt、GetUtils...',
does not include any third party dependencies

# Which have been retained?

1. GetxController、obs、Obx - core reactive api
2. Get.put、Get.find、Get.delete - dependency management
3. ever、once、interval - effect function

# Example

- 1.Create Controller

```dart
class Controller extends GetxController {
  final count = 0.obs;

  addCount() => count.value++;
}
```

- 2.Binding Controller

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
        title: const Text('Count Example'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                c.addCount();
              },
              child: Obx(() => Text('count: ${c.count.value}')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Child()));
              },
              child: const Text('Child Page'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- 3.Other Page Visit Controller

```dart
class Child extends StatelessWidget {
  Child({super.key});

  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    Controller c = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Page'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                c.count.value++;
              },
              child: Obx(() => Text('count: ${c.count.value}')),
            ),
          ],
        ),
      ),
    );
  }
}
```