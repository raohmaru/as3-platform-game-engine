package jp.raohmaru.game.levels.props 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.levels.props.Prop;

/**
 * Elemento del tipo escalera. Para que un char pueda caminar por la parte superior y no caer, el sprite de colisión debe contener una forma
 * con el color de relleno de Floor que haga de suelo en la parte superior.
 * @author raohmaru
 */
public class Ladder extends Prop 
{
	protected var _colbox_width : Number;
	
	/**
	 * Establece un ancho extra para comprobar la colisión con los chars, por si la escalera es demasiado estrecha.
	 * @default width
	 */
	public function get colBoxWidth() : Number
	{
		return _colbox_width;
	}	
	public function set colBoxWidth(value : Number) : void
	{
		_colbox_width = value;
		draw();
	}
	
	
	public function Ladder(movie_ref :String)
	{
		super(movie_ref);
		_colbox_width = width;
	}
	
	public function draw() : void
	{
		_movie.graphics.clear();
		
		if(_colbox_width > width)
		{
			// Área de colisión un poco + ancha para que el char la detecte bien detectada
			_movie.graphics.beginFill(0, 0);
			_movie.graphics.lineStyle(0, 0, 0);
			_movie.graphics.drawRect(-_colbox_width, 0, _colbox_width+_colbox_width, height);
			_movie.graphics.endFill();
		}
	}

	override public function contact(char :Char) :void
	{
		var charX :Number = char.x,
			charY :Number = char.y,
			charH :Number = char.engine.collisionBox.box.height,
			min_area :Number = charH >> 1;  // >> 1 -> /2
			
		// Si está dentro de la escalera...
		char.state.inLadder = (	charX > x-_colbox_width && charX < x+_colbox_width &&
								charY-(y+height) < min_area && 	// Verticalmente el char debe tener al menos un 50% de su cuerpo  
								y-(charY-charH) < min_area );	// dentro de la escalera
								
		// Escalando puede saltar hacia arriba
		if(char.state.climbing) char.canJump = true;
	}
}
}
