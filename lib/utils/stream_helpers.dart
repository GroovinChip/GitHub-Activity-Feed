import 'package:rxdart/rxdart.dart';

typedef AsyncOperation<T> = Future<T> Function();

void updateBehaviorSubjectAsync<T>(BehaviorSubject<T> subject, AsyncOperation<T> operation) {
  if (!subject.hasValue) {
    operation().then((data) {
      if (!subject.isClosed) {
        subject.value = data;
      }
    }).catchError((error, stackTrace){
      print('UPDATE ERROR\n$error\n$stackTrace');
      subject.addError(error, stackTrace);
    });
  }
}
