import 'package:ba_pedometer/pedometer/pedometer_status.dart';
import 'package:ba_pedometer/ui_updater.dart';

import 'package:ba_pedometer/utils.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'dart:math';
import 'dart:async';

class Pedometer with UiUpdater {
	int stpes = 0;
    PedometerStatus status = PedometerStatus.stopped;

	DateTime? stopAt;
	DateTime lastStepTime = DateTime.now();
    
	Timer? _walkingCheckTimer;
    StreamSubscription? _accelerometerSubscription;
    
    final double _minStepThreshold = 13.0;
	final double _maxStepThreshold = 18.0;

    void runListen() => _accelerometerSubscription =
		accelerometerEventStream(
			samplingPeriod: SensorInterval.fastestInterval
		).listen((AccelerometerEvent event) {
			// 3축 가속도를 이용하여 전체 움직임 벡터 크기 계산 (피타고라스 정리 정리)
			double accelerationMagnitude = sqrt(
				event.x * event.x + event.y * event.y + event.z * event.z
			);

			if (
				accelerationMagnitude <= _minStepThreshold ||
				accelerationMagnitude > _maxStepThreshold
			) return;

			// 설정한 임계값을 넘었고, 마지막 걸음 마킹 후 0.4초(인간이 걸을 수 있는 최소 간격)가 지났다면 걸음으로 인정
			DateTime now = DateTime.now();
			if (now.difference(lastStepTime).ms <= 300) return;

			stpes++;
			status = PedometerStatus.walking;
			stopAt = null;

			lastStepTime = now;
			_triggerWalkingTimeout();

			updateUI();
		});

    void _triggerWalkingTimeout() {
        _walkingCheckTimer?.cancel();

		_walkingCheckTimer = () {
			updateUI();
			final DateTime now = DateTime.now();

            status = PedometerStatus.stopped;
            stopAt = now;
        }.runTimer(const Duration(seconds: 1));
    }

    void stopPedometer() {
        _accelerometerSubscription?.cancel();
        _walkingCheckTimer?.cancel();
    }
}