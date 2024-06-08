extends Node

# Example reel strips, each represented as an array with different symbols
var reel_strips = [
	[1, 2, 2, 0, 4, 4, 4, 5],  # Reel 1
	[3, 4, 4, 1, 2, 2, 3, 5],  # Reel 2
	[5, 1, 3, 2, 4, 4, 1, 2],  # Reel 3
	[2, 5, 1, 3, 4, 4, 2, 0],  # Reel 4
	[4, 3, 2, 1, 5, 5, 0, 2]   # Reel 5
]

# Paytable: symbol id to payout for combinations, currently set to be the same for all fruits
var paytable = {
	0: {3: 5, 4: 10, 5: 20},  # Blueberry
	1: {3: 5, 4: 10, 5: 20},  # Raspberry
	2: {3: 5, 4: 10, 5: 20},  # Apple
	3: {3: 5, 4: 10, 5: 20},  # Grape
	4: {3: 5, 4: 10, 5: 20},  # Watermelon
	5: {3: 5, 4: 10, 5: 20}   # Orange
}

# Paths to fruit textures
var fruit_textures = [
	preload("res://fruits/1.png"),
	preload("res://fruits/2.png"),
	preload("res://fruits/3.png"),
	preload("res://fruits/4.png"),
	preload("res://fruits/5.png"),
	preload("res://fruits/6.png")
]

func _ready():
	# Connect the spin button signal
	$SpinButton.connect("pressed", self, "_on_spin_button_pressed")

	# Initialize the grid and populate with symbols
	spin()

# spin function
func spin():
	# grid for checking values for credits
	var grid = []
	for i in range(3):
		var row = []
		for j in range(5):
			var symbol = reel_strips[j][randi() % reel_strips[j].size()]
			row.append(symbol)
			# Set the texture for the corresponding TextureRect
			var texture_rect = $GridContainer.get_node("TextureRect" + str(i * 5 + j + 1))
			texture_rect.texture = fruit_textures[symbol]
		# fill grid with current row
		grid.append(row)
	# update line values
	update_lines(grid)

# update_lines function
func update_lines(grid):
	
	# configurations for line
	var line_configs = [
		grid[0],  # Line 1 - first row
		grid[1],  # Line 2 - second row
		grid[2],  # Line 3 - third row
		[grid[0][0], grid[1][2], grid[2][4]],  # Line 4 - first diagonal
		[grid[0][4], grid[1][2], grid[2][0]]   # Line 5 - second diagonal
	]
	
	var results = {}
	
	# get credits value for each line and fill the line label
	for i in range(line_configs.size()):
		var credits = calculate_credits(line_configs[i])
		get_node("Line" + str(i + 1) + "Win").text = "Line " + str(i + 1) + " Win: " + str(credits) + " credits"
		results["line" + str(i + 1)] = credits
	
	return results

# calculating credits for symbol matrix from update_lines()
func calculate_credits(symbols):
	# counter for consecutive fruits
	var count = 1
	
	for i in range(1, len(symbols)):
		if symbols[i] != symbols[0]:
			break
		count = count + 1
	# less than 3 consecutive fruits results in a lose state
	if count < 3:
		return 0
	else:
		return paytable[symbols[0]][count]

func _on_spin_button_pressed():
	spin()
