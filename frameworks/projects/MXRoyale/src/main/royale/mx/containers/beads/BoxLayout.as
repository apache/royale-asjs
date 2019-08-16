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

package mx.containers.beads
{
	
	import mx.containers.BoxDirection;
	import mx.containers.utilityClasses.Flex;
	import mx.controls.Image;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
    import mx.core.UIComponent;
	
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.UIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.ValuesManager;

	//import mx.core.mx_internal;
	//import mx.core.ScrollPolicy;
	
	//use namespace mx_internal;
	
	[ExcludeClass]
	
	/**
	 *  @private
	 *  The BoxLayout class is for internal use only.
	 */
	public class BoxLayout extends LayoutBase
	{		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function BoxLayout()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _strand:IStrand;
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			_target = value as Container;
			super.strand = value;
			
		}
		
		private var _target:Container;
		
		public function get target():Container
		{
			return _target;
		}
		
		public function set target(value:Container):void
		{
			_target = value;
		}
		
		//----------------------------------
		//  direction
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _direction:String = BoxDirection.VERTICAL;
		
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			_direction = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Measure container as per Box layout rules.
		 */
		public function measure():void
		{			
			var isVertical:Boolean = this.isVertical();
			
			var minWidth:Number = 0;
			var minHeight:Number = 0;
			
			var preferredWidth:Number = 0;
			var preferredHeight:Number = 0;
			
			var n:int = layoutView.numElements;
			var numChildrenWithOwnSpace:int = n;
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIComponent = layoutView.getElementAt(i) as IUIComponent;
				
				if (!child.includeInLayout)
				{
					numChildrenWithOwnSpace--;
					continue;
				}
				
				COMPILE::JS {
				if (child is Image) {
					trace("measure.image.complete: "+(child as Image).complete);
				}
				}
				
				var wPref:Number = child.getExplicitOrMeasuredWidth();
				var hPref:Number = child.getExplicitOrMeasuredHeight();
				
				if (isVertical)
				{
					minWidth = Math.max(!isNaN(child.percentWidth) ?
						child.minWidth : wPref, minWidth);
					
					preferredWidth = Math.max(wPref, preferredWidth);
					
					minHeight += !isNaN(child.percentHeight) ?
						child.minHeight : hPref;
					
					preferredHeight += hPref;
					
				}
				else
				{
					minWidth += !isNaN(child.percentWidth) ?
						child.minWidth : wPref;
					
					preferredWidth += wPref;
					
					minHeight = Math.max(!isNaN(child.percentHeight) ?
						child.minHeight : hPref, minHeight);
					
					preferredHeight = Math.max(hPref, preferredHeight);
					
				}
			}
			
			var wPadding:Number = widthPadding(numChildrenWithOwnSpace);
			var hPadding:Number = heightPadding(numChildrenWithOwnSpace);
			
			target.measuredMinWidth = minWidth + wPadding;
			target.measuredMinHeight = minHeight + hPadding;
			
			target.measuredWidth = preferredWidth + wPadding;
			target.measuredHeight = preferredHeight + hPadding;
		}
		
		override public function layout():Boolean
		{
			var n:int = layoutView.numElements;
			if (n == 0)
				return false;
			
			updateDisplayList(target.width, target.height);
			
			// update the target's actual size if needed.
			if (target.isWidthSizedToContent() && target.isHeightSizedToContent()) {
				target.setActualSize(target.getExplicitOrMeasuredWidth(), 
					                 target.getExplicitOrMeasuredHeight());
			}
            else if (target.isWidthSizedToContent())
                target.setWidth(target.getExplicitOrMeasuredWidth());
            else if (target.isHeightSizedToContent())
                target.setHeight(target.getExplicitOrMeasuredHeight());

			return true;
		}
		
		/**
		 *  @private
		 *  Lay out children as per Box layout rules.
		 */
		public function updateDisplayList(unscaledWidth:Number,
												   unscaledHeight:Number):void
		{			
			var n:int = layoutView.numElements;
			if (n == 0) return;
			
			var vm:EdgeMetrics = target.viewMetricsAndPadding;
            var pd:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(target);
			
			var paddingLeft:Number = pd.left;
			var paddingTop:Number = pd.top;
			
			var horizontalAlign:Number = getHorizontalAlignValue();
			var verticalAlign:Number = getVerticalAlignValue();
			
			var mw:Number = target.scaleX > 0 && target.scaleX != 1 ?
				target.minWidth / Math.abs(target.scaleX) :
				target.minWidth;
			var mh:Number = target.scaleY > 0 && target.scaleY != 1 ?
				target.minHeight / Math.abs(target.scaleY) :
				target.minHeight;
			
			if (host.isWidthSizedToContent() || host.isHeightSizedToContent()) {
				measure();
				if (host.isWidthSizedToContent()) unscaledWidth = target.measuredWidth;
				if (host.isHeightSizedToContent()) unscaledHeight = target.measuredHeight;
			}
			
			var w:Number = Math.max(unscaledWidth, mw) - vm.right - vm.left;
			var h:Number = Math.max(unscaledHeight, mh) - vm.bottom - vm.top;
			
//			var horizontalScrollBar:ScrollBar = target.horizontalScrollBar;
//			var verticalScrollBar:ScrollBar = target.verticalScrollBar;
			
			var gap:Number;
			var numChildrenWithOwnSpace:int;
			var excessSpace:Number;
			var top:Number;
			var left:Number;
			var i:int;
			var obj:IUIComponent;
			
			if (n == 1)
			{
				// This is an optimized code path for the case where there's one
				// child. This case is especially common when the Box is really
				// a GridItem. This code path works for both horizontal and
				// vertical layout.
				
				var child:IUIComponent = layoutView.getElementAt(0) as IUIComponent;
                var uic:UIComponent = child as UIComponent;
				
				var percentWidth:Number = child.percentWidth;
				var percentHeight:Number = child.percentHeight;
				
				var width:Number;
				if (percentWidth)
				{
					width = Math.max(child.minWidth,
						Math.min(child.maxWidth,
							((percentWidth >= 100) ? w : (w * percentWidth / 100))));
				}
                else if (uic != null && !isNaN(Number(uic.left)) && !isNaN(Number(uic.right)))
                {
                    width = w - Number(uic.left) - Number(uic.right);
                }
				else
				{
					width = child.getExplicitOrMeasuredWidth();
				}
				
				var height:Number
				if (percentHeight)
				{
					height = Math.max(child.minHeight,
						Math.min(child.maxHeight,
							((percentHeight >= 100) ? h : (h * percentHeight / 100))));
				}
                else if (uic != null && !isNaN(Number(uic.top)) && !isNaN(Number(uic.bottom)))
                {
                    height = h - Number(uic.top) - Number(uic.bottom);
                }
				else
				{
					height = child.getExplicitOrMeasuredHeight();
				}
				
				// if scaled and zoom is playing, best to let the sizes be non-integer
				if (child.scaleX == 1 && child.scaleY == 1)
					child.setActualSize(Math.floor(width), Math.floor(height));
				else
					child.setActualSize(width, height);
				
				// Ignore scrollbar sizes for child alignment purpose.
//				if (verticalScrollBar != null &&
//					target.verticalScrollPolicy == ScrollPolicy.AUTO)
//				{
//					w += verticalScrollBar.minWidth;
//				}
//				if (horizontalScrollBar != null &&
//					target.horizontalScrollPolicy == ScrollPolicy.AUTO)
//				{
//					h += horizontalScrollBar.minHeight;
//				}
				
				// Use the child's width and height because a Resize effect might
				// have changed the child's dimensions. Bug 146158.
				left = (w - child.width) * horizontalAlign + paddingLeft;
				top = (h - child.height) * verticalAlign + paddingTop;
				
                COMPILE::JS {
                    child.positioner.style.position = 'absolute';
                }
				child.move(Math.floor(left), Math.floor(top));
			}
				
			else if (isVertical()) // VBOX
			{
				gap = target.getStyle("verticalGap");
				
				numChildrenWithOwnSpace = n;
				for (i = 0; i < n; i++)
				{
					if (!IUIComponent(layoutView.getElementAt(i)).includeInLayout)
						numChildrenWithOwnSpace--;
				}
				
				// Stretch everything as needed, including widths.
				excessSpace = Flex.flexChildHeightsProportionally(
					layoutView, h - (numChildrenWithOwnSpace - 1) * gap, w);
				
				// Ignore scrollbar sizes for child alignment purpose.
//				if (horizontalScrollBar != null &&
//					target.horizontalScrollPolicy == ScrollPolicy.AUTO)
//				{
//					excessSpace += horizontalScrollBar.minHeight;
//				}
//				if (verticalScrollBar != null &&
//					target.verticalScrollPolicy == ScrollPolicy.AUTO)
//				{
//					w += verticalScrollBar.minWidth;
//				}
				
				top = paddingTop + excessSpace * verticalAlign;
				
				for (i = 0; i < n; i++)
				{
					obj = layoutView.getElementAt(i) as IUIComponent;
					left = (w - obj.width) * horizontalAlign + paddingLeft;
                    COMPILE::JS {
                        obj.positioner.style.position = 'absolute';
                    }
					obj.move(Math.floor(left), Math.floor(top));
					if (obj.includeInLayout)
						top += obj.height + gap;
				}
			}
				
			else  // HBOX
			{
				gap = target.getStyle("horizontalGap");
				
				numChildrenWithOwnSpace = n;
				for (i = 0; i < n; i++)
				{
					if (!IUIComponent(layoutView.getElementAt(i)).includeInLayout)
						numChildrenWithOwnSpace--;
				}
				
				// stretch everything as needed including heights
				excessSpace = Flex.flexChildWidthsProportionally(
					layoutView, w - (numChildrenWithOwnSpace - 1) * gap, h);
				
				// Ignore scrollbar sizes for child alignment purpose.
//				if (horizontalScrollBar != null &&
//					target.horizontalScrollPolicy == ScrollPolicy.AUTO)
//				{
//					h += horizontalScrollBar.minHeight;
//				}
//				if (verticalScrollBar != null &&
//					target.verticalScrollPolicy == ScrollPolicy.AUTO)
//				{
//					excessSpace += verticalScrollBar.minWidth;
//				}
				
				left = paddingLeft + excessSpace * horizontalAlign;
				
				for (i = 0; i < n; i++)
				{
					obj = layoutView.getElementAt(i) as IUIComponent;
					top = (h - obj.height) * verticalAlign + paddingTop;
                    COMPILE::JS {
                        obj.positioner.style.position = 'absolute';
                    }
					obj.move(Math.floor(left), Math.floor(top));
					if (obj.includeInLayout)
						left += obj.width + gap;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function isVertical():Boolean
		{
			return direction != BoxDirection.HORIZONTAL;
		}
		
		/**
		 *  @private
		 */
		public function widthPadding(numChildren:Number):Number
		{
			var vm:EdgeMetrics = target.viewMetricsAndPadding;
			var padding:Number = vm.left + vm.right;
			
			if (numChildren > 1 && isVertical() == false)
			{
				padding += target.getStyle("horizontalGap") *
					(numChildren - 1);
			}
			
			return padding;
		}
		
		/**
		 *  @private
		 */
		public function heightPadding(numChildren:Number):Number
		{
			var vm:EdgeMetrics = target.viewMetricsAndPadding;
			var padding:Number = vm.top + vm.bottom;
			
			if (numChildren > 1 && isVertical())
			{
				padding += target.getStyle("verticalGap") *
					(numChildren - 1);
			}
			
			return padding;
		}
		
		/**
		 *  @private
		 *  Returns a numeric value for the align setting.
		 *  0 = left/top, 0.5 = center, 1 = right/bottom
		 */
		public function getHorizontalAlignValue():Number
		{
			var horizontalAlign:String = target.horizontalAlign;
			
			if (horizontalAlign == "center")
				return 0.5;
				
			else if (horizontalAlign == "right")
				return 1;
			
			// default = left
			return 0;
		}
		
		/**
		 *  @private
		 *  Returns a numeric value for the align setting.
		 *  0 = left/top, 0.5 = center, 1 = right/bottom
		 */
		public function getVerticalAlignValue():Number
		{
			var verticalAlign:String = target.getStyle("verticalAlign");
			
			if (verticalAlign == "middle")
				return 0.5;
				
			else if (verticalAlign == "bottom")
				return 1;
			
			// default = top
			return 0;
		}
	}
	
}
