package jp.raohmaru.game.core 
{
import jp.raohmaru.game.enums.Depth;
import jp.raohmaru.game.levels.props.Prop;

import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.geom.Point;

import jp.raohmaru.game.chars.PlayerChar;
import jp.raohmaru.game.events.GameEvent;
import jp.raohmaru.game.levels.*;
import jp.raohmaru.game.properties.GameProperties;

/**
 * @author raohmaru
 */
public class PlatformGame extends EventDispatcher implements IGame
{
	private var _options :GameProperties,
				_player :PlayerChar,
				_tm :TimeMaster,
				_levels :Array,
				_view :Sprite,
				_content :Sprite,
				_camera :Camera,
				_hud :Sprite,
				_fixed_bg :Sprite,				_fixed_fg :Sprite,
				
				_debug :GameDebug;

	public function get options() :GameProperties
	{
		return _options;
	}	
	public function get numLevels() : uint
	{
		return _levels.length;
	}
	public function get view() : Sprite
	{
		return _view;
	}
	public function get content() : Sprite
	{
		return _content;
	}
	public function get player() : PlayerChar
	{
		return _player;
	}
	public function get camera() : Camera
	{
		return _camera;
	}
	
	public function set debug(value : Boolean) : void
	{
		if(value)
		{
			_debug = new GameDebug(this);
		}
		else
		{
			_debug.stop();
			_debug = null;
		}
	}
	public function get debug() : Boolean
	{
		return (_debug != null);
	}
	
	
	public function PlatformGame()
	{		
		init();
	}
	
	private function init() :void
	{
		_options = new GameProperties();
		_levels = new Array();
		
		_tm = TimeMaster.getInstance();
		_tm.init();
		
		// Crea las capas de sprites con los elementos visuales del juego
		_view = new Sprite();		
		
		_camera = new Camera(this);
		_view.addChild(_camera.viewport);
		
		_fixed_bg = new Sprite();
		_fixed_bg.mask = _view.addChild( _camera.cloneViewport() );
		_view.addChild(_fixed_bg);
		
		_content = new Sprite();
		_content.mask = _view.addChild( _camera.cloneViewport() );
		_view.addChild(_content);
		
		_fixed_fg = new Sprite();
		_fixed_fg.mask = _camera.viewport;
		_view.addChild(_fixed_fg);		
		
		_hud = new Sprite();
		_view.addChild(_hud);
	}
	
	public function start() :void
	{
		_options.currentLevel = 0;
		
		var clevel :Level = getCurrentLevel();
		
		// Nivel #0
		// No hace falta añadirlo si no se utiliza el método DisplayObject.hitTestPoint()
		//_content.addChild( clevel.stage.collisionMap );
		// Nivel #1
		addGameSprites(clevel.stage.backgrounds);
		// Nivel #2
		_content.addChild( _player );
		// Nivel #3
		addGameSprites(clevel.stage.props);
		// Nivel #4
		addGameSprites(clevel.stage.foregrounds);
		
		_player.x = clevel.playerStart.x;		_player.y = clevel.playerStart.y;
		
		
		_tm.start();
		
		dispatchEvent(new GameEvent(GameEvent.GAME_START, this));
	}
	
	
	
	public function addPlayer(player :PlayerChar) :PlayerChar
	{
		_player = player;
		_player.game = this;
		_camera.target = _player;
		
		return player;
	}
	
	public function addLevel(level :Level) :Level
	{
		level.game = this;
		_levels.push(level);
		
		return level;
	}
	
	public function getCurrentLevel() : Level
	{
		return _levels[_options.currentLevel];
	}
	

	/**
	 * Obsoleta
	 */
	public function getOffset() :Point
	{
		return _view.localToGlobal(new Point(_content.x, _content.y));
	}

	private function addGameSprites(source :Array) : void
	{
		var gsprite :GameSprite,
			len :int = source.length,
			i:int = 0;
		
		while(i < len)
		{
			gsprite = source[i];			
			++i;
							
			if(gsprite is Background)
			{
				if(Background(gsprite).fixed || Background(gsprite).delta)
				{
					if(gsprite is Foreground)
						_fixed_fg.addChild( gsprite );
					else
						_fixed_bg.addChild( gsprite );
					continue;
				}
			}
			else if(gsprite is Prop)
			{
				var index :int = -1;
				switch(Prop(gsprite).depth)
				{
					case Depth.BEHIND:
					case Depth.BOTTOM:
						index = 0;
						break;
				}
				
				if(index != -1)
				{
					_content.addChildAt( gsprite, index );
					continue;
				}
			}
			
			_content.addChild( gsprite );
		}
	}
}
}