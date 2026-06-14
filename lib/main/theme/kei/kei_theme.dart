import 'dart:math';

import 'package:ba_pedometer/utils.dart';
import 'package:ba_pedometer/main/theme/theme.dart';

enum _KeiThemeImages implements ThemeImages {
	avoidingEyes('assets/kei/avoiding_eyes.png'),
	goodSensei('assets/kei/good_sensei.png'),
	hypnosis('assets/kei/hypnosis.png'),
	mataq('assets/kei/mataq.png'),
	normal('assets/kei/normal.png'),
	veryAngry('assets/kei/very_angry.png'),
	what('assets/kei/what.png');

	@override
	final String path;

	const _KeiThemeImages(this.path);
}

class KeiTheme extends Theme {
	final List<List<(String, ThemeImages)>> _steps50Down = [
		[
			('...네, 부르셨나요.', _KeiThemeImages.normal),
			('그냥 심심해서 불렀다고요...?', _KeiThemeImages.what),
			('빨리 걷기나 하세요!', _KeiThemeImages.veryAngry)
		],
		[
			('%step% 걸음 걸어놓고 잡담하시는 건가요...', _KeiThemeImages.mataq),
			('정말이지, 조금은 노력해주세요...', _KeiThemeImages.avoidingEyes),
		],
	];

	final List<List<(String, ThemeImages)>> _stepsFinal = [
		[
			('목표치인 10000 걸음에 도달하셨네요.', _KeiThemeImages.normal),
			('뭔가요, 이 무언가를 기대하는 표정은...?', _KeiThemeImages.what),
			('...해드리면 되잖아요!', _KeiThemeImages.veryAngry),
			('잘하셨어요... 선생님.', _KeiThemeImages.avoidingEyes),
		],
		[
			('선생님, 오늘처럼 다음에도 저랑 같이 걷는거에요?', _KeiThemeImages.goodSensei),
			('아, 아니 선생님이 좋아서가 아니라', _KeiThemeImages.hypnosis),
			('왜, 왜 이렇게 히죽히죽 웃어요!!', _KeiThemeImages.veryAngry),
		],
	];

	@override
	ThemeImages defaultImage = _KeiThemeImages.normal;

	@override
	List<(String, ThemeImages)>? getTextAndImage(
		final int steps,
		final int stopTime,
		final int sameLocationTime
	) {
		if (steps < 50) {
			return _steps50Down.getOrNull(Random().nextInt(2));
		}

		if (steps >= 50) {
			return _stepsFinal.getOrNull(Random().nextInt(2));
		}

		return null;
	}
}
