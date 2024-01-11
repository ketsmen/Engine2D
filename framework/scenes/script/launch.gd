extends Control

func _ready():
	pass

func _process(_delta):
	pass

func _on_launch_sound_finished():
	print("Launch Sound End")
	$LaunchSound.play()


func _on_start_button_pressed():
	print("Launch Login Start")
	$LoginMain.visible = false
	$LaunchSound.stop()
