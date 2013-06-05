package jp.raohmaru.game.levels 
{
import jp.raohmaru.game.events.GameEvent;

import flash.geom.Point;

import jp.raohmaru.game.core.Camera;
import jp.raohmaru.game.core.GameSprite;
import jp.raohmaru.game.core.PlatformGame;
import jp.raohmaru.game.events.CameraEvent;

/**
 * @author raohmaru
 */
public class Background extends GameSprite
{	
	protected var	_fixed : Boolean,
					_delta :Point,
					_camera :Camera,
					_viewport_width :Number,					_viewport_height :Number,
					_scroll_width :Number,
					_scroll_height :Number;

	override public function set game(value :PlatformGame) :void
	{
		super.game = value;
		_camera = _game.camera;
		if(_delta) delta = _delta;
	}
	
	public function get fixed() : Boolean
	{
		return _fixed;
	}	
	public function set fixed(value : Boolean) : void
	{
		_fixed = value;
	}
	
	public function get delta() : Point
	{
		return _delta;
	}	
	public function set delta(value : Point) : void
	{
		_delta = value;
		
		if(_camera)
		{
			// Removemos los listeners por si habían sido añadidos, para no añadirlos dos veces
			_camera.removeEventListener(CameraEvent.CAMERA_UPDATE, cameraUpdate);			_camera.removeEventListener(CameraEvent.PROPERTY_CHANGE, cameraPropsChange);
		}
		
		if(_camera && _delta.x != 0 && _delta.y != 0)
		{
			_camera.addEventListener(CameraEvent.CAMERA_UPDATE, cameraUpdate);
			_camera.addEventListener(CameraEvent.PROPERTY_CHANGE, cameraPropsChange);
		}
	}

	
	public function Background(movie_ref :String)
	{
		super(movie_ref);
	}
		
	protected function cameraUpdate(e :CameraEvent) :void
	{
		x = -(((width-_viewport_width) * _camera.scrollX) / _scroll_width) * _delta.x;		y = -(((height-_viewport_height) * _camera.scrollY) / _scroll_height) * _delta.y;
	}
	
	protected function cameraPropsChange(e :CameraEvent = null) :void
	{
		// En pos de la optimización
		_viewport_width = _camera.viewport.width;
		_viewport_height = _camera.viewport.height;
		_scroll_width = _camera.scrollWidth;
		_scroll_height = _camera.scrollHeight;
	}
	
	override protected function onGameStart(e :GameEvent) :void
	{
		cameraPropsChange();
	}
}
}