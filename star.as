package{
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	public class star extends MovieClip{
		public var target:MovieClip;
		public var xSpeed:Number = 0;
		public var ySpeed:Number = 0;
		public var targX:Number = 0;
		public var fade = false;
		
		public function star(targ:MovieClip, x:Number=0, y:Number=0, starType:String = "Subi", vel = 20, xSp = 0)
		{
			var starRef = Class(getDefinitionByName('b'+starType));
			
			addChild(new starRef()).name = "star_mc";
			
			this.x = x;
			this.y = y;
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			if(x<targ.x)
			{
				xSpeed = (targ.x-x)/vel;
				if(xSpeed<20)xSpeed = 20;
			}
			if(x>targ.x)
			{
				xSpeed = -Math.abs((x-targ.x)/vel)
				if(xSpeed>-20)xSpeed = -20;
			}
			if(y<(targ.y-targ.height/2))
				ySpeed = ((targ.y-targ.height/2)-y)/vel;
			if(y>(targ.y-targ.height/2))
				ySpeed = -Math.abs((y-(targ.y-targ.height/2))/vel)
				
			if(xSp != 0)
			{
				fade = true;
				xSpeed = xSp;
			}
			xSpeed = Math.round(xSpeed);
			ySpeed = Math.round(ySpeed);
			target = targ;
			targX = target.x;
		}
		public function onFrame(e:Event)
		{
			if(!fade)targX = target.x;
			x+=xSpeed;
			y+=ySpeed;
			if((x<targX && xSpeed<0||x>targX && xSpeed>0))
			{
				if(!fade)MovieClip(root).charRef.hurtMonster(target);
				x = targX;
				y = target.y-target.height/2;
				getChildByName("star_mc").visible = false;
				removeEventListener(Event.ENTER_FRAME, onFrame);
				addChild(new starHit()).name = "starHit";
			}
			if(fade)alpha-=.05;
		}
		public function remove()
		{
			MovieClip(root).removeChild(MovieClip(root).getChildByName(this.name));
		}
	}
}