package jp.raohmaru.game.chars 
{
import flash.events.TimerEvent;
import flash.utils.Timer;

import jp.raohmaru.game.core.BasicEngine;
import jp.raohmaru.game.enums.*;
import jp.raohmaru.game.events.CharEvent;
import jp.raohmaru.game.properties.CharProperties;

/**
 * @author raohmaru
 */
public final class StatesManager 
{
	private var _char : Char,
				_engine :BasicEngine,
				_chprops :CharProperties,
				_state : String,
				_timer :Timer,
				
				_facing :String = Direction.RIGHT,
				_crouching :Boolean,
				_swiming :Boolean,
				_climbing :Boolean,
				_jumping :Boolean,
				_jumping_down :Boolean,
				_falling :Boolean,				_hanged :Boolean,
				
				_in_floor :Boolean,				_in_corner :Boolean,
				_in_edge :Boolean,
				_in_slope :Boolean,
				_in_ladder :Boolean,
				_in_rope : Boolean;

	public function get state() : String
	{
		return _state;
	}
	public function set state(value : String) : void
	{
		if(_state != value)
		{
			_state = value;
			_char.graphic.gotoAndStop(_state);
			
			if(_state == CharStates.STAND)
			{
				_timer.reset();
				_timer.start();
			}
			else if(_timer.running)
				_timer.stop();
				
			// Si escala se utiliza el mismo gráfico y se reproduce o para según el estado
			if(_state == CharStates.LADDER_CLIMB || _state == CharStates.ROPE_CLIMB)
			{
				if(_char.graphic.graphic_mc)
					_char.graphic.graphic_mc.play();
			}
			else if(_state == CharStates.LADDER_WAIT || _state == CharStates.ROPE_WAIT)
				_char.graphic.graphic_mc.stop();
		}
	}
		
	public function get facing() : String
	{
		return _facing;
	}
	public function set facing(value : String) : void
	{
		_facing = value;
		_char.graphic.scaleX = (_facing == Direction.LEFT) ? -1 : 1;
	}
	
	public function get crouching() : Boolean
	{
		return _crouching;
	}	
	public function set crouching(value : Boolean) : void
	{
		_crouching = value;
	}
	
	public function get swiming() : Boolean
	{
		return _swiming;
	}	
	public function set swiming(value : Boolean) : void
	{
		_swiming = value;
	}
	
	public function get jumping() : Boolean
	{
		return _jumping;
	}
	public function set jumping(value :Boolean) :void
	{
		_jumping = value;
	}
	
	public function get jumpingDown() : Boolean
	{
		return _jumping_down;
	}
	public function set jumpingDown(value :Boolean) :void
	{
		_jumping_down = value;
	}
	
	public function get climbing() : Boolean
	{
		return _climbing;
	}
	public function set climbing(value : Boolean) : void
	{
		_climbing = value;
	}
	
	public function get falling() : Boolean
	{
		return _falling;
	}
	public function set falling(value : Boolean) : void
	{
		_falling = value;
	}
	
	public function get hanged() : Boolean
	{
		return _hanged;
	}
	public function set hanged(value : Boolean) : void
	{
		_hanged = value;
	}
	
	public function get inFloor() : Boolean
	{
		return _in_floor;
	}
	public function set inFloor(value : Boolean) : void
	{
		_in_floor = value;
	}
	
	public function get inCorner() : Boolean
	{
		return _in_corner;
	}
	public function set inCorner(value : Boolean) : void
	{
		_in_corner = value;
	}
	
	public function get inEdge() : Boolean
	{
		return _in_edge;
	}
	public function set inEdge(value : Boolean) : void
	{
		_in_edge = value;
	}
	
	public function get inSlope() : Boolean
	{
		return _in_slope;
	}
	public function set inSlope(value : Boolean) : void
	{
		_in_slope = value;
	}
	
	public function get inLadder() : Boolean
	{
		return _in_ladder;
	}	
	public function set inLadder(value : Boolean) : void
	{
		_in_ladder = value;
	}
	
	public function get inRope() : Boolean
	{
		return _in_rope;
	}	
	public function set inRope(value : Boolean) : void
	{
		_in_rope = value;
	}
	
	
	public function StatesManager(char :Char)
	{
		_char = char;		_engine = char.engine;		
		_engine.addEventListener(CharEvent.MOVE, update);
		_chprops = _char.properties;
		_timer = new Timer(_chprops.standWaitTime, 1);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
	}

	private function update(e :CharEvent) :void
	{
		var vx :Number = _engine.vector.x,			vy :Number = _engine.vector.y;
			
			
		if(_climbing)
		{
			if(_engine.climbDir)
				if(_in_rope)
					state = CharStates.ROPE_CLIMB;
				else
					state = CharStates.LADDER_CLIMB;
			else
				if(_in_rope)
					state = CharStates.ROPE_WAIT;
				else
					state = CharStates.LADDER_WAIT;
		}
		
		else if(_hanged)
		{
			if(_engine.moveDir)
				state = CharStates.HANGED_MOVE;
			else
				state = CharStates.HANGED_WAIT;
		}
		
		else if(_crouching)
			state = CharStates.CROUCH;
			
		else if(_swiming)
			state = CharStates.SWIM;
			
		else if(_jumping)
			state = CharStates.JUMP;
			
		else if(!_engine.moveDir && vx != 0 && !_falling)
			state = CharStates.BRAKE;
			
		else if(vx != 0 && !_falling)
		{
			if(int(vx-1) <= _chprops.maxVelX && int(vx+1) >= -_chprops.maxVelX)
				state = CharStates.WALK;
			else
				state = CharStates.RUN;
		}
		
		else if(vy >= 0 && _falling)
			state = CharStates.FALL;
			
		else if(state != CharStates.WAIT)
			state = CharStates.STAND;
	}

	private function timerHandler(e :TimerEvent) :void
	{
		if(_state == CharStates.STAND) state = CharStates.WAIT;
	}	
}
}