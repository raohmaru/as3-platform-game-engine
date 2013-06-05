package jp.raohmaru.game.helpers 
{
import jp.raohmaru.game.enums.Axis;
import jp.raohmaru.game.enums.Side;

/**
 * @author raohmaru
 */
public final class HitSides 
{
	private var _top : Boolean,
				_right : Boolean,
				_bottom : Boolean,
				_left : Boolean,
				
				_topSide :Side,				_rigthSide :Side,				_bottomSide :Side,				_leftSide :Side;

	public function get top() : Boolean
	{
		return _top;
	}	
	public function set top(value : Boolean) : void
	{
		_top = value;
	}
	
	public function get right() : Boolean
	{
		return _right;
	}	
	public function set right(value : Boolean) : void
	{
		_right = value;
	}
	
	public function get bottom() : Boolean
	{
		return _bottom;
	}	
	public function set bottom(value : Boolean) : void
	{
		_bottom = value;
	}
	
	public function get left() : Boolean
	{
		return _left;
	}	
	public function set left(value : Boolean) : void
	{
		_left = value;
	}
	
	public function get topSide() : Side
	{
		return _topSide;
	}
	public function get rigthSide() : Side
	{
		return _rigthSide;
	}
	public function get bottomSide() : Side
	{
		return _bottomSide;
	}
	public function get leftSide() : Side
	{
		return _leftSide;
	}
	
	public function HitSides()
	{
		_topSide	= new Side(Side.TOP,	Axis.Y, -1);		_rigthSide	= new Side(Side.RIGHT,	Axis.X,  1);		_bottomSide	= new Side(Side.BOTTOM,	Axis.Y,  1);		_leftSide	= new Side(Side.LEFT,	Axis.X, -1);
	}
	
	public function toString() : String
	{
		return "[" + _top + ", " + _right + ", " + _bottom + ", " + _left + "]";
	}
}
}