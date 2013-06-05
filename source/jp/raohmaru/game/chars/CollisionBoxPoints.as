package jp.raohmaru.game.chars 
{

/**
 * @author raohmaru
 */
public final class CollisionBoxPoints 
{
	private var _top : int,
				_bottom : int,
				_left : int,
				_right : int;
	
	public function get top() : int
	{
		return _top;
	}	
	public function set top(value : int) : void
	{
		_top = (value > 0) ? value : 1;
	}
	
	public function get bottom() : int
	{
		return _bottom;
	}	
	public function set bottom(value : int) : void
	{
		_bottom = (value > 0) ? value : 1;
	}
	
	public function get left() : int
	{
		return _left;
	}	
	public function set left(value : int) : void
	{
		_left = (value > 0) ? value : 1;
	}
	
	public function get right() : int
	{
		return _right;
	}	
	public function set right(value : int) : void
	{
		_right = (value > 0) ? value : 1;
	}


	
	public function CollisionBoxPoints(top :int = 1, right :int = 1, bottom :int = 1, left :int = 1)
	{
		this.top = top;		this.right = right;		this.bottom = bottom;		this.left = left;
	}
	
	public function clone() : CollisionBoxPoints
	{
		return new CollisionBoxPoints(_top, _right, _bottom, _left);
	}
	
	public function toString() : String
	{
		return "{top:"+_top+", right:"+_right+", bottom:"+_bottom+", left:"+_left+"}";
	}
}
}