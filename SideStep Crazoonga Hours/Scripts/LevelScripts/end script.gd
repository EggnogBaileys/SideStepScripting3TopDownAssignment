extends CanvasLayer


func _ready():
	$Enemies.text = ("ENEMIES DEFEATED: " + str(Singleton.enemiesDefeated))
	$Deaths.text = ("CRAB DEATHS: " + str(Singleton.crabDeaths))
	$Time.text = ("TIME TAKEN: ") + str(Singleton.timeTaken)
