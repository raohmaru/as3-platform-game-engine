package jp.raohmaru.game.levels.props 
{
import flash.display.MovieClip;
import flash.utils.getDefinitionByName;

import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.core.*;
import jp.raohmaru.game.enums.Depth;
import jp.raohmaru.game.events.CameraEvent;

/**
 * @author raohmaru
 */
public class Prop extends GameSprite 
{
	protected var	_colision :MovieClip,
					_camera :Camera,
					_depth : String = Depth.FRONT;

	public function get colision() : MovieClip
	{
		return _colision;
	}
	
	/**
	 * Profundidad del elemento en relación a los chars.
	 * @default Depth.FRONT
	 * @see jp.raohmaru.game.enums.Depth
	 */
	public function get depth() : String
	{
		return _depth;
	}	
	public function set depth(value : String) : void
	{
		_depth = value;
	}
	
	override public function set game(value :PlatformGame) :void
	{
		super.game = value;
		_camera = _game.camera;
		_camera.addEventListener(CameraEvent.CAMERA_UPDATE, checkVisibility);
	}

	override public function set x(value : Number) : void
	{
		super.x = value;
		if(_colision) _colision.x = value;
	}
	override public function set y(value : Number) : void
	{
		super.y = value;
		if(_colision) _colision.y = value;
	}
	

	
	public function Prop(movie_ref :String)
	{
		super(movie_ref);
		
		// El mapa de colisión está dentro del MovieClip
		if(_movie.collision_mc)
		{
			_colision = _movie.removeChild(_movie.collision_mc) as MovieClip;
		}
	}
	
	/**
	 * Comprueba si el prop está en el plano de la cámara (es visible por el jugador). En caso afirmativo, el prop se muestra y activa, en caso negativo
	 * el prop se oculta y congela.
	 */
	protected function checkVisibility(e :CameraEvent) : void
	{
		var scrollX :Number = _camera.scrollX,			scrollY :Number = _camera.scrollY;
		
		if(x+width > scrollX && x < scrollX + _camera.width && y+height > scrollY && y < scrollY + _camera.height)
		{
			// Se oculta en vez de eliminarlo con removeChild() por rendimiento
			//[ http://www.insideria.com/2008/11/visible-false-versus-removechi.html ]
			if(!visible) visible = true;
		}
		else
		{
			if(visible) visible = false;
		}
	}
	
	public function contact(char :Char) :void
	{
		
	}
}
}