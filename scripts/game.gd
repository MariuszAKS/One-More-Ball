class_name Game
extends Node2D


signal begin_round

@onready var merchant: AnimatedSprite2D = get_node("Merchant")
@onready var talking: Talking = get_node("Control/Talking")
@onready var pieces: Pieces = get_node("Pieces")

var intro_text_index = 0
var intro_texts = ["TEST"]
# var intro_texts = [
# 	"So, you're in need of some money?",
# 	"I think I have a solution for you!",
# 	"Just play my little game!",
# 	"Don't worry about the entry fee.",
# 	"If you win, I won't take anything.",
# 	"And if you loose? Don't worry about it.",
# 	"You need money, correct? Splendid!\nWell then, let's begin!"
# ]


var current_round = 0
var winnings = 0
var price = 1000

var speed_multiplier = 1.0


func _ready():
	pieces.setup(self)
	pieces.correct_choice.connect(on_correct_choice)
	pieces.wrong_choice.connect(on_wrong_choice)

	talking.text_written.connect(intro_sequence)
	talking.start_writing_text(intro_texts[0])


func intro_sequence():
	intro_text_index += 1

	if intro_text_index < len(intro_texts):
		talking.start_writing_text(intro_texts[intro_text_index])
	else:
		talking.text_written.disconnect(intro_sequence)
		start_next_round()


func start_next_round():
	current_round += 1
	speed_multiplier *= 1.5

	update_ui()
	begin_round.emit()

func update_ui():
	# round, winnings, price
	pass


func on_correct_choice():
	merchant.play("angry")

	winnings = price
	price *= 2

func on_wrong_choice():
	merchant.play("happy")

	winnings = -666
	price = -666
