package jp.raohmaru.game.levels.terrains 
{
import jp.raohmaru.game.enums.Side;
import jp.raohmaru.game.levels.terrains.Terrain;

/**
 * @author raohmaru
 */
public class Floor extends Terrain 
{
	public static const COLOR :uint = 0x008484;
	
	/**
	 * Crea una nueva instancia de Floor.
	 * @param color Color del terreno (por defecto #008484).
	 */
	public function Floor(color :uint = 0x008484)
	{
		super(color, [Side.BOTTOM]);
	}
}
}
