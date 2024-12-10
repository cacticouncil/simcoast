extends Control

# Define the spacing for the grid lines
var x_spacing = 0
var y_spacing = 0
var y_line_count = 5
var max_value = 20

var grid_color = Color(0.5, 0.5, 0.5)  # Gray color
var lime_color = Color(0.0, 1.0, 0.0)
var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

var month_labels = []
var y_labels = []
var data = []
var firstMonth = UpdateDate.month

func update_month_labels():
	var currentMonthInd = UpdateDate.month
	if len(WindLevel.monthlyWindLevels) > 0:
		currentMonthInd = WindLevel.monthlyWindLevels[0][0]
	
	for i in range(12):
		var month = months[currentMonthInd]
		month_labels[i].text = month
		
		currentMonthInd += 1
		if currentMonthInd > len(months) - 1:
			currentMonthInd = 0

func update_y_labels():
	for ind in range(len(y_labels)):
		y_labels[ind].text = str(ind * (float(max_value) / y_line_count))
	
func update_max():
	var m = 0
	for ind in range(len(WindLevel.monthlyWindLevels)):
		var point = WindLevel.monthlyWindLevels[ind]
		var val = point[1]
		
		if val > m:
			m = int(val + 2)
			
			if m % 2 == 1:
				m += 1
			
			if m <= 20:
				max_value = 20
			else:
				max_value = m
			
			update_y_labels()

func create_labels():
	for ind in range(1, 13):
		var x_pos = ind * x_spacing
		
		# Create month label
		var label = Label.new()
		label.rect_position = Vector2(x_pos - 11, rect_size.y + 7)
		add_child(label)
		month_labels.append(label)
	
	for ind in range(y_line_count + 1):
		var y_pos = ind * (y_spacing)
		
		# Create number label
		var label = Label.new()
		label.text = str(ind * (float(max_value) / y_line_count))
		label.rect_position = Vector2(0 - 30, rect_size.y - (y_pos) - 6)
		add_child(label)
		y_labels.append(label)

func _draw():
	if !WindLevel.sensorPresent:
		return 
	# Draw vertical lines
	for ind in range(1, 13):
		var x_pos = ind * (x_spacing)
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, rect_size.y), grid_color)
	
	# Draw horizontal lines
	for ind in range(y_line_count + 1):
		var y_pos = ind * (y_spacing)
		draw_line(Vector2(0, y_pos), Vector2(rect_size.x, y_pos), grid_color)
	
	# Draw the axes
	draw_line(Vector2(0, 0), Vector2(0, rect_size.y), Color(0, 0, 0))  # Y-axis
	draw_line(Vector2(0, rect_size.y), Vector2(rect_size.x, rect_size.y), Color(0, 0, 0))  # X-axis
	
	# Draw the data
	draw_data()

func draw_data():
	for ind in range(len(WindLevel.monthlyWindLevels)):
		var point = WindLevel.monthlyWindLevels[ind]
		var val = point[1]
		
		var x_pos = (ind + 1) * x_spacing
		var y_pos = rect_size.y - (val * rect_size.y / float(max_value))
		draw_circle(Vector2(x_pos, y_pos), 4, lime_color)
	
	if len(WindLevel.monthlyWindLevels) < 2:
		return 
		
	for ind in range(1, len(WindLevel.monthlyWindLevels)):
		# Prev point
		var y_1 = WindLevel.monthlyWindLevels[ind-1][1]
		
		var x_pos_1 = (ind) * x_spacing
		var y_pos_1 = rect_size.y - (y_1 * rect_size.y / float(max_value))
		
		# Current point
		var y_2 = WindLevel.monthlyWindLevels[ind][1]
		
		var x_pos_2 = (ind + 1) * x_spacing
		var y_pos_2 = rect_size.y - (y_2 * rect_size.y / float(max_value))
		
		draw_line(Vector2(x_pos_1, y_pos_1), Vector2(x_pos_2, y_pos_2), lime_color)

func _process(delta):
	if !WindLevel.sensorPresent:
		return
		
	update_month_labels()
	update_max()
	update()
		
func _ready():
	x_spacing = float((rect_size.x - 30)) / 12
	y_spacing = float(rect_size.y) / y_line_count  # Use y_line_count for spacing

	if len(WindLevel.monthlyWindLevels) > 0:
		firstMonth = WindLevel.monthlyWindLevels[0][0]
		
	if WindLevel.sensorPresent:
		create_labels()
		update()
