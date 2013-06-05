package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.properties.CharProperties;
import jp.raohmaru.game.core.BasicEngine;
import jp.raohmaru.game.helpers.PixelColorSides;
import jp.raohmaru.game.properties.CharModifiers;

/**
 * @author raohmaru
 */
public class Terrain 
{
	protected var	_color : uint,
					_sides : Array,
					_is_modifier : Boolean,
					_do_2nd_collision_check :Boolean = true,
					_mod_check :Boolean;

	private var _sides_str :String;
	
	public function get color() : uint
	{
		return _color;
	}	
	public function set color(value : uint) : void
	{
		_color = value;
	}	
	
	public function get sides() : Array
	{
		return _sides;
	}	
	public function set sides(value : Array) : void
	{
		_sides = value;
		_sides_str = _sides.join("");
	}
	
	public function get isModifier() : Boolean
	{
		return _is_modifier;
	}
	
	public function get do2ndCollisionCheck() : Boolean
	{
		return _do_2nd_collision_check;
	}	
	public function set do2ndCollisionCheck(value : Boolean) : void
	{
		_do_2nd_collision_check = value;
	}
	
	
	public function Terrain(color :uint, sides :Array)
	{
		this.color = color;
		this.sides = sides;
	}
	
	public function check(color :uint, side :String, is2ndCollisionCheck :Boolean = false) : Boolean
	{
		if(is2ndCollisionCheck && !_do_2nd_collision_check) return false;
		
		return (color == _color && _sides_str.indexOf(side) != -1);
	}
	
	public function checkModifier(pixelColors :PixelColorSides) :Boolean
	{
		_mod_check = false;
		return false;
	}
	
	public function applyModifier(char :Char, engine :BasicEngine, mod :CharModifiers, props :CharProperties) :void
	{
		
	}
}
}