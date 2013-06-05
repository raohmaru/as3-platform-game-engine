package jp.raohmaru.game.chars 
{
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import jp.raohmaru.game.enums.Axis;
import jp.raohmaru.game.enums.Side;
import jp.raohmaru.game.events.CharEvent;
import jp.raohmaru.game.properties.CharProperties;

/**
 * @author raohmaru
 */
public final class CollisionBox extends EventDispatcher
{
	private var _char :Char,
				_box :Sprite,
				_rect :Rectangle,
				_col_box_points :CollisionBoxPoints,
				
				_box_width :Number,				_box_height :Number,
				
				_pivot_point :Point,
				_points_bottom :Array,				_points_top :Array,				_points_left :Array,				_points_right :Array;

	public function get rect() : Rectangle
	{
		return _rect;
	}
	public function get box() : Sprite
	{
		return _box;
	}
	
	public function get bottomPoints() : Array
	{
		return _points_bottom;
	}
	public function get topPoints() : Array
	{
		return _points_top;
	}
	public function get leftPoints() : Array
	{
		return _points_left;
	}
	public function get rightPoints() : Array
	{
		return _points_right;
	}
	
	public function get numsPoints() : CollisionBoxPoints
	{
		return _col_box_points;
	}
	
	public function get width() : Number
	{
		return _rect.width;
	}
	public function get height() : Number
	{
		return _rect.height;
	}
	public function get pivotPoint() : Point
	{
		return _pivot_point;
	}

	
	
	public function CollisionBox(char :Char, box :Sprite)
	{
		_char = char;		_box = box;
		
		setNumsPoints(new CollisionBoxPoints());
	}
	
	public function setNumsPoints(collisionBoxPoints :CollisionBoxPoints) :void
	{
		_col_box_points = collisionBoxPoints;		
		update();		
	}
	
	public function update() :void
	{
		var _box_rotation :Number = box.rotation;
		box.rotation = 0;
		
		_rect = box.getRect(_char);
		_char.helperLayer.graphics.clear();
		
		// Guarda las dimensiones originales
		if(!_box_width)
		{
			_box_width = _rect.width;			_box_height = _rect.height;
		}
		
		var props :CharProperties = _char.properties,
			left_side_len :Number = _rect.height - props.stepSize.height - props.headSize.height,
			left_center_y :Number = -props.stepSize.height - left_side_len/2;
		
		addPoints(Side.TOP,		props.headSize.width,	new Point(0, _rect.top));		addPoints(Side.BOTTOM,	props.stepSize.width,	new Point(0, _rect.bottom));
		addPoints(Side.RIGHT,	left_side_len,			new Point(_rect.right, left_center_y));		addPoints(Side.LEFT,	left_side_len,			new Point(_rect.left, left_center_y));
		
		_pivot_point = new Point(0, _rect.bottom);
		
		box.rotation = _box_rotation;
		
		dispatchEvent(new CharEvent(CharEvent.COLLISION_BOX_UPDATE));
	}
	
	public function setBoxDimensions(width :Number = NaN, height :Number = NaN) :void
	{
		if(isNaN(width)) width = _box_width;		if(isNaN(height)) height = _box_height;
		
		_box.width = width;		_box.height = height;
		
		update();
	}
	
	private function addPoints(side :String, side_len:Number, center_point :Point) : void
	{
		var num_points :int = _col_box_points[side],
			points_dte :Number = 0,
			axis :String = (side == Side.TOP || side == Side.BOTTOM) ? Axis.X : Axis.Y,
			other_axis :String = (axis == Axis.X) ? Axis.Y : Axis.X,
			point :Point;
			
		this['_points_'+side] = [];
		
		if(num_points == 1)
		{
			side_len = 0;
		}
		else
			points_dte = side_len/(num_points-1);
		
		for(var i:int=0; i<num_points; i++)
		{
			point = new Point();
			point[axis] = center_point[axis] - side_len/2 + points_dte*i;
			point[other_axis] = center_point[other_axis];
			
			this['_points_'+side].push( point );
			addHelperPoint( point );
		}
	}
	
	
	private function addHelperPoint(point :Point) : void
	{
		_char.helperLayer.graphics.beginFill(0xFF0000);
		_char.helperLayer.graphics.drawCircle(point.x, point.y, 1.5);
		_char.helperLayer.graphics.endFill();
	}
}
}