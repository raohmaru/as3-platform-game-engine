package jp.raohmaru.game.events 
{
import jp.raohmaru.game.core.Camera;
import jp.raohmaru.game.core.IGame;

import flash.events.Event;

public final class CameraEvent extends Event 
{
	public static const CAMERA_UPDATE :String = "cameraUpdate",
						PROPERTY_CHANGE :String = "propertyChange";
	
	private var _game :IGame,
				_camera :Camera;

	public function get game() :IGame
	{
		return _game;
	}
	public function get camera() :Camera
	{
		return _camera;
	}
	
	
	public function CameraEvent(type : String, game :IGame, camera :Camera)
	{
		_game = game;		_camera = camera;
		
		super(type, bubbles, cancelable);
	}
	
	override public function toString() :String 
	{
		return formatToString("CameraEvent", "game", "camera", "bubbles", "cancelable");
	}

	override public function clone() :Event
	{
		return new CameraEvent(type, game, camera);
	}
}
}
