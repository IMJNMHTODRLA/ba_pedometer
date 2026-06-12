import 'package:flutter/material.dart';
import 'package:ba_pedometer/utils.dart';

class ErrorScreen extends StatefulWidget {
    const ErrorScreen({super.key, required this.message});

    final String message;

    @override
    State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
    @override
    Widget build(BuildContext context) =>
    	Scaffold(
			backgroundColor: Colors.black,
            body: Text(
				'''
					에러가 발생하였습니다.
					메시지: ${widget.message}
				''',
				style: TextStyle(
					fontSize: 10,
					color: Colors.white,
				),
			).toAlign(0.0, 0.0),
        );
}