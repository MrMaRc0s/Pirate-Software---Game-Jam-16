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
	var min = int(time / 60)  # Convert to integer for formatting
	var formatString = "%02d : %02d"
	var actualString = formatString % [min, sec]
	return actualString

func updateGameTimer() -> void:
	$Timer.text = timeToString()
