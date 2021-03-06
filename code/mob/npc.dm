#define NPCSTATE_IDLE 1
#define NPCSTATE_MOVE 2
#define NPCSTATE_FIGHTING 3

#define NPCTYPE_PASSIVE 10
#define NPCTYPE_PASSIVE_MINTIME 10

#define NPCTYPE_AGGRESSIVE 11
#define NPCTYPE_AGGRESSIVE_MINTIME 15

#define NPCTYPE_DEFENSIVE 12
#define NPCTYPE_DEFENSIVE_MINTIME 10

/mob/player/npc
	name = "NPC player"

	var/timeSinceLast = 0

	var/wander = 1
	var/wanderFuzziness = 25 // how high "timeSinceLast" should reach before wandering again
	var/wanderRange = 5

	var/npcMaxWait = 15 //maximum time to wait in certain actions, before reverting to idle

	var/npcState = NPCSTATE_IDLE
	var/npcNature = NPCTYPE_PASSIVE

	var/target

	New()
		..()
		addProcessingObject(src)

/mob/player/npc/doProcess()
	..()
	if(beingCarried)
		return
	if(npcState == NPCSTATE_IDLE)
		if(wander && timeSinceLast > wanderFuzziness)
			var/list/toTarget = oview(src,wanderRange)
			if(toTarget)
				target = pick(toTarget)
				npcState = NPCSTATE_MOVE
				timeSinceLast = 0
	if(npcState == NPCSTATE_MOVE)
		if(timeSinceLast >= npcMaxWait)
			npcState = NPCSTATE_IDLE
			target = null
		if(!(loc in orange(1,target)))
			walk_to(src,target)
			timeSinceLast = 0
		else
			target = null
			npcState = NPCSTATE_IDLE
	timeSinceLast++