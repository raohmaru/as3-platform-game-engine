package jp.raohmaru.game.levels.props 
{
import flash.geom.Point;

import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.core.PlatformGame;
import jp.raohmaru.game.events.GameEvent;
import jp.raohmaru.game.levels.props.Prop;
import jp.raohmaru.geom.LineStyle;

/**
 * La típica cuerda de tender, pero para aventureros.
 * @author raohmaru
 */
public class ClothesLine extends Prop 
{
	private var _point1 :Point,
				_point2 :Point,
				_bezier :Point,
				_showLine : Boolean = false,
				_line_style :LineStyle;

	public function get point1() : Point
	{
		return _point1.clone();
	}	
	public function set point1(value : Point) : void
	{
		_point1 = value;
	}

	public function get point2() : Point
	{
		return _point2.clone();
	}	
	public function set point2(value : Point) : void
	{
		_point2 = value;
	}

	public function get bezier() : Point
	{
		return _bezier.clone();
	}	
	public function set bezier(value : Point) : void
	{
		_bezier = value;
	}
	
	public function get showLine() : Boolean
	{
		return _showLine;
	}	
	public function set showLine(value : Boolean) : void
	{
		_showLine = value;
		update();
	}
	
	public function get lineStyle() : LineStyle
	{
		return _line_style;
	}	
	public function set lineStyle(value : LineStyle) : void
	{
		_line_style = value;
		update();
	}
	
	override public function set game(value :PlatformGame) :void
	{
		super.game = value;
		_game.addEventListener(GameEvent.GAME_START, update);
	}

	
	public function ClothesLine(movie_ref :String = null)
	{
		super(movie_ref);
		
		_line_style = new LineStyle(1);
		_point1 = new Point(0, 0);		_point2 = new Point(200, 0);		_bezier = new Point(100, 50);
	}
	
	public function update(e :GameEvent = null) : void
	{
		if(!_game) return;
		if(e) _game.removeEventListener(GameEvent.GAME_START, update);
		
		_movie.graphics.clear();
		if(_showLine)
		{
			_line_style.applyToGraphics(_movie.graphics);
			_movie.graphics.moveTo(_point1.x, _point1.y);
			_movie.graphics.curveTo(bezier.x, bezier.y, _point2.x, _point2.y);
		}
		
		// Área de colisión un poco + alta para que el char la detecte bien detectada
		var safeY :Number = _game.options.maxGravity;
		_movie.graphics.beginFill(0, 0);
		_movie.graphics.lineStyle(0, 0, 0);
		_movie.graphics.drawRect(0, -safeY, width, height+safeY+safeY);
		_movie.graphics.endFill();
	}


	override public function contact(char :Char) :void
	{
		var charX :Number = char.x - x,
			charH :Number = char.engine.collisionBox.box.height,
			hanged :Boolean = char.state.hanged;
		
		//			   Si cae y está dentro de la cuerda
		if( (hanged || (char.willHang && char.engine.vector.y > 0)) && charX > _point1.x && charX < _point2.x)
		{
			var by :Number = getBezierPos( (charX - _point1.x) / _point2.x ).y + y + charH;
			
			// 			  Si está lo suficientemente cerca del punto dónde colgarse...
			if( hanged || (char.y > by && char.y - by < _game.options.maxGravity))
			{
				char.y = by;
				char.engine.vector.y = 0;
				if(!hanged) char.state.hanged = true;
				// Colgado puede saltar hacia arriba
				char.canJump = true;
			}
		}
		else if(hanged)
			char.state.hanged = false;
	}
	
	private function getBezierPos(time :Number) : Point
	{
		return new Point(
			_point1.x*(1-time)*(1-time)+2*_bezier.x*(1-time)*time+_point2.x*time*time,			_point1.y*(1-time)*(1-time)+2*_bezier.y*(1-time)*time+_point2.y*time*time
		);
	}
}
}
