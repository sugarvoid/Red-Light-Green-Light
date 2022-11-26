extends Control


onready var timer: Timer = get_node("Timer")
onready var btn_start: Button = get_node("BtnStart")
onready var txt_min_sec: TextEdit = get_node("TxtMinSeconds")
onready var txt_max_sec: TextEdit = get_node("TxtMaxSeconds")
onready var txt_rounds: TextEdit = get_node("TxtRounds")
onready var color_square: ColorRect = get_node("ModeColorRect")


enum STATES {
	RED,
	GREEN,
	NOT_PLAYING
}

var state: int = STATES.NOT_PLAYING
var total_rounds: int
var current_round: int
var min_sec: float
var max_sec: float
var rng: RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	self.timer.connect("timeout", self, "_on_timer_timeout")
	self.btn_start.connect("pressed", self, "_start_game")


func _start_new_round():
	self.state = STATES.GREEN
	_update_square_color()
	rng.randomize()
	var round_length: float = rng.randf_range(min_sec, max_sec)
	print(str('Round ', self.current_round))
	print(str('Green for ', round_length, ' seconds'))
	self.timer.start(round_length)


func _start_rest_mode():
	self.state = STATES.RED
	_update_square_color()
	rng.randomize()
	var round_length: float = rng.randf_range(min_sec, max_sec)
	print(str('Red for ', round_length, ' seconds'))
	self.timer.start(round_length)


func _start_game():
	if self.txt_max_sec.text.empty() || self.txt_min_sec.text.empty() || self.txt_rounds.text.empty():
		return
	
	self.current_round = 1
	self.min_sec = int(txt_min_sec.text)
	self.max_sec = int(txt_max_sec.text)
	self.total_rounds = int(txt_rounds.text)
	
	self._start_new_round()

func _on_timer_timeout():
	if self.state == STATES.GREEN:
		if self.current_round < total_rounds:
			current_round += 1
			self._start_rest_mode()
		else:
			print('game over')
			state = STATES.NOT_PLAYING
			self._clear_txt_boxes()
			self.timer.stop()
			_update_square_color()
	elif self.state == STATES.RED:
		self._start_new_round()
		

func _clear_txt_boxes() -> void:
	self.txt_max_sec.text = ""
	self.txt_min_sec.text = ""
	self.txt_rounds.text = ""

func _update_square_color():
	match self.state:
		STATES.GREEN:
			self.color_square.color = Color.green
		STATES.RED:
			self.color_square.color = Color.red
		STATES.NOT_PLAYING:
			self.color_square.color = Color.whitesmoke
