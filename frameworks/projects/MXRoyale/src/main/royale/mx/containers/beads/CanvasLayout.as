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
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;

	import org.apache.royale.core.IStrand;
	import mx.core.ILayoutElement;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.geom.Rectangle;

	//import mx.core.IConstraintClient;
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.layout.EdgeData;
	import mx.containers.utilityClasses.ConstraintColumn;
	import mx.containers.utilityClasses.ConstraintRow;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.core.ValuesManager;

	import mx.core.mx_internal;

	use namespace mx_internal;
/*
import mx.events.ChildExistenceChangedEvent;
import mx.events.MoveEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import flash.utils.Dictionary;

*/

/**
 *  @private
 *  The CanvasLayout class is for internal use only.
 */
public class CanvasLayout extends LayoutBase
{

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var r:Rectangle = new Rectangle();

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Restrict a number to a particular min and max.
	 */
	private function bound(a:Number, min:Number, max:Number):Number
	{
		if (a < min)
			a = min;
		else if (a > max)
			a = max;
		else
			a = Math.floor(a);

		return a;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	private var _contentArea:Rectangle;

	//Arrays that keep track of children spanning
	//content size columns or rows.
//	private var colSpanChildren:Array = [];
//	private var rowSpanChildren:Array = [];

//	private var constraintCache:Dictionary = new Dictionary(true);

	private var constraintRegionsInUse:Boolean = false;

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
    public function CanvasLayout()
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
		var oldTarget:Container = _target;
		_target = value as Container;
		super.strand = value;
		// The main layout may not get put on the strand until
		// after children are added so listen here as well
		if (value){
			if (target.parent)
				listenToChildren(true);
		} else {
			if (oldTarget) {
				host = oldTarget;
				listenToChildren(false);
				host = null;
			}
		}
		
	}

	override protected function handleInitComplete(event:Event):void
	{
		listenToChildren(true);
		super.handleInitComplete(event);
	}


	override protected function handleChildrenAdded(event:Event):void
	{
		//trace(this.target.id, event);
		listenToChildren(true);
		super.handleChildrenAdded(event);
	}

	private var childListeningCache:Array = [];
	private function listenToChildren(on:Boolean):void
	{
		var n:Number = layoutView.numElements;
		var handler:Function = childResizeHandler;

		var currentChildren:Array = [];
		for(var i:int=0; i < n; i++) {
			var child:IEventDispatcher = layoutView.getElementAt(i) as IEventDispatcher;
			currentChildren.push(child);

			listenToChild(child,on, handler);
		}
		if (!on) {
			n= childListeningCache.length;
			for(i=0; i < n; i++) {
				child = childListeningCache[i];
				if (currentChildren.indexOf(child)==-1) {
					listenToChild(child,false, handler);
				}
			}
			childListeningCache.length = 0;
		} else {
			n= childListeningCache.length;
			for(i=0; i < n; i++) {
				child = childListeningCache[i];
				if (currentChildren.indexOf(child)==-1) {
					listenToChild(child,false, handler);
				}
			}
			childListeningCache = currentChildren;
		}
	}

	private function listenToChild(child:IEventDispatcher, on:Boolean, handler:Function):void{
		var adjustListener:Function = on ? child.addEventListener : child.removeEventListener;
		/*adjustListener("widthChanged", handler);
		adjustListener("heightChanged", handler);*/
		//@todo adding 'sizeChanged' as well.... e.g. width increased, with only right set, should cause lower x value in child.
		adjustListener("widthChanged", handler);
		adjustListener("heightChanged", handler);
		adjustListener("sizeChanged", handler);
		adjustListener("move", handler);
	}

