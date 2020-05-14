import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef SubjectValueBuilder<T> = Widget Function(BuildContext context, T value);
typedef SubjectLoadingBuilder<T> = Widget Function(BuildContext context);
typedef SubjectErrorBuilder<T> = Widget Function(BuildContext context, dynamic error);

class SubjectStreamBuilder<T> extends StatelessWidget {
  const SubjectStreamBuilder({
    Key key,
    this.subject,
    this.builder,
    this.errorBuilder,
    this.loadingBuilder,
  }) : super(key: key);

  final BehaviorSubject<T> subject;
  final SubjectValueBuilder<T> builder;
  final SubjectErrorBuilder errorBuilder;
  final SubjectLoadingBuilder loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: subject.value,
      stream: subject,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          if (errorBuilder != null) {
            return errorBuilder(context, snapshot.error);
          } else {
            return ErrorWidget(snapshot.error);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          if (loadingBuilder != null) {
            return loadingBuilder(context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return builder(context, snapshot.data);
        }
      },
    );
  }
}
