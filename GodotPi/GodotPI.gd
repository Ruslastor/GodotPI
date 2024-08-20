#-----use it as a singletone
extends Node

enum BoardName{NONE, RPI_0_2W, RPI_3, RPI_4, RPI_5}

const RPI3_PIN_MAP : Array[Array] = [
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



class GPIO:
	static var GPIOS : Dictionary = {}
	enum PinDirection{OUTPUT, INPUT}
	enum PinPulling{NONE, PULL_UP, PULL_DOWN}
	
	var direction : PinDirection
	var pulling : PinPulling
	var gpio_n : StringName
	var pin_n : StringName
	
	func _init(gpio_n : int, direction : PinDirection, pulling : PinPulling) -> void:
		self.gpio_n = str(gpio_n)
		self.pulling = pulling
		self.direction = direction
		GPIO.GPIOS[self.gpio_n] = self
	
	func _configure_pin() -> void:
		var args : PackedStringArray = ['set', gpio_n]
		if direction == PinDirection.OUTPUT:
			args.push_back('op')
		else:
			args.push_back('ip')
		if pulling == PinPulling.PULL_UP:
			args.push_back('pu')
		if pulling == PinPulling.PULL_DOWN:
			args.push_back('pd')
		OS.execute('pinctrl', args)

		
	func digital_write(value : bool) -> void:
		if direction != PinDirection.OUTPUT:
			return
		var args : PackedStringArray = ['set', gpio_n]
		if value:
			args.push_back('dh')
		else:
			args.push_back('dl')
		OS.execute('pinctrl', args)
	
	func digital_read() -> bool:
		var out : Array[String] = []
		if direction != PinDirection.INPUT:
			return false
		OS.execute('pinctrl', ['get', gpio_n], out)
		return out[0].containsn(' hi ')




var board_name : BoardName = BoardName.NONE


func _ready() -> void:
	if OS.get_name() != "Linux":
		OS.alert('The OS is not Linux, but '+ OS.get_name()+'.\nUsing GodotPI is not possible.', 'GodotPi Alert')
		return
	board_name = _get_pi_name()
	_initialize_board(board_name)

func _get_pi_name() -> BoardName: # gives a board type, for example an RPI3 or RPI4...
	var output : Array = []
	OS.execute('cat', ['/proc/device-tree/model'], output)
	var result : PackedStringArray = output[0].split(' ')
	if result[0] != 'Raspberry':
		return BoardName.NONE
	match result[2]:
		'3':
			return BoardName.RPI_3
		_:
			return BoardName.NONE

func _initialize_board(board : BoardName) -> void: # takes a template pinout...
	var pin_map_to_use : Array[Array]
	match board:
		BoardName.RPI_3:
			pin_map_to_use = RPI3_PIN_MAP
	
	var pin_n : int = 1
	for pin in pin_map_to_use:
		
		pin_n += 1
