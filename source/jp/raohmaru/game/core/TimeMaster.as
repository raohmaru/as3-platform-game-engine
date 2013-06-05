package jp.raohmaru.game.core 
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * Controlador global del tiempo en el juego.
 * @author raohmaru
 */
public final class TimeMaster extends EventDispatcher 
{
	private var _engine :Sprite,
				_list :Array,
				_len :int;
	private static var _instance :TimeMaster;
	
	public function TimeMaster(enforcer : SingletonEnforcer)
	{		
	}
	
	public function init() : void
	{
		_engine = new Sprite();
		_list = [];
	}
	
	public function add(func :Function) : void
	{
		_len = _list.push(func);
	}
	
	public function remove(func :Function) : void
	{
		var i = _len;
		while(--i > -1)
		{
			if(_list[i] == func)
			{
				_list.splice(i, 1);
				break;
			}
		}
	}
	
	public function start() : void
	{
		_engine.addEventListener(Event.ENTER_FRAME, enterframeHandler);
	}
	
	public function stop() : void
	{
		_engine.removeEventListener(Event.ENTER_FRAME, enterframeHandler);
	}
	
	private function enterframeHandler(e :Event) :void
	{
		var i = _len;
		while(--i > -1)
			_list[i]();
	}

	
	/**
	 * Crea una instancia singleton de TimeMaster para utilizar en una misma aplicación.
	 * @return Instancia singleton de TimeMaster
	 * @example
	<listing version="3.0">
	import jp.raohmaru.game.core.TimeMaster;<br>
	var cssman : TimeMaster = TimeMaster.getInstance();</listing>
	 */
	public static function getInstance() :TimeMaster
	{
		if( _instance == null )
			_instance =	new TimeMaster(new SingletonEnforcer());
		
		return _instance;
	}
}
}

internal class SingletonEnforcer{}