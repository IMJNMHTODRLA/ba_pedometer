import 'package:flutter/material.dart';
import 'package:ba_pedometer/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:ba_pedometer/pedometer/pedometer.dart';
import 'package:ba_pedometer/location/location.dart';

class PerdometerScreen extends StatefulWidget {
    const PerdometerScreen({super.key, required this.title});

    final String title;

    @override
    State<PerdometerScreen> createState() => _PerdometerScreenState();
}

class _PerdometerScreenState extends State<PerdometerScreen> {
	final int _keiAngryTime = 30;

	final Pedometer _pedometer = Pedometer();
	final Location _location = Location();

	Timer? _secondLoopTimer;
	int _stopTime = 0;
	int _sameLocationTime = 0;
	
	void _loopTimer() {
		if (_secondLoopTimer != null) return;

		_secondLoopTimer = (timer) {
			if (!mounted) return;

			_updateStopTime();
			_updateSameLocationTime();

			setState(() {});
		}.runTimerPeriodic(const Duration(seconds: 1));
	}
	
	void _updateStopTime() {
		final DateTime? stopAt = _pedometer.stopAt;
		if (stopAt == null) {
			if (_stopTime != 0) _stopTime = 0;
			return;
		}
		
		_stopTime = DateTime
			.now()
			.difference(stopAt)
			.inSeconds;
	}

	void _updateSameLocationTime() {
		final Position? location = _location.lastPosition;
		if (location == null) {
			if (_sameLocationTime != 0) _sameLocationTime = 0;
			return;
		}

		_sameLocationTime = DateTime
			.now()
			.difference(location.timestamp)
			.inSeconds;
	}

	@override
	void initState() {
		super.initState();

		_pedometer.runListen();
		_loopTimer();

		_pedometer.notifyListeners = () {
			if (mounted) setState(() {});
		}; //TODO: 나중에 생각

		_location.notifyLocation = (Position _) {
			if (mounted) setState(() {});
		};

		_location.runListen();
	}

	@override
  	void dispose() {
    	super.dispose();

		_pedometer.stopPedometer();
		_location.stopLocation();
		_secondLoopTimer?.cancel();
  	}

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            /*appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
            ),*/

			backgroundColor: Color(0xFFE594AB),
			
            body: Stack(
				children: [
					Text(
						'${_pedometer.stpes} 걸음\n멈춘 시간: ${_stopTime}s\n위치 안 변하는 시간: ${_sameLocationTime}s',
						style: TextStyle(
							fontSize: 40,
							fontWeight: FontWeight.bold,
							color: const Color(0xFFFFFFFF),
						),
					).toAlign(0.0, -0.5),

					Text(
						'KEI: 도대체 얼마나 쉬는건데요!!\n선생: 저... 저기 케이, 일단 진정하고.....',
						style: TextStyle(
							fontSize: 20,
							fontWeight: FontWeight.bold,
							color: const Color(0xFFFFFFFF)
								.withValues(
									alpha: (_stopTime > _keiAngryTime)
										? 1.0 : 0.0
								),
						),
					).toAlign(0.0, 0.1),

					Text(
						'KEI: 위치는 안 변하는데 걸음 횟수는 올라가네요...?\n선생: 아',
						style: TextStyle(
							fontSize: 20,
							fontWeight: FontWeight.bold,
							color: const Color(0xFFFFFFFF)
								.withValues(
									alpha: (
										_sameLocationTime > 30 &&
										_stopTime < 1
									) ? 1.0 : 0.0
								),
						),
					).toAlign(0.0, 0.3)
				],
            ),
        );
    }
}