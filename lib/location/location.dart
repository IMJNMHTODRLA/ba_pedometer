import 'package:geolocator/geolocator.dart';
import 'package:ba_pedometer/error_screen.dart';
import 'package:ba_pedometer/ui_updater.dart';

import 'dart:async';

class Location with UiUpdater {
	Position? lastPosition;

	StreamSubscription<Position>? _positionStreamSubscription;

	Future<String?> checkPermission() async {
		final bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
		if (!isServiceEnabled) return "locationServiceEnabled is false";

		LocationPermission permission = await Geolocator.checkPermission();
		if (permission == LocationPermission.denied) {
			permission = await Geolocator.requestPermission();
			if (permission == LocationPermission.denied) return "permission denied";
		}

		if (permission == LocationPermission.deniedForever) return "permission deniedForever";

		return null;
	}

	void runListen() async {
		final String? error = await checkPermission();

		if (error != null) ErrorScreen(message: error);

		_positionStreamSubscription = Geolocator.getPositionStream(
			locationSettings: const LocationSettings(
				accuracy: LocationAccuracy.bestForNavigation,
				distanceFilter: 1,
			)
		).listen((Position position) {
			lastPosition = position;
			updateUI();
		});
	}

	void stopLocation() {
		_positionStreamSubscription?.cancel();
	}
}
