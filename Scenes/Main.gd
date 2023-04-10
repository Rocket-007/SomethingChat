extends Control


var url = "https://json.extendsclass.com/bin/71f04303054a"

var local_dict = {}
var username = ""


func _on_LoginRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	print(response)
	local_dict = response
	
	if response["users dict"].has(username):
		print("user already exists")
	else:
		var info = username
		local_dict["users dict"][info] = {"Favorite Color": ""}
		$UpdateRequest.request(url, [], true, HTTPClient.METHOD_PUT, to_json(local_dict))
		print("added name locally xus it didnt exist")


func _on_UpdateRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	print("update response: " + str(response))
	
	$App/ItemList.clear()
	for name in local_dict["users dict"].keys():
		$App/ItemList.add_item(name)
		for field in local_dict["users dict"][name]:
			$App/ItemList.add_item("     " + str(field))
			$App/ItemList.add_item("      " + str(local_dict["users dict"][name][field]))


func _on_Login_button_pressed():
	if $Login_panel/LineEdit.text != "":
		username = $Login_panel/LineEdit.text
		$LoginRequest.request(url)
		$Login_panel.hide()
		$App.show()
		$App/Label3.text = username


func _on_Update_button_pressed():
	local_dict["users dict"][username]["Favorite Color"] = $App/LineEdit.text
	$UpdateRequest.request(url, [], true, HTTPClient.METHOD_PUT, to_json(local_dict))


func _on_App_visibility_changed():
	return
	$App/ItemList.clear()
	
	if local_dict.size() == 0:
		return
		pass
		
	for name in local_dict["users dict"].keys():
		$App/ItemList.add_item(name)
		for field in local_dict["users dict"][name]:
			$App/ItemList.add_item("     " + str(field))
			$App/ItemList.add_item("     " + str(local_dict["users dict"][name][field]))


func _on_Back_pressed():
	$App.hide()
	$Login_panel.show()
