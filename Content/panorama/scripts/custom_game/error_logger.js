const logger_root = $("#logger_root")
const main_button = $("#main_button")
const logger = $("#logger")
const font_sizer = $("#logger_font_size")
const max_lines = 50
const lines = []
var current_font_size = 20
var current_line_number = 0
var open = false

function Load() {
	main_button.visible = false
	logger_root.visible = false
	logger_root.style.position = Game.GetScreenWidth()+"px 0px 0"

	const f = function() {		
		if (main_button.actuallayoutwidth == 0){
			$.Schedule(1, f)
		}else{
			main_button.style.position = (Game.GetScreenWidth()-main_button.actuallayoutwidth+4)+"px 17% 0"
		}
	}
	f()


	font_sizer.FindChildTraverse("IncrementButton").SetPanelEvent("onactivate", function() {
		if (GameUI.IsShiftDown()){
			var change = 5
		}else{
			var change = 1
		}
		var new_val = Math.min(parseInt(font_sizer.FindChildTraverse("TextEntry").text)+change, 60)
		font_sizer.FindChildTraverse("TextEntry").text = new_val
		current_font_size = new_val
		for (var line of lines){
			line.style.fontSize = new_val
		}
	})
	font_sizer.FindChildTraverse("DecrementButton").SetPanelEvent("onactivate", function() {
		if (GameUI.IsShiftDown()){
			var change = 5
		}else{
			var change = 1
		}
		var new_val = Math.max(parseInt(font_sizer.FindChildTraverse("TextEntry").text)-change, 20)
		font_sizer.FindChildTraverse("TextEntry").text = new_val
		current_font_size = new_val
		for (var line of lines){
			line.style.fontSize = new_val
		}
	})
}

function Open() {
	if (open){
		open = false
		logger_root.style.position = Game.GetScreenWidth()+"px 0px 0"
		main_button.style.position = (Game.GetScreenWidth()-main_button.actuallayoutwidth+4)+"px 17% 0"
	}else{
		open = true
		logger_root.style.position = (Game.GetScreenWidth()-logger_root.actuallayoutwidth)+"px 0px 0"
		main_button.style.position = (Game.GetScreenWidth()-logger_root.actuallayoutwidth-main_button.actuallayoutwidth+4)+"px 17% 0"
	}
}

function ShowButton() {
	main_button.visible = true
	logger_root.visible = true
}

function AddLine(msg) {
	var time = parseInt(Game.GetDOTATime(false, true))
	if (msg.text){
		if (current_line_number < max_lines){
			current_line_number++
			var line = $.CreatePanel("Label", logger, "")
			line.AddClass("logger_line")
			line.html = true
			line.text ="["+Math.floor(time/3600)+":"+Math.floor(time/60)+":"+time%60+"]: "+msg.text
			line.style.fontSize = current_font_size
			lines.push(line)
		}else{
			var old_line = lines.shift()
			old_line.DeleteAsync(0)
			var line = $.CreatePanel("Label", logger, "")
			line.AddClass("logger_line")
			line.html = true
			line.text ="["+Math.floor(time/3600)+":"+Math.floor(time/60)+":"+time%60+"]: "+msg.text
			line.style.fontSize = current_font_size
			lines.push(line)
		}
	}
}

GameEvents.Subscribe("error_logger_open", ShowButton)
GameEvents.Subscribe("error_logger_line", AddLine)