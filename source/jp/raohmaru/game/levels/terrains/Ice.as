package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.properties.CharProperties;
import jp.raohmaru.game.core.BasicEngine;
import jp.raohmaru.game.helpers.PixelColorSides;
import jp.raohmaru.game.properties.CharModifiers;
import jp.raohmaru.game.enums.Side;

/**
 * @author raohmaru
 */
public class Ice extends Terrain 
{
	private var _friction : Number;
	
	public function get friction() : Number
	{
		return _friction;
	}	
	public function set friction(value : Number) : void
	{
		_friction = value;
	}
	
	
	/**
	 * Crea un nuevo terreno del tipo agua. Con los valores por defecto los char flotarán.
	 * @param color Color del terreno (por defecto #00FFFF).
	 */
	public function Ice(color :uint = 0x00FFFF, friction :Number = .01)
	{
		super(color, Side.ALL);
		_is_modifier = true;
		
		_friction = friction;
	}
	

	override public function checkModifier(pixelColors :PixelColorSides) :Boolean
	{
		_mod_check = (pixelColors.bottom == _color);
		return _mod_check;
	}
	
	override public function applyModifier(char :Char, engine :BasicEngine, mod :CharModifiers, props :CharProperties) :void
	{
		mod.friction = _mod_check ? _friction : 1;
	}
}
}
