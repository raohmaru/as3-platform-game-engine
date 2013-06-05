package jp.raohmaru.game.levels 
{
import jp.raohmaru.game.levels.props.Prop;
import jp.raohmaru.game.core.IGameElement;
import jp.raohmaru.game.core.PlatformGame;
import jp.raohmaru.game.levels.terrains.Bounds;
import jp.raohmaru.game.levels.terrains.Terrain;

import flash.geom.Rectangle;

/**
 * @author raohmaru
 */
public final class LevelStage implements IGameElement
{
	private var	_game :PlatformGame,
				_colmap :CollisionMap,
				_terrains :Array,				_backgrounds :Array,				_foregrounds :Array,
				_props :Array,
				
				_bounds :Rectangle,
				_width :Number,				_height :Number;

	public function get game() : PlatformGame
	{
		return _game;
	}	
	public function set game(value : PlatformGame) : void
	{
		_game = value;
	}
	
	public function get collisionMap() :CollisionMap
	{
		return _colmap;
	}
	public function get terrains() :Array
	{
		return _terrains;
	}
	public function get backgrounds() :Array
	{
		return _backgrounds;
	}
	public function get foregrounds() :Array
	{
		return _foregrounds;
	}
	public function get props() :Array
	{
		return _props;
	}
	
	public function get width() : Number
	{
		return (!isNaN(_width)) ? _width : _bounds.right;
	}
	public function set width(value : Number) : void
	{
		_width = value;
	}
	
	public function get height() : Number
	{
		return (!isNaN(_height)) ? _width : _bounds.bottom;
	}
	public function set height(value : Number) : void
	{
		_height = value;
	}
	
	
	public function LevelStage()
	{
		_terrains = [];		_backgrounds = [];		_foregrounds = [];		_props = [];
		addTerrain( new Bounds() );
	}

	public function addCollisionMap(colmap :CollisionMap) :CollisionMap
	{
		_colmap = colmap;
		_bounds = _colmap.getBounds(_colmap);
		
		return colmap;
	}
	
	public function addTerrain(terrain :Terrain) :Terrain
	{
		_terrains.push(terrain);
		return terrain;
	}
	
	public function addBackground(bg :Background) :Background
	{
		bg.game = _game;
		_backgrounds.push(bg);
		return bg;
	}
	
	public function addForeground(fg :Foreground) :Foreground
	{
		fg.game = _game;
		_foregrounds.push(fg);
		return fg;
	}

	public function addProp(prop :Prop) :Prop
	{
		prop.game = _game;
		if(prop.colision) _colmap.addChild(prop.colision);
		_props.push(prop);
		return prop;
	}
}
}