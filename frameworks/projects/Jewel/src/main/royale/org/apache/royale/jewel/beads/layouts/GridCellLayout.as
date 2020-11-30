////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.jewel.beads.layouts
{
	COMPILE::SWF {
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IUIBase;
	}
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.beads.layouts.StyledLayoutBase;

    /**
     *  The GridCellLayout class is the layout used for childrens in a Grid
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class GridCellLayout extends StyledLayoutBase
	{
		public static const MAX_COLUMNS:Number = 12;
		public static const PHONE:String = "phone";
		public static const TABLET:String = "tablet";
		public static const DESKTOP:String = "desktop";
		public static const WIDESCREEN:String = "widescreen";

        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function GridCellLayout()
		{
			super();
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static const LAYOUT_TYPE_NAMES:String = "cell";

		/**
		 *  Add class selectors when the component is addedToParent
		 *  Otherwise component will not get the class selectors when 
		 *  perform "removeElement" and then "addElement"
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.9.4
 		 */
		override public function beadsAddedHandler(event:Event = null):void
		{
			super.beadsAddedHandler();

			setFractionForScreen(WIDESCREEN, _wideScreenNumerator, _wideScreenDenominator);
			setFractionForScreen(DESKTOP, _desktopNumerator, _desktopDenominator);
			setFractionForScreen(TABLET, _tabletNumerator, _tabletDenominator);
			setFractionForScreen(PHONE, _phoneNumerator, _phoneDenominator);
		}

		private var _wideScreenNumerator:Number;
		/**
		 *  The X Number for "widescreen-col-X-Y" effect selector.
		 *  Sets the widescreen numerator for the X/Y fraction that indicates the cell's size in
		 * 	widescreen screen. Needs to be set in conjunction with widescreen denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get wideScreenNumerator():Number
        {
            return _wideScreenNumerator;
        }

        public function set wideScreenNumerator(value:Number):void
        {
			if (_wideScreenNumerator != value)
            {
				if(hostComponent)
					setFractionForScreen(WIDESCREEN, value, _wideScreenDenominator);
				_wideScreenNumerator = value;
			}
		}

		private var _wideScreenDenominator:Number;
		/**
		 *  The Y Number for "widescreen-col-X-Y" effect selector.
		 *  Sets the widescreen denominator for the X/Y fraction that indicates the cell's size in
		 *  widescreen screen. Needs to be set in conjunction with widescreen denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get wideScreenDenominator():Number
        {
            return _wideScreenDenominator;
        }

        public function set wideScreenDenominator(value:Number):void
        {
			if (_wideScreenDenominator != value)
            {
				if(hostComponent)
					setFractionForScreen(WIDESCREEN, _wideScreenNumerator, value);
				_wideScreenDenominator = value;
			}
		}

		private var _desktopNumerator:Number;
		/**
		 *  The X Number for "desktop-col-X-Y" effect selector.
		 *  Sets the desktop numerator for the X/Y fraction that indicates the cell's size in
		 * 	desktop screen. Needs to be set in conjunction with desktop denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get desktopNumerator():Number
        {
            return _desktopNumerator;
        }

        public function set desktopNumerator(value:Number):void
        {
			if (_desktopNumerator != value)
            {
				if(hostComponent)
					setFractionForScreen(DESKTOP, value, _desktopDenominator);
				_desktopNumerator = value;
			}
		}

		private var _desktopDenominator:Number;
		/**
		 *  The Y Number for "desktop-col-X-Y" effect selector.
		 *  Sets the desktop denominator for the X/Y fraction that indicates the cell's size in
		 *  desktop screen. Needs to be set in conjunction with desktop denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get desktopDenominator():Number
        {
            return _desktopDenominator;
        }

        public function set desktopDenominator(value:Number):void
        {
			if (_desktopDenominator != value)
            {
				if(hostComponent)
					setFractionForScreen(DESKTOP, _desktopNumerator, value);
				_desktopDenominator = value;
			}
		}

		private var _tabletNumerator:Number;
		/**
		 *  The X Number for "tablet-col-X-Y" effect selector.
		 *  Sets the tablet numerator for the X/Y fraction that indicates the cell's size in
		 * 	tablet screen. Needs to be set in conjunction with tablet denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get tabletNumerator():Number
        {
            return _tabletNumerator;
        }

        public function set tabletNumerator(value:Number):void
        {
			if (_tabletNumerator != value)
            {
				if(hostComponent)
					setFractionForScreen(TABLET, value, _tabletDenominator);
				_tabletNumerator = value;
			}
		}

		private var _tabletDenominator:Number;
		/**
		 *  The Y Number for "tablet-col-X-Y" effect selector.
		 *  Sets the tablet denominator for the X/Y fraction that indicates the cell's size in
		 *  tablet screen. Needs to be set in conjunction with tablet denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get tabletDenominator():Number
        {
            return _tabletDenominator;
        }

        public function set tabletDenominator(value:Number):void
        {
			if (_tabletDenominator != value)
            {
				if(hostComponent)
					setFractionForScreen(TABLET, _tabletNumerator, value);
				_tabletDenominator = value;
			}
		}

		private var _phoneNumerator:Number;
		/**
		 *  The X Number for "phone-col-X-Y" effect selector.
		 *  Sets the phone numerator for the X/Y fraction that indicates the cell's size in
		 * 	phone screen. Needs to be set in conjunction with phone denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get phoneNumerator():Number
        {
            return _phoneNumerator;
        }

        public function set phoneNumerator(value:Number):void
        {
			if (_phoneNumerator != value)
            {
				if(hostComponent)
					setFractionForScreen(PHONE, value, _phoneDenominator);
				_phoneNumerator = value;
			}
		}

		private var _phoneDenominator:Number;
		/**
		 *  The Y Number for "phone-col-X-Y" effect selector.
		 *  Sets the phone denominator for the X/Y fraction that indicates the cell's size in
		 *  phone screen. Needs to be set in conjunction with phone denominator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get phoneDenominator():Number
        {
            return _phoneDenominator;
        }

        public function set phoneDenominator(value:Number):void
        {
			if (_phoneDenominator != value)
            {
				if(hostComponent)
					setFractionForScreen(PHONE, _phoneNumerator, value);
				_phoneDenominator = value;
			}
		}

		private function setFractionForScreen(screen:String, num:Number, den:Number):void
		{
			if(num && den)
			{
				if (num <= 0 || num > MAX_COLUMNS)
					throw new Error(screen + " numerator must be between 1 and " + MAX_COLUMNS);
				if (den <= 0 || den > MAX_COLUMNS)
					throw new Error(screen + " denominator must be between 1 and " + MAX_COLUMNS);
				
				hostComponent.replaceClass(screen + "-col-" + _desktopNumerator + "-" + _desktopDenominator, screen + "-col-" + num + "-" + den);
			}
        }

		private var _phoneVisible:Boolean;
		/**
		 *  Makes the cell to be visible or hidden in phone size
		 *  Uses "visible-phone" and "hidden-phone" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get phoneVisible():Boolean
        {
            return _phoneVisible;
        }

        public function set phoneVisible(value:Boolean):void
        {
			if (_phoneVisible != value)
            {
				_phoneVisible = value;

				if(hostComponent)
				{
					if(_phoneVisible)
						hostComponent.replaceClass("hidden-phone", "visible-phone");
					else
						hostComponent.replaceClass("visible-phone", "hidden-phone");
				}
			}
		}

		private var _tabletVisible:Boolean;
		/**
		 *  Makes the cell to be visible or hidden in phone size
		 *  Uses "visible-tablet" and "hidden-tablet" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get tabletVisible():Boolean
        {
            return _tabletVisible;
        }

        public function set tabletVisible(value:Boolean):void
        {
			if (_tabletVisible != value)
            {
				_tabletVisible = value;

				if(hostComponent)
				{
					if(_tabletVisible)
						hostComponent.replaceClass("hidden-tablet", "visible-tablet");
					else
						hostComponent.replaceClass("visible-tablet", "hidden-tablet");
				}
			}
		}

		private var _desktopVisible:Boolean;
		/**
		 *  Makes the cell to be visible or hidden in phone size
		 *  Uses "visible-desktop" and "hidden-desktop" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get desktopVisible():Boolean
        {
            return _desktopVisible;
        }

        public function set desktopVisible(value:Boolean):void
        {
			if (_desktopVisible != value)
            {
				_desktopVisible = value;
                
				if(hostComponent)
				{
					if(_desktopVisible)
						hostComponent.replaceClass("hidden-desktop", "visible-desktop");
					else
						hostComponent.replaceClass("visible-desktop", "hidden-desktop");
				}
			}
		}

		private var _wideScreenVisible:Boolean;
		/**
		 *  Makes the cell to be visible or hidden in phone size
		 *  Uses "visible-widescreen" and "hidden-widescreen" effect selectors.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get wideScreenVisible():Boolean
        {
            return _wideScreenVisible;
        }

        public function set wideScreenVisible(value:Boolean):void
        {
			if (_wideScreenVisible != value)
            {
				_wideScreenVisible = value;

				if(hostComponent)
				{
					if(_wideScreenVisible)
						hostComponent.replaceClass("hidden-widescreen", "visible-widescreen");
					else
						hostComponent.replaceClass("visible-widescreen", "hidden-widescreen");
				}
			}
		}

        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
         */
		override public function layout():Boolean
		{
            COMPILE::SWF
            {
				var contentView:ILayoutView = layoutView;

				var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
				var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();

				var w:Number = hostWidthSizedToContent ? 0 : contentView.width;
				var h:Number = hostHeightSizedToContent ? 0 : contentView.height;

				var n:int = contentView.numElements;

                for (var i:int = 0; i < n; i++)
                {
                    var child:IUIBase = contentView.getElementAt(i) as IUIBase;
					if (child == null || !child.visible) continue;

					var positions:Object = childPositions(child);
					var margins:Object = childMargins(child, contentView.width, contentView.height);
                    var ww:Number = w;
                    var hh:Number = h;

                    var ilc:ILayoutChild = child as ILayoutChild;

					// set the top edge of the child
                    if (!isNaN(positions.left))
                    {
                        if (ilc)
                            ilc.setX(positions.left+margins.left);
                        else
                            child.x = positions.left+margins.left;
                        ww -= positions.left + margins.left;
                    }

					// set the left edge of the child
                    if (!isNaN(positions.top))
                    {
                        if (ilc)
                            ilc.setY(positions.top+margins.top);
                        else
                            child.y = positions.top+margins.top;
                        hh -= positions.top + margins.top;
                    }

					// set the right edge of the child
					if (!isNaN(positions.right))
					{
						if (!hostWidthSizedToContent)
						{
							if (!isNaN(positions.left))
							{
								if (ilc)
									ilc.setWidth(ww - positions.right - margins.right, false);
								else
									child.width = ww - positions.right - margins.right;
							}
							else
							{
								if (ilc)
								{
									ilc.setX( w - positions.right - margins.left - child.width - margins.right);
								}
								else
								{
									child.x = w - positions.right - margins.left - child.width - margins.right;
								}
							}
						}
					}
					else if (ilc != null && !isNaN(ilc.percentWidth) && !hostWidthSizedToContent)
					{
						ilc.setWidth((ww - margins.right - margins.left) * ilc.percentWidth/100, false);
					}

					// set the bottm edge of the child
					if (!isNaN(positions.bottom))
					{
						if (!hostHeightSizedToContent)
						{
							if (!isNaN(positions.top))
							{
								if (ilc)
									ilc.setHeight(hh - positions.bottom - margins.bottom, false);
								else
									child.height = hh - positions.bottom - margins.bottom;
							}
							else
							{
								if (ilc)
									ilc.setY( h - positions.bottom - child.height - margins.bottom);
								else
									child.y = h - positions.bottom - child.height - margins.bottom;
							}
						}
					}
					else if (ilc != null && !isNaN(ilc.percentHeight) && !hostHeightSizedToContent)
					{
						ilc.setHeight((hh - margins.top - margins.bottom) * ilc.percentHeight/100, false);
					}
					
					if (margins.auto)
					{
						if (ilc)
							ilc.setX( (w - child.width) / 2);
						else
							child.x = (w - child.width) / 2;
					}
                }

                return true;

            }

            COMPILE::JS
            {
			return true;
            }
		}
	}
}
