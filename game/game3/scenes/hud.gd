extends CanvasLayer

signal start_button

func _ready():
	$LabelLifeCounter.text = "3"
	$LabelScoreClock.text = "2:00"
	$LabelMessage.text = ""
	$Button.hide()
	
func start():
	$Button.show()

func set_score(score):
	$LabelScoreClock.text = score	

func set_texto(text):
	$LabelMessage.text = text
	$LabelMessage.show()
	$TimerText.start()
	
func set_life(life):
	$LabelLifeCounter.text = str(life)
	
func _on_TimerText_timeout():
	$LabelMessage.hide()

func _on_Button_pressed():
	$Button.hide()
	emit_signal("start_button")
	
	
