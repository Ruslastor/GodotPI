class_name GodotPI
extends Node

enum BoardName{RPI_0_2W, RPI_3, RPI_4, RPI_5}

const RPI4_PIN_MAP : Array[Array] = [
	#is_gpio?, prio_num, interface
	[false],[false],
	[true, 2, 'i2c sda'], [false],
	[true, 3, 'i2c scl'], [false],
	[true, 4, 'gpclk'], [true, 14, 'uart txd'],
	[false], [true, 15, 'uart rxd'],
	[true, 17], [true, 18, 'pcmclk'],
	[true, 27], [false],
	[true, 22], [true, 23],
	[false], [true, 24],
	[true, 10, 'spi mosi'], [false],
	[true, 9, 'spi miso'], [true, 25],
	[true, 11, 'spi sclk'], [true, 8, 'spi ce0'],
	[false], [true, 7, 'spi ce1'],
	[true, 0, 'id_sd'], [true, 1, 'id_sc'],
	[true, 5], [false],
	[true, 6], [true, 12, 'pwm 0'],
	[true, 13, 'pwm 1'], [false],
	[true, 19, 'pcm fs'], [true, 16],
	[true, 26], [true, 20, 'pcm din'],
	[false], [true, 21, 'pcm dout'],
]

@export var board_name : BoardName


class GPIO:
	static var GPIOS : Dictionary = {}
	enum Mode{OUTPUT, INPUT}
	var gpio_mode : Mode
	var gpio_n : int
	
	func _init(gpio_n : int) -> void:
		self.gpio_n = gpio_n
		GPIO.GPIOS[self.gpio_n] = self

func _ready() -> void:
	_initialize_board(board_name)

func _initialize_board(board : BoardName) -> void:
	var pin_map_to_use : Array[Array]
	match board:
		BoardName.RPI_4:
			pin_map_to_use = RPI4_PIN_MAP
	
	var pin_n : int = 1
	for pin in pin_map_to_use:
		
		
		
		pin_n += 1




