	private var ranLayout:Boolean;
	private var ignoreChildCount:int = 0;
	override protected function childResizeHandler(event:Event):void
	{
		if (isLayoutRunning) return;
		if (ignoreChildCount) {
			ignoreChildCount--;
			return;
		}
		if (event.type == 'sizeChanged') ignoreChildCount = 2; //ignore next 2 widthChanged/heightChanged events
		ranLayout = false;
		super.childResizeHandler(event); // will set ranLayout if it did
		if (!ranLayout)
			performLayout();
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


	public function measure():void
	{
		var target:Container = this.target;
		/*var w:Number = 0;
		var h:Number = 0;
		var i:Number = 0;*/

		var vm:EdgeMetrics = target.viewMetricsAndPadding;
		/*var pd:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(target);

		var paddingLeft:Number = pd.left;
		var paddingTop:Number = pd.top;
		trace('paddings', pd)*/
		/*var n:int = layoutView.numElements;
		for (i = 0; i < n; i++)
		{
			var child:IUIComponent = layoutView.getElementAt(i) as IUIComponent;
			parseConstraints(child);
		}

		//We need to NaN out content-sized columns and rows width/height values
		//so that new values are calculated correctly and we avoid stale values

		for (i = 0; i < IConstraintLayout(target).constraintColumns.length; i++)
		{
			var col:ConstraintColumn = IConstraintLayout(target).constraintColumns[i];
			if (col.contentSize)
				col._width = NaN;
		}
		for (i = 0; i < IConstraintLayout(target).constraintRows.length; i++)
		{
			var row:ConstraintRow = IConstraintLayout(target).constraintRows[i];
			if (row.contentSize)
				row._height = NaN;
		}

		measureColumnsAndRows();*/

		_contentArea = null;
		var contentArea:Rectangle = measureContentArea();

		// Only add viewMetrics padding
		// if children are bigger than existing size.
		target.measuredWidth = contentArea.width + vm.left + vm.right;
		target.measuredHeight = contentArea.height + vm.top + vm.bottom;
	}


		//--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	/**
	 *
	 * @royaleignorecoercion Number
	 * @royaleignorecoercion org.apache.royale.core.UIBase
	 */
	override public function layout():Boolean
	{
		ranLayout = true;
		COMPILE::SWF
		{			
			var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
			var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
			
			var w:Number = hostWidthSizedToContent ? 0 : target.width;
			var h:Number = hostHeightSizedToContent ? 0 : target.height;
			
			var n:int = target.numChildren;
			if (n != childListeningCache.length) listenToChildren(true)	;
			for (var i:int = 0; i < n; i++)
			{
				var child:IUIComponent = target.getLayoutChildAt(i);
				if (!child.includeInLayout) continue;
				
				var positions:Object = childPositions(child);
				var margins:Object = childMargins(child, target.width, target.height);
				var ww:Number = w;
				var hh:Number = h;
				
				var xpos:Number;
				var ypos:Number;
				var useWidth:Number;
				var useHeight:Number;
								
				// set the top edge of the child
				if (!isNaN(positions.left))
				{
					xpos = positions.left+margins.left;
					ww -= positions.left + margins.left;
				}
				
				// set the left edge of the child
				if (!isNaN(positions.top))
				{
					ypos = positions.top+margins.top;
					hh -= positions.top + margins.top;
				}
				
				// set the right edge of the child
				if (!isNaN(positions.right))
				{
					if (!hostWidthSizedToContent)
					{
						if (!isNaN(positions.left))
						{
							useWidth = ww - positions.right - margins.right;
						}
						else
						{
							xpos = w - positions.right - margins.left - child.width - margins.right
						}
					}
				}
				else if (child != null && !isNaN(child.percentWidth) && !hostWidthSizedToContent)
				{
					useWidth = (ww - margins.right - margins.left) * child.percentWidth/100;
				}
				
				// set the bottm edge of the child
				if (!isNaN(positions.bottom))
				{
					if (!hostHeightSizedToContent)
					{
						if (!isNaN(positions.top))
						{
							useHeight = hh - positions.bottom - margins.bottom;
						}
						else
						{
							ypos = h - positions.bottom - child.height - margins.bottom;
						}
					}
				}
				else if (child != null && !isNaN(child.percentHeight) && !hostHeightSizedToContent)
				{
					useHeight = (hh - margins.top - margins.bottom) * child.percentHeight/100;
				}
				
				if (margins.auto)
				{
					xpos = (w - child.width) / 2;
				}
				
				child.move(xpos, ypos);
				child.setActualSize(useWidth, useHeight);
			}
				
			return true;
				
		}
			
		COMPILE::JS
		{
			var i:int
			var n:int;
			
			n = target.numChildren;
			if (n != childListeningCache.length) listenToChildren(true)	;
			// host must have either have position:absolute or position:relative
			if (target.element.style.position != "absolute" && target.element.style.position != "relative") {
				target.element.style.position = "relative";
			}

			var targetHeight:Number;
			var targetWidth:Number;

			var contentHeight:Boolean = target.isHeightSizedToContent();
			var contentWidth:Boolean = target.isWidthSizedToContent();
			var sizeTarget:Boolean;
			if (contentWidth || contentHeight) {
				if (target.setActualSizeCalled) {
					//assume that the parent layout setting wins, do not resize target
					targetWidth = target.width;
					targetHeight = target.height;
				} else {
					measure();
					targetWidth = contentWidth? target.measuredWidth : target.width;
					targetHeight = contentHeight? target.measuredHeight : target.height;
					sizeTarget = true;
				}
			} else {
				targetHeight = target.height;
				targetWidth = target.width;
			}


			var altCheck:Number;
			// each child must have position:absolute for BasicLayout to work
			for (i=0; i < n; i++) {
				var child:IUIComponent = target.getLayoutChildAt(i);
				if (!child.includeInLayout) continue;
				var layoutChild:ILayoutElement = child as ILayoutElement;
				var hCenter:Number = Number(layoutChild.horizontalCenter);
				var vCenter:Number = Number(layoutChild.verticalCenter);
				child.positioner.style.position = "absolute";
				var layoutNeeded:Boolean = true;
				var constraintLayout:Boolean = false;
				var widthSet:Boolean = false;
				var heightSet:Boolean = false;
				var percentWidthSet:Boolean = false;
				var percentHeightSet:Boolean = false;
				var hh:Number = child.height;
				var childLeft:Number = Number(layoutChild.left);
				var childRight:Number = Number(layoutChild.right);
				var childTop:Number = Number(layoutChild.top);
				var childBottom:Number = Number(layoutChild.bottom);
				var dimensionVal:Number;
				var measuredChild:Boolean = false;
				//top and bottom combined take precedence over percentHeight/height
				if (!isNaN(childTop) && !isNaN(childBottom)) {
					hh = targetHeight - (childTop + childBottom)
					constraintLayout = true;
					heightSet = true;
				} else if (!isNaN(child.percentHeight))
				{
					hh = targetHeight * child.percentHeight / 100;
					layoutNeeded = false;
					heightSet = percentHeightSet = true;
				} /* hack */ else {
					dimensionVal = child.explicitHeight
					if (isNaN(dimensionVal)) {
						dimensionVal = child.measuredHeight;
					}
					if (hh != dimensionVal) {
						hh = dimensionVal;
						heightSet = true;
					}
				}
				var ww:Number = child.width;
				//left and right combined take precedence over percentWidth/width
				if (!isNaN(childLeft) && !isNaN(childRight)) {
					ww = targetWidth - (childLeft + childRight)
					constraintLayout = true;
					widthSet = true;
				} else if (!isNaN(child.percentWidth))
				{
					ww = targetWidth * child.percentWidth / 100;
					layoutNeeded = !constraintLayout;
					widthSet = percentWidthSet = true;
				}/* hack */ else {
					dimensionVal = child.explicitWidth
					if (isNaN(dimensionVal)) {
						dimensionVal = child.measuredWidth;
					}
					if (ww != dimensionVal) {
						ww = dimensionVal;
						widthSet = true;
					}
				}
				var setVal:String;

				var childStyle:CSSStyleDeclaration = child.element.style;
				if (layoutNeeded || constraintLayout/*layoutNeeded || constraintLayout*/) {
				//	var sameConstraints:Boolean = false;

					if (!isNaN(childLeft)) {
						//if (childStyle.left  == childLeft+'px') sameConstraints = true;
						child.x = childLeft;
						if (!isNaN(childRight)) {
							setVal = childRight+'px';
							if (childStyle.right != setVal) {
								childStyle.right = setVal;
								//childStyle.width = '';
							} /*else {
								if (sameConstraints) //no change in width
									widthSet = false;
							}*/
							//the following improves behavior, but needs testing against Flex :
							//child.explicitWidth = NaN;
						} else {
							childStyle.right = '';
						}
					} else //@todo check this:
						if (!isNaN(childRight)) {
							childStyle.right = '';
							var oldVal:Number = child.x;
							childStyle.left = '';
							if (percentWidthSet) {
								child.x = targetWidth - ww - childRight;
							}
							else {
								altCheck = child.getExplicitOrMeasuredWidth()
								if (altCheck != ww) {
									ww = altCheck;
									widthSet = true;
								}
								child.x = targetWidth - ww - childRight;
							}
							childStyle.right = childRight+'px';
							if (oldVal == child.x) {
								//it won't restore the setting, so do it manually:
								childStyle.left = oldVal+'px';
							}
					} else {
						child.element.style.right = '';
					}
					//sameConstraints = false;
					if (!isNaN(childTop)) {
						child.y = childTop;
						if (!isNaN(childBottom)) {
							setVal = childBottom+'px';
							if (childStyle.bottom != setVal) {
								childStyle.bottom = childBottom+'px';
							}

							//the following improves behavior, but needs testing against Flex :
							//child.explicitHeight = NaN;
							//childStyle.height = '';
						} else {
							childStyle.bottom = '';
						}
					} else  //@todo check this:
						if (!isNaN(childBottom)) {
							childStyle.bottom = '';
							oldVal = child.y;
							childStyle.top = '';

							if (percentHeightSet) {
								child.y = targetHeight - hh - childBottom;
							}
							else {
								altCheck = child.getExplicitOrMeasuredHeight()
								if (altCheck != hh) {
									hh = altCheck;
									heightSet = true;
								}
								child.y = targetHeight - hh - childBottom;
							}
							childStyle.bottom = childBottom+'px';
							if (oldVal == child.y) {
								//it won't restore the setting, so do it manually:
								childStyle.top = oldVal+'px';
							}
						} else {
							childStyle.bottom = '';
					}
					layoutNeeded = !constraintLayout;
				}

				if (percentHeightSet) hh = Math.min(targetHeight-child.y, hh);
				if (percentWidthSet) ww = Math.min(targetWidth-child.x, ww);
				if (widthSet && heightSet) {
					child.setActualSize(ww, hh);
				} else if (heightSet) {
					UIBase(child).setHeight(hh);
				} else if (widthSet) {
					UIBase(child).setWidth(ww);
				} else if (layoutNeeded)
					child.dispatchEvent(new Event("layoutNeeded"));

				if (!isNaN(hCenter))
				{
					// TODO consider how this affects measurement of target
					child.x = Math.round((targetWidth - ww) / 2 + hCenter);
				}
				if (!isNaN(vCenter)) {
					// TODO consider how this affects measurement of target
					child.y = Math.round((targetHeight - hh) / 2 + vCenter);
				}
			}
			if (sizeTarget){
				if (contentWidth && contentHeight){
					target.setActualSize(targetWidth, targetHeight)
					/*COMPILE::JS{
						//GD - tbc, otherwise the 'non' includeInLayout elements outside measured bounds can cause scrollbars:
						target.element.style.overflow = 'visible'
					}*/

				} else if (contentWidth) {
					target.setWidth(targetWidth);
					/*COMPILE::JS{
						//GD - tbc, otherwise the 'non' includeInLayout elements outside measured bounds can cause scrollbars:
						target.element.style.overflowX = 'visible'
					}*/
				} else {
					target.setHeight(targetHeight);
					/*COMPILE::JS{
						//GD - tbc, otherwise the 'non' includeInLayout elements outside measured bounds can cause scrollbars:
						target.element.style.overflowY = 'visible'
					}*/
				}
			}
			return true;
		}
	}






	/**
	 *  @private
	 */
	/*private function parseConstraints(child:IUIComponent = null):ChildConstraintInfo
	{
		var constraints:LayoutConstraints = getLayoutConstraints(child);
		if (!constraints)
			return null;
		//Variables to track the offsets
		var left:Number;
		var right:Number;
		var horizontalCenter:Number;
		var top:Number;
		var bottom:Number;
		var verticalCenter:Number;
		var baseline:Number;

		//Variables to track the boundaries from which
		//the offsets are calculated from. If null, the
		//boundary is the parent container edge.
		var leftBoundary:String;
		var rightBoundary:String;
		var hcBoundary:String;
		var topBoundary:String;
		var bottomBoundary:String;
		var vcBoundary:String;
		var baselineBoundary:String;

		//Evaluate the constraint expression and store the offsets
		//and boundaries.
		var temp:Array;
		while (true)
		{
			temp = parseConstraintExp(constraints.left);
			if (!temp)
				left = NaN;
			else if (temp.length == 1)
				left = Number(temp[0]);
			else
			{
				leftBoundary = temp[0];
				left = temp[1];
			}

			temp = parseConstraintExp(constraints.right);
			if (!temp)
				right = NaN;
			else if (temp.length == 1)
				right = Number(temp[0]);
			else
			{
				rightBoundary = temp[0];
				right = temp[1];
			}

			temp = parseConstraintExp(constraints.horizontalCenter);
			if (!temp)
				horizontalCenter = NaN;
			else if (temp.length == 1)
				horizontalCenter = Number(temp[0]);
			else
			{
				hcBoundary = temp[0];
				horizontalCenter = temp[1];
			}

			temp = parseConstraintExp(constraints.top);
			if (!temp)
				top = NaN;
			else if (temp.length == 1)
				top = Number(temp[0]);
			else
			{
				topBoundary = temp[0];
				top = temp[1];
			}

			temp = parseConstraintExp(constraints.bottom);
			if (!temp)
				bottom = NaN;
			else if (temp.length == 1)
				bottom = Number(temp[0]);
			else
			{
				bottomBoundary = temp[0];
				bottom = temp[1];
			}

			temp = parseConstraintExp(constraints.verticalCenter);
			if (!temp)
				verticalCenter = NaN;
			else if (temp.length == 1)
				verticalCenter = Number(temp[0]);
			else
			{
				vcBoundary = temp[0];
				verticalCenter = temp[1];
			}
			temp = parseConstraintExp(constraints.baseline);
			if (!temp)
				baseline = NaN;
			else if (temp.length == 1)
				baseline = Number(temp[0]);
			else
			{
				baselineBoundary = temp[0];
				baseline = temp[1];
			}

			break;
		}

		//Store entries for the children who span columns/rows in
		//the colSpanChildren and rowSpanChildren arrays.
		var i:int;
		var colEntry:ContentColumnChild = new ContentColumnChild();
		var pushEntry:Boolean = false;
		var leftIndex:Number = 0;
		var rightIndex:Number = 0;
		var hcIndex:Number = 0;

		for (i = 0; i < IConstraintLayout(target).constraintColumns.length; i++)
		{
			var col:ConstraintColumn = IConstraintLayout(target).constraintColumns[i];
			if (col.contentSize)
			{
				if (col.id == leftBoundary)
				{
					colEntry.leftCol = col;
					colEntry.leftOffset = left;
					colEntry.left = leftIndex = i;
					pushEntry = true;
				}
				if (col.id == rightBoundary)
				{
					colEntry.rightCol = col;
					colEntry.rightOffset = right;
					colEntry.right = rightIndex = i + 1;
					pushEntry = true;
				}
				if (col.id == hcBoundary)
				{
					colEntry.hcCol = col;
					colEntry.hcOffset = horizontalCenter;
					colEntry.hc = hcIndex = i + 1;
					pushEntry = true;
				}
			}
		}

		//Figure out the bounding columns,
		//span value and the child spanning and push that
		//information onto colSpanChildren for evaluation
		//when measuring content sized columns
		if (pushEntry)
		{
			colEntry.child = child;
			if (colEntry.leftCol && !colEntry.rightCol ||
					colEntry.rightCol && !colEntry.leftCol ||
					colEntry.hcCol)
			{
				colEntry.span = 1;
			}
			else
				colEntry.span = rightIndex - leftIndex;

			//push the entry if it's not there already
			var found:Boolean = false;
			for (i = 0; i < colSpanChildren.length; i++)
			{
				if (colEntry.child == colSpanChildren[i].child)
				{
					found = true;
					break;
				}
			}

			if (!found)
				colSpanChildren.push(colEntry);
		}
		pushEntry = false;

		var rowEntry:ContentRowChild = new ContentRowChild();
		var topIndex:Number = 0;
		var bottomIndex:Number = 0;
		var vcIndex:Number = 0;
		var baselineIndex:Number = 0;
		for (i = 0; i < IConstraintLayout(target).constraintRows.length; i++)
		{
			var row:ConstraintRow = IConstraintLayout(target).constraintRows[i];
			if (row.contentSize)
			{
				if (row.id == topBoundary)
				{
					rowEntry.topRow = row;
					rowEntry.topOffset = top;
					rowEntry.top = topIndex = i;
					pushEntry = true;
				}
				if (row.id == bottomBoundary)
				{
					rowEntry.bottomRow = row;
					rowEntry.bottomOffset = bottom;
					rowEntry.bottom = bottomIndex = i + 1;
					pushEntry = true;
				}
				if (row.id == vcBoundary)
				{
					rowEntry.vcRow = row;
					rowEntry.vcOffset = verticalCenter;
					rowEntry.vc = vcIndex = i + 1;
					pushEntry = true;
				}
				if (row.id == baselineBoundary)
				{
					rowEntry.baselineRow = row;
					rowEntry.baselineOffset = baseline;
					rowEntry.baseline = baselineIndex = i + 1;
					pushEntry = true;
				}
			}
		}
		//Figure out the bounding rows,
		//span value and the child spanning and push that
		//information onto rowSpanChildren for evaluation
		//when measuring content sized rows
		if (pushEntry)
		{
			rowEntry.child = child;
			if (rowEntry.topRow && !rowEntry.bottomRow ||
					rowEntry.bottomRow && !rowEntry.topRow ||
					rowEntry.vcRow || rowEntry.baselineRow)
			{
				rowEntry.span = 1;
			}
			else
				rowEntry.span = bottomIndex - topIndex;

			//push the entry if it's not there already
			found = false;
			for (i = 0; i < rowSpanChildren.length; i++)
			{
				if (rowEntry.child == rowSpanChildren[i].child)
				{
					found = true;
					break;
				}
			}

			if (!found)
				rowSpanChildren.push(rowEntry);
		}
		//Cache constraint styles for future lookup
		var info:ChildConstraintInfo = new ChildConstraintInfo(left, right, horizontalCenter,
				top, bottom, verticalCenter, baseline, leftBoundary,
				rightBoundary, hcBoundary, topBoundary, bottomBoundary,
				vcBoundary, baselineBoundary);
		constraintCache[child] = info;
		return info;
	}*/

	/**
	 *  @private
	 *  This function measures the ConstraintColumns and
	 *  and ConstraintRows partitioning a Canvas and sets
	 *  up their x/y positions.
	 *
	 *  The algorithm works like this (in the horizontal
	 *  direction):
	 *  1. Fixed columns honor their pixel values.
	 *
	 *  2. Content sized columns whose children span
	 *  only that column assume the width of the widest child.
	 *
	 *  3. Those Content sized columns that span multiple
	 *  columns do the following:
	 *    a. Sort the children by order of how many columns they
	 *    are spanning.
	 *    b. For children spanning a single column, make each
	 *    column as wide as the preferred size of the child.
	 *    c. For subsequent children, divide the remainder space
	 *    equally between shared columns.
	 *
	 *  4. Remaining space is shared between the percentage size
	 *  columns.
	 *
	 *  5. x positions are set based on the column widths
	 *
	 */
	private function measureColumnsAndRows():void
	{
		//@todo constraint columns/rows
		/*var cols:Array = IConstraintLayout(target).constraintColumns;
		var rows:Array = IConstraintLayout(target).constraintRows;
		if (!rows.length > 0 && !cols.length > 0)
		{
			constraintRegionsInUse = false;
			return;
		}
		else
			constraintRegionsInUse = true;
		var i:int;
		var k:int;
		var canvasX:Number = 0;
		var canvasY:Number = 0;
		var vm:EdgeMetrics = Container(target).viewMetrics;
		var availableWidth:Number = Container(target).width - vm.left - vm.right;
		var availableHeight:Number = Container(target).height - vm.top - vm.bottom;
		var fixedSize:Array = [];
		var percentageSize:Array = [];
		var contentSize:Array = [];
		var cc:ConstraintColumn;
		var cr:ConstraintRow;
		var spaceToDistribute:Number;
		var w:Number;
		var h:Number;
		var remainingSpace:Number;

		if (cols.length > 0)
		{
			for (i = 0; i < cols.length; i++)
			{
				cc = cols[i];
				if (!isNaN(cc.percentWidth))
					percentageSize.push(cc);
				else if (!isNaN(cc.width) && !cc.contentSize)
					fixedSize.push(cc);
				else
				{
					contentSize.push(cc);
					cc.contentSize = true;
				}
			}
			//fixed size columns
			for (i = 0; i < fixedSize.length; i++)
			{
				cc = ConstraintColumn(fixedSize[i]);
				availableWidth = availableWidth - cc.width;
			}
			//content size columns
			if (contentSize.length > 0)
			{
				//first we figure allocate space to those columns
				//with children spanning them
				if (colSpanChildren.length > 0)
				{
					colSpanChildren.sortOn("span");
					for (k = 0; k < colSpanChildren.length; k++)
					{
						var colEntry:ContentColumnChild = colSpanChildren[k];
						//For those children that span 1 column, give that column
						//the max preferred width of the child;
						if (colEntry.span == 1)
						{
							//Match the columns
							if (colEntry.hcCol)
								cc = ConstraintColumn(cols[cols.indexOf(colEntry.hcCol)]);
							else if (colEntry.leftCol)
								cc = ConstraintColumn(cols[cols.indexOf(colEntry.leftCol)]);
							else if (colEntry.rightCol)
								cc = ConstraintColumn(cols[cols.indexOf(colEntry.rightCol)]);
							//Use preferred size if left and right are specified
							w = colEntry.child.getExplicitOrMeasuredWidth();
							//Now we add in offsets
							if (colEntry.hcOffset)
								w += colEntry.hcOffset;
							else
							{
								if (colEntry.leftOffset)
									w += colEntry.leftOffset;
								if (colEntry.rightOffset)
									w += colEntry.rightOffset;
							}
							//width may have been set by a previous pass - so we want to take the max
							if (!isNaN(cc.width))
								w = Math.max(cc.width, w);
							w = bound(w, cc.minWidth, cc.maxWidth);
							cc.setActualWidth(w);
							availableWidth -= cc.width;
						}
						//otherwise we share space amongst the spanned columns
						else
						{
							availableWidth = shareColumnSpace(colEntry, availableWidth);
						}
					}
					//reset
					colSpanChildren = [];
				}
				//now for those content size columns that don't have widths
				//give them their minWidth or 0.
				for (i = 0; i < contentSize.length; i++)
				{
					cc = contentSize[i];
					if (!cc.width)
					{
						w = bound(0, cc.minWidth, 0);
						cc.setActualWidth(w);
					}
				}
			}
			//percentage size columns
			remainingSpace = availableWidth;
			for (i = 0; i < percentageSize.length; i++)
			{
				cc = ConstraintColumn(percentageSize[i]);
				if (remainingSpace <= 0)
					w = 0;
				else
					w = Math.round((remainingSpace * cc.percentWidth)/100);
				w = bound(w, cc.minWidth, cc.maxWidth);
				cc.setActualWidth(w);
				availableWidth -= w;
			}

			//In the order they were declared, set up the x positions
			for (i = 0; i < cols.length; i++)
			{
				cc = ConstraintColumn(cols[i]);
				cc.x = canvasX;
				canvasX += cc.width;
			}
		}

		fixedSize = [];
		percentageSize = [];
		contentSize = [];
		if (rows.length > 0)
		{
			for (i = 0; i < rows.length; i++)
			{
				cr = rows[i];
				if (!isNaN(cr.percentHeight))
				{
					percentageSize.push(cr);
				}
				else if (!isNaN(cr.height) && !cr.contentSize)
					fixedSize.push(cr);
				else
				{
					contentSize.push(cr);
					cr.contentSize = true;
				}
			}
			//fixed size rows
			for (i = 0; i < fixedSize.length; i++)
			{
				cr = ConstraintRow(fixedSize[i]);
				availableHeight = availableHeight - cr.height;
			}
			//content size rows
			if (contentSize.length > 0)
			{
				//first we figure allocate space to those rows
				//with children spanning them
				if (rowSpanChildren.length > 0)
				{
					rowSpanChildren.sortOn("span");
					for (k = 0; k < rowSpanChildren.length; k++)
					{
						var rowEntry:ContentRowChild = rowSpanChildren[k];
						//For those children that span 1 row, give that row
						//the max preferred height of the child;
						if (rowEntry.span == 1)
						{
							//Match the rows
							if (rowEntry.vcRow)
								cr = ConstraintRow(rows[rows.indexOf(rowEntry.vcRow)]);
							else if (rowEntry.baselineRow)
								cr = ConstraintRow(rows[rows.indexOf(rowEntry.baselineRow)]);
							else if (rowEntry.topRow)
								cr = ConstraintRow(rows[rows.indexOf(rowEntry.topRow)]);
							else if (rowEntry.bottomRow)
								cr = ConstraintRow(rows[rows.indexOf(rowEntry.bottomRow)]);
							//Use preferred size if both top and bottom are specified
							h = rowEntry.child.getExplicitOrMeasuredHeight();
							//Now we add in offsets
							if (rowEntry.baselineOffset)
								h += rowEntry.baselineOffset;
							else if (rowEntry.vcOffset)
								h += rowEntry.vcOffset;
							else
							{
								if (rowEntry.topOffset)
									h += rowEntry.topOffset;
								if (rowEntry.bottomOffset)
									h += rowEntry.bottomOffset;
							}
							//height may have been set by a previous pass - so we want to take the max
							if (!isNaN(cr.height))
								h = Math.max(cr.height, h);
							h = bound(h, cr.minHeight, cr.maxHeight);
							cr.setActualHeight(h);
							availableHeight -= cr.height;
						}
						//otherwise we share space amongst the spanned rows
						else
						{
							availableHeight = shareRowSpace(rowEntry, availableHeight);
						}
					}
					//reset
					rowSpanChildren = [];
				}
				//now for those content size rows that don't have heights
				//give them their minHeight or 0.
				for (i = 0; i < contentSize.length; i++)
				{
					cr = ConstraintRow(contentSize[i]);
					if (!cr.height)
					{
						h = bound(0, cr.minHeight, 0);
						cr.setActualHeight(h);
					}
				}
			}
			//percentage size rows
			remainingSpace = availableHeight;
			for (i = 0; i < percentageSize.length; i++)
			{
				cr = ConstraintRow(percentageSize[i]);
				if (remainingSpace <= 0)
					h = 0;
				else
					h = Math.round((remainingSpace * cr.percentHeight)/100);
				h = bound(h, cr.minHeight, cr.maxHeight);
				cr.setActualHeight(h);
				availableHeight -= h;
			}
			//In the order they were declared, set up the y positions
			for (i = 0; i < rows.length; i++)
			{
				cr = rows[i];
				cr.y = canvasY;
				canvasY += cr.height;
			}
		}*/
	}



	/**
	 *  @private
	 *  Figure out the content area based on whether there are
	 *  ConstraintColumn instances or ConstraintRow instances
	 *  specified and the constraint style values.
	 */
	/*private function applyAnchorStylesDuringMeasure(child:IUIComponent,
													r:Rectangle):void
	{
		var constraintChild:IConstraintClient = child as IConstraintClient;
		if (!constraintChild)
			return;
		//Calculate constraint boundaries if it has not been calculated
		//already
		var childInfo:ChildConstraintInfo = constraintCache[constraintChild];
		if (!childInfo)
			childInfo = parseConstraints(child);
		var left:Number = childInfo.left;
		var right:Number = childInfo.right;
		var horizontalCenter:Number = childInfo.hc;
		var top:Number = childInfo.top;
		var bottom:Number = childInfo.bottom;
		var verticalCenter:Number = childInfo.vc;

		var cols:Array = IConstraintLayout(target).constraintColumns;
		var rows:Array = IConstraintLayout(target).constraintRows;

		var i:int;
		var holder:Number = 0;

		if (!cols.length > 0)
		{
			if (!isNaN(horizontalCenter))
			{
				r.x = Math.round((target.width - child.width) / 2 + horizontalCenter);
			}
			else if (!isNaN(left) && !isNaN(right))
			{
				r.x = left;
				r.width += right;
			}
			else if (!isNaN(left))
			{
				r.x = left;
			}
			else if (!isNaN(right))
			{
				r.x = 0;
				r.width += right;
			}
		}
		else //sum up the column widths
		{
			r.x = 0;
			for (i = 0; i < cols.length; i++)
			{
				holder += ConstraintColumn(cols[i]).width;
			}
			r.width = holder;
		}

		if (!rows.length > 0)
		{
			if (!isNaN(verticalCenter))
			{
				r.y = Math.round((target.height - child.height) / 2 + verticalCenter);
			}
			else if (!isNaN(top) && !isNaN(bottom))
			{
				r.y = top;
				r.height += bottom;
			}
			else if (!isNaN(top))
			{
				r.y = top;
			}
			else if (!isNaN(bottom))
			{
				r.y = 0;
				r.height += bottom;
			}
		}
		else //sum up the row heights
		{
			holder = 0;
			r.y = 0;
			for (i = 0; i < rows.length; i++)
			{
				holder += ConstraintRow(rows[i]).height;
			}
			r.height = holder;
		}
	}*/


	/**
	 *  @private
	 *  This function measures the bounds of the content area.
	 *  It looks at each child included in the layout, and determines
	 *  right and bottom edge.
	 *
	 *  When we are laying out the children, we use the larger of the
	 *  content area and viewable area to determine percentages and
	 *  the edges for constraints.
	 *
	 *  If the child has a percentageWidth or both left and right values
	 *  set, the minWidth is used for determining its area. Otherwise
	 *  the explicit or measured width is used. The same rules apply in
	 *  the vertical direction.
	 */
	private function measureContentArea():Rectangle
	{
		if (_contentArea)
			return _contentArea;
		var i:int;
		_contentArea = new Rectangle();
		var n:int = layoutView.numElements;

		//Special case where there are no children but there
		//are columns or rows
		/*if (n == 0 && constraintRegionsInUse)
		{
			var cols:Array = IConstraintLayout(target).constraintColumns;
			var rows:Array = IConstraintLayout(target).constraintRows;
			//The right of the contentArea rectangle is the x position of the last
			//column plus its width. If there are no columns, its 0.
			if (cols.length > 0)
				_contentArea.right = cols[cols.length-1].x + cols[cols.length-1].width;
			else
				_contentArea.right = 0;
			//The bottom of the contentArea rectangle is the y position of the last row
			//plus its height. If there are no rows, its 0;
			if (rows.length > 0)
				_contentArea.bottom = rows[rows.length-1].y + rows[rows.length-1].height;
			else _contentArea.bottom = 0;
		}*/

		for (i = 0; i < n; i++)
		{
			var child:IUIComponent = layoutView.getElementAt(i) as IUIComponent;


			if (!child.includeInLayout)
				continue;
			var layoutChild:ILayoutElement = child as ILayoutElement;
			if (layoutChild) {
				var childLeft:Number = Number(layoutChild.left);
				var childRight:Number = Number(layoutChild.right);
				var childTop:Number = Number(layoutChild.top);
				var childBottom:Number = Number(layoutChild.bottom);
				var hCenter:Number = Number(layoutChild.horizontalCenter);
				var vCenter:Number = Number(layoutChild.verticalCenter);
			} else {
				childLeft = childRight = childBottom = childTop = hCenter = vCenter = NaN;
			}


			//var childConstraints:LayoutConstraints = getLayoutConstraints(child);

			var cx:Number = child.x;
			var cy:Number = child.y;
			var pw:Number = child.getExplicitOrMeasuredWidth();
			var ph:Number = child.getExplicitOrMeasuredHeight();
			var explicitDimension:Boolean = !isNaN(child.explicitWidth);

			if (!isNaN(child.percentWidth) ||
					(layoutChild &&
							!isNaN(childLeft) &&
							!isNaN(childRight) &&
							!explicitDimension/*isNaN(child.explicitWidth)*/))
			{
				pw = child.minWidth;
			}

			//royale change (GD) here:
			if (!isNaN(childLeft)) {
				cx = childLeft;
			} else if (!isNaN(childRight)) {
				cx = childRight;
			}
			//royale change (GD) here (not 'right' but it seems to work for now):
			if (explicitDimension) {
				if (cx == childLeft && !isNaN(childRight)) {
					cx += childRight;
				}
			}

			explicitDimension = !isNaN(child.explicitHeight);
			if (!isNaN(child.percentHeight) ||
					(layoutChild &&
							!isNaN(childTop) &&
							!isNaN(childBottom) &&
							!explicitDimension/*isNaN(child.explicitHeight)*/))
			{
				ph = child.minHeight;
			}
			//royale change (GD) here:
			if (!isNaN(childTop)) {
				cy = childTop;
			} else if (!isNaN(childBottom)) {
				cy = childBottom;
			}
			//royale change (GD) here (not 'right' but it seems to work for now):
			if (explicitDimension) {
				if (cy == childTop && !isNaN(childBottom)) {
					cy += childBottom;
				}
			}


			r.x = cx
			r.y = cy
			r.width = pw;
			r.height = ph;
		//was: 	applyAnchorStylesDuringMeasure(child, r);

			/*var constraintChild:IConstraintClient = child as IConstraintClient;
			if (constraintChild) {
				//WIP contents of applyAnchorStylesDuringMeasure to go here
			}*/


			cx = r.x;
			cy = r.y;
			pw = r.width;
			ph = r.height;

			if (isNaN(cx))
				cx = child.x;
			if (isNaN(cy))
				cy = child.y;

			var rightEdge:Number = cx;
			var bottomEdge:Number = cy;

			if (isNaN(pw))
				pw = child.width;

			if (isNaN(ph))
				ph = child.height;

			rightEdge += pw;
			bottomEdge += ph;

			_contentArea.right = Math.max(_contentArea.right, rightEdge);
			_contentArea.bottom = Math.max(_contentArea.bottom, bottomEdge);
		}
		return _contentArea;
	}

	/*private function getLayoutConstraints(child:IUIComponent):LayoutConstraints
	{
		var constraintChild:IConstraintClient = child as IConstraintClient;

		if (!constraintChild)
			return null;

		var constraints:LayoutConstraints = new LayoutConstraints();

		constraints.baseline = constraintChild.getConstraintValue("baseline");
		constraints.bottom = constraintChild.getConstraintValue("bottom");
		constraints.horizontalCenter = constraintChild.getConstraintValue("horizontalCenter");
		constraints.left = constraintChild.getConstraintValue("left");
		constraints.right = constraintChild.getConstraintValue("right");
		constraints.top = constraintChild.getConstraintValue("top");
		constraints.verticalCenter = constraintChild.getConstraintValue("verticalCenter");

		return constraints;
	}*/
}
}

