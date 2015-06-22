package org.apache.flex.core
{
	/**
	 * A Viewport is a window onto an area of content. A viewport is given space
	 * in which to operate by a View bead and given this model with the properties
	 * necessary for its function.
	 */
	public interface IViewportModel extends IBeadModel
	{	
		// Layout and Content
		
		/**
		 * Returns true (or set to true) when the contentArea is
		 * actually the same as the host strand.
		 */
		function get contentIsHost():Boolean;
		function set contentIsHost(value:Boolean):void;
		
		/**
		 * The layout being used to size and shape the content area
		 */
		function get layout():IBeadLayout;
		function set layout(value:IBeadLayout):void;
		
		/**
		 * The content area being managed by the viewport
		 */
		function get contentArea():IUIBase;
		function set contentArea(value:IUIBase):void;
		
		// Viewport Position and Dimensions
		
		/**
		 * The x position of the viewport space as allocated by the View.
		 */
		function get viewportX():Number;
		function set viewportX(value:Number):void;
		
		/**
		 * The y position of the viewport space as allocated by the View.
		 */
		function get viewportY():Number;
		function set viewportY(value:Number):void;
		
		/**
		 * The width of the viewport space as allocated by the View.
		 */
		function get viewportWidth():Number;
		function set viewportWidth(value:Number):void;
		
		/**
		 * The height of the viewport space as allocated by the View.
		 */
		function get viewportHeight():Number;
		function set viewportHeight(value:Number):void;
		
		// Content Area Size and Position
		
		/**
		 * The position of the content area within the viewport. This may
		 * be an offset from the viewportX due to padding.
		 */
		function get contentX():Number;
		function set contentX(value:Number):void;
		
		/**
		 * The position of the content area within the viewport. This may
		 * be an offset from the viewportY due to padding.
		 */
		function get contentY():Number;
		function set contentY(value:Number):void;
		
		/**
		 * The width of the content area within the viewport. The width is
		 * determined by the content itself, mostly due to the use of 
		 * a layout.
		 */
		function get contentWidth():Number;
		function set contentWidth(value:Number):void;
		
		/**
		 * The height of the content area within the viewport. The height
		 * is determined by the content itself, mostly due to the use of
		 * a layout.
		 */
		function get contentHeight():Number;
		function set contentHeight(value:Number):void;
		
		// Scrolling Parameters
		
		/**
		 * The top position of the content area that is visible in the viewport.
		 */
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		/**
		 * The left position of the content area that is visible in the viewport.
		 */
		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
	}
}