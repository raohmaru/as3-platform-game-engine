package jp.raohmaru.game.core 
{
import flash.display.Sprite;
import flash.events.*;
import flash.geom.Point;

import jp.raohmaru.game.chars.*;
import jp.raohmaru.game.enums.*;
import jp.raohmaru.game.events.CharEvent;
import jp.raohmaru.game.helpers.*;
import jp.raohmaru.game.levels.*;
import jp.raohmaru.game.levels.props.Prop;
import jp.raohmaru.game.levels.terrains.Floor;
import jp.raohmaru.game.levels.terrains.Terrain;
import jp.raohmaru.game.properties.*;

/**
 * @author raohmaru
 */
public class BasicEngine extends EventDispatcher
{
	protected var 	_char :Char,
					_chprops :CharProperties,					_chmods :CharModifiers,					_chstate :StatesManager,
					_game :PlatformGame,
					_timer :TimeMaster,
					_colmap :CollisionMap,
					_terrains :Array,					_props :Array,
					
					_vector :Point,
					_collision_box :CollisionBox,
					_box :Sprite,
					_floor_angle :Number = 0,
					_hits :HitSides,					_pixel_colors :PixelColorSides,
					_circle_points :Array,
					_circle_points_length :int,
					
					_running :Boolean,
					_move_dir :String,					_climb_dir :String;

	private const	PI :Number =  Math.PI,  // Más rápido que acceder a la constante desde Math.PI
					_DEGREES :Number =  180/PI,
					_3Q_CIRCLE :Number = PI*3,
					_GRAVITY :Number = 9.81;

	public function get collisionBox() : CollisionBox
	{
		return _collision_box;
	}
	public function get pixelColors() : PixelColorSides
	{
		return _pixel_colors;
	}
	public function get hits() : HitSides
	{
		return _hits;
	}	
	
	public function get vector() : Point
	{
		return _vector;
	}
	public function get running() : Boolean
	{
		return _running;
	}
	
	public function get resting() : Boolean
	{
		return running;
	}	
	public function set resting(value : Boolean) : void
	{
		if(value)
		{
			stop();
			_char.alpha = .5;
		}
		else
		{
			start();
			_char.alpha = 1;
		}
	}
	
	public function get moveDir() : String
	{
		return _move_dir;
	}
	public function set moveDir(value :String) :void
	{
		_move_dir = value;
	}
	
	public function get climbDir() : String
	{
		return _climb_dir;
	}
	public function set climbDir(value :String) :void
	{
		_climb_dir = value;
	}
		
		
	public function BasicEngine(char :Char)
	{
		_char = char;
		
		_collision_box = new CollisionBox(char, char.movie.collision_box);
		_collision_box.setNumsPoints( new CollisionBoxPoints(2, 3, 2, 3) );
		_box = _collision_box.box;
		
		_hits = new HitSides();		_pixel_colors = new PixelColorSides(_char, _collision_box);
		
		_chprops = _char.properties;
		_chprops.addEventListener(CharEvent.PROPERTY_CHANGE, onPropertiesChange);
		
		_timer = TimeMaster.getInstance();
	}
	
	/**
	 * Prepara el engine para el nivel actual.
	 */
	public function init() : void
	{
		_chmods = _char.modifiers;		_chstate = _char.state;
		
		_vector = new Point();
		
		_game = _char.game;
		var level_stage :LevelStage = _game.getCurrentLevel().stage;
		
		_colmap = level_stage.collisionMap;
		_terrains = level_stage.terrains;		_props = level_stage.props;
		_pixel_colors.collisionMap = _colmap;
		
		onPropertiesChange();
	}

	public function start() : void
	{
		_timer.add(onTimerStep);
		_running = true;
	}

	public function stop() : void
	{
		_timer.remove(onTimerStep);
		_running = false;
	}
	
	
	
	protected function onTimerStep() : void
	{
		var crouch_mod :Number = (_chstate.crouching) ? _chprops.crouchVelMod : 1,
			maxVelX :Number = _chprops.maxVelX * crouch_mod,			sMaxVelX :Number = _chprops.sMaxVelX * crouch_mod;
		
		// MODIFICADORES
		// Aceleración X
		if( _move_dir &&
			_chmods.willMove &&
			 // Límites a la velocidad
		 	((_vector.x > -maxVelX && _move_dir == Direction.LEFT) ||
		 	 (_vector.x < maxVelX && _move_dir == Direction.RIGHT)) )
		
			_vector.x += _chprops.incrVelX * crouch_mod *  
						(_move_dir == Direction.LEFT ? -1 : 1) *
						(_chstate.falling ? _chprops.airMovMod : 1);   // En el aire es más difícil cambiar de dirección
						
		// Escalando
		if(_chstate.inLadder)		
			if(_climb_dir && _chmods.willClimb)
				_vector.y = _chprops.climbSpeed * (_climb_dir == Direction.UP ? -1 : 1);
			else if(_chstate.climbing)  // Si se escala pero no se mueve se para la velocidad de ascenso 
				_vector.y = 0;
		
		
		_vector.x *= _chmods.velX;		_vector.y *= _chmods.velY;
		
		
		// Frenada X
		var absVX :Number = _vector.x;  // Esto es infinitamente más rápido que Math.abs()
			if(absVX < 0) absVX = -absVX;
		if(!_move_dir && absVX > 0 && (!_chprops.physics || (!_chstate.inSlope && _chprops.physics)))
			if(_chstate.climbing)
				_vector.x = 0;  // Escalando o colgado frena en seco
			else
				_vector.x -= _vector.x / (_chprops.brakeX /
							((_chstate.falling ? _chprops.airBreakMod : 1) // En el aire hay menos fricción
							* _chmods.friction))
							+ 1e-18 - 1e-18;  // Según [http://wiki.joa-ebert.com/index.php/Avoiding_Denormals], para evitar números demasiado pequeños
						
		if(_vector.x < .1 && _vector.x > -.1) _vector.x = 0;
		
		// Gravedad
		if(!_chstate.climbing && !_chstate.hanged)
			_vector.y += _game.options.gravityIncr * _chmods.gravity;
		
				
		// Modificación a la velocidad según la morfología del suelo
		if(_chprops.physics)
		{
			if(!_chstate.inEdge && _floor_angle != 0 && !_chstate.falling)  // Para que no afecte al saltar a una cornisa
			{
				// Aceleración de un cuerpo cilíndrico en un plano inclinado
				// [http://www.sc.ehu.es/sbweb/fisica/solido/plano_inclinado/plano_inclinado.htm]				var a :Number = (2*_chprops.mass*_GRAVITY*Math.sin(_floor_angle)) / (1.5);
				
				_vector.x -= Math.cos(_floor_angle) * a;
				_vector.y += Math.sin(_floor_angle) * a;
			}
		}
		
		// Rotación según la inclinación del suelo
		if(_chprops.rotateByFloor)
		{
			var _rot :Number = _char.graphic.rotation,
				_y :Number = _char.graphic.y,
				absAngle :Number = _floor_angle;
				if(absAngle < 0) absAngle = -absAngle;
																			 // % de inclinación del suelo hasta donde se rotará
			if(!_chstate.falling && _floor_angle != 0 && !_chstate.inCorner && !_chstate.inEdge && absAngle < _chprops.maxFloorAngleToRotate)
			{
				_rot = _floor_angle * _DEGREES;
				_y = _vector.x * _floor_angle;
			}
			
			_char.graphic.rotation -= (_char.graphic.rotation+_rot) * (_chstate.falling ? .1 : .2);  // Más rápido multiplicar que / (_chstate.falling ? 10 : 5);
			_collision_box.box.rotation = _char.graphic.rotation;
			
			// Corrige un desfase en la altura al rotar el char
			_char.graphic.y -= (_char.graphic.y+_y) / 3;
		}
				
				
		// ¿Está cayendo, saltando o escalando?
		_chstate.falling = !_hits.bottom;
		_char.canJump = !_chstate.falling;
		_chstate.inFloor = _hits.bottom;
		if(_chstate.jumping && _vector.y >= 0) _chstate.jumping = false;
		if(!_chstate.climbing && _climb_dir && _chstate.inLadder && _chstate.falling) _chstate.climbing = true;
		else if(_chstate.climbing && (!_chstate.inLadder || !_chstate.falling)) _chstate.climbing = false;
		
		
		
		// Límites
		if(_vector.x < -sMaxVelX)					_vector.x = -sMaxVelX;
		else if(_vector.x > sMaxVelX)				_vector.x = sMaxVelX;
		if(_vector.y > _game.options.maxGravity)	_vector.y = _game.options.maxGravity;
		
		if(_chstate.hanged) _vector.x *= _chprops.hangMod;
		
		
		
		// Actualiza el BitmapData de donde obtener los píxeles de color
		_pixel_colors.updateBitmap(_vector);
		
		
		// Inclinación del suelo
		if(_vector.y >= 0) calculateFloorInclination();
		
		
		var oldX :Number = _char.x,
			oldY :Number = _char.y;
			
		
		// HIT TEST 1
		// Distance collision check
		collisionCheck();
		
		_char.x = Math.round(_char.x + _vector.x + _chmods.incrX);
		_char.y = Math.round(_char.y + _vector.y + _chmods.incrY);
		
				
		// HIT TEST 2
		// Corrige la posición si se está dentro de una zona de colisión
		collisionCheck(false);
		
		
		// FIXME Corrige un bug cuando se salta a una cornisa y se cae justa en la esquina, provocando que el char no pueda moverse
		if(oldX == _char.x && oldY == _char.y && !_hits.bottom && !_hits.left && !_hits.right && _vector.y != 0 && _vector.x != 0)
		{
			_vector.y = 0;
			// Para minimizar el tiempo que está parado
			_char.x += Math.round(_vector.x + _chmods.incrX);			_char.y -= 1;
		}
		
		
		// Contacto con algún prop del nivel
		propDetection();
		
		
		// ¿Entra en estado de reposo?
		if(_chprops.canRest)
		{
			absVX = _vector.x;
				if(absVX < 0) absVX = -absVX;			var absVY :Number = _vector.y;
				if(absVY < 0) absVY = -absVY;
			
			if(absVX <= .1 && absVY <= _game.options.minGravity && !_chstate.falling && !_move_dir )
				resting = true;
		}
		
		
		
		
		dispatchEvent(new CharEvent(CharEvent.MOVE, _game, _char));
	}	
	
	
	
	protected function collisionCheck(dte_check :Boolean = true) :void
	{		var detection_order :Array = [_hits.bottomSide, _hits.leftSide, _hits.rigthSide, _hits.topSide],
			temp_value :Boolean,
			side :Side,
			i :int;
		
		if(!dte_check)
		{		
			// Si se mueve hacia la derecha, se detecta antes el lado derecho
			if(_vector.x > 0)
			{
				detection_order[1] = _hits.rigthSide;
				detection_order[2] = _hits.leftSide;
			}
			// Si ascendiende, se detecta primero el lado superior			if(_vector.y < 0)
			{
				detection_order.pop();				detection_order.unshift(_hits.topSide);
			}
		}
		
		while(i < 4)
		{
			side = detection_order[i];
			temp_value = sideCollisionCheck(side.side, side.axis, side.incr, dte_check);
			if(dte_check) _hits[side.side] = temp_value;
			++i;  // ¿Más rápido que i++?
		}
	}
	
	protected function sideCollisionCheck(side :String, prop :String, incr :Number, dte_check :Boolean = true) :Boolean
	{
		var points :Array = _collision_box[side+'Points'],
			points_len :int = points.length,
			point :Point,
			new_vector :Number,
			temp_value :Number,
			new_value :Number,
			abs_vector :Number, abs_new_vector :Number, abs_value :Number, abs_new_value :Number,
			i :int;
		 
		while(i < points_len)
		{
			point = Point(points[i]).clone();			
			point.x += _char.x;
			point.y += _char.y;
				
			// Detecta colisiones sólo si el vector va en el sentido de la detección
			if( dte_check && ((incr > 0 && _vector[prop] > 0) || (incr < 0 && _vector[prop] < 0)) )
			{
				temp_value = 0;
				abs_vector = _vector[prop];  // Más rápido que Math.abs()
				if(abs_vector < 0) abs_vector = -abs_vector;
				
				// Detecta si hay una posible colisión según la distancia indicada
				var j :int = 0;
				while(j < abs_vector)
				{
					// Comprueba que el color del pixel en esa coordenada sea de un tipo de terreno
					if(	pixelColorCollisionCheck(point, side) )
					{
						abs_new_vector = new_vector;
						if(abs_new_vector < 0) abs_new_vector = -abs_new_vector;
						
						if( isNaN(new_vector) || ( j < abs_new_vector ) ) new_vector = temp_value;
						
						break;
					}
					point[prop] += incr;
					temp_value += incr;
					
					++j;
				}
			}
			
			
			// Si se ha detectado colisión pero se está metido dentro de la zona de colisión...
			if(!dte_check)
			{
				// No estoy muy seguro pq se ha de sumar el _vector, pero corrige el desfase al volver a obtener el color de un pixel
				// después de haber movido el char
				point.x += _vector.x;
				point.y += _vector.y;
				temp_value = 0;
								while( pixelColorCollisionCheck(point, side, true) )
				{		
					point[prop] -= incr;
					temp_value -= incr;
				}
				
				abs_value = temp_value;
				if(abs_value < 0) abs_value = -abs_value;
				
				abs_new_value = new_value;
				if(abs_new_value < 0) abs_new_value = -abs_new_value;
				
				if( (isNaN(new_value) && temp_value != 0) || ( abs_value > abs_new_value ) )
					new_value = temp_value + incr;
			}
			
			++i;
		}
		
		if(!isNaN(new_vector)) _vector[prop] = new_vector;
		if(!isNaN(new_value)) _char[prop] += new_value;
		
		return dte_check ? !isNaN(new_vector) : !isNaN(new_value);
	}
	
	protected function pixelColorCollisionCheck(point :Point, side :String, is2ndCheck :Boolean = false) :Boolean
	{
		var pixel_color :uint = _pixel_colors.getPixelColor(
				point.x-_char.x,
				point.y-_char.y
		);
		
		
		// Permite bajar de una plataforma marcada como Floor; si es una escalera y se está en la parte superior moviéndose hacia abajo,
		// y si es una plataforma agachado y después se salta		
		if(side == Side.BOTTOM)
		{
			if(pixel_color == Floor.COLOR)
			{
				if( (_climb_dir == Direction.DOWN && _chstate.inLadder && !is2ndCheck) || (_chprops.canJumpDown && _chstate.jumpingDown) )
					return false;
			}
			else if(pixel_color != 0 && _chstate.jumpingDown)
				_chstate.jumpingDown = false;
		}			
		
		
		var terrain :Terrain,
			_terrains_len :int = _terrains.length,
			i :int;
		// Detecta colisión si el color es de un tipo específico de terreno
		while(i < _terrains_len)
		{
			terrain = _terrains[i];
			// Almacena el color del píxel sólo si corresponde a un color de la lista de terrenos
			if(pixel_color == terrain.color) _pixel_colors[side] = pixel_color;
			if( terrain.check(pixel_color, side, is2ndCheck) ) return true;
			++i;
		}
		
		return false;
	}
	
	protected function calculateFloorInclination() : void
	{		
		var _y :Number = 0,
			slope_depth :Number = _chprops.slopeDepth,
			
			point :Point = new Point(),
			i :int,
			
			incr1 :Number = PI,			incr2 :Number = -PI,
			point1 :Point = new Point(),			point2 :Point = new Point(),
			founded1 :Boolean,			founded2 :Boolean,
			
			cateto1 :Number,			cateto2 :Number;
						
			
		// Detecta un punto donde calcular la rotación hasta cierta profundidad, por si se baja por una ladera y se pierde contacto con el suelo
		while(_y < slope_depth) 
		{
			if(_pixel_colors.getPixelColor(0, _y) != 0)
				break;
				
			++_y;
		}
		
		
		// Si no se ha detectado ningún punto...
		if(_y >= slope_depth) return;
		
		
		/**
		 * Averigua la inclinación recorriendo los puntos de un círculo, una vez para el lado izquierdo y otro para el derecho,
		 * hasta que encuentra dos colisiones.
		 *     <-    ->
		 *      (    )
		 *    (        )
		 *   (        .·x
		 *   (    .·    )
		 *    x.·      )
		 *      (    )
		 */		while( i < _circle_points_length)
		{
			point.x = Point(_circle_points[i]).x;
			point.y = Point(_circle_points[i]).y + _y;
				
			// Detectar por separado es más rápido q un for con arrays
			if(!founded1)
			{
				founded1 = _pixel_colors.getPixelColor( point.x, point.y ) != 0;
				if(founded1)
				{
					point1.x = point.x;					point1.y = point.y;
				}
				else
					incr1 += _chprops.slopePrecision;
					
				if(_game.debug)
				{
					_char.helperLayer.getChildByName('rot0').x = point.x;
					_char.helperLayer.getChildByName('rot0').y = point.y;
				}
			}
			if(!founded2)
			{
				point.x = -point.x;
				founded2 = _pixel_colors.getPixelColor( point.x, point.y ) != 0;
				if(founded2)
				{
					point2.x = point.x;
					point2.y = point.y;
				}
				else
					incr2 -= _chprops.slopePrecision;
					
				if(_game.debug)
				{
					_char.helperLayer.getChildByName('rot1').x = point.x;
					_char.helperLayer.getChildByName('rot1').y = point.y;
				}
			}
			
			++i;
		}
		
		cateto1 = point2.x - point1.x;		cateto2 = point2.y - point1.y;
		//_floor_angle = (point1.y-point2.y) / Point.distance(point1, point2);		_floor_angle = (point1.y-point2.y) / Math.sqrt(cateto1*cateto1 + cateto2*cateto2);  // Mucho más rápido
		if(isNaN(_floor_angle)) _floor_angle = 0;
		
		
		// ¿Está en una esquina o en una cornisa?
		incr1 -= _chprops.slopePrecision*2; 		// Se restan 2 incrementos innecesarios
		incr2 = -incr2 - _chprops.slopePrecision*2;
		
		_chstate.inCorner = (_hits.bottom && (_hits.left || _hits.right) && (_floor_angle <= 0.1 && _floor_angle >= -0.1) );
		
		// Detecta si un punto está en el ángulo del suelo y el otro tocando un lado inclinado		var in_edge :Boolean =	(int(incr1) == 4 && incr2 > 5) ||   // Para números positivos, int() es + rápido que Math.floor()
								(int(incr2) == 4 && incr1 > 5);		
		if(in_edge)	// Nos aseguramos que sea una cornisa y no una pendiente			in_edge = _pixel_colors.getPixelColor((point2.x+point1.x)>>2, (point2.y+point1.y)>>2) != 0; // >>2 equivale a /4		
		_chstate.inEdge = in_edge;
		
		_chstate.inSlope = (!in_edge && _floor_angle != 0);
	}
	
	protected function propDetection() : void
	{
		var len :int = _props.length,
			i :int = 0,
			prop :Prop,
			hit :Boolean;
			
		while(i < len)
		{
			prop = _props[i];
			
			if(prop.visible)			
				if(_box.hitTestObject(prop))
				{
					prop.contact(_char);
					hit = true;
				}
			
			++i;
		}
		
		// Restaura los estados que se cambian al colisionar con ciertos props (por si acaso)
		if(!hit)
		{
			if(_chstate.inLadder) _chstate.inLadder = false;			if(_chstate.inRope) _chstate.inRope = false;			if(_chstate.hanged) _chstate.hanged = false;
		}
	}

	
	protected function onPropertiesChange(e :CharEvent = null) :void
	{
		_collision_box.update();
		
		
		// Guarda en una matriz los puntos de una circunferencia, utilizados para detectar la inclinación del terreno.
		var incr :Number = PI,
			radius :Number = _char.properties.stepSize.width/2,
			slope_precision :Number = _char.properties.slopePrecision;
		_circle_points = [];
			
		// Hace 3/4 de circunferencia
		while( incr < _3Q_CIRCLE )
		{			
			_circle_points.push( new Point(Math.sin(incr)*radius, Math.cos(incr)*radius) );
			incr += slope_precision;
		}
		
		_circle_points_length = _circle_points.length;
	}
}
}