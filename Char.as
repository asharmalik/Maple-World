package{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	
	public class Char extends MovieClip{
		public var char_mc:MovieClip;
		public var portals:Array = new Array();
		public var platforms:Array = new Array();
		public var connects:Array = new Array();
		public var walls:Array = new Array();
		public var spawns:Array = new Array();
		public var levels:Array = new Array();
		public var jump = false;
		public var fall = false;
		public var walking = false;
		public var climbing = false;
		public var attacking = false;
		public var onRope = false;
		public var changing = false;
		public var dead = false;
		public var statKeyDown = false;
		public var conType = "none";
		public var gravity:int = 0;
		public var maxSpawn:int = 0;
		public var spawnCount:int = 0;
		public var maxRange:int = 300;
		public var attID:int = 0;
		public var star:int = 0;
		public var frame:int = 1;
		public var jumpHeight:int = -18;
		public var maxSpeed:int = 6;
		public var speed:int = 0;
		public var friction:Number = 1;
		public var mhp:int = 50;
		public var hp:int = 50;
		public var mmp:int = 50;
		public var mp:int = 50;
		public var str:int = 4;
		public var dex:int = 4;
		public var INT:int = 4;
		public var luk:int = 14;
		public var job:int = 0;
		public var lvl:int = 1;
		public var mastery:int = 10;
		public var wAtk:int = 22;
		public var wDef:int = 10;
		public var magic:int = 1;
		public var mDef:int = 1;
		public var acc:int = 1;
		public var avoid:int = 1;
		public var hands:int = 1;
		public var starAtt:int = 27;
		public var hurt:int = 0;
		public var exp:int = 0;
		public var mexp:int = 0;
		public var ap:int = 0;
		public var statsKey:int = 67;
		public var lastStatX:int = 100;
		public var lastStatY:int = -100;
		public var pid:int = 0;
		
		public function Char(x:int, y:int, mid:int){
			addChild(new charSprite()).name = "char_mc";
			this.x = x;
			this.y = y;
			MovieClip(getChildByName("char_mc")).stop();
			getChildByName("char_mc").addEventListener(Event.ENTER_FRAME, onEnter);
			char_mc = MovieClip(getChildByName("char_mc"));
			levels = [15, 34, 57, 92, 135, 372, 560, 840, 1242, 1716, 2360, 3216, 4200, 5460, 7050, 8840,
					  11040, 13716, 16680, 20216, 24402, 28980, 34320, 40512, 47216, 54900, 63666, 73080,
					  83720, 95700, 108480, 122760, 138666, 155540, 174216, 194832, 216600, 240500, 266682,
					  294216, 324240, 356916, 391160, 428280, 468450, 510420, 555680, 604416, 655200, 709716,
					  748608, 789631, 832902, 878545, 926689, 977471, 1031036, 1087536, 1147032, 1209994,
					  1276301, 1346242, 1346242, 1420016, 1497832, 1579913, 1666492, 1757815, 1854143,
					  1955750, 2062925, 2175973, 2295216, 2420993, 2553663, 2693603, 2841212, 2996910,
					  3161140, 3334370, 3517093, 3709829, 3913127, 4127566, 4353756, 4592341, 4844001,
					  5109452,  5389449, 5684790, 5996316, 6324914, 6671519, 7037118, 7422752, 7829518,
					  8258575, 8711144, 9188514, 9692044, 10223168, 10783397, 11374327, 11997640, 12655110,
					  13348610, 14080113, 14851703, 15665576, 16524049, 17429566, 18384706, 19392187,
					  20454878, 21575805, 22758159, 24005306, 25320796, 26708375, 28171993, 29715818];
		}
		public function platCheck(mc):Boolean{
			for(var i=0;i<platforms.length;i++)
			{
				if(mc.x<=platforms[i].ex && mc.x>=platforms[i].bx &&
					mc.y<=platforms[i].y && mc.y+mc.gravity>=platforms[i].y)
				{
					if(mc.gravity>0)mc.gravity = 0;
					mc.y = platforms[i].y;
					mc.pid = i;
					return true;
				}
			}
			return false;
		}
		public function connectCheck():Boolean{
			if(!onRope && !attacking && !changing){
				if(MovieClip(root).keys[38] || MovieClip(root).keys[40])
				{
					if(MovieClip(root).keys[38])y-=10;
					for(var i=0;i<connects.length;i++)
					{
						if(y>=connects[i].by && y<=connects[i].ey &&
							x<connects[i].ex && x>connects[i].bx)
						{
							conType = connects[i].cType;
							onRope = true;
							gravity = speed = 0;
							x = connects[i].m;
							return true;
						}
					}
					if(MovieClip(root).keys[38])y+=10;
				}
			}
			if(onRope && !attacking && !changing){
				for(i=0;i<connects.length;i++)
				{
					if(y>connects[i].by && y<connects[i].ey &&
						x<connects[i].ex && x>connects[i].bx)
					{
						conType = connects[i].cType;
						return true;
					}
				}
			}
			conType = "none";
			onRope = false;
			return onRope;
		}
		public function wallCheck(){
			for(var i=0;i<walls.length;i++)
			{
				if(y<walls[i].ey && y>walls[i].by)
				{
					if(speed<=0)
					{
						if(x>=walls[i].x && x+speed<=walls[i].x)
						{
							x = walls[i].x+1;
							speed = 0;
						}
					}
					if(speed>=0)
					{
						if(x<=walls[i].x && x+speed>=walls[i].x)
						{
							x = walls[i].x-1;
							speed = 0;
						}
					}
				}
			}
		}
		public function portalCheck():void{
			if(MovieClip(root).keys[38] && !changing && !Boolean(MovieClip(root).getChildByName("black_mc")))
			{
				for(var i=0;i<portals.length;i++)
				{
					if(x<portals[i].ex && x>portals[i].bx && y == portals[i].y)
					{
						changing = true;
						MovieClip(root).from = MovieClip(root).mapid;
						MovieClip(root).midc = portals[i].id;
						MovieClip(root).mapid = portals[i].id;
						char_mc.gotoAndStop(1);
						MovieClip(root).addChild(new blackOut(0, 0)).name = "black_mc";
						MovieClip(root).getChildByName("black_mc").x = MovieClip(root).getChildByName("cam_mc").x;
						MovieClip(root).getChildByName("black_mc").y = MovieClip(root).getChildByName("cam_mc").y;
						MovieClip(root).getChildByName("black_mc").width = 800;
						MovieClip(root).getChildByName("black_mc").height = 500;
					}
				}
			}
		}
		public function displayHandler():void{
			if(!jump && !fall)frame = 1;
			if(walking)frame = 3;
			if(jump||fall)frame = 4;
			if(onRope && conType == "ladder")frame = 5;
			if(onRope && climbing)frame++;
			if(MovieClip(getChildByName("char_mc")).currentFrame != frame &&
				!attacking && !changing)
			   MovieClip(getChildByName("char_mc")).gotoAndStop(frame);
		}
		public function moveHandler():void{
			if(!jump && !fall && !onRope && !attacking && !changing)
			{
				if(MovieClip(root).keys[37] && !MovieClip(root).keys[39]
						&& speed>-maxSpeed)
				{
					scaleX = 1;
					walking = true;
					speed--;
				}
				if(MovieClip(root).keys[39] && !MovieClip(root).keys[37]
					&& speed<maxSpeed)
				{
					scaleX = -1;
					walking = true;
					speed++;
				}
				if((!MovieClip(root).keys[37] && !MovieClip(root).keys[39])||
					(MovieClip(root).keys[37] && MovieClip(root).keys[39]))
				{
					walking = false;
					if(speed%friction != 0)speed = Math.floor(speed);
					if(speed>0)speed-=friction;
					if(speed<0)speed+=friction;
				}
			}
			if(!onRope && (!attacking && !changing||jump))x+=speed;
		}
		public function gravityHandler():void{
			if(!platCheck(this) && !connectCheck())
			{
				gravity++;
				if(jump)gravity++;
				y+=gravity;
				if(!jump)fall = true;
				if(!attacking && !changing)
				{
					if(MovieClip(root).keys[37] && !MovieClip(root).keys[39])scaleX = 1;
					if(!MovieClip(root).keys[37] && MovieClip(root).keys[39])scaleX = -1;
				}
			}else{
				gravity = 0;
				jump = fall = false;
				if(!onRope && !changing && !attacking){
					if(MovieClip(root).keys[32])
					{
						if(speed>0)speed-=friction;
						if(speed<0)speed+=friction;
						if(MovieClip(root).keys[37] && !MovieClip(root).keys[39])
						{
							scaleX = 1;
							speed = -maxSpeed/1.2;
						}
						if(!MovieClip(root).keys[37] && MovieClip(root).keys[39])
						{
							scaleX = -1;
							speed = maxSpeed/1.2;
						}
						jump = true;
						gravity = jumpHeight;
					}
				}else if(!changing && !attacking){
					climbing = false;
					if(MovieClip(root).keys[38] && !MovieClip(root).keys[40])
					{
						climbing = true;
						y-=5;
					}
					if(MovieClip(root).keys[40] && !MovieClip(root).keys[38])
					{
						climbing = true;
						y+=5;
					}
					if(MovieClip(root).keys[32] &&
						(MovieClip(root).keys[37] && !MovieClip(root).keys[39]||
						!MovieClip(root).keys[37] && MovieClip(root).keys[39])
						&& !MovieClip(root).keys[38] && !MovieClip(root).keys[40])
					{
						onRope = climbing = false;
						conType = "none";
						if(MovieClip(root).keys[37] && !MovieClip(root).keys[39])
						{
							scaleX = 1;
							speed = -maxSpeed/1.1;
						}
						if(!MovieClip(root).keys[37] && MovieClip(root).keys[39])
						{
							scaleX = -1;
							speed = maxSpeed/1.1;
						}
						jump = true;
						gravity = jumpHeight/2;
					}
				}
			}
		}
		public function attackHandler():void{
			if(!attacking && !changing && !onRope)
			{
				if(MovieClip(root).keys[90])
				{
					attacking = true;
					MovieClip(getChildByName("char_mc")).gotoAndStop(randRange(7, 9));
					attID = 0;
				}
			}
		}
		public function bugHandler():void{
			if(char_mc.currentFrame<7 && attacking)attacking = false;
			if(hp<=0 && !dead){dead = true;hp = 0;}
			if(hurt>0){
				hurt--;
				if(hurt>0)
				{
					if(hurt%2 == 0)setBrightness(this, 10);
					else setBrightness(this, -50);
				}else setBrightness(this, 0);
			}
			if(mexp == 0)initHide();
			if(exp>=mexp && mexp>0){
				exp = 0;
				lvl++;
				ap+=5;
				initHide();
				MovieClip(root).addChild(new showAndAttach("effectsLevelUp", this));
				if(job>=0){
					if(lvl%2 == 0)
					{
						mhp+=13;
						mmp+=8;
					}
					else{
						mhp+=14;
						mmp+=9;
					}
				}
				hp = mhp;
				mp = mmp;
			}
		}
		public function keyHandler():void{
			if(MovieClip(root).keys[statsKey] && !statKeyDown)
			{
				statKeyDown = true;
				if(!Boolean(MovieClip(root).status_mc.getChildByName("stats_mc")))
				{
					MovieClip(root).status_mc.addChild(new uiStats()).name = "stats_mc";
					MovieClip(root).status_mc.getChildByName("stats_mc").x = lastStatX;
					MovieClip(root).status_mc.getChildByName("stats_mc").y = lastStatY;
				}else
					MovieClip(MovieClip(root).status_mc.getChildByName("stats_mc")).closeWin(new MouseEvent(MouseEvent.CLICK));
			}
			statKeyDown = MovieClip(root).keys[statsKey];
		}
		public function getTarget():MovieClip{
			var mobs = MovieClip(root).mobs;
			var closest:MovieClip;
			for(var i=0;i<mobs.length;i++)
			{
				var xDif:int;
				var yDif:int;
				var xrng:int
				if((scaleX == 1 && mobs[i].x<x||scaleX == -1 && mobs[i].x>x) && !mobs[i].dead)
				{
					xDif = Math.abs(mobs[i].x-x);
					yDif = Math.abs(mobs[i].y-y);
					xDif-=yDif*3;
					xrng = Math.abs(mobs[i].x-x);
					if(Boolean(MovieClip(mobs[i])) && !Boolean(MovieClip(closest)) && xDif>-200 && xrng<maxRange
						&& (xrng>40||yDif<10))
					{
						closest = mobs[i];
						MovieClip(closest).range = xDif;
					}else if(Boolean(MovieClip(closest)) && (xrng>40||yDif<10) && (xDif<MovieClip(closest).range||
					MovieClip(closest).range<=-100) && xDif>-100 && yDif<70 && xrng<maxRange)
					{
						closest = mobs[i];
						MovieClip(closest).range = xDif;
						MovieClip(closest).yDif = yDif;
					}
				}
			}
			return MovieClip(closest);
		}
		public function attackDone():void{
			if(platCheck(this))speed = 0;
			attacking = false;
			displayHandler();
			char_mc.gotoAndStop(1);
		}
		public function attack():void{
			if(attID == 0)
			{
				var targ = getTarget()
				if(Boolean(targ))
				{
					MovieClip(root).shoot(MovieClip(targ));
				}else{
					if(scaleX == -1)
					{
						MovieClip(root).getChildByName("rightEmpty_mc").y = y-height/2;
						MovieClip(root).shoot(MovieClip(root).getChildByName("rightEmpty_mc"), 20);
					}else
					{
						MovieClip(root).getChildByName("leftEmpty_mc").y = y-height/2;
						MovieClip(root).shoot(MovieClip(root).getChildByName("leftEmpty_mc"), -20);
					}
				}
			}
		}
		public function createPlat(bx:int, ex:int, y:int, spawn:Boolean = true):void{
			platforms.push(new Object());
			platforms[platforms.length-1].bx = bx;
			platforms[platforms.length-1].ex = ex;
			platforms[platforms.length-1].y = y;
			platforms[platforms.length-1].spawn = spawn;
		}
		public function createConnect(bx:int, ex:int, by:int, ey:int, type, mid):void{
			connects.push(new Object());
			connects[connects.length-1].bx = bx;
			connects[connects.length-1].ex = ex;
			connects[connects.length-1].by = by;
			connects[connects.length-1].ey = ey;
			connects[connects.length-1].cType = type;
			connects[connects.length-1].m = mid;
		}
		public function createWall(by:int, ey:int, x:int):void{
			walls.push(new Object());
			walls[walls.length-1].by = by;
			walls[walls.length-1].ey = ey;
			walls[walls.length-1].x = x;
		}
		public function createSpawn(sCount, ... spawn):void{
			maxSpawn = sCount;
			for(var i=0;i<spawn.length;i++)
				spawns.push(spawn[i]);
		}
		public function createPortal(bx:int, ex:int, y:int, id:int):void{
			portals.push(new Object());
			portals[portals.length-1].bx = bx;
			portals[portals.length-1].ex = ex;
			portals[portals.length-1].y = y;
			portals[portals.length-1].id = id;
		}
		public function initPlatforms(mID:int):void{
			if(mID == 0){
				if(MovieClip(root).from == 1){
					setXY(845, 371);
				}
				else{
					x = 251;
					y = 276;
				}
				createPlat(-700, 900, 371);
				createPlat(-165, 35, 311, false);
				createPlat(-117, -7, 257, false);
				createPlat(62, 112, 257, false);
				createPlat(170, 230, 257, false);
				createPlat(290, 350, 257, false);
				createPlat(400, 460, 257, false);
				createPlat(600, 800, 308, false); 
				createPlat(650, 756, 258, false);
				createPlat(-480, 645, 146);
				createPlat(444, 644, 81, false);
				createPlat(500, 610, 30, false);
				createPlat(-480, 655, -196);
				createPlat(378, 568, -258, false);
				createPlat(422, 542, -310, false);
				createConnect(600, 640, 146, 302, "ladder", 624);
				createConnect(550, 600, -196, 12, "ladder", 574);
				createWall(-500, 527, -615);
				createWall(-500, 527, 870);
				createSpawn(30, 0, 1, 2);
				createPortal(823, 873, 371, 1);
			}
			if(mID == 1){
				if(MovieClip(root).from == 0){
					setXY(50, 334);
				}
				else{
					setXY(1290, 241);
				}
				createWall(-500, 560, 10);
				createWall(318, 385, 1139);
				createWall(-500, 500, 1902);
				createPlat(0, 1140, 372);
				createPlat(1135, 1923, 318);//false
				createPortal(22, 82, 372, 0);
				createSpawn(1, 4);
			}
		}
		public function exists(mc:MovieClip):Boolean{
			return Boolean(MovieClip(mc));
		}
		public function randRange(min:int, max:int):int{
			return Math.floor(Math.random()*((max+1)-min))+min;
		}
		public function changeMap(map):void{
			speed = 0;
			gravity = 0;
			spawnCount = 0;
			attacking = jump = fall = walking = false;
			platforms = new Array();
			connects = new Array();
			walls = new Array();
			portals = new Array();
			spawns = new Array();
			platforms.length = connects.length = portals.length = 0;
			initPlatforms(map);
		}
		public function setXY(x:int, y:int){
			this.x = x;
			this.y = y;
			MovieClip(root).getChildByName("cam_mc").x = x;
			MovieClip(root).getChildByName("cam_mc").y = y;
			MovieClip(root).moveCam(new Event(Event.ENTER_FRAME));
			MovieClip(root).getChildByName("black_mc").x = MovieClip(root).getChildByName("cam_mc").x;
			MovieClip(root).getChildByName("black_mc").y = MovieClip(root).getChildByName("cam_mc").y;
		}
		public function hurtMonster(targ:MovieClip){
			var mindmg:int = new int(((luk*3.6+str+dex)/100)*(wAtk+starAtt));
			var maxdmg:int = new int((luk*0.9*3.6*(mastery*.01)+str+dex)/100*(wAtk+starAtt));
			var dmg:int = randRange(mindmg, maxdmg);
			dmg-=MovieClip(root).mobInfo[targ.id].wDef/2;
			dmg+=dex;
			if(dmg<0)dmg = 0;
			dmg-=dex;
			if(dmg<=0 && dmg+dex>0)dmg = 1;
			dmg = Math.round(dmg);
			targ.hp-=dmg;
			MovieClip(root).addChild(new damage(0, dmg, targ));
		}
		public function setBrightness(mc:MovieClip, brightness){
			var percent:int = 100-Math.abs(brightness);
			var offset:int = 0;
			var color:ColorTransform = new ColorTransform();
			
			if(brightness>-100)offset = 256*(brightness/100);
		
			color.redOffset = color.greenOffset = color.blueOffset = offset;
			mc.transform.colorTransform = color;
		}
		public function initHide(){
			mexp = levels[lvl-1];
			MovieClip(root).status_mc.changeLevel(lvl);
		}
		public function onEnter(e:Event):void{
			moveHandler();
			gravityHandler();
			displayHandler();
			attackHandler();
			keyHandler();
			bugHandler();
			connectCheck();
			wallCheck();
			portalCheck();
		}
	}
}