package jp.raohmaru.game.core 
{
import jp.raohmaru.game.events.GameEvent;

import flash.display.*;
import flash.utils.getDefinitionByName;

/**
 * @author raohmaru
 */
public class GameSprite extends Sprite implements IGameElement 
{
	protected var	_movie :MovieClip,
					_game :PlatformGame;

	public function get movie() : MovieClip
	{
		return _movie;
	}
	
	public function get game() : PlatformGame
	{
		return _game;
	}	
	public function set game(value : PlatformGame) : void
	{
		_game = value;
		_game.addEventListener(GameEvent.GAME_START, onGameStart);
	}
	
				
	public function GameSprite(movie_ref :String)
	{
		if(movie_ref)
		{
			var ClassReference :Class = getDefinitionByName(movie_ref) as Class;
			_movie = new ClassReference();
		}
		else
			_movie = new MovieClip();
		
		addChild(_movie);	
	}
	

	protected function onGameStart(e :GameEvent) :void
	{
		
	}
}
}