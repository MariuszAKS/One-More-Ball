extends Control

@export var start_button: Button

func _ready():
    start_button.pressed.connect(start_game)

func start_game():
    get_tree().change_scene_to_file("res://scenes/game.tscn")
