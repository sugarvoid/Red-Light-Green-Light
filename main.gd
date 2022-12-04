extends Control

onready var tmr_main: Timer = get_node("TmrMain")
onready var tmr_round: Timer = get_node("Timer")
onready var btn_start: Button = get_node("BtnStart")
onready var txt_game_min: TextEdit = get_node("TxtRounds")
onready var opb_go: OptionButton = get_node("OpbGo")
onready var opb_rest: OptionButton = get_node("OpbRest")
onready var color_square: ColorRect = get_node("colorSquare")
onready var aud_ding: AudioStreamPlayer = get_node("AudDing")

const TIMES: Dictionary = {
	# Short Rounds
	'red_short_min': 3.0,
	'red_short_max': 8.0,
	
	'green_short_min': 4.0,
	'green_short_max': 9.0,
	
	
	# Long Rounds
	'red_long_min': 10.0,
	'red_long_max': 20.0,
	
	'green_long_min': 6.0,
	'green_long_max': 15.0,
}

enum STATES {
	RED,
	GREEN,
	NOT_PLAYING,
}


var state: int = STATES.NOT_PLAYING
var current_round: int
var rng: RandomNumberGenerator
var game_length: int


func _ready():
	self.color_square.color = Color.whitesmoke
	## self._inlarge_window()
	self.rng = RandomNumberGenerator.new()
	self.tmr_main.connect("timeout", self, "_game_over")
	self.tmr_round.connect("timeout", self, "_on_timer_timeout")
	self.btn_start.connect("pressed", self, "_start_game")


func _start_new_round():
	var min_s: float
	var max_s: float
	self._play_ding()
	self.state = STATES.GREEN
	$AudWait.stop()
	_update_square_color()

	match self.opb_go.selected:
		0:
			min_s = self.TIMES.green_short_min
			max_s = self.TIMES.green_short_max
		1:
			min_s = self.TIMES.green_long_min
			max_s = self.TIMES.green_long_max
	
	var round_length: float = self._get_round_length(min_s, max_s) 
	
	print(str('Green for ', round_length, ' seconds'))
	
	self.tmr_round.start(round_length)


func _start_rest_mode():
	var min_s: float
	var max_s: float
	self.state = STATES.RED
	_update_square_color()
	
	match self.opb_rest.selected:
		0:
			min_s = self.TIMES.red_short_min
			max_s = self.TIMES.red_short_max
		1:
			min_s = self.TIMES.red_long_min
			max_s = self.TIMES.red_long_max
	
	var round_length: float = self._get_round_length(min_s, max_s) 
	print(str('Red for ', round_length, ' seconds'))
	$AudWait.play()
	self.tmr_round.start(round_length)


func _start_game():
	if self.txt_game_min.text.empty():
		return
	self.game_length = int(txt_game_min.text)* 60
	self.tmr_main.start(game_length)
	self._start_new_round()


func _on_timer_timeout():
	if self.state == STATES.GREEN:
		self._start_rest_mode()
	elif self.state == STATES.RED:
		self._start_new_round()
		

func _clear_txt_boxes() -> void:
	print('game over')

	self.txt_game_min.text = ""


func _get_round_length(lowest: float, highest: float) -> float:
	rng.randomize()
	return rng.randf_range(lowest, highest) 


func _inlarge_window() -> void:
	OS.set_window_size(Vector2(1650, 900))


func _update_square_color():
	match self.state:
		STATES.GREEN:
			self.color_square.color = Color.green
		STATES.RED:
			self.color_square.color = Color.red
		STATES.NOT_PLAYING:
			self.color_square.color = Color.whitesmoke


func _play_ding() -> void:
	self.aud_ding.play()


func _game_over():
	$AudWait.stop()
	self.state = STATES.NOT_PLAYING
	self._clear_txt_boxes()
	self.tmr_main.stop()
	_update_square_color()
