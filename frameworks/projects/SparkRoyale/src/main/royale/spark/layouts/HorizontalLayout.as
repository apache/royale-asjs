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

package spark.layouts
{
import mx.containers.utilityClasses.Flex;
import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

import spark.components.DataGroup;
import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;
import spark.layouts.supportClasses.DropLocation;
import spark.layouts.supportClasses.LayoutBase;
import spark.layouts.supportClasses.LayoutElementHelper;
import spark.layouts.supportClasses.LinearLayoutVector;

import org.apache.royale.events.Event;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import spark.core.IGapLayout;

use namespace mx_internal;

/**
 *  The HorizontalLayout class arranges the layout elements in a horizontal sequence,
 *  left to right, with optional gaps between the elements and optional padding
 *  around the elements.
 *
 *  <p>The horizontal position of the elements is determined by arranging them
 *  in a horizontal sequence, left to right, taking into account the padding
 *  before the first element and the gaps between the elements.</p>
 *
 *  <p>The vertical position of the elements is determined by the layout's 
 *  <code>verticalAlign</code> property.</p>
 *
 *  <p>During the execution of the <code>measure()</code> method, 
 *  the default size of the container is calculated by
 *  accumulating the preferred sizes of the elements, including gaps and padding.
 *  When the <code>requestedColumnCount</code> property is set to a value other than -1, 
 *  only the space for that many elements
 *  is measured, starting from the first element.</p>
 *
 *  <p>During the execution of the <code>updateDisplayList()</code> method, 
 *  the width of each element is calculated
 *  according to the following rules, listed in their respective order of
 *  precedence (element's minimum width and maximum width are always respected):</p>
 *  <ul>
 *    <li>If <code>variableColumnWidth</code> is <code>false</code>, 
 *    then set the element's width to the
 *    value of the <code>columnWidth</code> property.</li>
 *
 *    <li>If the element's <code>percentWidth</code> is set, then calculate the element's
 *    width by distributing the available container width between all
 *    elements with <code>percentWidth</code> setting. 
 *    The available container width
 *    is equal to the container width minus the gaps, the padding and the
 *    space occupied by the rest of the elements. The element's <code>precentWidth</code>
 *    property is ignored when the layout is virtualized.</li>
 *
 *    <li>Set the element's width to its preferred width.</li>
 *  </ul>
 *
 *  <p>The height of each element is calculated according to the following rules,
 *  listed in their respective order of precedence (element's minimum height and
 *  maximum height are always respected):</p>
 *  <ul>
 *    <li>If the <code>verticalAlign</code> property is <code>"justify"</code>,
 *   then set the element's height to the container height.</li>
 *
 *    <li>If the <code>verticalAlign</code> property is <code>"contentJustify"</code>, 
 *    then set the element's height to the maximum between the container's height 
 *    and all elements' preferred height.</li>
 *
 *    <li>If the element's <code>percentHeight</code> property is set, 
 *    then calculate the element's height as a percentage of the container's height.</li>
 *
 *    <li>Set the element's height to its preferred height.</li>
 *  </ul>
 *
 *  @mxml 
 *  <p>The <code>&lt;s:HorizontalLayout&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:HorizontalLayout 
 *    <strong>Properties</strong>
 *    columnWidth="<i>calculated</i>"
 *    gap="6"
 *    padding="0"
 *    paddingBottom="0"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    paddingTop="0"
 *    requestedColumnCount="-1"
 *    requestedMaxColumnCount="-1"
 *    requestedMinColumnCount="-1"
 *    variableColumnWidth="true"
 *    verticalAlign="top"
 *  /&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class HorizontalLayout extends LayoutBase implements IGapLayout
{
//    include "../core/Version.as";

    /**
     *  @private
     *  Cached column widths, max row height for virtual layout.   Not used unless
     *  useVirtualLayout=true.   See updateLLV(), resetCachedVirtualLayoutState(),
     *  etc.
     */
    private var llv:LinearLayoutVector;
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    private static function calculatePercentHeight(layoutElement:ILayoutElement, height:Number):Number
    {
        var percentHeight:Number;
        /*
        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_6)
        {
            percentHeight = LayoutElementHelper.pinBetween(Math.round(layoutElement.percentHeight * 0.01 * height),
                                                           layoutElement.getMinBoundsHeight(),
                                                           layoutElement.getMaxBoundsHeight() );
            return percentHeight < height ? percentHeight : height;
        }
        else
        {*/
            percentHeight = LayoutElementHelper.pinBetween(Math.min(Math.round(layoutElement.percentHeight * 0.01 * height), height),
                                                           layoutElement.getMinBoundsHeight(),
                                                           layoutElement.getMaxBoundsHeight() );
            return percentHeight;
        /*}*/
    }

    private static function sizeLayoutElement(layoutElement:ILayoutElement, height:Number, 
                                              verticalAlign:String, restrictedHeight:Number, 
                                              width:Number, variableColumnWidth:Boolean, 
                                              columnWidth:Number):void
    {
        var newHeight:Number = NaN;
        
        // if verticalAlign is "justify" or "contentJustify", 
        // restrict the height to restrictedHeight.  Otherwise, 
        // size it normally
        if (verticalAlign == VerticalAlign.JUSTIFY ||
            verticalAlign == VerticalAlign.CONTENT_JUSTIFY)
        {
            newHeight = restrictedHeight;
        }
        else
        {
            if (!isNaN(layoutElement.percentHeight))
               newHeight = calculatePercentHeight(layoutElement, height);   
        }
        
        if (variableColumnWidth)
            layoutElement.setLayoutBoundsSize(width, newHeight);
        else
            layoutElement.setLayoutBoundsSize(columnWidth, newHeight);
    }
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */    
    public function HorizontalLayout():void
    {
        super();

        // Don't drag-scroll in the vertical direction
        dragScrollRegionSizeVertical = 0;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  alignmentBaseline
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the alignmentBaseline property.
     */
    private var _alignmentBaseline:Object = "maxAscent:0";

    /**
     *  @private
     *
     *  The base line of the layout, in pixels. 
     *
     *  The base line is the virtual horizontal line to which layout elements' text is aligned,
     *  it is relative to the top edge of the container plus any <code>paddingTop</code>.
     *
     *  The base line can be specified as either an explicit number, or as a numberical offset from
     *  the computed maximum of the elements' text ascent by using the "maxAscent:offset" syntax.
     *
     *  Note that <code>alignmentBaseline</code> has an effect only when <code>verticalAlign</code>
     *  is set to "baseline".
     *
     *  @default "maxAscent:0"
     *  @see #verticalAlign 
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    mx_internal function get alignmentBaseline():Object
    {
        return _alignmentBaseline;
    }

    /**
     *  @private
     */
    mx_internal function set alignmentBaseline(value:Object):void
    {
        if (_alignmentBaseline == value) 
            return;
        
        _alignmentBaseline = value;
        invalidateTargetSizeAndDisplayList();
    }

    //----------------------------------
    //  gap
    //----------------------------------

    private var _gap:int = 6;

    [Inspectable(category="General")]

    /**
     *  The horizontal space between layout elements, in pixels.
     * 
     *  Note that the gap is only applied between layout elements, so if there's
     *  just one element, the gap has no effect on the layout.
     * 
     *  @default 6
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */    
    public function get gap():int
    {
        return _gap;
    }

    /**
     *  @private
     */
    public function set gap(value:int):void
    {
        if (_gap == value) 
            return;
    
        _gap = value;
        invalidateTargetSizeAndDisplayList();
    }
    
    //----------------------------------
    //  columnCount
    //----------------------------------

    private var _columnCount:int = -1;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]

    /**
     *  Returns the current number of elements in view.
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get columnCount():int
    {
        return _columnCount;
    }

    /**
     *  @private
     * 
     *  Sets the <code>columnCount</code> property and dispatches
     *  a PropertyChangeEvent.
     */
    private function setColumnCount(value:int):void
    {
        if (_columnCount == value)
            return;
        var oldValue:int = _columnCount;
        _columnCount = value;
        dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnCount", oldValue, value));
    }
	
	//----------------------------------
	//  padding
	//----------------------------------
	
	private var _padding:Number = 0;
	
	[Inspectable(category="General")]
	
	/**
	 *  The minimum number of pixels between the container's edges and
	 *  the edges of the layout element.
	 * 
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get padding():Number
	{
		return _padding;
	}
	
	/**
	 *  @private
	 */
	public function set padding(value:Number):void
	{
		if (_padding == value)
			return;
		
		_padding = value;
		
		paddingBottom = _padding;
		paddingLeft = _padding;
		paddingRight = _padding;
		paddingTop = _padding;
		
		invalidateTargetSizeAndDisplayList();
	}    
        
    //----------------------------------
    //  paddingLeft
    //----------------------------------

    private var _paddingLeft:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  Number of pixels between the container's left edge
     *  and the left edge of the first layout element.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingLeft():Number
    {
        return _paddingLeft;
    }

    /**
     *  @private
     */
    public function set paddingLeft(value:Number):void
    {
        if (_paddingLeft == value)
            return;
                               
        _paddingLeft = value;
        invalidateTargetSizeAndDisplayList();
    }    
    
    //----------------------------------
    //  paddingRight
    //----------------------------------

    private var _paddingRight:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  Number of pixels between the container's right edge
     *  and the right edge of the last layout element.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingRight():Number
    {
        return _paddingRight;
    }

    /**
     *  @private
     */
    public function set paddingRight(value:Number):void
    {
        if (_paddingRight == value)
            return;
                               
        _paddingRight = value;
        invalidateTargetSizeAndDisplayList();
    }    
    
    //----------------------------------
    //  paddingTop
    //----------------------------------

    private var _paddingTop:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  The minimum number of pixels between the container's top edge and
     *  the top of all the container's layout elements. 
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingTop():Number
    {
        return _paddingTop;
    }

    /**
     *  @private
     */
    public function set paddingTop(value:Number):void
    {
        if (_paddingTop == value)
            return;
                               
        _paddingTop = value;
        invalidateTargetSizeAndDisplayList();
    }    
    
    //----------------------------------
    //  paddingBottom
    //----------------------------------

    private var _paddingBottom:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  The minimum number of pixels between the container's bottom edge and
     *  the bottom of all the container's layout elements. 
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingBottom():Number
    {
        return _paddingBottom;
    }

    /**
     *  @private
     */
    public function set paddingBottom(value:Number):void
    {
        if (_paddingBottom == value)
            return;
                               
        _paddingBottom = value;
        invalidateTargetSizeAndDisplayList();
    }    

    //----------------------------------
    //  requestedMaxColumnCount
    //----------------------------------
    
    private var _requestedMaxColumnCount:int = -1;
    
    [Inspectable(category="General", minValue="-1")]
    
    /**
     *  The measured width of this layout is large enough to display 
     *  at most <code>requestedMaxColumnCount</code> layout elements. 
     * 
     *  <p>If <code>requestedColumnCount</code> is set, then
     *  this property has no effect.</p>
     *
     *  <p>If the actual size of the container using this layout has been explicitly set,
     *  then this property has no effect.</p>
     * 
     *  @default -1
     *  @see #requestedColumnCount
     *  @see #requestedMinColumnCount
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requestedMaxColumnCount():int
    {
        return _requestedMaxColumnCount;
    }
    
    /**
     *  @private
     */
    public function set requestedMaxColumnCount(value:int):void
    {
        if (_requestedMaxColumnCount == value)
            return;
        
        _requestedMaxColumnCount = value;
        
        if (target)
            target.invalidateSize();
    }   
    
    //----------------------------------
    //  requestedMinColumnCount
    //----------------------------------
    
    private var _requestedMinColumnCount:int = -1;
    
    [Inspectable(category="General", minValue="-1")]
    
    /**
     *  The measured width of this layout is large enough to display 
     *  at least <code>requestedMinColumnCount</code> layout elements. 
     * 
     *  <p>If <code>requestedColumnCount</code> is set, then
     *  this property has no effect.</p>
     *
     *  <p>If the actual size of the container using this layout has been explicitly set,
     *  then this property has no effect.</p>
     * 
     *  @default -1
     *  @see #requestedColumnCount
     *  @see #requestedMaxColumnCount
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requestedMinColumnCount():int
    {
        return _requestedMinColumnCount;
    }

    /**
     *  @private
     */
    public function set requestedMinColumnCount(value:int):void
    {
        if (_requestedMinColumnCount == value)
            return;

        _requestedMinColumnCount = value;

        if (target)
            target.invalidateSize();
    }   

    //----------------------------------
    //  requestedColumnCount
    //----------------------------------

    private var _requestedColumnCount:int = -1;
    
    [Inspectable(category="General", minValue="-1")]

    /**
     *  The measured size of this layout is wide enough to display 
     *  the first <code>requestedColumnCount</code> layout elements. 
     *  If <code>requestedColumnCount</code> is -1, then the measured
     *  size will be big enough for all of the layout elements.
     * 
     *  <p>If the actual size of the container using this layout has been explicitly set,
     *  then this property has no effect.</p>
     * 
     *  @default -1
     *  @see #requestedMinColumnCount
     *  @see #requestedMaxColumnCount
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get requestedColumnCount():int
    {
        return _requestedColumnCount;
    }

    /**
     *  @private
     */
    public function set requestedColumnCount(value:int):void
    {
        if (_requestedColumnCount == value)
            return;
                               
        _requestedColumnCount = value;
        
        if (target)
            target.invalidateSize();
    }    
    
    //----------------------------------
    //  columnWidth
    //----------------------------------
    
    private var _columnWidth:Number;

    [Inspectable(category="General", minValue="0.0")]

    /**
     *  If the <code>variableColumnWidth</code> property is <code>false</code>, 
     *  then this property specifies the actual width of each layout element, in pixels.
     * 
     *  <p>If the <code>variableColumnWidth</code> property is <code>true</code>, 
     *  the default, then this property has no effect.</p>
     * 
     *  <p>The default value of this property is the preferred width
     *  of the item specified by the <code>typicalLayoutElement</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get columnWidth():Number
    {
        if (!isNaN(_columnWidth))
            return _columnWidth;
        else 
        {
            var elt:ILayoutElement = typicalLayoutElement
            return (elt) ? elt.getPreferredBoundsWidth() : 0;
        }
    }

    /**
     *  @private
     */
    public function set columnWidth(value:Number):void
    {
        if (_columnWidth == value)
            return;
            
        _columnWidth = value;
        invalidateTargetSizeAndDisplayList();
    }

    //----------------------------------
    //  variableColumnWidth
    //----------------------------------

    /**
     *  @private
     */
    private var _variableColumnWidth:Boolean = true;

    [Inspectable(category="General", enumeration="true,false")]

    /**
     *  If <code>true</code>, specifies that layout elements are to be allocated their
     *  preferred width.
     *
     *  <p>Setting this property to <code>false</code> specifies fixed width columns.
     *  The actual width of each layout element is 
     *  the value of the <code>columnWidth</code> property, and the layout ignores  
     *  a layout elements' <code>percentWidth</code> property.</p>
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get variableColumnWidth():Boolean
    {
        return _variableColumnWidth;
    }

    /**
     *  @private
     */
    public function set variableColumnWidth(value:Boolean):void
    {
        if (value == _variableColumnWidth) return;
        
        _variableColumnWidth = value;
        invalidateTargetSizeAndDisplayList();
    }
    
    //----------------------------------
    //  firstIndexInView
    //----------------------------------

    /**
     *  @private
     */
    private var _firstIndexInView:int = -1;

    [Inspectable(category="General")]
    [Bindable("indexInViewChanged")]    

    /**
     *  The index of the first column that is part of the layout and within
     *  the layout target's scroll rectangle, or -1 if nothing has been displayed yet.
     * 
     *  Note that the column may only be partially in view.
     * 
     *  @see lastIndexInView
     *  @see fractionOfElementInView
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get firstIndexInView():int
    {
        return _firstIndexInView;
    }
    
    
    //----------------------------------
    //  lastIndexInView
    //----------------------------------

    /**
     *  @private
     */
    private var _lastIndexInView:int = -1;
    
    [Inspectable(category="General")]
    [Bindable("indexInViewChanged")]    

    /**
     *  The index of the last column that is part of the layout and within
     *  the layout target's scroll rectangle, or -1 if nothing has been displayed yet.
     * 
     *  Note that the column may only be partially in view.
     * 
     *  @see firstIndexInView
     *  @see fractionOfElementInView
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get lastIndexInView():int
    {
        return _lastIndexInView;
    }
    
    //----------------------------------
    //  horizontalAlign
    //----------------------------------
    
    /**
     *  @private
     */
    private var _horizontalAlign:String = HorizontalAlign.LEFT;
    
    [Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
    
    /** 
     *  The horizontal alignment of the content relative to the container's width.
     *  If the value is <code>"left"</code>, <code>"right"</code>, or <code>"center"</code> then the 
     *  layout element is aligned relative to the container's <code>contentWidth</code> property.
     *
     *  <p>This property has no effect when <code>clipAndEnableScrolling</code> is true
     *  and the <code>contentWidth</code> is greater than the container's width.</p>
     *
     *  <p>This property does not affect the layout's measured size.</p>
     *  
     *  @default "left"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get horizontalAlign():String
    {
        return _horizontalAlign;
    }
    
    /**
     *  @private
     */
    public function set horizontalAlign(value:String):void
    {
        if (value == _horizontalAlign) 
            return;
        
        _horizontalAlign = value;
        
        /*
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
            layoutTarget.invalidateDisplayList();
        */
    }
    
    //----------------------------------
    //  verticalAlign
    //----------------------------------

    /**
     *  @private
     */
    private var _verticalAlign:String = VerticalAlign.TOP;

    [Inspectable(category="General", enumeration="top,bottom,middle,justify,contentJustify,baseline", defaultValue="top")]

    /** 
     *  The vertical alignment of layout elements.
     * 
     *  <p>If the value is <code>"bottom"</code>, <code>"middle"</code>, 
     *  or <code>"top"</code> then the layout elements are aligned relative 
     *  to the container's <code>contentHeight</code> property.</p>
     * 
     *  <p>If the value is <code>"contentJustify"</code> then the actual
     *  height of the layout element is set to 
     *  the container's <code>contentHeight</code> property. 
     *  The content height of the container is the height of the largest layout element. 
     *  If all layout elements are smaller than the height of the container, 
     *  then set the height of all the layout elements to the height of the container.</p>
     * 
     *  <p>If the value is <code>"justify"</code> then the actual height
     *  of the layout elements is set to the container's height.</p>
     *
     *  <p>If the value is <code>"baseline"</code> then the elements are positioned
     *  such that their text is aligned to the maximum of the elements' text ascent.</p>
     * 
     *  @default "top"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get verticalAlign():String
    {
        return _verticalAlign;
    }

    /**
     *  @private
     */
    public function set verticalAlign(value:String):void
    {
        if (value == _verticalAlign) 
            return;

        var oldValue:String = _verticalAlign;
        _verticalAlign = value;

        // "baseline" affects the measured size
        if (oldValue == VerticalAlign.BASELINE ||
            value    == VerticalAlign.BASELINE)
        {
            invalidateTargetSizeAndDisplayList();
        }
        else
        {
            /*
            var layoutTarget:GroupBase = target;
            if (layoutTarget)
                layoutTarget.invalidateDisplayList();
            */
        }
    }

    /**
     *  @private
     * 
     *  Sets the <code>firstIndexInView</code> and <code>lastIndexInView</code>
     *  properties and dispatches a <code>"indexInViewChanged"</code>
     *  event.  
     * 
     *  @param firstIndex The new value for firstIndexInView.
     *  @param lastIndex The new value for lastIndexInView.
     * 
     *  @see firstIndexInView
     *  @see lastIndexInview
     */
    private function setIndexInView(firstIndex:int, lastIndex:int):void
    {
        if ((_firstIndexInView == firstIndex) && (_lastIndexInView == lastIndex))
            return;
            
        _firstIndexInView = firstIndex;
        _lastIndexInView = lastIndex;
        dispatchEvent(new Event("indexInViewChanged"));
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function set clipAndEnableScrolling(value:Boolean):void
    {
        super.clipAndEnableScrolling = value;
        /*
        var hAlign:String = horizontalAlign;
        if (hAlign == HorizontalAlign.CENTER || hAlign == HorizontalAlign.RIGHT)
        {
            var g:GroupBase = target;
            if (g)
                g.invalidateDisplayList();
        }*/
    }

    /**
     * @private
     */
    override public function clearVirtualLayoutCache():void
    {
        llv = null;

        /*
        var g:GroupBase = GroupBase(target);
        if (!g)
            return;
        
        target.invalidateSize();
        target.invalidateDisplayList();
        */
    }     

    /**
     *  @private
     */
    override public function getElementBounds(index:int):Rectangle
    {
        if (!useVirtualLayout)
            return super.getElementBounds(index);

        var g:GroupBase = GroupBase(target);
        if (!g || (index < 0) || (index >= g.numElements) || !llv) 
            return null;

        // We need a valid LLV for this function
        updateLLV(g);
		
        return llv.getBounds(index);
    }    
    
    /**
     *  Returns 1.0 if the specified index is completely in view, 0.0 if
     *  it's not, or a value between 0.0 and 1.0 that represents the percentage 
     *  of the if the index that is partially in view.
     * 
     *  <p>An index is "in view" if the corresponding non-null layout element is 
     *  within the horizontal limits of the container's <code>scrollRect</code>
     *  and included in the layout.</p>
     *  
     *  <p>If the specified index is partially within the view, the 
     *  returned value is the percentage of the corresponding
     *  layout element that's visible.</p>
     *
     *  @param index The index of the column.
     * 
     *  @return The percentage of the specified element that's in view.
     *  Returns 0.0 if the specified index is invalid or if it corresponds to
     *  null element, or a ILayoutElement for which 
     *  the <code>includeInLayout</code> property is <code>false</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function fractionOfElementInView(index:int):Number
    {
        var g:GroupBase = target;
        if (!g)
            return 0.0;
                
        if ((index < 0) || (index >= g.numElements))
            return 0.0;
               
        if (!clipAndEnableScrolling)
            return 1.0;
               
        var r0:int = firstIndexInView;  
        var r1:int = lastIndexInView;
        
        // index is outside the "in view" or visible range
        if ((r0 == -1) || (r1 == -1) || (index < r0) || (index > r1))
            return 0.0;

        // within the visible index range, but not first or last            
        if ((index > r0) && (index < r1))
            return 1.0;

        // get the layout element's X and Width
        var eltX:Number;
        var eltWidth:Number;
        if (useVirtualLayout)
        {
            if (!llv)
                return 0.0;
            eltX = llv.start(index);
            eltWidth = llv.getMajorSize(index);
        }
        else 
        {
            var elt:ILayoutElement = g.getElementAt(index) as ILayoutElement;
            if (!elt || !elt.includeInLayout)
                return 0.0;
            eltX = elt.getLayoutBoundsX();
            eltWidth = elt.getLayoutBoundsWidth();
        }
            
        // index is either the first or last column in the scrollRect
        // and potentially partially visible.
        //   x0,x1 - scrollRect left,right edges
        //   ix0, ix1 - layout element left,right edges
        var x0:Number = g.horizontalScrollPosition; 
        var x1:Number = x0 + g.width;
        var ix0:Number = eltX;
        var ix1:Number = ix0 + eltWidth;
        if (ix0 >= ix1)  // element has 0 or negative height
            return 1.0;
        if ((ix0 >= x0) && (ix1 <= x1))
            return 1.0;
        return (Math.min(x1, ix1) - Math.max(x0, ix0)) / (ix1 - ix0);
    }

    /**
     *  @private
     * 
     *  Binary search for the first layout element that contains y.  
     * 
     *  This function considers both the element's actual bounds and 
     *  the gap that follows it to be part of the element.  The search 
     *  covers index i0 through i1 (inclusive).
     * 
     *  This function is intended for variable height elements.
     * 
     *  Returns the index of the element that contains x, or -1.
     */
    private static function findIndexAt(x:Number, gap:int, g:GroupBase, i0:int, i1:int):int
    {
        var index:int = (i0 + i1) / 2;
        var element:ILayoutElement = g.getElementAt(index) as ILayoutElement;        
        var elementX:Number = element.getLayoutBoundsX();
        // TBD: deal with null element, includeInLayout false.
        if ((x >= elementX) && (x < elementX + element.getLayoutBoundsWidth() + gap))
            return index;
        else if (i0 == i1)
            return -1;
        else if (x < elementX)
            return findIndexAt(x, gap, g, i0, Math.max(i0, index-1));
        else 
            return findIndexAt(x, gap, g, Math.min(index+1, i1), i1);
    }  
    
    /**
     *  @private
     * 
     *  Returns the index of the first non-null includeInLayout element, 
     *  beginning with the element at index i.  
     * 
     *  Returns -1 if no such element can be found.
     */
    private static function findLayoutElementIndex(g:GroupBase, i:int, dir:int):int
    {
        var n:int = g.numElements;
        while((i >= 0) && (i < n))
        {
           var element:ILayoutElement = g.getElementAt(i) as ILayoutElement;
           if (element && element.includeInLayout)
           {
               return i;      
           }
           i += dir;
        }
        return -1;
    } 
    
    /**
     *  @private
     * 
     *  Updates the first,lastIndexInView properties per the new
     *  scroll position.
     *  
     *  @see setIndexInView
     */
    override protected function scrollPositionChanged():void
    {
        super.scrollPositionChanged();
        
        var g:GroupBase = target;
        if (!g)
            return;     

        var n:int = g.numElements - 1;
        if (n < 0) 
        {
            setIndexInView(-1, -1);
            return;
        }
        
        var scrollR:Rectangle = getScrollRect();
        if (!scrollR)
        {
            setIndexInView(0, n);
            return;    
        }
        
        // We're going to use findIndexAt to find the index of 
        // the elements that overlap the left and right edges of the scrollRect.
        // Values that are exactly equal to scrollRect.right aren't actually
        // rendered, since the left,right interval is only half open.
        // To account for that we back away from the right edge by a
        // hopefully infinitesimal amount.
     
        var x0:Number = scrollR.left;
        var x1:Number = scrollR.right - .0001;
        if (x1 <= x0)
        {
            setIndexInView(-1, -1);
            return;
        }

        if (useVirtualLayout && !llv)
        {
            setIndexInView(-1, -1);
            return;
        }

        var i0:int;
        var i1:int;
        if (useVirtualLayout)
        {
            i0 = llv.indexOf(x0);
            i1 = llv.indexOf(x1);
        }
        else
        {
            i0 = findIndexAt(x0 + gap, gap, g, 0, n);
            i1 = findIndexAt(x1, gap, g, 0, n);
        }

        // Special case: no element overlaps x0, is index 0 visible?
        if (i0 == -1)
        {   
            var index0:int = findLayoutElementIndex(g, 0, +1);
            if (index0 != -1)
            {
                var element0:ILayoutElement = g.getElementAt(index0) as ILayoutElement; 
                var element0X:Number = element0.getLayoutBoundsX();
                var element0Width:Number = element0.getLayoutBoundsWidth();                 
                if ((element0X < x1) && ((element0X + element0Width) > x0))
                    i0 = index0;
            }
        }

        // Special case: no element overlaps y1, is index n visible?
        if (i1 == -1)
        {
            var index1:int = findLayoutElementIndex(g, n, -1);
            if (index1 != -1)
            {
                var element1:ILayoutElement = g.getElementAt(index1) as ILayoutElement; 
                var element1X:Number = element1.getLayoutBoundsX();
                var element1Width:Number = element1.getLayoutBoundsWidth();                 
                if ((element1X < x1) && ((element1X + element1Width) > x0))
                    i1 = index1;
            }
        }   

        if (useVirtualLayout)
        {
            var firstElement:ILayoutElement = g.getElementAt(_firstIndexInView) as ILayoutElement;
            var lastElement:ILayoutElement = g.getElementAt(_lastIndexInView) as ILayoutElement;
            var scrollRect:Rectangle = getScrollRect();
            
            /* If the scrollRect is within the bounds of the elements, we do
            not need to call invalidateDisplayList(). This considerably speeds
            up small scrolls.
            if (!firstElement || !lastElement || 
                scrollRect.left < firstElement.getLayoutBoundsX() || 
                scrollRect.right >= (lastElement.getLayoutBoundsX() + lastElement.getLayoutBoundsWidth()))
            {
                g.invalidateDisplayList();
            }*/
        }
                
        setIndexInView(i0, i1);
    }

    /**
     *  @private
     * 
     *  Returns the actual position/size Rectangle of the first partially 
     *  visible or not-visible, non-null includeInLayout element, beginning
     *  with the element at index i, searching in direction dir (dir must
     *  be +1 or -1).   The last argument is the GroupBase scrollRect, it's
     *  guaranteed to be non-null.
     * 
     *  Returns null if no such element can be found.
     */
    private function findLayoutElementBounds(g:GroupBase, i:int, dir:int, r:Rectangle):Rectangle
    {
        var n:int = g.numElements;

        if (fractionOfElementInView(i) >= 1)
        {
            // Special case: if we hit the first/last element, 
            // then return the area of the padding so that we
            // can scroll all the way to the start/end.
            i += dir;
            if (i < 0)
                return new Rectangle(0, 0, paddingLeft, 0);
            if (i >= n)
                return new Rectangle(getElementBounds(n-1).right, 0, paddingRight, 0);
        }

        while((i >= 0) && (i < n))
        {
           var elementR:Rectangle = getElementBounds(i);
           // Special case: if the scrollRect r _only_ contains
           // elementR, then if we're searching left (dir == -1),
           // and elementR's left edge is visible, then try again
           // with i-1.   Likewise for dir == +1.
           if (elementR)
           {
               var overlapsLeft:Boolean = (dir == -1) && (elementR.left == r.left) && (elementR.right >= r.right);
               var overlapsRight:Boolean = (dir == +1) && (elementR.right == r.right) && (elementR.left <= r.left);
               if (!(overlapsLeft || overlapsRight))             
                   return elementR;               
           }
           i += dir;
        }
        return null;
    }

    /**
     *  @private 
     */
    override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
    {
        return findLayoutElementBounds(target, firstIndexInView, -1, scrollRect);
    } 

    /**
     *  @private 
     */
    override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
    {
        return findLayoutElementBounds(target, lastIndexInView, +1, scrollRect);
    } 

    /**
     *  @private
     *  Fills in the result with preferred and min sizes of the element.
     */
    private function getElementWidth(element:ILayoutElement, fixedColumnWidth:Number, result:SizesAndLimit):void
    {
        // Calculate preferred width first, as it's being used to calculate min width
        var elementPreferredWidth:Number = isNaN(fixedColumnWidth) ? Math.ceil(element.getPreferredBoundsWidth()) :
                                                                     fixedColumnWidth;
        // Calculate min width
        var flexibleWidth:Boolean = !isNaN(element.percentWidth);
        var elementMinWidth:Number = flexibleWidth ? Math.ceil(element.getMinBoundsWidth()) : 
                                                     elementPreferredWidth;
        result.preferredSize = elementPreferredWidth;
        result.minSize = elementMinWidth;
    }
    
    /**
     *  @private
     *  Fills in the result with preferred and min sizes of the element.
     */
    private function getElementHeight(element:ILayoutElement, justify:Boolean, result:SizesAndLimit):void
    {
        // Calculate preferred height first, as it's being used to calculate min height below
        var elementPreferredHeight:Number = Math.ceil(element.getPreferredBoundsHeight());
        
        // Calculate min height
        var flexibleHeight:Boolean = !isNaN(element.percentHeight) || justify;
        var elementMinHeight:Number = flexibleHeight ? Math.ceil(element.getMinBoundsHeight()) : 
                                                       elementPreferredHeight;
        result.preferredSize = elementPreferredHeight;
        result.minSize = elementMinHeight;
    }

    /**
     *  @private
     *  Returns [baselineTop, baselineBottom, baselineBottomMin],
     *  where baselineTop is the portion of the elements above the common baseline
     *  and the baselineBottom is the portion of the elements below the common baseline.
     */
    private function calculateBaselineTopBottom(calculateBottom:Boolean):Array
    {
        var baselineOffset:Number = 0;
        var baselineTop:Number = 0;
        var baselineBottom:Number = 0;
        var baselineBottomMin:Number = 0;

        var calculateTop:Boolean;
        var temp:Array = LayoutElementHelper.parseConstraintExp(alignmentBaseline);
        if (temp.length == 2 && temp[1] == "maxAscent")
        {
            baselineOffset = Number(temp[0]);
            calculateTop = true;
        }
        else
        {
            calculateTop = false;
            baselineTop = Number(temp[0]);
            
            // If someone sets the explicit baseline to NaN, then
            // still calculate from the elements
            if (isNaN(baselineTop))
            {
                baselineTop = 0;
                calculateTop = true;
            }
        }

        var count:int = target.numElements;
        for (var i:int = 0; i < count; i++)
        {
            var element:ILayoutElement = target.getElementAt(i) as ILayoutElement;
            if (!element || !element.includeInLayout)
                continue;

            var elementBaseline:Number/* = element.baseline as Number;
            if (isNaN(elementBaseline))
                elementBaseline*/ = 0;
            
            var baselinePosition:Number = element.baselinePosition;

            // The portion of the current element that's above the baseline
            var elementBaselineTop:Number = baselinePosition - elementBaseline;

            if (calculateTop)
                baselineTop = Math.max(elementBaselineTop, baselineTop);

            if (calculateBottom)
            {
                // The portion of the current element that's below the baseline
                var elementHeight:Number = element.getPreferredBoundsHeight();
                var elementBaselineBottom:Number = elementHeight - elementBaselineTop;
                
                // Calculate bottom based on min height if the element has flexible height
                var elementBaselineBottomMin:Number = elementBaselineBottom; 
                if (!isNaN(element.percentHeight))
                    elementBaselineBottomMin = element.getMinBoundsHeight() - elementBaselineTop;
    
                baselineBottom = Math.max(elementBaselineBottom, baselineBottom);
            }
        }

        // If ascent was specified, add the offset
        if (calculateTop)
            baselineTop += baselineOffset;

        return [baselineTop, baselineBottom, baselineBottomMin];
    }

    /**
     *  @private
     *  @return columns to measure based on elements in layout and any requested/min/max rowCount settings. 
     */
    private function getColumsToMeasure(numElementsInLayout:int):int
    {
        var columnsToMeasure:int;
        if (requestedColumnCount != -1)
            columnsToMeasure = requestedColumnCount;
        else
        {
            columnsToMeasure = numElementsInLayout;
            if (requestedMaxColumnCount != -1)
                columnsToMeasure = Math.min(requestedMaxColumnCount, columnsToMeasure);
            if (requestedMinColumnCount != -1)
                columnsToMeasure = Math.max(requestedMinColumnCount, columnsToMeasure);
        }
        return columnsToMeasure;
    }
    
    /**
     *  @private
     * 
     *  Compute exact values for measuredWidth,Height and  measuredMinWidth,Height.
     *  
     *  Measure each of the layout elements.  If requestedColumnCount >= 0 we 
     *  consider the height and width of as many layout elements, padding with 
     *  typicalLayoutElement if needed, starting with index 0. We then only 
     *  consider the height of the elements remaining.
     * 
     *  If requestedColumnCount is -1, we consider width/height of each element.
     */
    private function measureReal(layoutTarget:GroupBase):void
    {
        var size:SizesAndLimit          = new SizesAndLimit();
        var alignToBaseline:Boolean     = verticalAlign == VerticalAlign.BASELINE;
        var justify:Boolean             = verticalAlign == VerticalAlign.JUSTIFY;
        var numElements:int             = layoutTarget.numElements;     // How many elements there are in the target
        var numElementsInLayout:int     = numElements;                  // How many elements have includeInLayout == true, start off with numElements.
        var requestedColumnCount:int    = this.requestedColumnCount;
        var columnsMeasured:int         = 0;                            // How many columns have been measured
        
        var preferredHeight:Number      = 0; // sum of the elt preferred heights
        var preferredWidth:Number       = 0; // max of the elt preferred widths
        var minHeight:Number            = 0; // sum of the elt minimum heights
        var minWidth:Number             = 0; // max of the elt minimum widths
        
        var fixedColumnWidth:Number = NaN;
        if (!variableColumnWidth)
            fixedColumnWidth = columnWidth;  // may query typicalLayoutElement, elt at index=0
        
        // Get the numElementsInLayout clamped to requested min/max
        var columnsToMeasure:int = getColumsToMeasure(numElementsInLayout);
        var element:ILayoutElement;
        for (var i:int = 0; i < numElements; i++)
        {
            element = layoutTarget.getElementAt(i) as ILayoutElement;
            if (!element || !element.includeInLayout)
            {
                numElementsInLayout--;
                continue;
            }

            if (!alignToBaseline)
            {
                // Consider the height of each element, inclusive of those outside
                // the requestedColumnCount range.
                getElementHeight(element, justify, size);
                preferredHeight = Math.max(preferredHeight, size.preferredSize);
                minHeight = Math.max(minHeight, size.minSize);
            }
            
            // Can we measure the width of this column?
            if (columnsMeasured < columnsToMeasure)
            {
                getElementWidth(element, fixedColumnWidth, size);
                preferredWidth += size.preferredSize;
                minWidth += size.minSize;
                columnsMeasured++;
            }
        }
        
        // Calculate the total number of columns to measure again, since numElementsInLayout may have changed
        columnsToMeasure = getColumsToMeasure(numElementsInLayout);

        // Do we need to measure more columns?
        if (columnsMeasured < columnsToMeasure)
        {
            // Use the typical element
            element = typicalLayoutElement;
            if (element)
            {
                if (!alignToBaseline)
                {
                    // Height
                    getElementHeight(element, justify, size);
                    preferredHeight = Math.max(preferredHeight, size.preferredSize);
                    minHeight = Math.max(minHeight, size.minSize);
                }
    
                // Width
                getElementWidth(element, fixedColumnWidth, size);
                preferredWidth += size.preferredSize * (columnsToMeasure - columnsMeasured);
                minWidth += size.minSize * (columnsToMeasure - columnsMeasured);
                columnsMeasured = columnsToMeasure;
            }
        }

        if (alignToBaseline)
        {
            var result:Array = calculateBaselineTopBottom(true /*calculateBottom*/);
            var top:Number = result[0];
            var bottom:Number = result[1];
            var bottomMin:Number = result[2];
            
            preferredHeight = Math.ceil(top + bottom);
            minHeight = Math.ceil(top + bottomMin);
        }

        // Add gaps
        if (columnsMeasured > 1)
        { 
            var hgap:Number = gap * (columnsMeasured - 1);
            preferredWidth += hgap;
            minWidth += hgap;
        }
        
        var hPadding:Number = paddingLeft + paddingRight;
        var vPadding:Number = paddingTop + paddingBottom;
        
        layoutTarget.measuredHeight = preferredHeight + vPadding;
        layoutTarget.measuredWidth = preferredWidth + hPadding;
        layoutTarget.measuredMinHeight = minHeight + vPadding;
        layoutTarget.measuredMinWidth  = minWidth + hPadding;
    }

    /**
     *  @private
     * 
     *  Syncs the LinearLayoutVector llv with typicalLayoutElement and
     *  the target's numElements.  Calling this function accounts
     *  for the possibility that the typicalLayoutElement has changed, or
     *  something that its preferred size depends on has changed.
     */
    private function updateLLV(layoutTarget:GroupBase):void
    {
        if (!llv)
        {
            llv = new LinearLayoutVector(LinearLayoutVector.HORIZONTAL)
            // Virtualization defaults for cases
            // where there are no items and no typical item.
            // The llv defaults are the width/height of a Spark Button skin.
            llv.defaultMinorSize = 22;
            llv.defaultMajorSize = 71;
        }

        var typicalElt:ILayoutElement = typicalLayoutElement;
        if (typicalElt)
        {
            var typicalWidth:Number = typicalElt.getPreferredBoundsWidth();
            var typicalHeight:Number = typicalElt.getPreferredBoundsHeight();
            llv.defaultMinorSize = typicalHeight;
            llv.defaultMajorSize = typicalWidth;
        }
        
        if (!isNaN(_columnWidth))
            llv.defaultMajorSize = _columnWidth;
        
        if (layoutTarget)
            llv.length = layoutTarget.numElements;        

        llv.gap = gap;
        llv.majorAxisOffset = paddingLeft;
    }

    /**
     *  @private
     */
     override public function elementAdded(index:int):void
     {
         if ((index >= 0) && useVirtualLayout && llv)
            llv.insert(index);  // insert index parameter is uint
     }

    /**
     *  @private
     */
     override public function elementRemoved(index:int):void
     {
        if ((index >= 0) && useVirtualLayout && llv)
            llv.remove(index);  // remove index parameter is uint
     }     

    /**
     *  @private
     * 
     *  Compute potentially approximate values for measuredWidth,Height and 
     *  measuredMinWidth,Height.
     * 
     *  This method does not get layout elements from the target except
     *  as a side effect of calling typicalLayoutElement.
     * 
     *  If variableColumnWidth="false" then all dimensions are based on 
     *  typicalLayoutElement and the sizes already cached in llv.  The 
     *  llv's defaultMajorSize, minorSize, and minMinorSize 
     *  are based on typicalLayoutElement.
     */
    private function measureVirtual(layoutTarget:GroupBase):void
    {
        var eltCount:int = layoutTarget.numElements;
        var measuredEltCount:int = getColumsToMeasure(eltCount);
        
        var hPadding:Number = paddingLeft + paddingRight;
        var vPadding:Number = paddingTop + paddingBottom;
        
        if (measuredEltCount <= 0)
        {
            layoutTarget.measuredWidth = layoutTarget.measuredMinWidth = hPadding;
            layoutTarget.measuredHeight = layoutTarget.measuredMinHeight = vPadding;
            return;
        }        
        
        updateLLV(layoutTarget);     
        if (variableColumnWidth)
        {
            // Special case: fewer elements than requestedColumnCount, so temporarily
            // make llv.length == requestedColumnCount.
            var oldLength:int = -1;
            if (measuredEltCount > llv.length)
            {
                oldLength = llv.length;
                llv.length = measuredEltCount;
            }

            // paddingRight is already taken into account as the majorAxisOffset of the llv 
            // Measured size according to the cached actual size:
            var measuredWidth:Number = llv.end(measuredEltCount - 1) + paddingRight;
            
            /* AJH Later
            // For the live ItemRenderers use the preferred size
            // instead of the cached actual size:
            var dataGroupTarget:DataGroup = layoutTarget as DataGroup;
            if (dataGroupTarget)
            {
                var indices:Vector.<int> = dataGroupTarget.getItemIndicesInView();
                for each (var i:int in indices)
                {
                    var element:ILayoutElement = dataGroupTarget.getElementAt(i);
                    if (element)
                    {
                        measuredWidth -= llv.getMajorSize(i);
                        measuredWidth += element.getPreferredBoundsWidth();
                    }
                }
            }
            */
            
            layoutTarget.measuredWidth = measuredWidth;
            
            if (oldLength != -1)
                llv.length = oldLength;
        }
        else
        {
            var hgap:Number = (measuredEltCount > 1) ? (measuredEltCount - 1) * gap : 0;
            layoutTarget.measuredWidth = (measuredEltCount * columnWidth) + hgap + hPadding;
        }
        layoutTarget.measuredHeight = llv.minorSize + vPadding;

        layoutTarget.measuredMinWidth = layoutTarget.measuredWidth;
        layoutTarget.measuredMinHeight = (verticalAlign == VerticalAlign.JUSTIFY) ? 
                llv.minMinorSize + vPadding : layoutTarget.measuredHeight;
    }

    /**
     *  @private
     * 
     *  If requestedColumnCount is specified then as many layout elements
     *  or "columns" are measured, starting with element 0, otherwise all of the 
     *  layout elements are measured.
     *  
     *  If requestedColumnCount is specified and is greater than the
     *  number of layout elements, then the typicalLayoutElement is used
     *  in place of the missing layout elements.
     * 
     *  If variableColumnWidth="true", then the layoutTarget's measuredWidth
     *  is the sum of preferred widths of the layout elements, plus the sum of the
     *  gaps between elements, and its measuredHeight is the max of the elements' 
     *  preferred heights.
     * 
     *  If variableColumnWidth="false", then the layoutTarget's measuredWidth
     *  is columnWidth multiplied by the number or layout elements, plus the 
     *  sum of the gaps between elements.
     * 
     *  The layoutTarget's measuredMinWidth is the sum of the minWidths of 
     *  layout elements that have specified a value for the percentWidth
     *  property, and the preferredWidth of the elements that have not, 
     *  plus the sum of the gaps between elements.
     * 
     *  The difference reflects the fact that elements which specify 
     *  percentWidth are considered to be "flexible" and updateDisplayList 
     *  will give flexible components at least their minWidth.  
     * 
     *  Layout elements that aren't flexible always get their preferred width.
     * 
     *  The layoutTarget's measuredMinHeight is the max of the minHeights for 
     *  elements that have specified percentHeight (that are "flexible") and the 
     *  preferredHeight of the elements that have not.
     * 
     *  As before the difference is due to the fact that flexible items are only
     *  guaranteed their minHeight.
     */
    override public function measure():void
    {
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;
            
        if (useVirtualLayout)
            measureVirtual(layoutTarget);
        else 
            measureReal(layoutTarget);
            
        // Use Math.ceil() to make sure that if the content partially occupies
        // the last pixel, we'll count it as if the whole pixel is occupied.
        layoutTarget.measuredWidth = Math.ceil(layoutTarget.measuredWidth);    
        layoutTarget.measuredHeight = Math.ceil(layoutTarget.measuredHeight);    
        layoutTarget.measuredMinWidth = Math.ceil(layoutTarget.measuredMinWidth);    
        layoutTarget.measuredMinHeight = Math.ceil(layoutTarget.measuredMinHeight);    
    }
    
    /**
     *  @private 
     */  
    override public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean):int
    {
        if (!target || target.numElements < 1)
            return -1; 
            
        var maxIndex:int = target.numElements - 1;

        // Special case when nothing was previously selected
        if (currentIndex == -1)
        {
            if (navigationUnit == NavigationUnit.LEFT)
                return arrowKeysWrapFocus ? maxIndex : -1;

            if (navigationUnit == NavigationUnit.RIGHT)
                return 0;    
        }    

        // Make sure currentIndex is within range
        currentIndex = Math.max(0, Math.min(maxIndex, currentIndex));

        var newIndex:int; 
        var bounds:Rectangle;
        var x:Number;

        switch (navigationUnit)
        {
            case NavigationUnit.LEFT:
            {
               if (arrowKeysWrapFocus && currentIndex == 0)
                   newIndex = maxIndex;
               else
                   newIndex = currentIndex - 1;  
               break;
            } 

            case NavigationUnit.RIGHT: 
            {
               if (arrowKeysWrapFocus && currentIndex == maxIndex)
                   newIndex = 0;
               else
                   newIndex = currentIndex + 1;  
               break;
            }
             
            case NavigationUnit.PAGE_UP:
            case NavigationUnit.PAGE_LEFT:
            {
                // Find the first fully visible element
                var firstVisible:int = firstIndexInView;
                var firstFullyVisible:int = firstVisible;
                if (fractionOfElementInView(firstFullyVisible) < 1)
                    firstFullyVisible += 1;
                 
                // Is the current element in the middle of the viewport?
                if (firstFullyVisible < currentIndex && currentIndex <= lastIndexInView)
                    newIndex = firstFullyVisible;
                else
                {
                    // Find an element that's one page left
                    if (currentIndex == firstFullyVisible || currentIndex == firstVisible)
                    {
                        // currentIndex is visible, we can calculate where the scrollRect top
                        // would end up if we scroll by a page                    
                        x = getHorizontalScrollPositionDelta(NavigationUnit.PAGE_LEFT) + getScrollRect().left;
                    }
                    else
                    {
                        // currentIndex is not visible, just find an element a page left from currentIndex
                        x = getElementBounds(currentIndex).right - getScrollRect().width;
                    }

                    // Find the element after the last element that spans left of the x position
                    newIndex = currentIndex - 1;
                    while (0 <= newIndex)
                    {
                        bounds = getElementBounds(newIndex);
                        if (bounds && bounds.left < x)
                        {
                            // This element spans the y position, so return the next one
                            newIndex = Math.min(currentIndex - 1, newIndex + 1);
                            break;
                        }
                        newIndex--;    
                    }
                }
                break;
            }

            case NavigationUnit.PAGE_DOWN:
            case NavigationUnit.PAGE_RIGHT:
            {
                // Find the last fully visible element:
                var lastVisible:int = lastIndexInView;
                var lastFullyVisible:int = lastVisible;
                if (fractionOfElementInView(lastFullyVisible) < 1)
                    lastFullyVisible -= 1;
                
                // Is the current element in the middle of the viewport?
                if (firstIndexInView <= currentIndex && currentIndex < lastFullyVisible)
                    newIndex = lastFullyVisible;
                else
                {
                    // Find an element that's one page right
                    if (currentIndex == lastFullyVisible || currentIndex == lastVisible)
                    {
                        // currentIndex is visible, we can calculate where the scrollRect bottom
                        // would end up if we scroll by a page                    
                        x = getHorizontalScrollPositionDelta(NavigationUnit.PAGE_RIGHT) + getScrollRect().right;
                    }
                    else
                    {
                        // currentIndex is not visible, just find an element a page right from currentIndex
                        x = getElementBounds(currentIndex).left + getScrollRect().width;
                    }

                    // Find the element before the first element that spans right of the y position
                    newIndex = currentIndex + 1;
                    while (newIndex <= maxIndex)
                    {
                        bounds = getElementBounds(newIndex);
                        if (bounds && bounds.right > x)
                        {
                            // This element spans the y position, so return the previous one
                            newIndex = Math.max(currentIndex + 1, newIndex - 1);
                            break;
                        }
                        newIndex++;    
                    }
                }
                break;
            }

            default: return super.getNavigationDestinationIndex(currentIndex, navigationUnit, arrowKeysWrapFocus);
        }
        return Math.max(0, Math.min(maxIndex, newIndex));  
    }
    
    /**
     *  @private
     * 
     *  Used only for virtual layout.
     */
    private function calculateElementHeight(elt:ILayoutElement, targetHeight:Number, containerHeight:Number):Number
    {
       // If percentHeight is specified then the element's height is the percentage
       // of targetHeight clipped to min/maxHeight and to (upper limit) targetHeight.
       var percentHeight:Number = elt.percentHeight;
       if (!isNaN(percentHeight))
       {
          var height:Number = percentHeight * 0.01 * targetHeight;
          return Math.min(targetHeight, Math.min(elt.getMaxBoundsHeight(), Math.max(elt.getMinBoundsHeight(), height)));
       }
       switch(verticalAlign)
       {
           case VerticalAlign.JUSTIFY: 
               return targetHeight;
           case VerticalAlign.CONTENT_JUSTIFY: 
               return Math.max(elt.getPreferredBoundsHeight(), containerHeight);
       }
       return NaN; // not constrained
    }

    /**
     *  @private
     * 
     *  Used only for virtual layout.
     */
    private function calculateElementY(elt:ILayoutElement, eltHeight:Number, containerHeight:Number):Number
    {
       switch(verticalAlign)
       {
           case VerticalAlign.MIDDLE: 
               return Math.round((containerHeight - eltHeight) * 0.5);
           case VerticalAlign.BOTTOM: 
               return containerHeight - eltHeight;
       }
       return 0;  // VerticalAlign.TOP
    }

    /**
     *  @private
     * 
     *  Update the layout of the virtualized elements that overlap
     *  the scrollRect's horizontal extent.
     *
     *  The width of each layout element will be its preferred width, and its
     *  x will be the right edge of the previous item, plus the gap.
     * 
     *  No support for percentWidth, includeInLayout=false, or null layoutElements,
     * 
     *  The height of each layout element will be set to its preferred height, unless
     *  one of the following is true:
     * 
     *  - If percentHeight is specified for this element, then its height will be the
     *  specified percentage of the target's actual (unscaled) height, clipped 
     *  the layout element's minimum and maximum height.
     * 
     *  - If verticalAlign is "justify", then the element's height will
     *  be set to the target's actual (unscaled) height.
     * 
     *  - If verticalAlign is "contentJustify", then the element's height
     *  will be set to the target's content height.
     * 
     *  The Y coordinate of each layout element will be set to 0 unless one of the
     *  following is true:
     * 
     *  - If verticalAlign is "middle" then y is set so that the element's preferred
     *  height is centered within the larget of the contentHeight and the target's height:
     *      y = (Math.max(contentHeight, target.height) - layoutElementHeight) * 0.5
     * 
     *  - If verticalAlign is "bottom" the y is set so that the element's bottom
     *  edge is aligned with the the bottom edge of the content:
     *      y = (Math.max(contentHeight, target.height) - layoutElementHeight)
     * 
     *  Implementation note: unless verticalAlign is either "justify" or 
     *  "top", the layout elements' y or height depends on the contentHeight.
     *  The contentHeight is a maximum and although it may be updated to 
     *  different value after all (viewable) elements have been laid out, it
     *  often does not change.  For that reason we use the current contentHeight
     *  for the initial layout and then, if it has changed, we loop through 
     *  the layout items again and fix up the y/height values.
     */
    private function updateDisplayListVirtual(targetWidth:Number, targetHeight:Number):void
    {
        var layoutTarget:GroupBase = target; 
        var eltCount:int = layoutTarget.numElements;
        targetHeight = Math.max(0, targetHeight - paddingTop - paddingBottom);
        var minVisibleX:Number = layoutTarget.horizontalScrollPosition;
        var maxVisibleX:Number = minVisibleX + targetWidth;
       
        var contentWidth:Number;
        var paddedContentWidth:Number;

        updateLLV(layoutTarget);

        // Find the index of the first visible item. Since the item's bounds includes the gap
        // that follows it, we want to avoid looking at an item that has only a portion of
        // its gap intersecting with the visible region.
        // We have to also be careful, as gap could be negative and in that case, we should
        // simply start from minVisibleX - SDK-22497.
        var startIndex:int = llv.indexOf(Math.max(0, minVisibleX + gap));
        if (startIndex == -1)
        {
            // No items are visible.  Just set the content size.
            contentWidth = llv.end(llv.length - 1) - paddingLeft;
            paddedContentWidth = Math.ceil(contentWidth + paddingLeft + paddingRight);
            layoutTarget.setContentSize(paddedContentWidth, layoutTarget.contentHeight);
            return;
        }
            
        var fixedColumnWidth:Number = NaN;
        if (!variableColumnWidth)
            fixedColumnWidth = columnWidth;  // may query typicalLayoutElement, elt at index=0
         
        var justifyHeights:Boolean = verticalAlign == VerticalAlign.JUSTIFY;
        var eltWidth:Number = NaN;
        var eltHeight:Number = (justifyHeights) ? Math.max(llv.minMinorSize, targetHeight) : llv.minorSize;  
        var contentHeight:Number = (justifyHeights) ? Math.max(llv.minMinorSize, targetHeight) : llv.minorSize;
        var containerHeight:Number = Math.max(contentHeight, targetHeight);
        var x:Number = llv.start(startIndex);
        var index:int = startIndex;
        var y0:Number = paddingTop;
        
        // First pass: compute element x,y,width,height based on 
        // current contentHeight; cache computed widths/heights in llv.
        for (; (x < maxVisibleX) && (index < eltCount); index++)
        {
            // TODO (hmuller): should pass in eltWidth, eltHeight
            var elt:ILayoutElement = layoutTarget.getVirtualElementAt(index);
            var w:Number = fixedColumnWidth; // NaN for variable width columns
            var h:Number = calculateElementHeight(elt, targetHeight, containerHeight); // can be NaN
            elt.setLayoutBoundsSize(w, h);
            w = elt.getLayoutBoundsWidth();        
            h = elt.getLayoutBoundsHeight();
            var y:Number = y0 + calculateElementY(elt, h, containerHeight);
            elt.setLayoutBoundsPosition(x, y);
            llv.cacheDimensions(index, elt);
            x += w + gap;
        }
        var endIndex:int = index - 1;

        // Second pass: if neccessary, fix up y and height values based
        // on the updated contentHeight
        if (!justifyHeights && (llv.minorSize != contentHeight))
        {
            contentHeight = llv.minorSize;
            containerHeight = Math.max(contentHeight, targetHeight);            
            if ((verticalAlign != VerticalAlign.TOP) && (verticalAlign != VerticalAlign.JUSTIFY))
            {
                for (index = startIndex; index <= endIndex; index++)
                {
                    elt = layoutTarget.getElementAt(index) as ILayoutElement;
                    h = calculateElementHeight(elt, targetHeight, containerHeight); // can be NaN
                    elt.setLayoutBoundsSize(elt.getLayoutBoundsWidth(), h);
                    h = elt.getLayoutBoundsHeight();
                    y = y0 + calculateElementY(elt, h, containerHeight);
                    elt.setLayoutBoundsPosition(elt.getLayoutBoundsX(), y);
                }
             }
        }

        // Third pass: if neccessary, fix up x based on updated contentWidth
        contentWidth = llv.end(llv.length - 1) - paddingLeft;
        targetWidth = Math.max(0, targetWidth - paddingLeft - paddingRight);
        if (contentWidth < targetWidth)
        {
            var excessWidth:Number = targetWidth - contentWidth;
            var dx:Number = 0;
            var hAlign:String = horizontalAlign;
            if (hAlign == HorizontalAlign.CENTER)
            {
                dx = Math.round(excessWidth / 2);   
            }
            else if (hAlign == HorizontalAlign.RIGHT)
            {
                dx = excessWidth;
            }
            if (dx > 0)
            {
                for (index = startIndex; index <= endIndex; index++)
                {
                    elt = layoutTarget.getElementAt(index) as ILayoutElement;
                    elt.setLayoutBoundsPosition(dx + elt.getLayoutBoundsX(), elt.getLayoutBoundsY());
                }
                contentWidth += dx;
            }
        }
        
        setColumnCount(index - startIndex);
        setIndexInView(startIndex, endIndex);

        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
        paddedContentWidth = Math.ceil(contentWidth + paddingLeft + paddingRight);
        var paddedContentHeight:Number = Math.ceil(contentHeight + paddingTop + paddingBottom);
        layoutTarget.setContentSize(paddedContentWidth, paddedContentHeight);
    }
    
    /**
     *  @private 
     */
    private function updateDisplayListReal(targetWidth:Number, targetHeight:Number):void
    {
        var layoutTarget:GroupBase = target;
        targetWidth = Math.max(0, targetWidth - paddingLeft - paddingRight);
        targetHeight = Math.max(0, targetHeight - paddingTop - paddingBottom);
        
        var layoutElement:ILayoutElement;
        var count:int = layoutTarget.numElements;
        
        // If verticalAlign is top, we don't need to figure out the contentHeight.
        // Otherwise the contentHeight is used to position the element and even size 
        // the element if it's "contentJustify" or "justify".
        var containerHeight:Number = targetHeight;
        if (verticalAlign == VerticalAlign.CONTENT_JUSTIFY ||
           (clipAndEnableScrolling && (verticalAlign == VerticalAlign.MIDDLE ||
                                       verticalAlign == VerticalAlign.BOTTOM))) 
        {
            for (var i:int = 0; i < count; i++)
            {
                layoutElement = layoutTarget.getElementAt(i) as ILayoutElement;
                if (!layoutElement || !layoutElement.includeInLayout)
                    continue;
                
                var layoutElementHeight:Number;
                if (!isNaN(layoutElement.percentHeight))
                    layoutElementHeight = calculatePercentHeight(layoutElement, targetHeight);
                else
                    layoutElementHeight = layoutElement.getPreferredBoundsHeight();
                    
                containerHeight = Math.max(containerHeight, Math.ceil(layoutElementHeight));
            }
        }

        var excessWidth:Number = distributeWidth(targetWidth, targetHeight, containerHeight);
        
        // default to top (0)
        var vAlign:Number = 0;
        if (verticalAlign == VerticalAlign.MIDDLE)
            vAlign = .5;
        else if (verticalAlign == VerticalAlign.BOTTOM)
            vAlign = 1;

        var actualBaseline:Number = 0;
        var alignToBaseline:Boolean = verticalAlign == VerticalAlign.BASELINE;
        if (alignToBaseline)
        {
            var result:Array = calculateBaselineTopBottom(false /*calculateBottom*/);
            actualBaseline = result[0];
        }

        // If columnCount wasn't set, then as the LayoutElements are positioned
        // we'll count how many columns fall within the layoutTarget's scrollRect
        var visibleColumns:uint = 0;
        var minVisibleX:Number = layoutTarget.horizontalScrollPosition;
        var maxVisibleX:Number = minVisibleX + targetWidth

        // Finally, position the LayoutElements and find the first/last
        // visible indices, the content size, and the number of 
        // visible elements. 
        var x:Number = paddingLeft;
        var y0:Number = paddingTop;
        var maxX:Number = paddingLeft;
        var maxY:Number = paddingTop;     
        var firstColInView:int = -1;
        var lastColInView:int = -1;

        // Take horizontalAlign into account
        if (excessWidth > 0 || !clipAndEnableScrolling)
        {
            var hAlign:String = horizontalAlign;
            if (hAlign == HorizontalAlign.CENTER)
            {
                x = paddingLeft + Math.round(excessWidth / 2);   
            }
            else if (hAlign == HorizontalAlign.RIGHT)
            {
                x = paddingLeft + excessWidth;   
            }
        }

        for (var index:int = 0; index < count; index++)
        {
            layoutElement = layoutTarget.getElementAt(index) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
                continue;

            // Set the layout element's position
            var dx:Number = Math.ceil(layoutElement.getLayoutBoundsWidth());
            var dy:Number = Math.ceil(layoutElement.getLayoutBoundsHeight());

            var y:Number;
            if (alignToBaseline)
            {
                var elementBaseline:Number/* = layoutElement.baseline as Number;
                if (isNaN(elementBaseline))
                    elementBaseline*/ = 0;

                // Note: don't round the position. Rounding will case the text line to shift by
                // a pixel and won't look aligned with the other element's text.
                var baselinePosition:Number = layoutElement.baselinePosition;
                y = y0 + actualBaseline + elementBaseline - baselinePosition;
            }
            else
            {
                y = y0 + (containerHeight - dy) * vAlign;
                // In case we have VerticalAlign.MIDDLE we have to round
                if (vAlign == 0.5)
                    y = Math.round(y);
            }

            layoutElement.setLayoutBoundsPosition(x, y);

            // Update maxX,Y, first,lastVisibleIndex, and x
            maxX = Math.max(maxX, x + dx);
            maxY = Math.max(maxY, y + dy);            
            if (!clipAndEnableScrolling || 
                ((x < maxVisibleX) && ((x + dx) > minVisibleX)) || 
                ((dx <= 0) && ((x == maxVisibleX) || (x == minVisibleX))))            
            {
                visibleColumns += 1;
                if (firstColInView == -1)
                   firstColInView = lastColInView = index;
                else
                   lastColInView = index;
            }                
            x += dx + gap;
        }
        
        setColumnCount(visibleColumns);  
        setIndexInView(firstColInView, lastColInView);

        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
        layoutTarget.setContentSize(Math.ceil(maxX + paddingRight),
                                    Math.ceil(maxY + paddingBottom));
    }


    /**
     *  @private
     * 
     *  This function sets the width of each child
     *  so that the widths add up to <code>width</code>. 
     *  Each child is set to its preferred width
     *  if its percentWidth is zero.
     *  If its percentWidth is a positive number,
     *  the child grows (or shrinks) to consume its
     *  share of extra space.
     *  
     *  The return value is any extra space that's left over
     *  after growing all children to their maxWidth.
     */
    private function distributeWidth(width:Number,
                                     height:Number,
                                     restrictedHeight:Number):Number
    {
        var spaceToDistribute:Number = width;
        var totalPercentWidth:Number = 0;
        var childInfoArray:Array = [];
        var childInfo:HLayoutElementFlexChildInfo;
        var newHeight:Number;
        var layoutElement:ILayoutElement;
        
        // columnWidth can be expensive to compute
        var cw:Number = (variableColumnWidth) ? 0 : Math.ceil(columnWidth);
        var count:int = target.numElements;
        var totalCount:int = count; // number of elements to use in gap calculation
        
        // If the child is flexible, store information about it in the
        // childInfoArray. For non-flexible children, just set the child's
        // width and height immediately.
        for (var index:int = 0; index < count; index++)
        {
            layoutElement = target.getElementAt(index) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
            {
                totalCount--;
                continue;
            }
            
            if (!isNaN(layoutElement.percentWidth) && variableColumnWidth)
            {
                totalPercentWidth += layoutElement.percentWidth;

                childInfo = new HLayoutElementFlexChildInfo();
                childInfo.layoutElement = layoutElement;
                childInfo.percent    = layoutElement.percentWidth;
                childInfo.min        = layoutElement.getMinBoundsWidth();
                childInfo.max        = layoutElement.getMaxBoundsWidth();
                
                childInfoArray.push(childInfo);                
            }
            else
            {
                sizeLayoutElement(layoutElement, height, verticalAlign, 
                                  restrictedHeight, NaN, variableColumnWidth, cw);
                
                spaceToDistribute -= Math.ceil(layoutElement.getLayoutBoundsWidth());
            } 
        }
        
        if (totalCount > 1)
            spaceToDistribute -= (totalCount-1) * gap;

        // Distribute the extra space among the flexible children
        if (totalPercentWidth)
        {
            Flex.flexChildrenProportionally(width,
                                            spaceToDistribute,
                                            totalPercentWidth,
                                            childInfoArray);
            var roundOff:Number = 0;
            for each (childInfo in childInfoArray)
            {
                // Make sure the calculated percentages are rounded to pixel boundaries
                var childSize:int = Math.round(childInfo.size + roundOff);
                roundOff += childInfo.size - childSize;

                sizeLayoutElement(childInfo.layoutElement, height, verticalAlign, 
                                  restrictedHeight, childSize, 
                                  variableColumnWidth, cw);
                spaceToDistribute -= childSize;
            }
        }
        return spaceToDistribute;
    }
    
    /**
     *  @private
     */
    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        var layoutTarget:GroupBase = target; 
        if (!layoutTarget)
            return;

        if ((layoutTarget.numElements == 0) || (unscaledWidth == 0) || (unscaledHeight == 0))
        {
            setColumnCount(0);
            setIndexInView(-1, -1);
            if (layoutTarget.numElements == 0)
                layoutTarget.setContentSize(Math.ceil(paddingLeft + paddingRight),
                                            Math.ceil(paddingTop + paddingBottom));
            return;         
        }

        if (useVirtualLayout) 
            updateDisplayListVirtual(unscaledWidth, unscaledHeight);
        else
            updateDisplayListReal(unscaledWidth, unscaledHeight);
    }
    
    /**
     *  @private 
     *  Convenience function for subclasses that invalidates the
     *  target's size and displayList so that both layout's <code>measure()</code>
     *  and <code>updateDisplayList</code> methods get called.
     * 
     *  <p>Typically a layout invalidates the target's size and display list so that
     *  it gets a chance to recalculate the target's default size and also size and
     *  position the target's elements. For example changing the <code>gap</code>
     *  property on a <code>VerticalLayout</code> will internally call this method
     *  to ensure that the elements are re-arranged with the new setting and the
     *  target's default size is recomputed.</p> 
     */
    private function invalidateTargetSizeAndDisplayList():void
    {
        /*
        var g:GroupBase = target;
        if (!g)
            return;

        g.invalidateSize();
        g.invalidateDisplayList();
        */
    }

    //--------------------------------------------------------------------------
    //
    //  Drop methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */
    override protected function calculateDropIndex(x:Number, y:Number):int
    {
        // Iterate over the visible elements
        var layoutTarget:GroupBase = target;
        var count:int = layoutTarget.numElements;
        
        // If there are no items, insert at index 0
        if (count == 0)
            return 0;
        
        // Go through the visible elements
        var minDistance:Number = Number.MAX_VALUE;
        var bestIndex:int = -1;
        var start:int = this.firstIndexInView;
        var end:int = this.lastIndexInView;
        
        for (var i:int = start; i <= end; i++)
        {
            var elementBounds:Rectangle = this.getElementBounds(i);
            if (!elementBounds)
                continue;
            
            if (elementBounds.left <= x && x <= elementBounds.right)
            {
                var centerX:Number = elementBounds.x + elementBounds.width / 2;
                return (x < centerX) ? i : i + 1;
            }
            
            var curDistance:Number = Math.min(Math.abs(x - elementBounds.left),
                                              Math.abs(x - elementBounds.right));
            if (curDistance < minDistance)
            {
                minDistance = curDistance;
                bestIndex = (x < elementBounds.left) ? i : i + 1;
            }
        }
        
        // If there are no visible elements, either pick to drop at the beginning or at the end
        if (bestIndex == -1)
            bestIndex = getElementBounds(0).x < x ? count : 0;

        return bestIndex;
    }
    
    /**
     *  @private
     */
    override protected function calculateDropIndicatorBounds(dropLocation:DropLocation):Rectangle
    {
        var dropIndex:int = dropLocation.dropIndex;
        var count:int = target.numElements;
        var gap:Number = this.gap;
        
        // Special case, if we insert at the end, and the gap is negative, consider it to be zero
        if (gap < 0 && dropIndex == count)
            gap = 0;
        
        var emptySpace:Number = (0 < gap ) ? gap : 0; 
        var emptySpaceLeft:Number = 0;
        if (target.numElements > 0)
        {
            emptySpaceLeft = (dropIndex < count) ? getElementBounds(dropIndex).left - emptySpace : 
                                                   getElementBounds(dropIndex - 1).right + gap - emptySpace;
        }
        
        // Calculate the size of the bounds, take minium and maximum into account
        var width:Number = emptySpace;
        var height:Number = Math.max(target.height, target.contentHeight) - paddingTop - paddingBottom;
        if (dropIndicator is IVisualElement)
        {
            var element:IVisualElement = IVisualElement(dropIndicator);
            width = Math.max(Math.min(width, element.getMaxBoundsWidth(false)), element.getMinBoundsWidth(false));
        }
        
        var x:Number = emptySpaceLeft + Math.round((emptySpace - width)/2);
        // Allow 1 pixel overlap with container border
        x = Math.max(-Math.ceil(width / 2), Math.min(target.contentWidth - Math.ceil(width/2), x));

        var y:Number = paddingTop;
        return new Rectangle(x, y, width, height);
    }

    /**
     *  @private
    override protected function calculateDragScrollDelta(dropLocation:DropLocation,
                                                         elapsedTime:Number):Point
    {
        var delta:Point = super.calculateDragScrollDelta(dropLocation, elapsedTime);
        // Don't scroll in the vertical direction
        if (delta)
            delta.y = 0;
        return delta;
    }
     */

    /**
     *  @private
     *  Identifies the element which has its "compare point" located closest 
     *  to the specified position.
     */
    override mx_internal function getElementNearestScrollPosition(
        position:Point,
        elementComparePoint:String = "center"):int
    {
        if (!useVirtualLayout)
            return super.getElementNearestScrollPosition(position, elementComparePoint);
        
        var g:GroupBase = GroupBase(target);
        if (!g)
            return -1;
        
        // We need a valid LLV for this function
        updateLLV(g);
        
        // Find the element which overlaps with the position
        var index:int = llv.indexOf(position.x);

        // Invalid index indicates that the position is past either end of the 
        // laid-out elements.   In this case, choose either the first or last one.
        if (index == -1)
            index = position.x < 0 ? 0 : g.numElements - 1; 
        
        var bounds:Rectangle = llv.getBounds(index);
        var adjacentBounds:Rectangle;
        
        // If we're comparing with a right-edge point, check both the current element and the element
        // at index-1 to see which is closest.
        if ((elementComparePoint == "topRight" || elementComparePoint == "bottomRight") && index > 0)
        {
            adjacentBounds = llv.getBounds(index - 1);
            if (Point.distance(position, adjacentBounds.bottomRight) < Point.distance(position, bounds.bottomRight))
                index--;
        }
        
        // If we're comparing with a left-edge point, check both the current element and the element
        // at index+1 to see which is closest.
        if ((elementComparePoint == "topLeft" || elementComparePoint == "bottomLeft") && index < g.numElements-1) 
        {
            adjacentBounds = llv.getBounds(index + 1);             
            if (Point.distance(position, adjacentBounds.topLeft) < Point.distance(position, bounds.topLeft))
                index++;
        }
        return index;
    }
}
}

import mx.containers.utilityClasses.FlexChildInfo;
import mx.core.ILayoutElement;
class HLayoutElementFlexChildInfo extends FlexChildInfo
{
    public var layoutElement:ILayoutElement;    
}

class SizesAndLimit
{
    public var preferredSize:Number;
    public var minSize:Number;
}
