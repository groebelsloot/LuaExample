package ;

class GameState
{
	
	//Simplified gamesate from our game. For demo purposes.s
	
	private var _statevalues:Map<String, Dynamic> = new Map<String, Dynamic>();
	private var _actorStates:Map<String, Map<String, Dynamic>> = new Map<String, Map<String, Dynamic>>();

	public var inventory:Array<String> = new Array<String>();

	//intialize the default game state (new game only)
	public function new() {
		
	}

	//The game state should store only things that surpass single actors
	public function setGameState(key:String, value:Dynamic):Void {
		this._statevalues[key] = value;
	}

	public function getGameState(key:String):Dynamic {
		if(this._statevalues.exists(key)) {
			return this._statevalues[key];
		}
		return null;
	}

	//The actor state stores properties related to particular actors. These things should NOT be stored in the game state
	public function setActorState(actorId:String, key:String, value:Dynamic):Void {
		Sys.println("GameEngine: SetActorstate "+actorId + ", " + key + ": " + value);
		if(!this._actorStates.exists(actorId)) {
			this._actorStates[actorId] = new Map<String, Dynamic>();
		}
		this._actorStates[actorId][key] = value;
	}

	public function getActorState(actorId:String, key:String):Dynamic {
		if (this._actorStates.exists(actorId) && this._actorStates[actorId].exists(key)) {
			Sys.println("GameEngine: Actorstate "+actorId + ", " + key + " = " + this._actorStates[actorId][key]);
			return this._actorStates[actorId][key];
		}
		else {
			Sys.println("GameEngine: Actorstate "+actorId + ", " + key + " = null");
		}
		return null;
	}

	public function inventoryReset() {
		inventory = new Array<String>();
	}

	public function inventoryAdd(itemid:String) {
		if (!inventoryContains(itemid)) {
			Sys.println("GameEngine: add to inventory: "+itemid);
			inventory.push(itemid);
		}
	}

	public function inventoryContains(itemid:String):Bool {
		return (inventory.indexOf(itemid) > -1);
	}

	public function inventoryRemove(itemid:String) {
		inventory.remove(itemid);
	}

}