import 'package:flutter/material.dart';
import 'package:ba_pedometer/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:ba_pedometer/pedometer/pedometer.dart';
import 'package:ba_pedometer/location/location.dart';

import 'package:ba_pedometer/main/theme/theme.dart' as ba;

class PerdometerScreen extends StatefulWidget {
    const PerdometerScreen({super.key, required this.theme});

    final ba.Theme theme;

    @override
    State<PerdometerScreen> createState() => _PerdometerScreenState();
}

class _PerdometerScreenState extends State<PerdometerScreen> {
	final Pedometer _pedometer = Pedometer();
	final Location _location = Location();

	Timer? _secondLoopTimer;
	int _stopTime = 0;
	int _sameLocationTime = 0;
	
	late ba.ThemeImages _nowImage = widget.theme.defaultImage;
	String? _nowText;
	bool _isSendText = false;

	void _clickGetText() async {
		if (_isSendText) return;

		List<(String, ba.ThemeImages)>? textList = widget.theme.getTextAndImage(
			_pedometer.stpes,
			_stopTime,
			_sameLocationTime
		);

		if (textList == null) return;

		textList = textList.map((entry) {
			final (String text, ba.ThemeImages image) = entry;

			final String stringSteps = _pedometer.stpes.toString();
			final String replaceText = text.replaceAll("%step%", stringSteps);

			return (replaceText, image);
		}).toList();

		_isSendText = true;

		for (
			final (String text, ba.ThemeImages image) 
			in textList
		) {
			setState(() {
				_nowImage = image;
				_nowText = text;
			});

			final int delay = text.length * 110;
			await Future.delayed(Duration(milliseconds: delay)); 
		}
		
		_nowImage = widget.theme.defaultImage;
		_nowText = null;

		_isSendText = false;
	}

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

		_pedometer.notifyListeners = () {
			if (!mounted) setState(() {});
		};
		_location.notifyListeners = () {
			if (!mounted) setState(() {});
		};

		_pedometer.runListen();
		_location.runListen();
		_loopTimer();
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
		final double screenWidth = MediaQuery.of(context).size.width;
		final double screenHeight = MediaQuery.of(context).size.height;

        return Scaffold(
			backgroundColor: Color(0xFFE594AB),
			
            body: Stack(
				children: [
					Text(
						'${_pedometer.stpes} 걸음',
						style: TextStyle(
							fontSize: 45,
							fontWeight: FontWeight.bold,
							color: const Color(0xFFFFFFFF),
						),
					).toAlign(0.0, -0.7),

					Image.asset(
						_nowImage.path,

						width: screenWidth * 0.85,
						height: screenHeight * 0.85,

						fit: BoxFit.contain,
					)
					.toAlign(0.5, 1.85)
					.toOnTap(() => _clickGetText()),

					Text(
						_nowText ?? '',
						style: TextStyle(
							fontSize: 20,
							fontWeight: FontWeight.bold,

							color: Colors.black
								.withValues(
									alpha: (_nowText != null) ? 1.0 : 0.0
								),

							backgroundColor: Colors.white
								.withValues(
									alpha: (_nowText != null) ? 1.0 : 0.0
								),
						),
					).toAlign(0.0, 0.1)
				],
            ),
        );
    }
}