extends Control
class_name HUD

var time : float = 0.0
var stop : bool = false

func _process(delta: float) -> void:
	if stop:
		return
	time += delta
	updateGameTimer()  # Call updateGameTimer to update the label

func timeToString() -> String:
	var sec = fmod(time, 60)
	var minn = int(time / 60)
	var formatString = "%02d : %02d"
	var actualString = formatString % [minn, sec]
	return actualString

func updateGameTimer() -> void:
	$Timer.text = timeToString()
