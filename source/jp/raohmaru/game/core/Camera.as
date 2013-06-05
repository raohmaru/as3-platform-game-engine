package jp.raohmaru.game.core 
{
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.events.CameraEvent;
import jp.raohmaru.game.events.GameEvent;
import jp.raohmaru.game.levels.LevelStage;

/**
 * @author raohmaru
 */
public class Camera extends EventDispatcher
{
	protected var	_game :PlatformGame,
					_level_stage :LevelStage,					
					_viewportRect :Rectangle,
					_viewport :Sprite,
					_viewports :Array,
					_target :Char,
					_restrictToLevelBounds :Boolean = true,
					_horizontalScroll : Boolean = true,
					_verticalScroll : Boolean = true;

	public function get viewportRect() : Rectangle
	{
		return _viewportRect;
	}	
	public function set viewportRect(value : Rectangle) : void
	{
		_viewportRect = value;
		
		for(var i:int=0; i<_viewports.length; i++)
			drawRectInViewport(_viewports[i]);
			
		dispatchEvent( new CameraEvent(CameraEvent.PROPERTY_CHANGE, _game, this) );
	}
	
	public function get viewport() : Sprite
	{
		return _viewport;
	}
	
	public function get target() : Char
	{
		return _target;
	}	
	public function set target(value : Char) : void
	{
		_target = value;
	}
	
	public function get restrictToLevelBounds() : Boolean
	{
		return _restrictToLevelBounds;
	}	
	public function set restrictToLevelBounds(value : Boolean) : void
	{
		_restrictToLevelBounds = value;
		dispatchEvent( new CameraEvent(CameraEvent.PROPERTY_CHANGE, _game, this) );
	}
	
	public function get horizontalScroll() : Boolean
	{
		return _horizontalScroll;
	}	
	public function set horizontalScroll(value : Boolean) : void
	{
		_horizontalScroll = value;
	}
	
	public function get verticalScroll() : Boolean
	{
		return _verticalScroll;
	}	
	public function set verticalScroll(value : Boolean) : void
	{
		_verticalScroll = value;
	}
	
	public function get width() : Number
	{
		return _viewportRect.width;
	}
	public function get height() : Number
	{
		return _viewportRect.height;
	}
	
	public function get scrollX() : Number
	{
		return -_game.content.x;
	}
	public function get scrollY() : Number
	{
		return -_game.content.y;
	}
	
	public function get scrollWidth() : Number
	{
		return (_restrictToLevelBounds) ? _level_stage.width-_viewportRect.width : _level_stage.width;
	}
	public function get scrollHeight() : Number
	{
		return (_restrictToLevelBounds) ? _level_stage.height-_viewportRect.height : _level_stage.height;
	}
	
	
	public function Camera(game :PlatformGame)
	{
		_game = game;
		_game.addEventListener(GameEvent.GAME_START, onGameStart);
		
		_viewports = new Array();
		_viewport = new Sprite();
		_viewports.push(_viewport);
		
		TimeMaster.getInstance().add(update);
		
		viewportRect = new Rectangle(0, 0, 300, 300);		
	}
	
	protected function onGameStart(e :GameEvent) :void
	{
		_level_stage = _game.getCurrentLevel().stage;
	}
		private function update() :void
	{
		var cameraX :Number = -_target.x + (_viewportRect.width >> 1),  // >>1 equivale a /2
			cameraY :Number = -_target.y + (_viewportRect.height >> 1);
		
		if(_restrictToLevelBounds)
		{
			if(_horizontalScroll)
			{
				if(_level_stage.width > _viewportRect.width)
				{
					var level_view_width :Number = _viewportRect.width-_level_stage.width;
					
					if		(cameraX > _viewportRect.x) cameraX = _viewportRect.x;
					else if	(cameraX < level_view_width) cameraX = level_view_width;
				}
				else
					cameraX = 0;
			}
			
			if(_verticalScroll)
			{
				if(_level_stage.height > _viewportRect.height)
				{
					var level_view_height :Number = _viewportRect.height-_level_stage.height;
					
					if		(cameraY > _viewportRect.y) cameraY = _viewportRect.y;
					else if	(cameraY < level_view_height) cameraY = level_view_height;
				}
				else
					cameraY = 0;
			}
		}
		
		if(_horizontalScroll)	_game.content.x = cameraX;
		if(_verticalScroll)		_game.content.y = cameraY;
		
		dispatchEvent( new CameraEvent(CameraEvent.CAMERA_UPDATE, _game, this) );
	}
	
	/**
	 * Obtiene un nuevo Sprite que actuará de máscara.
	 */
	public function cloneViewport() :Sprite
	{
		var clone :Sprite = new Sprite();
		_viewports.push(clone);
		drawRectInViewport(clone);
		return clone;
	}
	
	/**
	 * Dibuja un rectangulo en la vista que hará de máscara.
	 */
	private function drawRectInViewport(viewport :Sprite) : void
	{
		viewport.graphics.clear();
		viewport.graphics.beginFill(0xCC0000);
		viewport.graphics.drawRect(_viewportRect.x, _viewportRect.y, _viewportRect.width, _viewportRect.height);
	}
}
}