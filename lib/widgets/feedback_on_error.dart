import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

class FeedbackOnError extends StatelessWidget {
  const FeedbackOnError({
    @required this.message,
    Key key,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          RaisedButton(
            child: Text('Report to developer'),
            onPressed: () => Wiredash.of(context).show(),
          ),
        ],
      ),
    );
  }
}
