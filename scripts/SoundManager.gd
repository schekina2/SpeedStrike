extends Node

func generate_tone(frequency: float, duration: float, wave_type: String = "sine") -> AudioStreamWAV:
	var sample_rate = 44100
	var num_samples = int(sample_rate * duration)
	var data = PackedByteArray()
	data.resize(num_samples * 2)

	for i in range(num_samples):
		var t = float(i) / sample_rate
		var envelope = 1.0 - (float(i) / num_samples)  # fade out
		var value: float

		match wave_type:
			"sine":
				value = sin(TAU * frequency * t)
			"square":
				value = sign(sin(TAU * frequency * t))
			"noise":
				value = randf_range(-1.0, 1.0)

		value *= envelope * 0.3  # volume
		var sample = int(value * 32767)
		sample = clamp(sample, -32768, 32767)
		data.encode_s16(i * 2, sample)

	var stream = AudioStreamWAV.new()
	stream.data = data
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	return stream

func play_eat_sound(player: AudioStreamPlayer):
	player.stream = generate_tone(600, 0.1, "sine")
	player.play()

func play_dash_sound(player: AudioStreamPlayer):
	player.stream = generate_tone(300, 0.15, "square")
	player.play()

func play_kill_sound(player: AudioStreamPlayer):
	player.stream = generate_tone(150, 0.2, "noise")
	player.play()

func play_game_over_sound(player: AudioStreamPlayer):
	player.stream = generate_tone(100, 0.5, "square")
	player.play()