import mx.containers.utilityClasses.ConstraintColumn;
import mx.core.IUIComponent;
import mx.containers.utilityClasses.ConstraintRow;
////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ChildConstraintInfo
//
////////////////////////////////////////////////////////////////////////////////

/*
class ChildConstraintInfo
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/!**
	 *  @private
	 *!/
	public function ChildConstraintInfo(
			left:Number, right:Number, hc:Number,
			top:Number, bottom:Number, vc:Number,
			baseline:Number, leftBoundary:String = null,
			rightBoundary:String = null, hcBoundary:String = null,
			topBoundary:String = null, bottomBoundary:String = null,
			vcBoundary:String = null, baselineBoundary:String = null):void
	{
		super();

		// offsets
		this.left = left;
		this.right = right;
		this.hc = hc;
		this.top = top;
		this.bottom = bottom;
		this.vc = vc;
		this.baseline = baseline;

		// boundaries (ie: parent, column or row edge)
		this.leftBoundary = leftBoundary;
		this.rightBoundary = rightBoundary;
		this.hcBoundary = hcBoundary;
		this.topBoundary = topBoundary;
		this.bottomBoundary = bottomBoundary;
		this.vcBoundary = vcBoundary;
		this.baselineBoundary = baselineBoundary;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	public var left:Number;
	public var right:Number;
	public var hc:Number;
	public var top:Number;
	public var bottom:Number;
	public var vc:Number;
	public var baseline:Number;
	public var leftBoundary:String;
	public var rightBoundary:String;
	public var hcBoundary:String;
	public var topBoundary:String;
	public var bottomBoundary:String;
	public var vcBoundary:String;
	public var baselineBoundary:String;

}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ContentColumnChild
//
////////////////////////////////////////////////////////////////////////////////

class ContentColumnChild
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/!**
	 *  @private
	 *!/
	public function ContentColumnChild():void
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	public var leftCol:ConstraintColumn;
	public var leftOffset:Number;
	public var left:Number;
	public var rightCol:ConstraintColumn;
	public var rightOffset:Number;
	public var right:Number;
	public var hcCol:ConstraintColumn;
	public var hcOffset:Number;
	public var hc:Number;
	public var child:IUIComponent;
	public var span:Number;
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ContentRowChild
//
////////////////////////////////////////////////////////////////////////////////

class ContentRowChild
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/!**
	 *  @private
	 *!/
	public function ContentRowChild():void
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	public var topRow:ConstraintRow;
	public var topOffset:Number;
	public var top:Number;
	public var bottomRow:ConstraintRow;
	public var bottomOffset:Number;
	public var bottom:Number;
	public var vcRow:ConstraintRow;
	public var vcOffset:Number;
	public var vc:Number;
	public var baselineRow:ConstraintRow;
	public var baselineOffset:Number;
	public var baseline:Number;
	public var child:IUIComponent;
	public var span:Number;

}*/
