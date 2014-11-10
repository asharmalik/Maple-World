package{
	import flash.display.*;
	import flash.events.*;
	public dynamic class main extends MovieClip{
		public var focused = false;
		
		public function main(){
			stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			stage.addEventListener(Event.ACTIVATE, onActivate);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUp);
		}
		public function onDeactivate(e:Event){
			focused = false;
			for(var i=0;i<999;i++)MovieClip(root).keys[i] = false;
		}
		public function onActivate(e:Event){
			focused = true;
		}
		public function onDown(e:KeyboardEvent){
			if(focused)MovieClip(root).keys[e.keyCode] = true;
		}
		public function onUp(e:KeyboardEvent){
			MovieClip(root).keys[e.keyCode] = false;
		}
	}
}