package
{
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.MouseEvent;
	
	[Event("rollEvent")]
	
	public class RollEventController extends EventDispatcher implements IBeadController
	{
		public function RollEventController()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var dispatcher:IEventDispatcher = value as IEventDispatcher;
			
			dispatcher.addEventListener(MouseEvent.MOUSE_OVER, handleOver);
			dispatcher.addEventListener(MouseEvent.MOUSE_OUT, handleOut);
			dispatcher.addEventListener(MouseEvent.MOUSE_DOWN, handleDown);
			dispatcher.addEventListener(MouseEvent.MOUSE_UP, handleUp);
		}
		
		private function handleOver(event:MouseEvent):void
		{
			trace("RolledOver");
			
			dispatchEvent(new RollEvent("rollOver"));
		}
		
		private function handleOut(event:MouseEvent):void
		{
			trace("RolledOut");
			
			dispatchEvent(new RollEvent("rollOut"));
		}
		
		private function handleDown(event:MouseEvent):void
		{
			trace("Detected Down");
			
			dispatchEvent(new RollEvent("mouseDown"));
		}
		
		private function handleUp(event:MouseEvent):void
		{
			trace("Detected Up");
			
			dispatchEvent(new RollEvent("mouseUp"));
		}
	}
}