import 'dart:async';

class SideMenuController {
  late int _currentPage;

  int get currentPage => _currentPage;

  SideMenuController({int initialPage = 0}) {
    _currentPage = initialPage;
  }
  final _streamController = StreamController<int>.broadcast();

  Stream<int> get stream => _streamController.stream;

  void changePage(int index) {
    _currentPage = index;
    _streamController.sink.add(index);
  }

  void dispose() {
    _streamController.close();
  }

  void addListener(void Function(int index) listener) {
    _streamController.stream.listen(listener);
  }

  void removeListener(void Function(int) listener) {
    _streamController.stream.listen(listener).cancel();
  }
}
