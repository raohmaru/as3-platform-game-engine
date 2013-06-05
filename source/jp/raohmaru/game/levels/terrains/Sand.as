package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.properties.CharProperties;
import jp.raohmaru.game.core.BasicEngine;
import jp.raohmaru.game.properties.CharModifiers;
import jp.raohmaru.game.helpers.PixelColorSides;
import jp.raohmaru.game.enums.Side;
import jp.raohmaru.game.levels.terrains.Terrain;

/**
 * @author raohmaru
 */
public class Sand extends Terrain 
{
	private var _sunk_vel : Number,
				_x_mod : Number,				_jump_mod : Number;
	
	public function get sunkVel() : Number
	{
		return _sunk_vel;
	}	
	public function set sunkVel(value : Number) : void
	{
		_sunk_vel = value;
	}
	
	public function get xMod() : Number
	{
		return _x_mod;
	}	
	public function set xMod(value : Number) : void
	{
		_x_mod = value;
	}
	
	public function get jumpMod() : Number
	{
		return _jump_mod;
	}	
	public function set jumpMod(value : Number) : void
	{
		_jump_mod = value;
	}


	/**
	 * Crea un nuevo objeto Sand.
	 * @param color Color del terreno (por defecto #FFCC00).
	 */
	public function Sand(color :uint = 0xFFCC00, sunkVel :Number = 1, modX :Number = .5, jumpMod :Number = .75)
	{
		super(color, [Side.BOTTOM]);
		
		_is_modifier = true;
		_do_2nd_collision_check = false;
		
		_sunk_vel = sunkVel;		_x_mod = modX;		_jump_mod = jumpMod;
	}

	override public function checkModifier(pixelColors :PixelColorSides) :Boolean
	{
		_mod_check = (pixelColors.bottom == _color);
		return _mod_check;
	}

	override public function applyModifier(char :Char, engine :BasicEngine, mod :CharModifiers, props :CharProperties) :void
	{
		mod.incrY = (_mod_check) ? _sunk_vel : 0;				mod.velX = (_mod_check) ? _x_mod : 1;		mod.jump = (_mod_check) ? _jump_mod : 1;
	}
}
}
