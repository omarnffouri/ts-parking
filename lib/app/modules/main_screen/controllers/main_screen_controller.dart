import 'package:get/get.dart';

class MainScreenController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
  }
}
