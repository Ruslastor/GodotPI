extends Control

var led_out : GodotPi.GPIO = GodotPi.GPIO.new(26, GodotPi.GPIO.PinDirection.OUTPUT, GodotPi.GPIO.PinPulling.PULL_DOWN)
var another_led_out : GodotPi.GPIO = GodotPi.GPIO.new(6, GodotPi.GPIO.PinDirection.OUTPUT, GodotPi.GPIO.PinPulling.PULL_DOWN)
var button_in : GodotPi.GPIO = GodotPi.GPIO.new(16, GodotPi.GPIO.PinDirection.INPUT, GodotPi.GPIO.PinPulling.PULL_UP)


func _process(delta: float) -> void:
	if button_in.digital_read():
		led_out.digital_write(false)
	else:
		led_out.digital_write(true)


var another_on : bool = false

func _on_button_pressed() -> void:
	another_on = !another_on
	another_led_out.digital_write(another_on)
