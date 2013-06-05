package jp.raohmaru.game.core 
{

/**
 * @author raohmaru
 */
public interface IGameElement 
{
	function get game() : PlatformGame;
	function set game(value : PlatformGame) : void;
}
}