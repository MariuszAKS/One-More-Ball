class_name Game
extends Node2D


signal begin_round

@onready var merchant: AnimatedSprite2D = get_node("Merchant")
@onready var talking: Talking = get_node("Control/Talking")
@onready var pieces: Pieces = get_node("Pieces")

@onready var ending: ColorRect = get_node("Control/Ending")
@onready var run_button: Button = get_node("Control/Button")

var intro_text_index = 0
var intro_texts = [
	"So, you're in need of some money?",
	"I think I have a solution for you!",
	"Just play my little game, you can win a 1000!",
	"Don't worry about the entry fee.",
	"If you win, I won't take anything.",
	"And if you loose? Don't worry about it.",
	"You need money, correct? Splendid!\nWell then, let's begin!"
]


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

	ending.get_child(0).get_child(0).get_node("Button").pressed.connect(go_to_menu)
	run_button.pressed.connect(on_ending)


func intro_sequence():
	intro_text_index += 1

	if intro_text_index < len(intro_texts):
		talking.start_writing_text(intro_texts[intro_text_index])
	else:
		talking.text_written.disconnect(intro_sequence)
		talking.text_written.connect(start_next_round)
		start_next_round()


func start_next_round():
	merchant.play("default")
	current_round += 1
	speed_multiplier *= 1.5

	begin_round.emit()

func on_ending():
	ending.show()
	var label: Label = ending.get_child(0).get_child(0).get_node("Label")

	if winnings == -666:
		label.text = "You lost.\nAt least you don't have to worry about money anymore."
	else:
		label.text = "You run away from the merchant with the money.\nYour score: " + str(winnings)

func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func on_correct_choice():
	merchant.play("angry")

	winnings = price
	price *= 2

	talking.start_writing_text("You're good. Double or nothing?\nYou can win " + str(price) + "!")

func on_wrong_choice():
	merchant.play("happy")

	winnings = -666
	price = -666

	merchant.animation_finished.connect(on_ending)
