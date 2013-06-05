package jp.raohmaru.game.chars 
{
import jp.raohmaru.game.enums.Direction;

import flash.events.Event;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;

/**
 * @author raohmaru
 */
public class PlayerChar extends Char 
{
	protected var	_space_pressed :Boolean,					_down_pressed :Boolean;
	
	
	public function PlayerChar(movie :String)
	{
		super(movie);
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e :Event) :void
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	
	
	protected function keyHandler(e :KeyboardEvent) :void
	{
		if(e.type == KeyboardEvent.KEY_DOWN)
		{
			if(e.keyCode == Keyboard.LEFT)			move(Direction.LEFT);
			else if(e.keyCode == Keyboard.RIGHT)	move(Direction.RIGHT);			else if(e.keyCode == Keyboard.UP)		move(Direction.UP);
			else if(e.keyCode == Keyboard.DOWN)
			{
				move(Direction.DOWN);
				
				if(!_down_pressed && !_stateman.climbing)
				{
					crouch();
					_down_pressed = true;
				}
			}
			else if(e.keyCode == Keyboard.SPACE && !_space_pressed)
			{
				jump();
				_space_pressed = true;
			}
			
			// En reposo el engine está detenido
			if(!_engine.resting) _engine.resting = false;
		}
		else
		{
			if( (e.keyCode == Keyboard.LEFT && _engine.moveDir == Direction.LEFT) ||
				(e.keyCode == Keyboard.RIGHT && _engine.moveDir == Direction.RIGHT )) stopMove();
			if (e.keyCode == Keyboard.UP && _engine.climbDir == Direction.UP ) stopClimb();
				
			if(e.keyCode == Keyboard.DOWN)
			{
				if(_engine.climbDir == Direction.DOWN) stopClimb();
				
				if(_stateman.crouching) crouch(false);
				_down_pressed = false;
			}
			
			if(e.keyCode == Keyboard.SPACE && _space_pressed) _space_pressed = false;			
		}
	}
}
}