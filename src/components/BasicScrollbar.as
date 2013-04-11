package components 
{
	import flash.display.Sprite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle; 
	import flash.display.Shape; 

	public class BasicScrollbar extends Sprite
	{
		
		private var _dragged:Sprite; 
		private var _mask:Sprite; 
		private var _ruler:Sprite; 
		private var _background:Sprite; 
		private var _hitarea:Sprite; 
		private var _blurred:Boolean; 
		private var _YFactor:Number; 
		
		private var _initY:Number; 
		
		private var scrollPos:int;
		private var scrollWidth:Number = 50;
		private var minY:Number;
		private var maxY:Number;
		private var percentuale:uint;
		private var contentstarty:Number; 
		private var bf:BlurFilter;
		
		private var initialized:Boolean = false; 
		
		public function BasicScrollbar(dragged:Sprite, maskclip:Sprite,  hitarea:Sprite, blurred:Boolean = false, yfactor:Number = 4, baseColor:uint= 0x000000)
		{
			super();
			
				_background = new Sprite();
				_background.graphics.beginFill(baseColor,.1);
				_background.graphics.drawRect(0,0,scrollWidth, maskclip.height);
				_background.graphics.endFill();
				addChild(_background);
			//	_background.x = -10;
				_background.y = maskclip.y;
				
				_ruler = new Sprite();
				_ruler.graphics.beginFill(baseColor,.1);
				_ruler.graphics.drawRect(0,0,scrollWidth, 10);
				_ruler.graphics.endFill()
				addChild(_ruler);
				//_ruler.x =  -10;
				_ruler.y = maskclip.y;
			
			_dragged = dragged; 
			_mask = maskclip; 
			_hitarea = hitarea as Sprite;
			//trace(_hitarea);  
			_blurred = blurred; 
			_YFactor = yfactor; 
		}
		
		public function set dragged (v:Sprite):void {
			_dragged = v; 
		}
		
		public function set maskclip (v:Sprite):void {
			_mask = v; 
		}
		
		public function set ruler (v:Sprite):void {
			_ruler = v; 
		}
		
		public function set background (v:Sprite):void {
			_background = v; 
		}
		
		public function set hitarea (v:Sprite):void {
			_hitarea = v; 
		}		
		
		private function checkPieces():Boolean {
			var ok:Boolean = true; 
			if (_dragged == null) {
				//trace("SCROLLBAR: DRAGGED not set"); 
				ok = false; 	
			}
			if (_mask == null) {
				//trace("SCROLLBAR: MASK not set"); 
				ok = false; 	
			}
			if (_ruler == null) {
				//trace("SCROLLBAR: RULER not set"); 	
				ok = false; 
			}
			if (_background == null) {
				//trace("SCROLLBAR: BACKGROUND not set"); 	
				ok = false; 
			}
			if (_hitarea == null) {
				//trace("SCROLLBAR: HITAREA not set"); 	
				ok = false; 
			}
			return ok; 
		}
		public function goto(aNum:int=0):void 
		{
			scrollPos = aNum;
			////trace("ima going to " + scrollPos);
			this._ruler.y=scrollPos
			//_dragged.y = scrollPos; 
			//scrollData(scrollPos);
		}
		public function init(aNum:int=0):void 
		{
			
			if (checkPieces() == false) {
				//trace("SCROLLBAR: CANNOT INITIALIZE"); 
			} else { 
				
				if (initialized == true) 
				{
					reset();
				}
				bf = new BlurFilter(0, 0, 1); 
				//this._dragged.filters = new Array(bf); 
				this._dragged.mask = this._mask; 
				this._dragged.cacheAsBitmap = true; 
				
				this.minY = _background.y; 
				
				this._ruler.buttonMode = true; 
	
				this.contentstarty = _dragged.y; 
	
				_ruler.addEventListener(MouseEvent.MOUSE_DOWN, clickHandle); 
				//StageManager.getInstance().getStage().addEventListener(MouseEvent.MOUSE_UP, releaseHandle); 
				//StageManager.getInstance().getStage().addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandle, true); 
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandle); 
				
				initialized = true; 
				
			}
		}
		
		private function clickHandle(e:MouseEvent) :void
		{
			//var rect:Rectangle = new Rectangle(_background.x-(_ruler.width/2), minY, 0, maxY);
			var rect:Rectangle = new Rectangle(_background.x, minY, 0, maxY);
			_ruler.startDrag(false, rect);
		}
		
		private function releaseHandle(e:MouseEvent) :void
		{
			_ruler.stopDrag();
		}
		/*
		private function wheelHandle(e:MouseEvent):void
		{
			if (this._hitarea.hitTestPoint(StageManager.getInstance().getStage().mouseX, StageManager.getInstance().getStage().mouseY, false))
			{
				////trace("Scrolling..."+e.delta)
				scrollData(e.delta/3);		
			}
		}
		*/
		private function enterFrameHandle(e:Event):void
		{
			positionContent();
		}
		
		private function scrollData(q:int):void
		{
			var d:Number;
			var rulerY:Number; 
			
			var quantity:Number = this._ruler.height / 5; 

			d = -q * Math.abs(quantity); 
	
			if (d > 0) {
				rulerY = Math.min(maxY, _ruler.y + d);
			}
			if (d < 0) {
				rulerY = Math.max(minY, _ruler.y + d);
			}
			
			_ruler.y = rulerY; 
	
			positionContent();
		}
		
		public function positionContent():void {
			var upY:Number;
			var downY:Number;
			var curY:Number;
			
			/* thanks to Kalicious (http://www.kalicious.com/) */
			this._ruler.height = (this._mask.height / this._dragged.height)* this._background.height;
			//this._ruler.height = (this._dragged.height / this._mask.height)* this._background.height;
			this.maxY = this._background.height - this._ruler.height;
			/*	*/ 		

			var limit:Number = this._background.height - this._ruler.height; 

 			if (this._ruler.y > limit) {
				this._ruler.y = limit; 
			} 
	
			checkContentLength();	
	
			percentuale = (100 / maxY) * _ruler.y;
				
			upY = 0;
			downY = _dragged.height - (_mask.height / 2);
			 
			//var fx:Number = contentstarty - (((downY - (_mask.height/2)) / 100) * percentuale); 
			var fx:Number = contentstarty - (((downY - (_mask.height/2)) / 100) * percentuale); 
			
			var curry:Number = _dragged.y; 
			var finalx:Number = fx; 
			
			if (curry != finalx) {
				var diff:Number = finalx-curry;
				curry += diff / _YFactor; 
				
				var bfactor:Number = Math.abs(diff)/8; 
				bf.blurY = bfactor/4; 
				if (_blurred == true) {
					//_dragged.filters = new Array(bf);
				}
			}
			
			_dragged.y = curry; 
		}
		
		public function checkContentLength():void
		{
			if (_dragged.height < _mask.height) {
				_ruler.visible = false;
				reset();
			} else {
				_ruler.visible = true; 
			}
		}
		
		public function reset():void {
			_dragged.y = contentstarty; 
			_ruler.y = 0; 			
		}
		
	}
}