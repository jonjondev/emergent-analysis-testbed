extends Area2D

var health = 80

func _gather():
	health -= 1
	if health == 0:
		health = 80
		Reporter.report_event(self, "quarry", "gathered")
		return "rock"