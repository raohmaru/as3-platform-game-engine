package jp.raohmaru.game.chars 
{
import flash.display.*;
import flash.geom.Point;

import jp.raohmaru.game.core.*;
import jp.raohmaru.game.enums.*;
import jp.raohmaru.game.events.*;
import jp.raohmaru.game.properties.*;

/**
 * @author raohmaru
 */
public class Char extends GameSprite
{
	protected var 	_graphic :MovieClip,
					_engine :BasicEngine,
					_properties :CharProperties,					_stateman :StatesManager,					_status :CharStatus,					_mod :CharModifiers,
					_helper_layer :Sprite,
					
					_can_jump :Boolean,
					_will_hang :Boolean;

	
	public function get graphic() : MovieClip
	{
		return _graphic;
	}
	public function get engine() : BasicEngine
	{
		return _engine;
	}
	public function get properties() : CharProperties
	{
		return _properties;
	}
	public function get state() : StatesManager
	{
		return _stateman;
	}
	public function get status() : CharStatus
	{
		return _status;
	}
	public function get modifiers() : CharModifiers
	{
		return _mod;
	}
	public function get helperLayer() : Sprite
	{
		return _helper_layer;
	}	
	
	public function get willHang() : Boolean
	{
		return _will_hang;
	}
	public function set willHang(value :Boolean) :void
	{
		_will_hang = value;
	}
	
	public function get canJump() : Boolean
	{
		return _can_jump;
	}
	public function set canJump(value :Boolean) :void
	{
		_can_jump = value;
	}
	
	
	public function Char(movie_ref :String)
	{
		super(movie_ref);
		_graphic = _movie.graphic_mc;
		
		_helper_layer = new Sprite();
		// Añade dos puntos de ayuda visual que se alinean con el suelo
		for(var i:int=0; i<2; i++) 
		{
			var floor_point :Sprite = new Sprite();
				floor_point.name = "rot"+i;
				floor_point.graphics.beginFill(0xFF00FF);
				floor_point.graphics.drawCircle(0, 0, 1);
				floor_point.graphics.endFill();
			
			_helper_layer.addChild(floor_point);
		}
		
		_properties = new CharProperties();		
		_engine = new BasicEngine(this);		
		_stateman = new StatesManager(this);		_status = new CharStatus();		_mod = new CharModifiers(this);
	}

	public function move(dir :String) :void
	{
		if(dir == Direction.LEFT || dir == Direction.RIGHT)
		{
			_engine.moveDir = dir;
			_stateman.facing = dir;
		}
		if(dir == Direction.UP || dir == Direction.DOWN)
		{
			_engine.climbDir = dir;
			
			if(dir == Direction.UP)
				_will_hang = true;
			
			else if(_stateman.hanged)  // Pulsando Abajo se descuelga
				_stateman.hanged = false;
		}
	}
	
	public function stopMove() : void
	{
		_engine.moveDir = null;
	}
	
	public function stopClimb() : void
	{
		_engine.climbDir = null;
		_will_hang = false;
	}
	
	public function jump() : void
	{
		if(_can_jump)
		{
			// Quieto y agachado salta hacia abajo
			if(!_engine.moveDir && _engine.climbDir == Direction.DOWN)
			{
				jumpDown();
			}
			else if(_engine.climbDir != Direction.DOWN)
			{
				_engine.vector.y = -_properties.jumpHeight * _mod.jump;
			}
			
			_stateman.jumping = true;
		}
			
		// Al saltar se cancelan los siguientes estados
		if(_stateman.hanged) _stateman.hanged = false;		if(_stateman.climbing) _stateman.climbing = false;
	}
	
	public function jumpDown() : void
	{
		_stateman.jumpingDown = true;
	}

	public function crouch(value :Boolean = true) :void
	{
		if(!_stateman.swiming)
		{		
			_stateman.crouching = (_stateman.falling) ? false : value;
			
			if(_stateman.crouching)
				_engine.collisionBox.setBoxDimensions(NaN, _properties.crouchHeight);
			else
				_engine.collisionBox.setBoxDimensions();
		}
	}


	override protected function onGameStart(e :GameEvent) :void
	{
		if(_game.debug)
			addChild(_helper_layer);
		else
			_engine.collisionBox.box.visible = false;
		
		_mod.init();
		_engine.init();		_engine.start();
	}
}
}