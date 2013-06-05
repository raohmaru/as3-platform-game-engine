package jp.raohmaru.game.events 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.core.IGame;

import flash.events.Event;

public final class CharEvent extends Event 
{
	public static const MOVE :String = "move",
						PROPERTY_CHANGE :String = "propertyChange",
						COLLISION_BOX_UPDATE :String = "collisionBoxUpdate";
	
	private var _game :IGame,
				_char :Char;

	public function get game() :IGame
	{
		return _game;
	}	
	public function get char() :Char
	{
		return _char;
	}
	
	
	public function CharEvent(type : String, game :IGame = null, char :Char = null)
	{
		_game = game;		_char = char;
		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("CharEvent", "game", "char", "bubbles", "cancelable");
	}

	override public function clone() :Event
	{
		return new CharEvent(type, game, char);
	}
}
}
