package jp.raohmaru.game.levels.props 
{
import flash.geom.Point;
import flash.geom.Rectangle;

import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.core.TimeMaster;
import jp.raohmaru.game.enums.Axis;
import jp.raohmaru.game.events.CameraEvent;
import jp.raohmaru.game.events.GameEvent;
import jp.raohmaru.game.levels.props.Prop;

/**
 * @author raohmaru
 */
public class Platform extends Prop 
{
	private var _speedX : Number = 5,
				_speedY : Number = 0,
				_distance :Point,
				_freeze : Boolean,
				
				_check_axis :String,
				_bounds :Rectangle,
				_wait_time : int = 25,
				_c :int,
				_timer :TimeMaster;

	private const	AXIS_X :String = Axis.X,
					AXIS_Y :String = Axis.Y;

	public function get speedX() : Number
	{
		return _speedX;
	}	
	public function set speedX(value : Number) : void
	{
		_speedX = value;
	}
	
	public function get speedY() : Number
	{
		return _speedY;
	}	
	public function set speedY(value : Number) : void
	{
		_speedY = value;
	}
	
	public function get distance() : Point
	{
		return _distance;
	}	
	public function set distance(value : Point) : void
	{
		_distance = value;
		
		var dx :Number = _distance.x,
			dy :Number = _distance.y;		
		if(dx < 0) dx = -dx;   // Más rápido que Math.abs()		if(dy < 0) dy = -dy;
		
		_check_axis = (dx > dy) ? AXIS_X : AXIS_Y;
	}

	public function get waitTime() : uint
	{
		return _wait_time;
	}	
	public function set waitTime(value : uint) : void
	{
		_wait_time = int(value) * 25;  // 25 son los frames por segundos de la película principal
	}
	
	public function get freeze() : Boolean
	{
		return _freeze;
	}	
	public function set freeze(value : Boolean) : void
	{
		_freeze = value;
	}
	
	
	
	public function Platform(movie_ref :String)
	{
		super(movie_ref);
		
		distance = new Point(100, 0);
		_timer = TimeMaster.getInstance();
	}	

	override protected function onGameStart(e :GameEvent) :void
	{
		super.onGameStart(e);
		
		var bx :Number = (_distance.x >= 0) ? x : x+_distance.x,			by :Number = (_distance.y >= 0) ? y : y+_distance.y,
			w :Number = (_distance.x >= 0) ? _distance.x : -_distance.x,			h :Number = (_distance.y >= 0) ? _distance.y : -_distance.y;
			
		// El área de movimiento de la plataforma
		_bounds = new Rectangle(bx, by, w, h);
		
		_timer.add(onTimerStep);
	}
	
	override public function contact(char :Char) :void
	{
		var charX :Number = char.x;
		// Si está encima de la plataforma...
		if( charX > x && charX < x+width &&
			char.y < y + (height >> 1) &&  // >> 1 -> /2
			!char.state.falling)
				if(_c > _wait_time)
				{
					char.x += speedX;
					//char.y += speedY;
				}
				
	}
	
	private function onTimerStep() :void
	{
		if(_freeze)
			return;
	
		if(_c++ > _wait_time)
		{
			// Si la distancia más grande que recorre es horizontal, comprobará el eje X
			if(_check_axis == AXIS_X)
			{
				if(x > _bounds.right || x < _bounds.left)
				{
					speedX = -speedX;					speedY = -speedY;
					_c = 0;
				}
			}
			else
			{
				if(y > _bounds.bottom || y < _bounds.top)
				{
					speedX = -speedX;
					speedY = -speedY;
					_c = 0;
				}
			}
		}
		
		if(_c > _wait_time)
		{
			x += speedX;
			y += speedY;
		}
	}
}
}