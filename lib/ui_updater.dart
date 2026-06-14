mixin UiUpdater {
	void Function()? notifyListeners;

	void updateUI() => notifyListeners?.call();
}