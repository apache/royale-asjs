package org.apache.flex.html.beads.models
{
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
	public class ViewportModel extends EventDispatcher implements IViewportModel
	{
		public function ViewportModel()
		{
			super();
		}
		
		private var _layout:IBeadLayout;
		private var _contentArea:IUIBase;
		private var _contentWidth:Number = 0;
		private var _contentHeight:Number = 0;
		private var _contentX:Number = 0;
		private var _contentY:Number = 0;
		private var _viewportWidth:Number = 0;
		private var _viewportHeight:Number = 0;
		private var _viewportX:Number = 0;
		private var _viewportY:Number = 0;
		private var _verticalScrollPosition:Number = 0;
		private var _horizontalScrollPosition:Number = 0;
		
		public function get layout():IBeadLayout
		{
			return _layout;
		}
		public function set layout(value:IBeadLayout):void
		{
			_layout = value;
			dispatchEvent( new Event("layoutChanged") );
		}
		
		public function get contentArea():IUIBase
		{
			return _contentArea;
		}
		public function set contentArea(value:IUIBase):void
		{
			_contentArea = value;
			dispatchEvent( new Event("contentAreaChanged") );
		}
		
		public function get viewportWidth():Number
		{
			return _viewportWidth;
		}
		public function set viewportWidth(value:Number):void
		{
			_viewportWidth = value;
		}
		
		public function get viewportHeight():Number
		{
			return _viewportHeight;
		}
		public function set viewportHeight(value:Number):void
		{
			_viewportHeight = value;
		}
		
		public function get viewportX():Number
		{
			return _viewportX;
		}
		public function set viewportX(value:Number):void
		{
			_viewportX = value;
		}
		
		public function get viewportY():Number
		{
			return _viewportY;
		}
		public function set viewportY(value:Number):void
		{
			_viewportY = value;
		}
		
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		public function set contentWidth(value:Number):void
		{
			_contentWidth = value;
		}
		
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		public function set contentHeight(value:Number):void
		{
			_contentHeight = value;
		}
		
		public function get contentX():Number
		{
			return _contentX;
		}
		public function set contentX(value:Number):void
		{
			_contentX = value;
		}
		
		public function get contentY():Number
		{
			return _contentY;
		}
		public function set contentY(value:Number):void
		{
			_contentY = value;
		}
		
		public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}
		public function set verticalScrollPosition(value:Number):void
		{
			_verticalScrollPosition = value;
			dispatchEvent( new Event("verticalScrollPositionChanged") );
		}
		
		public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		public function set horizontalScrollPosition(value:Number):void
		{
			_horizontalScrollPosition = value;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}