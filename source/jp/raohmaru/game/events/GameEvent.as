package jp.raohmaru.game.events 
{
import jp.raohmaru.game.core.IGame;

import flash.events.Event;

public final class GameEvent extends Event 
{
	public static const GAME_START :String = "gameStart";
	
	private var _game :IGame;

	public function get game() :IGame
	{
		return _game;
	}
	
	
	public function GameEvent(type : String, game :IGame)
	{
		_game = game;
		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("GameEvent", "game", "bubbles", "cancelable");
	}

	override public function clone() :Event
	{
		return new GameEvent(type, game);
	}
}
}
