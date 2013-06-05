package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.utils.NumberUtil;
import jp.raohmaru.game.properties.CharProperties;
import jp.raohmaru.game.core.BasicEngine;
import jp.raohmaru.game.properties.CharModifiers;
import jp.raohmaru.game.helpers.PixelColorSides;
import jp.raohmaru.game.levels.terrains.Terrain;

import flash.geom.Rectangle;

/**
 * @author raohmaru
 */
public class Water extends Terrain 
{
	private var _colorARGB :uint,
				_gravity_mod : Number,
				_velX_mod : Number,				_velY_mod : Number,
				_bounce : Number,
				_jump_mod :Number;
	
	/**
	 * Modificador a la gravedad. Un valor positivo hace que el char se hunda, y un valor negativo que flote.
	 * @default -.5
	 */
	public function get gravityMod() : Number
	{
		return _gravity_mod;
	}	
	public function set gravityMod(value : Number) : void
	{
		_gravity_mod = value;
	}
	
	public function get velXMod() : Number
	{
		return _velX_mod;
	}	
	public function set velXMod(value : Number) : void
	{
		_velX_mod = value;
	}
	
	public function get velYMod() : Number
	{
		return _velY_mod;
	}	
	public function set velYMod(value : Number) : void
	{
		_velY_mod = value;
		_jump_mod = 1/_velY_mod;
	}
	
	public function get bounce() : Number
	{
		return _bounce;
	}
	public function set bounce(value : Number) : void
	{
		_bounce = value;
	}
	
	
	/**
	 * Crea un nuevo terreno del tipo agua. Con los valores por defecto los char flotarán.
	 * @param color Color del terreno (por defecto #029FFD).
	 */
	public function Water(color :uint = 0x029FFD, gravityMod :Number = -.5, velXMod :Number = .75, velYMod :Number = .5, bounce :Number = 3)
	{
		super(color, []);
		
		_is_modifier = true;
		
		_colorARGB = NumberUtil.colorToARGB(color);
		this.gravityMod = gravityMod;		this.velXMod = velXMod;		this.velYMod = velYMod;		this.bounce = bounce;
	}
	

	override public function checkModifier(pixelColors :PixelColorSides) :Boolean
	{
		var side_check :Boolean = (pixelColors.left == _color && pixelColors.right == _color);
		
		_mod_check = (pixelColors.bottom == _color && side_check) || (pixelColors.top == _color && side_check) || (side_check);
		return _mod_check;
	}
	
	override public function applyModifier(char :Char, engine :BasicEngine, mod :CharModifiers, props :CharProperties) :void
	{
		var g :Number = 1,		
			bH :Number,
			cbrect :Rectangle,
			wH :Number,
			swim :Boolean;
		
		if(_mod_check)
		{
			g = _gravity_mod;			
			bH = engine.pixelColors.bitmapData.height;
			cbrect = engine.pixelColors.bitmapData.getColorBoundsRect(0xFFFFFFFF, _colorARGB);
			// Corrige los píxeles de más que se añaden al BitmapData para comprobar el ángulo del suelo			
			cbrect.height += (bH-cbrect.bottom) - props.slopeDepth;
			bH -= props.slopeDepth;
			
			wH = cbrect.height;
			
			// Por si toca suelo, ya que el bitmapData no sólo comprende agua si no además una porción de suelo
			if(bH != cbrect.bottom) bH = cbrect.bottom;
			
			// Sólo si el char tiene más de 1/4 de cuerpo metido en el agua, está le afectará 
			_mod_check = (wH >= bH>>2); // wH/4
			
			if(_gravity_mod < 0 && _mod_check)
			{
				var bH23 :Number = 	(bH<<1)/3;  // bH*2/3
				
				// Por el principio de Arquímedes, el char sufrirá una fuerza ascendete igual a 2/3 de su altura
				g = (_gravity_mod * (wH-bH23)) / (bH-bH23) * _bounce;
			}
				
			g += props.mass;
			// Si pesan mucho se hunden demasiado rápido
			if(props.mass >= 1 && g > 1) g = 1;
			
			if(_mod_check && char.state.crouching) char.crouch(false);
		}
		
		// Para minimizar los efectos del agua si tiene medio cuerpo sumergido
		swim = (_mod_check && !isNaN(wH) && wH >= bH>>1); // bH/2;
		
		char.state.swiming = swim;
		mod.gravity = (_mod_check)? g : 1;			mod.velX = (_mod_check)	? _velX_mod : 1;
		mod.velY = (swim)	? _velY_mod : 1;
		// Para compensar la disminución en el salto por el valor de velYMod
		mod.jump = (swim)	? _jump_mod : 1;
		
		if(swim) char.canJump = true;
	}
}
}
