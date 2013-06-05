package jp.raohmaru.game.properties 
{
import flash.events.EventDispatcher;

/**
 * @author raohmaru
 */
public final class GameProperties extends EventDispatcher
{
	private var _gravity_incr :Number = 3,
				_min_gravity :Number = 3,
				_max_gravity :Number = 18,
				_current_level :int;
	
	public function get gravityIncr() : Number
	{
		return _gravity_incr;
	}	
	public function set gravityIncr(value : Number) : void
	{
		_gravity_incr = value;
	}
	
	public function get minGravity() : Number
	{
		return _min_gravity;
	}	
	public function set minGravity(value : Number) : void
	{
		_min_gravity = value;
	}
	
	public function get maxGravity() : Number
	{
		return _max_gravity;
	}	
	public function set maxGravity(value : Number) : void
	{
		_max_gravity = value;
	}
	
	public function get currentLevel() : int
	{
		return _current_level;
	}	
	public function set currentLevel(value : int) : void
	{
		_current_level = value;
	}
	
	
	public function GameProperties()
	{
		
	}
}
}