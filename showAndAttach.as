package{
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	public class showAndAttach extends MovieClip{
		public var target:MovieClip;
		
		public function showAndAttach(cName:String, targ:MovieClip)
		{
			var newClass:Class = Class(getDefinitionByName(cName));
			addChild(new newClass()).name = "class_mc";
			target = targ;
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		public function onFrame(e:Event)
		{
			if(Boolean(this))
			{
				x = target.x;
				y = target.y;
			}
		}
		public function remove()
		{
			removeEventListener(Event.ENTER_FRAME, onFrame);
			MovieClip(root).removeChild(MovieClip(root).getChildByName(this.name));
		}
	}
}