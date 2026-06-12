import 'dart:async';
import 'package:flutter/material.dart';

extension DurationExtension on Duration {
	int get ms => inMilliseconds;
}

extension WidgetExtension on Widget {
	Widget toAlign(final double x, final double y) =>
		Align(alignment: Alignment(x, y), child: this);
}

extension TimerExtension on void Function(Timer timer) {
	Timer runTimerPeriodic(final Duration duration) =>
		Timer.periodic(duration, (timer) => this(timer));
}

extension Timer2Extension on void Function() {
	Timer runTimer(final Duration duration) =>
		Timer(duration, () => this());
}
