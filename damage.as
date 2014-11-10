package{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class damage extends MovieClip{
		public var damage_mc:MovieClip;
		public var dmg:String;
		public var dType:String;
		public var speed:Number = 0;
		public var life:Number = 20;
		
		public function damage(type:Number, damage:Number, target:MovieClip){			
			var damageBitmap:Bitmap = new Bitmap();
			var dmgClass:Class;
			var width2:Number = 22;
			
			damage_mc = MovieClip(addChild(new MovieClip()));
			dmg = String(damage);
			dType = String(type);
			
			if(type == 2){
				width2+=5;
				dmg = 'c'+dmg;
			}
			if(damage>0){
				for(var i=0;i<dmg.length;i++){
					damageBitmap = new Bitmap();
					dmgClass = Class(getDefinitionByName("damage"+dType+dmg.charAt(i)));
					damageBitmap.bitmapData = new dmgClass(0, 0);
					damage_mc.addChild(damageBitmap).name = "dmg"+i+"_mc";
					damage_mc.getChildByName("dmg"+i+"_mc").x = width2*i;
					damage_mc.getChildByName("dmg"+i+"_mc").y+=randRange(0, 2);
					if(dmg.charAt(i) == 'c'){
						damage_mc.getChildByName("dmg"+i+"_mc").y = -6;
						damage_mc.getChildByName("dmg"+i+"_mc").x = -10;
					}
					if(dmg.charAt(i) == '1')damage_mc.getChildByName("dmg"+i+"_mc").x+=3;
				}
			}else{
				damageBitmap = new Bitmap();
				dmgClass = Class(getDefinitionByName("damage"+dType+"miss"));
				damageBitmap.bitmapData = new dmgClass(0, 0);
				damage_mc.addChild(damageBitmap).name = "dmg_mc";
			}
			
			damage_mc.x = target.x-damage_mc.width/2;
			damage_mc.y = target.y-target.height/2-damage_mc.height;
			addEventListener(Event.ENTER_FRAME, onEnter);
		}
		public function randRange(min:Number, max:Number):Number{
			return Math.floor(Math.random()*((max+1)-min))+min;
		}
		public function onEnter(e:Event){
			if(speed<3)speed++;
			damage_mc.y-=speed;
			if(life>0)life--;
			if(life == 0 && alpha>0)alpha-=.10;
			if(MovieClip(root).charRef.changing)
			MovieClip(root).setChildIndex(this, MovieClip(root).numChildren-3);
			if(Math.ceil(alpha) == 0)//||MovieClip(root).charRef.changing)
			{
				removeEventListener(Event.ENTER_FRAME, onEnter);
				parent.removeChild(this);
			}
		}
	}
}