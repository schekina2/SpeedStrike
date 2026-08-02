extends Node

func _ready():
	var player = AudioStreamPlayer.new()
	add_child(player)
	start_music(player)

func generate_tone(frequency: float, duration: float, wave_type: String = "sine") -> AudioStreamWAV:
	var sample_rate = 44100
	var num_samples = int(sample_rate * duration)
	var data = PackedByteArray()
	data.resize(num_samples * 2)

	for i in range(num_samples):
		var t = float(i) / sample_rate
		var envelope = 1.0 - (float(i) / num_samples)
		var value: float

		match wave_type:
			"sine":
				value = sin(TAU * frequency * t)
			"square":
				value = sign(sin(TAU * frequency * t))
			"noise":
				value = randf_range(-1.0, 1.0)

		value *= envelope * 0.3
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
	
var music_player: AudioStreamPlayer
var is_muted: bool = false

func generate_music_loop() -> AudioStreamWAV:
	var sample_rate = 44100
	var duration = 4.0
	var num_samples = int(sample_rate * duration)
	var data = PackedByteArray()
	data.resize(num_samples * 2)

	var notes = [220.0, 261.6, 329.6, 261.6]
	var note_duration = duration / notes.size()

	for i in range(num_samples):
		var t = float(i) / sample_rate
		var note_index = int(t / note_duration) % notes.size()
		var freq = notes[note_index]
		var local_t = fmod(t, note_duration)

		var value = sin(TAU * freq * local_t) * 0.15
		value += sin(TAU * freq * 2 * local_t) * 0.05

		var sample = int(value * 32767)
		sample = clamp(sample, -32768, 32767)
		data.encode_s16(i * 2, sample)

	var stream = AudioStreamWAV.new()
	stream.data = data
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = num_samples
	return stream

func start_music(player: AudioStreamPlayer):
	music_player = player
	music_player.stream = generate_music_loop()
	music_player.volume_db = -10
	if not is_muted:
		music_player.play()

func toggle_mute():
	is_muted = not is_muted
	if music_player:
		if is_muted:
			music_player.stop()
		else:
			music_player.play()
	return is_muted
