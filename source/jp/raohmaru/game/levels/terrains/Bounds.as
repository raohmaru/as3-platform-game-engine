package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.enums.Side;
import jp.raohmaru.game.levels.terrains.Terrain;

/**
 * @author raohmaru
 */
public class Bounds extends Terrain 
{
	/**
	 * Crea un nuevo terreno del tipo límites del nivel.
	 * @param color Color del terreno (por defecto #000001, porque el método BitmapData.getPixel() obtiene <code>0</code> si no se ha detectado
	 * ningún color de píxel).
	 */
	public function Bounds(color :uint = 1)
	{
		super(color, Side.ALL);
	}
}
}
