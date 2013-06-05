package jp.raohmaru.game.levels 
{
import jp.raohmaru.game.core.GameSprite;

/**
 * @author raohmaru
 */
public class CollisionMap extends GameSprite
{	
	public function CollisionMap(movie_ref :String)
	{
		super(movie_ref);
		// Se oculta pq se añade a la lista de visualización del juego, pq si no no funciona el método DisplayObject.hitTestPoint()
		//visible = false;
	}
}
}