package  
{
import flash.display.MovieClip;
import flash.geom.Point;
import flash.geom.Rectangle;

import jp.raohmaru.game.chars.PlayerChar;
import jp.raohmaru.game.core.*;
import jp.raohmaru.game.enums.Depth;
import jp.raohmaru.game.levels.*;
import jp.raohmaru.game.levels.CollisionMap;
import jp.raohmaru.game.levels.props.*;
import jp.raohmaru.game.levels.props.Platform;
import jp.raohmaru.game.levels.terrains.*;

/**
 * @author Raul_Parralejo
 */
public class Test extends MovieClip 
{
	private var _game :PlatformGame;
	
	public function Test()
	{		
		_game = new PlatformGame();
		//_game.view.x = 50;
		//_game.view.y = 50;
		_game.camera.viewportRect = new Rectangle(0, 0, 500, 300);
		//_game.camera.restrictToLevelBounds = false;
		//_game.camera.horizontalScroll = false;
		//_game.camera.verticalScroll = false;
		//_game.debug = true;
		
		addChildAt(_game.view, 0);
		
		setupLevel(10);
		
		var player :PlayerChar = new PlayerChar("player");
			player.properties.canRest = false;
			player.properties.rotateByFloor = true;			player.properties.physics = true;
			//player.move();
		
		_game.addPlayer(player);			
		_game.start();
	}
	
	private function setupLevel(id :int) :void
	{
		var colmap :CollisionMap = new CollisionMap("collision"+id),
			map :Foreground = new Foreground("collision"+id);
			
		var level :Level = _game.addLevel( new Level() );
			level.stage.addCollisionMap(colmap);
			level.stage.addForeground(map);
			
		switch(id)
		{
			case 1:
				level.stage.addTerrain( new Floor() );
				level.playerStart = new Point(200, 70);
				break;
		
			case 2:
				level.stage.addTerrain( new Floor() );
				level.stage.addTerrain( new Wall() );
				level.playerStart = new Point(240, 140);
				break;
		
			case 3:
				level.stage.addTerrain( new Ice() );
				level.playerStart = new Point(20, 200);
				break;
		
			case 4:
				level.playerStart = new Point(100, 90);
				break;
		
			case 5:
				level.playerStart = new Point(300, 30);
				break;
		
			case 6:
				level.playerStart = new Point(220, 30);
				break;
		
			case 7:
				level.playerStart = new Point(14, 48);
				break;
		
			case 8:
				
				var trees :Background = new Background("trees"),
					trees_fg :Foreground = new Foreground("treesfg");
					
				var sky :Background = new Background("sky");
					sky.fixed = true;
					
				var mountains :Background = new Background("mountains");
					mountains.delta = new Point(.5,1);
				
				level.stage.addBackground(sky);
				level.stage.addBackground(mountains);
				level.stage.addBackground(trees);
				level.stage.addForeground(trees_fg);
				
				level.playerStart = new Point(177, 204);
				
				break;
				
			case 9:
				level.stage.addTerrain( new Floor() );
				level.stage.addTerrain( new Sand() );
				level.playerStart = new Point(314, 129);
				break;
		
			case 10:
				level.stage.addTerrain( new Floor() );
				
				var rope :Rope = new Rope(); 
					rope.x = 2328;
					rope.y = 435;
					rope.length = 365;
					rope.showLine = true;
					rope.depth = Depth.BEHIND;
					
				var ladder :Ladder = new Ladder("ladder");
					ladder.x = 3097;
					ladder.y = 606;
					ladder.depth = Depth.BEHIND;
					
				level.stage.addProp( rope );
				level.stage.addProp( ladder );
					
				level.playerStart = new Point(137, 0);
				break;
		
			case 11:
				level.stage.addTerrain( new Water() );
				level.stage.addTerrain( new Travelator() );
				level.playerStart = new Point(23, 76);
				break;
		
			case 12:				
				level.stage.addTerrain( new Floor() );
				// level.stage.width = 700;
				
				var platform :Platform = new Platform("platform");
					platform.x = 523;
					platform.y = 124;
					platform.distance = new Point(310, 0);
					//platform.depth = Depth.BEHIND;
					
				ladder = new Ladder("ladder");
				ladder.x = 34;
				ladder.y = 50;
				ladder.depth = Depth.BEHIND;
					
				var clothes_line :ClothesLine = new ClothesLine(); 
					clothes_line.x = 137;
					clothes_line.y = 43;
					//rope.bezier = new Point(100, 150);
					clothes_line.showLine = true;
					clothes_line.lineStyle.color = 0x663300;
					clothes_line.depth = Depth.BEHIND;
					
				rope = new Rope(); 
				rope.x = 905;
				rope.y = 35;
				rope.length = 150;
				rope.showLine = true;
				rope.depth = Depth.BEHIND;
					
				level.stage.addProp( platform );
				level.stage.addProp( ladder );
				level.stage.addProp( clothes_line );
				level.stage.addProp( rope );
				
				level.playerStart = new Point(91, 152);
				
				break;				
		}
		
	}
}
}