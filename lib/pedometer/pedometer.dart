import 'package:ba_pedometer/pedometer/pedometer_status.dart';

import 'package:ba_pedometer/utils.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'dart:math';
import 'dart:async';

class Pedometer {
	int stpes = 0;
    PedometerStatus status = PedometerStatus.stopped;

	DateTime? stopAt;
	DateTime lastStepTime = DateTime.now();
    
	Timer? _walkingCheckTimer;
    StreamSubscription? _accelerometerSubscription;
    
    final double _minStepThreshold = 13.5;
	final double _maxStepThreshold = 15.0;

    // 가속도 센서로 걸음 감지
    void runListen() => _accelerometerSubscription =
		accelerometerEventStream().listen((AccelerometerEvent event) {
			_updateUI();

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
			if (now.difference(lastStepTime).ms <= 400) return;

			stpes++;
			status = PedometerStatus.walking;
			stopAt = null;

			lastStepTime = now;
			_triggerWalkingTimeout();
		});

    // 폰이 일정 시간 동안 안 흔들리면 'stopped' 상태로 바꾸는 안전장치
    void _triggerWalkingTimeout() {
		_updateUI();
        _walkingCheckTimer?.cancel();

		_walkingCheckTimer = () {
			final DateTime now = DateTime.now();

            status = PedometerStatus.stopped;
            stopAt = now;

			_updateUI();
        }.runTimer(const Duration(seconds: 1));
    }

    void stopPedometer() {
        _accelerometerSubscription?.cancel();
        _walkingCheckTimer?.cancel();
    }

	void Function()? notifyListeners;

	void _updateUI() {
		if (notifyListeners != null) notifyListeners!();
	}
}