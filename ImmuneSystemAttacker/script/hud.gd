extends Control
class_name HUD

var time : float = 0.0
var stop : bool = false
var flag : bool = true

func _process(delta: float) -> void:
	if stop:
		return
	time += delta
	if !Global.boss:
		updateGameTimer()
	elif Global.boss and flag:
		$BossFightText.text = "BOSS FIGHT!"
		$BossTextTimer.start(1.6)
		flag = false

func timeToString() -> String:
	var sec = fmod(time, 60)
	var minn = int(time / 60)
	var formatString = "%02d : %02d"
	var actualString = formatString % [minn, sec]
	if minn == 2 && !Global.neutrophils:
		Global.neutrophils = true
	if minn == 3 && !Global.naturalKillerCell:
		Global.naturalKillerCell = true
	if minn == 4 && !Global.Kamikazi:
		Global.Kamikazi = true
	if minn == 5 && !Global.boss:
		Global.boss = true
	return actualString

func updateGameTimer() -> void:
	$Timer.text = timeToString()

func _on_boss_text_timer_timeout() -> void:
	$BossFightText.text = ""
