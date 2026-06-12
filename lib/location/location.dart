import 'package:geolocator/geolocator.dart';
import 'package:ba_pedometer/error_screen.dart';

import 'dart:async';

class Location {
	//List<Position> positionList = [];
	//필요없다고 판단
	
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
				//distanceFilter: 1,
				//TODO: 테스트 때는 삭제
			)
		).listen((Position position) {
			//positionList.add(position);
			lastPosition = position;

			_updateLocation(position);
		});
	}

	void stopLocation() {
		_positionStreamSubscription?.cancel();
	}

	void Function(Position)? notifyLocation;

	void _updateLocation(Position position) {
		if (notifyLocation != null) notifyLocation!(position);
	}
}
