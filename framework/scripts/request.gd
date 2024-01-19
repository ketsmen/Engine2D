#*****************************************************************************
# @file    request.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 初始化节点数据
var http_url:String = "https://game.geekros.com"
var http_request:HTTPRequest = HTTPRequest.new()
var http_headers = [
	"Content-Type: application/json",
	"Service-Token: ",
	"User-Token: ",
]

func on_service(path: String, method: int, data, callback):
	if !http_request.is_inside_tree():
		add_child(http_request)
	var json_data = JSON.stringify(data)
	http_headers[2] = "User-Token: " + Global["data"]["token"]
	http_request.request_completed.connect(callback)
	http_request.request(http_url + path, http_headers, method, json_data)
