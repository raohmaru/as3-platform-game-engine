package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.enums.Side;
import jp.raohmaru.game.levels.terrains.Terrain;

/**
 * @author raohmaru
 */
public class Wall extends Terrain 
{
	/**
	 * Crea una nueva instancia de Wall.
	 * @param color Color del terreno (por defecto #CC0000).
	 */
	public function Wall(color :uint = 0xCC0000)
	{
		super(color, [Side.LEFT, Side.RIGHT]);
	}
}
}
