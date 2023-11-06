// ignore_for_file: file_names

import 'dart:async';

class PageTimerManager {
  Timer? _timer;
  final String pageName;
  final Function fetchFunction;

  PageTimerManager(this.pageName, this.fetchFunction);

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: _getInterval()), (_) {
      fetchFunction();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  int _getInterval() {
    if (pageName == 'avdel') {
      return 10; // 10 seconds for Avdel page
    } else if (pageName == 'carrellista') {
      return 3; // 3 seconds for Carrellista page
    } else if (pageName == 'op40') {
      return 1; // 3 seconds for Carrellista page
    }
    return 0; // Default to 0 seconds if the page is not recognized
  }
}
