tool

extends EditorScript

func datetime_to_string(date):
	if (
		date.has("year")
		and date.has("month")
		and date.has("day")
		and date.has("hour")
		and date.has("minute")
		and date.has("second")
	):
		# Date and time.
		return "{year}-{month}-{day} {hour}:{minute}:{second}".format({
			year = str(date.year).pad_zeros(2),
			month = str(date.month).pad_zeros(2),
			day = str(date.day).pad_zeros(2),
			hour = str(date.hour).pad_zeros(2),
			minute = str(date.minute).pad_zeros(2),
			second = str(date.second).pad_zeros(2),
		})
	elif date.has("year") and date.has("month") and date.has("day"):
		# Date only.
		return "{year}-{month}-{day}".format({
			year = str(date.year).pad_zeros(2),
			month = str(date.month).pad_zeros(2),
			day = str(date.day).pad_zeros(2),
		})
	else:
		# Time only.
		return "{hour}:{minute}:{second}".format({
			hour = str(date.hour).pad_zeros(2),
			minute = str(date.minute).pad_zeros(2),
			second = str(date.second).pad_zeros(2),
		})

func differenciate_table(table1, table2):
	var new_table = {}
	for v in table1.keys():
		if table2.has(v):
#			print(v)
			pass
		else:
			new_table[v] = table1[v]
	return new_table

func _run():
#	print(datetime_to_string(OS.get_datetime()))
#	print(OS.get_datetime())
	var a = {"a":"1", "b":"2", "c":"3"}
	var b = {"a":"1", "b":"2", "c":"3", "d":"4", "sd":133}
	
	print(differenciate_table(b, a))
	
