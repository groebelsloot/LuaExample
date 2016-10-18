package ;

import lua.Lua;



class GameEngine 
{

	private var luaDeltaTime:Float  = 1.0 / 30;		// 1.0 / 30 = 30 fps
	
	public var gamestate:GameState = new GameState();
	public var lua:Lua;
	public var running:Bool = true;
	
	public var fake_action:String = "";	
	
	public function new() {
		lua = LuaUtil.setupLUA(this);
		if (lua == null) {
			var _txt = "Error loading Lua scripts";
			trace(_txt);
		}
		else {
			//Run the initial method for the room
			lua.execute("runProcess(enter_room)");
		}
		
		lua.execute("runProcess(pickup_matches)");
		update();
	}

	public function luaFunctionExists(f:String):Bool {
		return lua.execute("return (" + f + " ~= nil)");
	}

	//Fake update loop without real timer for demo purposes
	public function update()
	{
		while (running) {
			if (fake_action != "") Sys.println("GameEngine: "+fake_action);
			if (lua != null) {
				updateLUA();
				updateWorld();
			}
			else {
				trace("Lua is null! Not Good!");
			}
			//2 frames per second for our demo. So wait half a second here
			Sys.sleep(0.5);
			
			//Fake arriving
			if (fake_action == "walking") {
				fake_action = "";
				actorArrived("hero");
			}
			else if (fake_action == "animating") {
				fake_action = "";
				animationFinished("hero", "usedown");
			}
			else if (fake_action == "talking") {
				fake_action = "";
				actorFinishedSpeaking();
			}
		}
	}

	private function updateLUA() {
		//Step 1 frame in Lua and wake up threads when needed
		lua.execute('signal("frameupdate")');
		lua.call("wakeUpWaitingThreads", [luaDeltaTime]);
	}

	private function updateWorld() {
		
	}
	
	//perform the action on the target(s)
	//simplified version for demo
	private function performAction(action:String, actionTarget:String):Void {
		var func:String = action + '_' + actionTarget;
		if (luaFunctionExists(func)) {
			lua.execute("runProcess("+func+")");
		}
	}

	//Callback functions
	
	public function actiondone() {
		//for demo purpose: quit de update loop
		running = false;
	}
	
	//Called when actor arrives at target
	//simplified version for demo
	public function actorArrived(actor:String) {
		Sys.println("GameEngine: signal('arrived_" + actor + "')");
		lua.execute('signal("arrived_' + actor + '")');
	}
	
	//simplified version for demo
	public function actorFinishedSpeaking() {
		Sys.println("GameEngine: signal('finishedspeaking')");
		lua.execute('signal("finishedspeaking")');
	}

	//Called when an animation is finished
	//simplified version for demo
	public function animationFinished(objectid:String, animationname:String) {
		Sys.println("GameEngine: signal('animationfinished_"+objectid+"_"+animationname+"')");
		lua.execute('signal("animationfinished_'+objectid+'_'+animationname+'")');
	}

	//simplified version for demo
	public function actorSays(actor:String, speech:String):Void {
		fake_action = "talking";
		Sys.println("GameEngine: " + actor + " says '" + speech + "'");
	}
}