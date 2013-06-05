package jp.raohmaru.game.enums 
{

/**
 * @author raohmaru
 */
public final class Side 
{
	public static const	TOP :String = "top",
						RIGHT :String = "right",
						BOTTOM :String = "bottom",
						LEFT :String = "left",
						
						ALL :Array = [TOP, RIGHT, BOTTOM, LEFT];

	private var _side : String,
				_axis : String,
				_incr  : Number;
	
	public function get side() : String
	{
		return _side;
	}	
	public function set side(value : String) : void
	{
		_side = value;
	}
	
	public function get axis() : String
	{
		return _axis;
	}	
	public function set axis(value : String) : void
	{
		_axis = value;
	}
	
	public function get incr () : Number
	{
		return _incr ;
	}	
	public function set incr (value : Number) : void
	{
		_incr  = value;
	}


	public function Side(side :String, axis :String, incr :Number)
	{
		_side = side;		_axis = axis;		_incr = incr;
	}
}
}