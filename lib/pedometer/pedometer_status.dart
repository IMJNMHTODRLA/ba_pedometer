enum PedometerStatus {
	walking('walking'),
	stopped('stopped'),
	unknown('unknown');

	final String value;
  	const PedometerStatus(this.value);

	static PedometerStatus toPedometerStatus(final String stringStatus) =>
		switch (stringStatus) {
			'walking' => walking,
			'stopped' => stopped,
			_ => unknown,
		};
}
