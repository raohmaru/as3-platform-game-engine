package jp.raohmaru.game.properties 
{
import flash.geom.Rectangle;

import jp.raohmaru.game.events.CharEvent;

import flash.events.EventDispatcher;

/**
 * @author raohmaru
 */
public final class CharProperties extends EventDispatcher
{
	private var _incr_velX :Number = 2,
				_max_velX :Number = 10,				_smax_velX :Number = 15,
				_brakeX :Number = 2,
				_jump_height :Number = 18,
				_air_mov_mod :Number = .5,
				_air_break_mod :Number = .25,
				_step_size :Rectangle = new Rectangle(0, 0, 8, 7),
				_head_size :Rectangle = new Rectangle(0, 0, 8, 7),
				_max_angle_climb :Number = .85,				_max_angle_jump :Number = .8,				_max_floor_angle_to_rotate :Number = .9,
				_slope_precision :Number = 10 * Math.PI/180,
				_slope_depth :Number = 20,
				_mass :Number = .2,
				_crouch_height :Number = 16,				_crouch_vel_mod :Number = .4,
				_climb_speed :Number = 5,				_hang_mod :Number = .75,
				
				_can_rest :Boolean = true,
				_can_jump_down :Boolean = true,
				_rotate_by_floor :Boolean,
				_physics :Boolean,
				_stand_wait_time :Number = 4000;

	
	public function get incrVelX() : Number
	{
		return _incr_velX;
	}	
	public function set incrVelX(value : Number) : void
	{
		_incr_velX = value;
	}
	
	public function get maxVelX() : Number
	{
		return _max_velX;
	}	
	public function set maxVelX(value : Number) : void
	{
		_max_velX = value;
	}
	
	public function get sMaxVelX() : Number
	{
		return _smax_velX;
	}	
	public function set sMaxVelX(value : Number) : void
	{
		_smax_velX = value;
	}
	
	public function get brakeX() : Number
	{
		return _brakeX;
	}	
	public function set brakeX(value : Number) : void
	{
		_brakeX = value;
	}
	
	public function get jumpHeight() : Number
	{
		return _jump_height;
	}	
	public function set jumpHeight(value : Number) : void
	{
		_jump_height = value;
	}
	
	public function get airMovMod() : Number
	{
		return _air_mov_mod;
	}	
	public function set airMovMod(value : Number) : void
	{
		_air_mov_mod = value;
	}
	
	public function get airBreakMod() : Number
	{
		return _air_break_mod;
	}	
	public function set airBreakMod(value : Number) : void
	{
		_air_break_mod = value;
	}
	
	public function get stepSize() : Rectangle
	{
		return _step_size;
	}	
	public function set stepSize(value : Rectangle) : void
	{
		_step_size = value;
		dispatchEvent(new CharEvent(CharEvent.PROPERTY_CHANGE));
	}
	
	public function get headSize() : Rectangle
	{
		return _head_size;
	}	
	public function set headSize(value : Rectangle) : void
	{
		_head_size = value;
		dispatchEvent(new CharEvent(CharEvent.PROPERTY_CHANGE));
	}
	
	public function get maxAngleClimb() : Number
	{
		return _max_angle_climb;
	}	
	public function set maxAngleClimb(value : Number) : void
	{
		_max_angle_climb = value;
	}
	
	public function get maxAngleJump() : Number
	{
		return _max_angle_jump;
	}	
	public function set maxAngleJump(value : Number) : void
	{
		_max_angle_jump = value;
	}
	
	public function get maxFloorAngleToRotate() : Number
	{
		return _max_floor_angle_to_rotate;
	}	
	public function set maxFloorAngleToRotate(value : Number) : void
	{
		_max_floor_angle_to_rotate = value;
	}
	
	public function get slopePrecision() : Number
	{
		return _slope_precision;
	}	
	public function set slopePrecision(value : Number) : void
	{
		_slope_precision = value;
	}
	
	public function get slopeDepth() : Number
	{
		return _slope_depth;
	}	
	public function set slopeDepth(value : Number) : void
	{
		_slope_depth = value;
	}
	
	public function get mass() : Number
	{
		return _mass;
	}	
	public function set mass(value : Number) : void
	{
		_mass = value;
	}
	
	public function get crouchHeight() : Number
	{
		return _crouch_height;
	}	
	public function set crouchHeight(value : Number) : void
	{
		_crouch_height = value;
	}
	
	public function get crouchVelMod() : Number
	{
		return _crouch_vel_mod;
	}	
	public function set crouchVelMod(value : Number) : void
	{
		_crouch_vel_mod = value;
	}
	
	public function get climbSpeed() : Number
	{
		return _climb_speed;
	}	
	public function set climbSpeed(value : Number) : void
	{
		_climb_speed = value;
	}
	
	public function get hangMod() : Number
	{
		return _hang_mod;
	}	
	public function set hangMod(value : Number) : void
	{
		_hang_mod = value;
	}
	
	
	public function get rotateByFloor() : Boolean
	{
		return _rotate_by_floor;
	}	
	public function set rotateByFloor(value : Boolean) : void
	{
		_rotate_by_floor = value;
	}

	public function get canRest() : Boolean
	{
		return _can_rest;
	}	
	public function set canRest(value : Boolean) : void
	{
		_can_rest = value;
	}
	
	public function get canJumpDown() : Boolean
	{
		return _can_jump_down;
	}	
	public function set canJumpDown(value : Boolean) : void
	{
		_can_jump_down = value;
	}
	
	public function get physics() : Boolean
	{
		return _physics;
	}	
	public function set physics(value : Boolean) : void
	{
		_physics = value;
	}
	
	public function get standWaitTime() : Number
	{
		return _stand_wait_time;
	}	
	public function set standWaitTime(value : Number) : void
	{
		_stand_wait_time = value;
	}
	
	
	public function CharProperties()
	{
		
	}
}
}