package {	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.geom.PerspectiveProjection;	import flash.geom.Point;	import flash.utils.getTimer;	public class Main extends Sprite {		private var motions:Array;		private var sp:Sprite;		public function Main() {			super();			if ( stage ) {				onAdd(null);			} else {				this.addEventListener(Event.ADDED_TO_STAGE, onAdd);			}		}				private function onAdd(e:Event):void {			this.removeEventListener(Event.ADDED_TO_STAGE, onAdd);						stage.scaleMode = StageScaleMode.NO_SCALE;			stage.align = StageAlign.TOP_LEFT;			stage.quality = "best";			stage.addEventListener(Event.RESIZE, onResizeHandler);						sp = new Sprite();			this.addChild(sp);						motions = [];			motions.push( new MotionMan(sp, "A_test.bvh") );			motions.push( new MotionMan(sp, "B_test.bvh") );			motions.push( new MotionMan(sp, "C_test.bvh") );						onResizeHandler(null);						this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);		}				private function onResizeHandler(e:Event):void {			sp.x = stage.stageWidth / 2 >> 0;			sp.y = stage.stageHeight / 2 >> 0;			setProjectionCenter(stage.stageWidth / 2 >> 0, stage.stageHeight / 2 >> 0, sp, stage);		}				private function onEnterFrameHandler(e:Event):void {			var n_timer:Number = flash.utils.getTimer();			sp.graphics.clear();			//update motions			for each ( var motion:MotionMan in motions ) {				motion.update(n_timer);			}			//z-sort			var a:Array = [];			var l:int = sp.numChildren;			var i:int = 0;			var _sp:Sprite;			for ( i = 0; i<l; i++ ) {				_sp = sp.getChildAt(i) as Sprite;				a.push( _sp );			}			a.sortOn("z", Array.NUMERIC);			for each ( _sp in a ) {				sp.addChildAt(_sp, 0);			}		}				private function setProjectionCenter(_x:Number, _y:Number, _target:DisplayObject, stage:Stage):void {			// reset perspectiveProjection			var o:DisplayObject = _target;			while (o.parent != stage) {			  o.transform.perspectiveProjection = null;			  o = o.parent;			}			try{				if ( _target.root ){					var proj:PerspectiveProjection = _target.root.transform.perspectiveProjection;					var pt:Point = proj.projectionCenter;					pt.x = _x;					pt.y = _y;					proj.projectionCenter = pt;					_target.root.transform.perspectiveProjection = proj;				}			} catch(e:*) {}			}	}}