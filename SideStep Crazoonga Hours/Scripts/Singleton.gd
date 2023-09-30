extends Node3D

var shellCount = 0


func ShellCountIncrement():
	shellCount += 1
	emit_signal("CheckShells(Singleton.shellCount)")
