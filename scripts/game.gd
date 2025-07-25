class_name Game
extends Node2D


var game_state: Global.GameState = Global.GameState.CHOICE

@onready var merchant: AnimatedSprite2D = get_node("Merchant")
@onready var pieces: Pieces = get_node("Pieces")


var current_round = 0
var current_price = 0
var next_price = 1000

var speed_multiplier = 1.0


func _ready():
	pieces.game = self
	pieces.correct_choice.connect(on_correct_choice)
	pieces.wrong_choice.connect(on_wrong_choice)


func start_next_round():
	current_round += 1
	speed_multiplier *= 1.5

	Global.start_round.emit()

func on_correct_choice():
	merchant.play("angry")

	current_price = next_price
	next_price *= 2

func on_wrong_choice():
	merchant.play("happy")
	
	current_price = -666
	next_price = -666
