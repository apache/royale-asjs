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

package mx.containers.beads.layouts
{
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
	
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.geom.Rectangle;

/*
import mx.core.mx_internal;
import mx.events.ChildExistenceChangedEvent;
import mx.events.MoveEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import flash.utils.Dictionary;

use namespace mx_internal;
*/

/**
 *  @private
 *  The CanvasLayout class is for internal use only.
 */
public class BasicLayout extends LayoutBase
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
    public function BasicLayout()
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

    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	override public function layout():Boolean
	{
		COMPILE::SWF
		{			
			var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
			var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
			
			var w:Number = hostWidthSizedToContent ? 0 : target.width;
			var h:Number = hostHeightSizedToContent ? 0 : target.height;
			
			var n:int = target.numChildren;
				
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
			
			// host must have either have position:absolute or position:relative
			if (target.element.style.position != "absolute" && target.element.style.position != "relative") {
				target.element.style.position = "relative";
			}
			
			// each child must have position:absolute for BasicLayout to work
			for (i=0; i < n; i++) {
				var child:IUIComponent = target.getLayoutChildAt(i);
				child.positioner.style.position = "absolute";
                child.dispatchEvent(new Event("layoutNeeded"));
			}
			
			return true;
		}
	}
}
}

