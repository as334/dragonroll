/atom/movable
	// size and weight determine how difficult it is to pick up and whether the player can throw it far
	// size 1 = small object, like a tool or gun
	// size 2 = two handed object, like a box or a crate
	// size 3 = larger object, like a fridge or a stove
	// size 4 = largest object, like a car or a cow
	// weight is a number between 1 and 10, and is checked against the STR score of a player trying to pick it up. 1d20 vs (weight + size)
	var/size = 0
	var/weight = 0

	var/thrown = FALSE
	var/thrownTarget
	var/beingCarried = FALSE
	var/mob/player/carriedBy
	var/atom/movable/carrying
	var/myOldLayer = 0
	var/myOldPixelY = 0

//done as the atom is added to the processing list
/atom/movable/proc/preProc()
	if(thrown)
		density = 0

//done as the atom is removed from the processing list
/atom/movable/proc/postProc()
	if(!thrown)
		density = 1

//the process of an object, ie regenerating lasers, food rotting etc
/atom/movable/proc/doProcess()
	if(beingCarried)
		if(do_roll(1,20,carriedBy.playerData.str.statCur) >= weight + size)
			loc = carriedBy.loc
		else
			displayInfo("You fumble and lose your strength, dropping the [carrying]!","[src] drops the [carrying]!",src,carrying)
			beDropped()
	if(thrown)
		if(loc != thrownTarget:loc)
			step_to(src,thrownTarget)
		else
			thrown = FALSE
			thrownTarget = null

/atom/movable/proc/beDropped()
	if(beingCarried)
		layer = myOldLayer
		pixel_y = myOldPixelY
		beingCarried = FALSE
		carriedBy = null
		remProcessingObject(src)