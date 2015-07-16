package org.apache.flex.html.supportClasses
{
	import flash.geom.Rectangle;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.IViewportScroller;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.utils.BeadMetrics;
	
	public class ScrollingViewport implements IBead, IViewport
	{
		static private const scrollerSize:int = 16;
		static private const scrollerSizeWithBorder:int = 17;
		
		public function ScrollingViewport()
		{
		}
		
		private var contentArea:UIBase;
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _model:IViewportModel;
		
		public function set model(value:IViewportModel):void
		{
			_model = value;
			
			if (model.contentArea) contentArea = model.contentArea as UIBase;
			
			model.addEventListener("contentAreaChanged", handleContentChange);
			model.addEventListener("verticalScrollPositionChanged", handleVerticalScrollChange);
			model.addEventListener("horizontalScrollPositionChanged", handleHorizontalScrollChange);
		}
		public function get model():IViewportModel
		{
			return _model;
		}
		
		private var _verticalScroller:ScrollBar;
		public function get verticalScroller():IViewportScroller
		{
			return _verticalScroller;
		}
		
		private var _horizontalScroller:ScrollBar
		public function get horizontalScroller():IViewportScroller
		{
			return _horizontalScroller;
		}
		
		/**
		 * Invoke this function to reshape and set the contentArea being managed by
		 * this viewport. If scrollers are present this will update them as well to
		 * reflect the current location of the visible portion of the contentArea
		 * within the viewport.
		 */
		public function updateContentAreaSize():void
		{
			var host:UIBase = UIBase(_strand);
			var rect:Rectangle;
			var vbarAdjustHeightBy:Number = 0;
			var hbarAdjustWidthBy:Number = 0;
			
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).maximum = model.contentHeight;
				_verticalScroller.x = model.viewportWidth - scrollerSizeWithBorder;
				_verticalScroller.y = model.viewportY;
				
				rect = contentArea.scrollRect;
				rect.y = ScrollBarModel(_verticalScroller.model).value;
				contentArea.scrollRect = rect;
				
				hbarAdjustWidthBy = scrollerSizeWithBorder;
			}
			
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).maximum = model.contentWidth;
				_horizontalScroller.x = model.viewportX;
				_horizontalScroller.y = model.viewportHeight - scrollerSizeWithBorder;
				
				rect = contentArea.scrollRect;
				rect.x = ScrollBarModel(_horizontalScroller.model).value;
				contentArea.scrollRect = rect;
				
				vbarAdjustHeightBy = scrollerSizeWithBorder;
			}
			
			if (_verticalScroller) {
				_verticalScroller.setWidthAndHeight(scrollerSize, model.viewportHeight - vbarAdjustHeightBy, false);
			}
			if (_horizontalScroller) {
				_horizontalScroller.setWidthAndHeight(model.viewportHeight - hbarAdjustWidthBy, scrollerSize, false);
			} 
			
			if (!model.contentIsHost) {
				contentArea.x = model.contentX;
				contentArea.y = model.contentY;
			}
			contentArea.setWidthAndHeight(model.contentWidth, model.contentHeight, true);
		}
		
		public function updateSize():void
		{
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
			var host:UIBase = UIBase(_strand);
			var addVbar:Boolean = false;
			var addHbar:Boolean = false;
			
			if (model.viewportHeight >= model.contentHeight) {
				if (_verticalScroller) {
					host.removeElement(_verticalScroller);
					_verticalScroller = null;
				}
			}
			else if (model.contentHeight > model.viewportHeight) {
				if (_verticalScroller == null) {
					addVbar = true;
				}
			}
			
			if (model.viewportWidth >= model.contentWidth) {
				if (_horizontalScroller) {
					host.removeElement(_horizontalScroller);
					_horizontalScroller = null;
				}
			}
			else if (model.contentWidth > model.viewportWidth) {
				if (_horizontalScroller == null) {
					addHbar = true;
				}
			}
			
			if (addVbar) needsVerticalScroller();
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).maximum = model.contentHeight;
				ScrollBarModel(_verticalScroller.model).pageSize = model.viewportHeight - metrics.top - metrics.bottom;
				ScrollBarModel(_verticalScroller.model).pageStepSize = model.viewportHeight - metrics.top - metrics.bottom;
			}
			
			if (addHbar) needsHorizontalScroller();
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).maximum = model.contentWidth;
				ScrollBarModel(_horizontalScroller.model).pageSize = model.viewportWidth - metrics.left - metrics.right;
				ScrollBarModel(_horizontalScroller.model).pageStepSize = model.viewportWidth - metrics.left - metrics.right
			}
			
			var rect:Rectangle = contentArea.scrollRect;
			if (rect) {
				rect.x = 0;
				rect.y = 0;
				rect.width = model.viewportWidth - metrics.left - metrics.right;
				rect.height = model.viewportHeight - 2*metrics.top - 2*metrics.bottom;
				contentArea.scrollRect = rect;
			}
		}
		
		/**
		 * Call this function when at least one scroller is needed to view the entire
		 * contentArea.
		 */
		public function needsScrollers():void
		{
			needsVerticalScroller();
			needsHorizontalScroller();
		}
		
		/**
		 * Call this function when only a vertical scroller is needed
		 */
		public function needsVerticalScroller():void
		{
			var host:UIBase = UIBase(_strand);
			
			var needVertical:Boolean = model.contentHeight > model.viewportHeight;
			
			if (needVertical && _verticalScroller == null) {
				_verticalScroller = createVerticalScrollBar();
				var vMetrics:UIMetrics = BeadMetrics.getMetrics(_verticalScroller);
				_verticalScroller.visible = true;
				_verticalScroller.x = model.viewportWidth - scrollerSizeWithBorder - vMetrics.left - vMetrics.right;
				_verticalScroller.y = model.viewportY;
				_verticalScroller.setWidthAndHeight(scrollerSize, model.viewportHeight, true);
				
				host.addElement(_verticalScroller, false);
			}
		}
		
		/**
		 * Call this function when only a horizontal scroller is needed
		 */
		public function needsHorizontalScroller():void
		{
			var host:UIBase = UIBase(_strand);
			
			var needHorizontal:Boolean = model.contentWidth > model.viewportWidth;
			
			if (needHorizontal && _horizontalScroller == null) {
				_horizontalScroller = createHorizontalScrollBar();
				var hMetrics:UIMetrics = BeadMetrics.getMetrics(_horizontalScroller);
				_horizontalScroller.visible = true;
				_horizontalScroller.x = model.viewportX;
				_horizontalScroller.y = model.viewportHeight - scrollerSizeWithBorder - hMetrics.top - hMetrics.bottom;
				_horizontalScroller.setWidthAndHeight(model.viewportWidth, scrollerSize, true);
				
				host.addElement(_horizontalScroller, false);
			}
		}
		
		public function scrollerWidth():Number
		{
			if (_verticalScroller) return _verticalScroller.width;
			return 0;
		}
		
		public function scrollerHeight():Number
		{
			if (_horizontalScroller) return _horizontalScroller.height;
			return 0;
		}
		
		private function createVerticalScrollBar():ScrollBar
		{
			var host:UIBase = UIBase(_strand);
			var metrics:UIMetrics = BeadMetrics.getMetrics(host);
			
			var vsbm:ScrollBarModel = new ScrollBarModel();
			vsbm.maximum = model.contentHeight;
			vsbm.minimum = 0;
			vsbm.pageSize = model.viewportHeight - metrics.top - metrics.bottom;
			vsbm.pageStepSize = model.viewportHeight - metrics.top - metrics.bottom;
			vsbm.snapInterval = 1;
			vsbm.stepSize = 1;
			vsbm.value = 0;
			
			var vsb:ScrollBar;
			vsb = new ScrollBar();
			vsb.model = vsbm;
			vsb.visible = false;
			
			vsb.addEventListener("scroll",handleVerticalScroll);
			
			var rect:Rectangle = contentArea.scrollRect;
			if (rect == null) {
				rect = new Rectangle(0, 0, 
					                 model.viewportWidth - metrics.left - metrics.right, 
									 model.viewportHeight - metrics.top - metrics.bottom);
				contentArea.scrollRect = rect;
			}
			
			return vsb;
		}
		
		private function createHorizontalScrollBar():ScrollBar
		{
			var host:UIBase = UIBase(_strand);
			var metrics:UIMetrics = BeadMetrics.getMetrics(host);
			
			var hsbm:ScrollBarModel = new ScrollBarModel();
			hsbm.maximum = model.contentWidth;
			hsbm.minimum = 0;
			hsbm.pageSize = model.viewportWidth - metrics.left - metrics.right;
			hsbm.pageStepSize = model.viewportWidth - metrics.left - metrics.right;
			hsbm.snapInterval = 1;
			hsbm.stepSize = 1;
			hsbm.value = 0;
			
			var hsb:ScrollBar;
			hsb = new ScrollBar();
			hsb.model = hsbm;
			hsb.visible = false;
			
			hsb.addEventListener("scroll",handleHorizontalScroll);
			
			var rect:Rectangle = contentArea.scrollRect;
			if (rect == null) {
				rect = new Rectangle(0, 0, 
					model.viewportWidth - metrics.left - metrics.right, 
					model.viewportHeight - metrics.top - metrics.bottom);
				contentArea.scrollRect = rect;
			}
			
			return hsb;
		}
		
		private function handleVerticalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var vpos:Number = ScrollBarModel(_verticalScroller.model).value;
			var rect:Rectangle = contentArea.scrollRect;
			rect.y = vpos;
			contentArea.scrollRect = rect;
			
			model.verticalScrollPosition = vpos;
		}
		
		private function handleHorizontalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var hpos:Number = ScrollBarModel(_horizontalScroller.model).value;
			var rect:Rectangle = contentArea.scrollRect;
			rect.x = hpos;
			contentArea.scrollRect = rect;
			
			model.horizontalScrollPosition = hpos;
		}
		
		private function handleContentChange(event:Event):void
		{
			contentArea = model.contentArea as UIBase;
		}
		
		private function handleVerticalScrollChange(event:Event):void
		{
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).value = model.verticalScrollPosition;
			}
		}
		
		private function handleHorizontalScrollChange(event:Event):void
		{
			if (_horizontalScroller) {
				ScrollBarModel(_horizontalScroller.model).value = model.horizontalScrollPosition;
			}
		}
	}
}