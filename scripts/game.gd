extends Node2D


@onready var merchant: AnimatedSprite2D = get_node("Merchant")
# @onready var pieces: Pieces = get_node("Pieces")


var current_round = 0
var current_price = 0
var next_price = 1000

var speed_multiplier = 1.0


func _ready():
    # connect to signals from Pieces node
    pass


func start_next_round():
    current_round += 1
    speed_multiplier *= 1.5

func on_correct_choice():
    current_price = next_price
    next_price *= 2

func on_wrong_choice():
    current_price = -666
    next_price = -666
