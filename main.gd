extends Control


onready var go_time: ModeTime = get_node("GoTime")
onready var rest_time: ModeTime = get_node("StopTime")

onready var timer: Timer = get_node("Timer")
onready var btn_start: Button = get_node("BtnStart")

onready var txt_rounds: TextEdit = get_node("TxtRounds")
onready var light: Sprite = get_node("Light")


enum STATES {
	RED,
	GREEN,
	NOT_PLAYING,
}

var state: int = STATES.NOT_PLAYING
var total_rounds: int
var current_round: int
var rng: RandomNumberGenerator


func _ready():
	self.rng = RandomNumberGenerator.new()
	self.timer.connect("timeout", self, "_on_timer_timeout")
	self.btn_start.connect("pressed", self, "_start_game")


func _start_new_round():
	self.state = STATES.GREEN
	_update_square_color()
	var round_length: int = self._get_round_length(go_time.get_min_time(), go_time.get_max_time()) 
	print(str('Round ', self.current_round))
	print(str('Green for ', round_length, ' seconds'))
	self.timer.start(round_length)


func _start_rest_mode():
	self.state = STATES.RED
	_update_square_color()
	var round_length: int = self._get_round_length(rest_time.get_min_time(), rest_time.get_max_time()) 
	print(str('Red for ', round_length, ' seconds'))
	self.timer.start(round_length)


func _start_game():
	if self.go_time.has_blank_spots() || self.rest_time.has_blank_spots():
		return
	self.current_round = 1
	self.total_rounds = int(txt_rounds.text)
	self._start_new_round()


func _on_timer_timeout():
	if self.state == STATES.GREEN:
		if self.current_round < total_rounds:
			self.current_round += 1
			self._start_rest_mode()
		else:
			self.state = STATES.NOT_PLAYING
			self._clear_txt_boxes()
			self.timer.stop()
			_update_square_color()
	elif self.state == STATES.RED:
		self._start_new_round()
		

func _clear_txt_boxes() -> void:
	self.txt_rounds.text = ""
	self.go_time.clear_text_edits()
	self.rest_time.clear_text_edits()

func _get_round_length(lowest: int, highest: int) -> int:
	rng.randomize()
	return rng.randi_range(lowest, highest) 
	

func _update_square_color():
	match self.state:
		STATES.GREEN:
			self.light.frame = 2
		STATES.RED:
			self.light.frame = 1
		STATES.NOT_PLAYING:
			self.light.frame = 0
