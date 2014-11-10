package{
	import flash.display.*;
	import flash.events.*;
	public class blackOut extends MovieClip{
		public var xx:Number;
		public var yy:Number;
		
		public function blackOut(x:Number, y:Number)
		{
			addChild(new blackSprite());
			this.x = x
			this.y = y;
			xx = this.x;
			yy = this.y;
		}
		public function remove()
		{
			MovieClip(root).spawnHandler(new TimerEvent(TimerEvent.TIMER));
			parent.removeChild(this);
		}
		public function bring()
		{
			MovieClip(root).initMap(MovieClip(root).midc);
			MovieClip(root).setChildIndex(DisplayObject(this), MovieClip(root).numChildren-1);
			this.x = MovieClip(root).getChildByName("cam_mc").x;
			this.y = MovieClip(root).getChildByName("cam_mc").y;
		}
	}
}