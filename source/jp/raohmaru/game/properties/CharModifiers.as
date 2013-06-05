package jp.raohmaru.game.properties 
{
import jp.raohmaru.game.chars.Char;
import jp.raohmaru.game.events.CharEvent;
import jp.raohmaru.game.levels.terrains.Terrain;

/**
 * @author raohmaru
 */
public final class CharModifiers 
{
	private var _char :Char,
				_terrains :Array,				_terrains_len :int,
				_active_terrains :int,
				
				_friction :Number,				_gravity :Number,
				_incrX : Number,				_incrY : Number,
				_velX : Number,				_velY : Number,
				_jump : Number,
				_willMove : Boolean,
				_willClimb : Boolean;

	public static const	DEFAULT_FRICTION :Number = 1,
						DEFAULT_GRAVITY :Number = 1,
						DEFAULT_INCRX :Number = 0,						DEFAULT_INCRY :Number = 0,
						DEFAULT_VELX :Number = 1,
						DEFAULT_VELY :Number = 1,						DEFAULT_JUMP :Number = 1;
	
	public function get friction() :Number
	{
		return _friction;
	}
	public function set friction(value :Number) :void
	{
		_friction = value;
	}
	
	public function get gravity() :Number
	{
		return _gravity;
	}
	public function set gravity(value :Number) :void
	{
		_gravity = value;
	}
		
	public function get incrX() : Number
	{
		return _incrX;
	}	
	public function set incrX(value : Number) : void
	{
		_incrX = value;
	}
	
	public function get incrY() : Number
	{
		return _incrY;
	}	
	public function set incrY(value : Number) : void
	{
		_incrY = value;
	}
	
	public function get velX() : Number
	{
		return _velX;
	}	
	public function set velX(value : Number) : void
	{
		_velX = value;
	}
	
	public function get velY() : Number
	{
		return _velY;
	}	
	public function set velY(value : Number) : void
	{
		_velY = value;
	}
	
	public function get jump() : Number
	{
		return _jump;
	}
	public function set jump(value : Number) : void
	{
		_jump = value;
	}
	
	public function get willMove() : Boolean
	{
		return _willMove;
	}	
	public function set willMove(value : Boolean) : void
	{
		_willMove = value;
	}
	
	public function get willClimb() : Boolean
	{
		return _willClimb;
	}	
	public function set willClimb(value : Boolean) : void
	{
		_willClimb = value;
	}
	
	
	
	public function CharModifiers(char :Char)
	{
		_char = char;		
		_char.engine.addEventListener(CharEvent.MOVE, update);
	}
	
	public function init() : void
	{
		_terrains = [];
		_active_terrains = 0;
		
		var lv_terrains :Array = _char.game.getCurrentLevel().stage.terrains,
			terrain :Terrain;
		
		// Únicamente comprobará los tipos de terreno que modifiquen las propiedades del char
		for(var i:int=0; i<lv_terrains.length; i++) 
		{
			terrain = lv_terrains[i];
			if(terrain.isModifier) _terrains.push(terrain);
		}
		
		_terrains_len = _terrains.length;
		
		reset();
	}	
	
	private function update(e :CharEvent) :void
	{
		var terrain :Terrain,
			check :Boolean,
			bit :int,
			is_active :Boolean,
			i :int;
		
		while(i < _terrains_len)
		{
			terrain = _terrains[i];
			check = terrain.checkModifier(_char.engine.pixelColors);
			// Con las operaciones de bit, se genera un valor de bit para cada terreno (1 elevado a i), con el q se compara en _active_terrains para saber
			// si está incluido o no. Luego se incluye o se elimina con los operadors | y ^
			bit = 1<<i;
			is_active = (_active_terrains & bit) > 0;
			
			// Aplica los modificadores si está dentro del terreno o sólo 1 vez cuando sale
			if( check || (!check && is_active) )
				// Se pasan así los objetos por optimización, pues es más lento acceder a un objeto pasando por varias propiedades
				terrain.applyModifier(_char, _char.engine, this, _char.properties);
				
			// Añade o elimina de la lista de modificadores activos el terreno actual
			if(check && !is_active)
				_active_terrains = _active_terrains | bit;
			else if(!check && is_active)
				_active_terrains = _active_terrains ^ bit;
				
			++i;  // ¿Más rápido que i++?
		}
	}
	
	/**
	 * Restablece el valor de un modificador.
	 * @param mod Modificador a restablecer.
	 * @see jp.raohmaru.game.enums.Modifiers
	 */
	public function restore(mod :String) : void
	{
		this[mod] = this['DEFAULT_' + mod.toUpperCase()];
	}
	
	public function reset() : void
	{
		_friction = DEFAULT_FRICTION;		_gravity = DEFAULT_GRAVITY;
		_incrX = DEFAULT_INCRX;		_incrY = DEFAULT_INCRY;
		_velX = DEFAULT_VELX;
		_velY = DEFAULT_VELY;		_jump = DEFAULT_JUMP;
		_willMove = true;
		_willClimb = true;
	}
}
}