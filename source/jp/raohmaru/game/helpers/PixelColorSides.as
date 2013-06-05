package jp.raohmaru.game.helpers 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;

import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.chars.CollisionBox;
import jp.raohmaru.game.enums.Side;
import jp.raohmaru.game.events.CharEvent;
import jp.raohmaru.game.levels.CollisionMap;

/**
 * @author raohmaru
 */
public final class PixelColorSides 
{
	private var _collision_box :CollisionBox,
				_char :Char,
				_colmap :CollisionMap,
				_bitmapData :BitmapData,
				_vector :Point,
				
				_top : uint,
				_right : uint,
				_bottom : uint,
				_left : uint,
				
				_bmp :Bitmap;

	public function set collisionMap(value : CollisionMap) : void
	{
		_colmap = value;
	}
	public function get bitmapData() : BitmapData
	{
		return _bitmapData;
	}
	
	public function get top() : uint
	{
		return _top;
	}	
	public function set top(value : uint) : void
	{
		if(value != 0) _top = value;
	}
	
	public function get right() : uint
	{
		return _right;
	}	
	public function set right(value : uint) : void
	{
		if(value != 0) _right = value;
	}
	
	public function get bottom() : uint
	{
		return _bottom;
	}	
	public function set bottom(value : uint) : void
	{
		if(value != 0) _bottom = value;
	}
	
	public function get left() : uint
	{
		return _left;
	}	
	public function set left(value : uint) : void
	{
		if(value != 0) _left = value;
	}
	
	
	public function PixelColorSides(char :Char, collision_box :CollisionBox)
	{
		_char = char;
		_collision_box = collision_box;
	}

	public function reset() : void
	{
		_top = 0;		_right = 0;		_bottom = 0;		_left = 0;
	}
	
	/**
	 * Genera un BitmapData del mapa de colisión actual según la posición del char, de dimensiones iguales a la caja de colisión de este char
	 * más la dirección de su vector. Posteriormente con este BitmapData se obtendrán el color de los píxeles del punto de colisión.
	 */
	public function updateBitmap(vector :Point) : void
	{
		/*if(!_bmp)
		{
			_bmp = new Bitmap();
			_bmp.x = 240;
			_bmp.y = 30;
			_char.game.view.addChild(_bmp);
		}*/
		
		reset();
		
		_vector = vector.clone();
		
		var abs_vx :Number = _vector.x,  // Esto es infinitamente más rápido que Math.abs()
			abs_vy :Number = _vector.y;
		if(abs_vx < 0) abs_vx = -abs_vx;		if(abs_vy < 0) abs_vy = -abs_vy;
		
		// Crea un BitmapData de tamaño igual a la caja de colisión + el doble de la velocidad actual, asegurándonos así que siempre
		// se puede obtener el color de un píxel
		var matrix :Matrix = new Matrix();
			matrix.translate(				-_char.x + _collision_box.width/2 + Math.floor(abs_vx),				-_char.y + _collision_box.height + abs_vy
			);
				
		_bitmapData = new BitmapData(
			_collision_box.width + (abs_vx << 1) + 1,  // abs_vx << 1 equivale a abs_vx * 2
			_collision_box.height + (abs_vy << 1) + _char.properties.slopeDepth,
			true,
			0);
		_bitmapData.draw(_colmap, matrix);
		// A veces, en Flash IDE va lento si no se asigna _bitmapData a un objeto Bitmap
		//_bmp.bitmapData = _bitmapData;
	}
	
	public function getPixelColor(x :Number, y :Number) :uint
	{
		var	abs_vy :Number = _vector.y,
			pixel_color :uint;
		
		if(abs_vy < 0) abs_vy = -abs_vy;  // Más rápido que Math.abs()
			
		pixel_color = _bitmapData.getPixel(
			x + (_bitmapData.width >> 1), // >> 1 equivale a / 2
			y + _collision_box.height + abs_vy);
			
		return pixel_color;
	}
	
	public function toString() : String
	{
		return "{top:"+_top+", right:"+_right+", bottom:"+_bottom+", left:"+_left+"}";
	}
}
}