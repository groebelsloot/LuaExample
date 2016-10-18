package ;
import lua.Lua;

/**
 * ...
 * @author Mic Uurloon
 */
class LuaUtil
{

	public static function setupLUA(gameengine: GameEngine):Lua {
		var lua:Lua = new Lua();
		var prefix:String = "\t\t\t\t\t\t\t\t\t\t";

		//Load all libraries:
		lua.loadLibs(["base", "debug", "io", "math", "os", "package", "string", "coroutine", "table"]);

		lua.setVars( {
			getActorState: function(actorId:String, key:String):String {
				Sys.println(prefix+"Lua: getActorState("+actorId+","+key+")");
				return gameengine.gamestate.getActorState(actorId, key);
			}
		});

		//actor speaks
		lua.setVars( {
			actorSays:
				function(actorid:String, speech:String) {
					Sys.println(prefix+"Lua: actorSays("+actorid+","+speech+")");
					if (actorid != null && speech != null) {
						gameengine.actorSays(actorid, speech);
						return true;
					}
					return false;
				}
			});
		
		//Remove object from Room:
		lua.setVars( {
			actiondone:
				function() {
					Sys.println(prefix+"Lua: actiondone()");
					gameengine.actiondone();
					return true;
				}
			});

		//Remove object from Room:
		lua.setVars( {
			actorRemove:
				function(actorid:String) {
					Sys.println(prefix + "Lua: actorRemove(" + actorid + ")");
					//set Actor to invisible
					return true;
				}
			});

		//Pickup inventory item
		lua.setVars( {
			pickupItem:
				function(objectid:String) {
					Sys.println(prefix + "Lua: pickupItem(" + objectid + ")");
					gameengine.gamestate.inventoryAdd(objectid);
					return true;
				}
			});

		//Remove inventory item
		lua.setVars( {
			removeItem:
				function(objectid:String) {
					Sys.println(prefix+"Lua: removeItem("+objectid+")");
					return true;
				}
			});

		//Actor go to target
		lua.setVars( {
			actorGotoTarget:
				function(actorid:String, targetactorid:String) {
					Sys.println(prefix + "Lua: actorGotoTarget(" + actorid + "," + targetactorid + ")");
					//fake start walking:
					gameengine.fake_action = "walking";
					return true;
				}
			});
		
		//Actor play animation
		lua.setVars( {
			actorPlayAnimation:
				function(actorid:String, animation:String) {
					Sys.println(prefix + "Lua: actorPlayAnimation(" + actorid + "," + animation + ")");
					//fake start animating:
					gameengine.fake_action = "animating";
					return true;
				}
			});

		if (loadLuaFile(lua, "WaitSupport.lua") == false) return null;

		var luafile:String = "office.lua";
		if (loadLuaFile(lua, luafile) == false) return null;


		return lua;
	}

	public static function loadLuaFile(lua:Lua, luafile:String):Bool {
		var result:String = "";
		var luatxt:String = "";
		var fin = sys.io.File.read(luafile, false);
		try	{
			while( true ) {
				luatxt += fin.readLine() + "\r\n";
			}
		}
		catch( ex:haxe.io.Eof )  {}
		fin.close();
		result = executeLua(lua, luatxt);
		if (hasError(result)) {
			trace(result);
			return false;
		}
		return true;
	}

	public static function executeLua(lua:Lua, s:String):String {
		var result:String;
		var luaresult:Dynamic = lua.execute(s);
		result = "";
		return result;
	}

	public static function hasError(s:String):Bool {
		//expand when new errors have been found
		if (s.indexOf("syntax error") > -1) return true;
		else if (s.indexOf("expected near") > -1) return true;
		else if (s.indexOf("unexpected symbol") > -1) return true;
		else if (s.indexOf("'end' expected") > -1) return true;
		else if (s.indexOf("unfinished string near") > -1) return true;
		return false;
	}
}