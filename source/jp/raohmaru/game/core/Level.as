package jp.raohmaru.game.core 
{
import jp.raohmaru.game.chars.Char;

import flash.geom.Point;

import jp.raohmaru.game.levels.LevelStage;

/**
 * @author raohmaru
 */
public class Level implements IGameElement 
{
	private var	_game :PlatformGame,
				_stage :LevelStage,
				_chars :Array,
				_player_start :Point;

	public function get game() : PlatformGame
	{
		return _game;
	}	
	public function set game(value : PlatformGame) : void
	{
		_game = value;
		_stage.game = value;
	}
	
	public function get stage() :LevelStage
	{
		return _stage;
	}
	
	public function get playerStart() : Point
	{
		return _player_start;
	}	
	public function set playerStart(value : Point) : void
	{
		_player_start = value;
	}
	
				
	public function Level()
	{
		_stage = new LevelStage();
		_chars = new Array();
		_player_start = new Point();
	}
	
	public function addChar(char :Char) :Char
	{
		char.game = _game;
		_chars.push(char);
		return char;
	}
}
}