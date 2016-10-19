
function enter_room()
	--initialize
	
	-- comment the next line to see different results when running
	setActorState("kate", "location", "office")
	
	actorSays("hero", "Allright, I'm in the office!")
end

function pickup_matches()
	actorGotoTarget("hero", "officematches")
	waitSignal("arrived_hero")
	actorPlayAnimation("hero", "usedown")
	waitSignal("animationfinished_hero_usedown")
	if getActorState("kate", "location") == "office" then
		actorSays("kate", "Hey don't take my matches!")
		waitSignal("finishedspeaking")
	else
		pickupItem("inv_matches")
		actorRemove("matches")
		actorSays("hero", "This will come in handy!")
		waitSignal("finishedspeaking")
	end
	actiondone()
end
