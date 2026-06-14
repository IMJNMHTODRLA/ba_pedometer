import 'dart:async';
import 'package:flutter/material.dart';

extension DurationExtension on Duration {
	int get ms => inMilliseconds;
}

extension WidgetExtension on Widget {
	Widget toOnTap(void Function()? onTap) =>
		GestureDetector(onTap: onTap, child: this);

	Widget toAlign(
		final double x, final double y,
		{final bool isOverlap = false}
	) {
		final Align alignChild = Align(
			alignment: Alignment(x, y),
			child: this,
		);

		if (isOverlap) {
			return Positioned.fill(
				child: alignChild,
			);
		}

		return alignChild;
	}
}

extension TimerExtension on void Function(Timer timer) {
	Timer runTimerPeriodic(final Duration duration) =>
		Timer.periodic(duration, (timer) => this(timer));
}

extension Timer2Extension on void Function() {
	Timer runTimer(final Duration duration) =>
		Timer(duration, () => this());
}

extension ListExtension<T> on List<T> {
	T? getOrNull(int index) {
		if (index >= 0 && index < length) {
			return this[index];
		}
		return null;
	}
}
