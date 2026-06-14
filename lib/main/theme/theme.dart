abstract interface class ThemeImages {
	String get path;
}

abstract class Theme {
	ThemeImages get defaultImage;

	List<(String, ThemeImages)>? getTextAndImage(
		final int steps,
		final int stopTime,
		final int sameLocationTime
	);
}
