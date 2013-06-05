package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.core.BasicEngine;
import jp.raohmaru.game.enums.Side;
import jp.raohmaru.game.helpers.PixelColorSides;
import jp.raohmaru.game.levels.terrains.Terrain;
import jp.raohmaru.game.properties.*;

/**
 * Plataforma deslizante o cinta transportadora, también conocida en inglés como "moving sidewalk".
 * También funciona como escalera mecánica o "escalator"
 * @author raohmaru
 */
public class Travelator extends Terrain 
{
	private var _speed : Number;
	
	public function get speed() : Number
	{
		return _speed;
	}	
	public function set speed(value : Number) : void
	{
		_speed = value;
	}
	
	
	/**
	 * Crea una instancia del tipo de terreno Travelator.
	 * @param color Color del terreno (por defecto #00CC00).
	 */
	public function Travelator(color :uint = 0x00CC00, speed :Number = 4)
	{
		super(color, [Side.BOTTOM, Side.LEFT, Side.RIGHT]);
		
		_is_modifier = true;
		
		this.speed = speed;
	}
	
	override public function checkModifier(pixelColors :PixelColorSides) :Boolean
	{
		_mod_check = (pixelColors.bottom == _color);
		return _mod_check;
	}
	
	override public function applyModifier(char :Char, engine :BasicEngine, mod :CharModifiers, props :CharProperties) :void
	{
		mod.incrX = _mod_check ? _speed : 0;
	}
}
}