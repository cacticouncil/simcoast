extends Control

# Define the spacing for the grid lines
var x_spacing = 0
var y_spacing = 0
var y_line_count = 10
var minSeaLevel = 0
var maxSeaLevel = 10

var grid_color = Color(0.5, 0.5, 0.5)  # Gray color
var lime_color = Color(0.0, 1.0, 0.0)
var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

var month_labels = []
var y_labels = []

var data = []

var currentMonth = UpdateDate.month
var firstMonth = UpdateDate.month

# Update the month labels. Gets the last 12 months
func update_month_labels():
	var currentMonthInd = UpdateDate.month
	if len(SeaLevel.monthlySeaLevels) > 0:
		currentMonthInd = SeaLevel.monthlySeaLevels[0][0]
	
	for i in range(12):
		var month = months[currentMonthInd]
		month_labels[i].text = month
		
		currentMonthInd += 1
		if currentMonthInd > len(months) - 1:
			currentMonthInd = 0

func update_y_labels():
	for ind in range(len(y_labels)):
		y_labels[ind].text = str(minSeaLevel + ind * (float(maxSeaLevel - minSeaLevel) / y_line_count))

# Update the min and max so the graph y axis changes dynamically
# I.e the sea level increases above the current max y point, change the y axis to hold the new points
func update_min_max():
	var maxVal = 0
	var minVal = -1
	
	for ind in range(len(SeaLevel.monthlySeaLevels)):
		var point = SeaLevel.monthlySeaLevels[ind]
		var val = point[1]
		
		if minVal < 0:
			minVal = SeaLevel.monthlySeaLevels[0][1]
			minVal = int(floor(val))
			if minVal % 2 == 1:
				minVal -= 1
				
			minSeaLevel = max(0, minVal)
			
		if val < minVal:
			minVal = int(floor(val))
			if minVal % 2 == 1:
				minVal -= 1
				
			minSeaLevel = max(0, minVal)
				
			
		if val > maxVal:
			if val <= 10:
				maxSeaLevel = 10
			else:
				maxVal = int(val + 10)
				if maxVal % 2 == 1:
					maxVal += 1
					
				maxSeaLevel = maxVal
				
	update_y_labels()
	
func create_labels():
	for ind in range(1, 13):
		var x_pos = ind * (x_spacing)
		
		# Create month label
		var label = Label.new()
		label.rect_position = Vector2(x_pos - 11, rect_size.y + 7)
		add_child(label)
		month_labels.append(label)
	
	for ind in range(y_line_count + 1):
		var y_pos = ind * (y_spacing)
		
		# Create number label
		var label = Label.new()
		label.text = str(ind)
		label.rect_position = Vector2(0 - 30, rect_size.y - (y_pos) - 6)
		add_child(label)
		y_labels.append(label)
		
func _draw():
	if !SeaLevel.sensorPresent:
		return 
		
	# Draw vertical lines
	for ind in range(1, 13):
		var x_pos = ind * (x_spacing)
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, rect_size.y), grid_color)
	
	# Draw horizontal lines	
	for ind in range(y_line_count + 1):
		var y_pos = ind * (y_spacing)
		draw_line(Vector2(0, y_pos), Vector2(rect_size.x , y_pos), grid_color)
	
	# Draw the axes
	draw_line(Vector2(0, 0), Vector2(0, rect_size.y), Color(0, 0, 0))  # Y-axis
	draw_line(Vector2(0, rect_size.y), Vector2(rect_size.x, rect_size.y), Color(0, 0, 0))  # X-axis
	
	# Draw the data
	draw_data()

# Uses the respective data to plot the y points
func draw_data():
	for ind in len(SeaLevel.monthlySeaLevels):
		var point = SeaLevel.monthlySeaLevels[ind]
		
		var val = point[1]
		
		var x_pos = (ind + 1) * x_spacing
		var y_pos = rect_size.y - ((val - minSeaLevel) / (maxSeaLevel - minSeaLevel) * rect_size.y);
		draw_circle(Vector2(x_pos, y_pos), 4, lime_color)
	
	if len(SeaLevel.monthlySeaLevels) < 2:
		return 
		
	for ind in range(1, len(SeaLevel.monthlySeaLevels)):
		# Prev point
		var y_1 = SeaLevel.monthlySeaLevels[ind-1][1]
		
		var x_pos_1 = (ind) * x_spacing
		var y_pos_1 = rect_size.y - ((y_1 - minSeaLevel) / (maxSeaLevel - minSeaLevel) * rect_size.y);
		
		# Current point
		var y_2 = SeaLevel.monthlySeaLevels[ind][1]
		
		var x_pos_2 = (ind + 1) * x_spacing
		var y_pos_2 = rect_size.y - ((y_2 - minSeaLevel) / (maxSeaLevel - minSeaLevel) * rect_size.y);

		
		draw_line(Vector2(x_pos_1, y_pos_1), Vector2(x_pos_2, y_pos_2), lime_color)


func _process(delta):
	if !SeaLevel.sensorPresent:
		return 
		
	update_month_labels()
	update_min_max()
	update()
		
func _ready():
	x_spacing = (rect_size.x - 30) / 12
	y_spacing = (rect_size.y) / y_line_count
	
	if len(SeaLevel.monthlySeaLevels) > 0:
		firstMonth = SeaLevel.monthlySeaLevels[0][0]
		
	if SeaLevel.sensorPresent:
		create_labels()
		update()
		
