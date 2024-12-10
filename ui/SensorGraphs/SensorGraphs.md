# Sensor Graphs Doc

Currently there are 3 sensors: tide, rain, wind. Each have their own gdscript files. The graphs pull the data from their respective type. For example, for tide, SeaLevel.gd contains monthlySeaLevels[] which contains the sea level for each month. It reads the array and plots those values as the y axis. The array contains a max of 12 points with the first element getting removed when max is exceeded. This means the array stores data for the last 12 months.

``create_labels():``
- Creates the month and y-axis labels

``draw_data()``
- Draws the actual points using the array data. Then draws lines connecting the points

``update_min_max()``
- This is an important function that dynamically adjusts the y axis when the y value exceeds the current max or min. The function ensures the graph stays within set bounds.

