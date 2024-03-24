extends CanvasLayer

signal start_game

func show_message(text):
	$StartButton.hide()
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_message_typewriter(text, index):
	$StartButton.hide()
	var message_text = text
	$Message.text = ""
	$Message.show()

	# Iterate through each character in the message_text
	for i in range(message_text.length()):
		# Append the next character to the message
		$Message.text += message_text[i]
		# Wait for a short delay (you can adjust this value to control the typing speed)
		await get_tree().create_timer(0.07).timeout
		
	if index == 4:
		$MessageTimer.start()
	else:
		await get_tree().create_timer(0.5).timeout
		$Message.hide()

func show_game_over():
	show_message("Well, you died lol")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	# Make a one-shot timer and wait for it to finish.
	# await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
