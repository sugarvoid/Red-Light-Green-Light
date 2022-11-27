extends Control


onready var timer: Timer = get_node("Timer")
onready var btn_start: Button = get_node("BtnStart")

onready var txt_green_min: TextEdit = get_node("TxtGreenMin")
onready var txt_green_max: TextEdit = get_node("TxtGreenMax")

onready var txt_red_min: TextEdit = get_node("TxtRedMin")
onready var txt_red_max: TextEdit = get_node("TxtRedMax")

onready var txt_rounds: TextEdit = get_node("TxtRounds")
onready var light: Sprite = get_node("Light")


enum STATES {
	RED,
	GREEN,
	NOT_PLAYING
}

var state: int = STATES.NOT_PLAYING
var total_rounds: int
var current_round: int
var green_min: float
var green_max: float
var red_min: float
var red_max: float
var rng: RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()
	self.timer.connect("timeout", self, "_on_timer_timeout")
	self.btn_start.connect("pressed", self, "_start_game")


func _start_new_round():
	self.state = STATES.GREEN
	_update_square_color()
	rng.randomize()
	var round_length: float = rng.randf_range(red_min, red_max)
	print(str('Round ', self.current_round))
	print(str('Green for ', round_length, ' seconds'))
	self.timer.start(round_length)


func _start_rest_mode():
	self.state = STATES.RED
	_update_square_color()
	rng.randomize()
	var round_length: float = rng.randf_range(green_min, green_max)
	print(str('Red for ', round_length, ' seconds'))
	self.timer.start(round_length)


func _start_game():
	if self.txt_green_max.text.empty() || self.txt_green_min.text.empty() || self.txt_rounds.text.empty():
		return
	
	self.current_round = 1
	self.red_min = int(txt_red_min.text)
	self.red_max = int(txt_red_max.text)
	self.green_min = int(txt_green_min.text)
	self.green_max = int(txt_green_max.text)
	self.total_rounds = int(txt_rounds.text)
	
	self._start_new_round()

func _on_timer_timeout():
	if self.state == STATES.GREEN:
		if self.current_round < total_rounds:
			current_round += 1
			self._start_rest_mode()
		else:
			state = STATES.NOT_PLAYING
			self._clear_txt_boxes()
			self.timer.stop()
			_update_square_color()
	elif self.state == STATES.RED:
		self._start_new_round()
		

func _clear_txt_boxes() -> void:
	self.txt_green_min.text = ""
	self.txt_green_max.text = ""
	self.txt_red_min.text = ""
	self.txt_red_max.text = ""
	self.txt_rounds.text = ""

func _update_square_color():
	match self.state:
		STATES.GREEN:
			self.light.frame = 2
		STATES.RED:
			self.light.frame = 1
		STATES.NOT_PLAYING:
			self.light.frame = 0
