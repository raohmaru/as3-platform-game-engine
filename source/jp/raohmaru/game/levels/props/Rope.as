package jp.raohmaru.game.levels.props 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.levels.props.Prop;
import jp.raohmaru.geom.LineStyle;

/**
 * @author raohmaru
 */
public class Rope extends Ladder
{
	private var _length :Number = 100,
				_showLine : Boolean = false,
				_line_style :LineStyle = new LineStyle(3);

	public function get length() : Number
	{
		return _length;
	}	
	public function set length(value : Number) : void
	{
		_length = value;
		draw();
	}
	
	public function get showLine() : Boolean
	{
		return _showLine;
	}	
	public function set showLine(value : Boolean) : void
	{
		_showLine = value;
		draw();
	}
	
	public function get lineStyle() : LineStyle
	{
		return _line_style;
	}	
	public function set lineStyle(value : LineStyle) : void
	{
		_line_style = value;
		draw();
	}

	
	public function Rope(movie_ref :String = null)
	{
		super(movie_ref);
		colBoxWidth = 7;
	}
	
	override public function draw() : void
	{
		_movie.graphics.clear();
		if(_showLine)
		{
			_line_style.applyToGraphics(_movie.graphics);
			_movie.graphics.lineTo(0, _length);
		}
		
		// Área de colisión un poco + ancha para que el char la detecte bien detectada
		_movie.graphics.beginFill(0, 0);
		_movie.graphics.lineStyle(0, 0, 0);
		_movie.graphics.drawRect(-_colbox_width, 0, _colbox_width+_colbox_width, _length);
		_movie.graphics.endFill();
	}


	override public function contact(char :Char) :void
	{
		super.contact(char);
		
		char.state.inRope = char.state.inLadder;
		
		if(char.state.climbing)
		{
			var charH :Number = char.engine.collisionBox.box.height;
			
			char.x = x;
			if(char.y-charH < y) char.y = y + charH;  // Cuando llega arriba no puede continuar subiendo
			if(char.modifiers.willMove) char.modifiers.willMove = false;
		}
		else if(!char.modifiers.willMove) char.modifiers.willMove = true;
	}
}
}
