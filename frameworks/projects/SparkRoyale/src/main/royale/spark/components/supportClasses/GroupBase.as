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

package spark.components.supportClasses
{

//import flash.display.DisplayObject;
//import flash.display.Sprite;
//import flash.events.Event;
//import flash.events.GestureEvent;
//import flash.events.MouseEvent;
//import flash.events.PressAndTapGestureEvent;
//import flash.events.TouchEvent;
//import flash.events.TransformGestureEvent;
//import flash.filters.ShaderFilter;
//import flash.geom.Point;
//import flash.geom.Rectangle;

//import mx.core.ILayoutElement;
import mx.core.IUIComponent;
import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

import spark.core.IViewport;
import spark.layouts.BasicLayout;
import spark.layouts.supportClasses.LayoutBase;

import org.apache.royale.binding.ContainerDataBinding;
import org.apache.royale.binding.DataBindingBase;
import org.apache.royale.core.IBeadLayout;
import org.apache.royale.core.IContainer;
import org.apache.royale.core.ILayoutHost;
import org.apache.royale.core.ILayoutParent;
import org.apache.royale.core.IParent;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.events.ValueEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.utils.MXMLDataInterpreter;
import org.apache.royale.utils.loadBeadFromValuesManager;

//import spark.utils.FTETextUtil;
//import spark.utils.MaskUtil;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/* include "../../styles/metadata/BasicInheritingTextStyles.as"
include "../../styles/metadata/AdvancedInheritingTextStyles.as"
include "../../styles/metadata/SelectionFormatTextStyles.as" */

/**
 *  Accent color used by component skins. The default button skin uses this color
 *  to tint the background. Slider track highlighting uses this color. 
 * 
 *  @default #0099FF
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="accentColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  The colors to use for the backgrounds of the items in the list. 
 *  The value is an array of one or more colors. 
 *  The backgrounds of the list items alternate among the colors in the array. 
 * 
 *  <p>The default value for the Spark theme is <code>undefined</code>.
 *  The default value for the Mobile theme is <code>0xFFFFFF</code>.</p>
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  The main color for a component. 
 *   
 *  @default 0xCCCCCC
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="chromeColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  The alpha of the content background for this component.
 *
 *  @default 1.0
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark, mobile", minValue="0.0", maxValue="1.0")]

/**
 *  The color of the content background for this component.
 * 
 *  <p>For a List, changing <code>contentBackgroundColor</code> will 
 *  change the content background color of the List; however, if the item renderer
 *  is opaque, the user may not see any difference.  The item renderer's color is 
 *  affected by <code>alternatingItemColors</code>.  In the Spark theme, by default, item 
 *  renderers are transparent (<code>alternatingItemColors = undefined</code>); however, 
 *  in the Mobile theme, item renderers are opaque by default 
 *  (<code>alternatingItemColors = 0xFFFFFF</code>).</p>
 *  
 *  <p>The default value for the Spark theme is <code>0xFFFFFF</code>.
 *  The default value for the Mobile theme is <code>0xF0F0F0</code>.</p> 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  The alpha value when the container is disabled.
 *
 *  @default 0.5
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="disabledAlpha", type="Number", inherit="no", theme="spark, mobile", minValue="0.0", maxValue="1.0")]

/**
 *  Color of the background of an item renderer when it is being pressed down
 * 
 *  <p>If <code>downColor</code> is set to <code>undefined</code>, 
 *  <code>downColor</code> is not used.</p>
 * 
 *  <p>The default value for the Spark theme is <code>undefined</code>.
 *  The default value for the Mobile theme is <code>0xE0E0E0</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4.5
 */
//[Style(name="downColor", type="uint", format="Color", inherit="yes", theme="mobile")]

/**
 *  Color of focus ring when the component is in focus.
 *   
 *  @default 0x70B2EE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  Color of the highlights when the mouse is over the component.
 * 
 *  <p>This style is only applicable in mouse <code>interactionMode</code>.</p>
 * 
 *  @default 0xCEDBEF
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  Color of any symbol of a component. Examples include the check mark of a CheckBox or
 *  the arrow of a scroll button.
 *   
 *  @default 0x000000
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  When in touch interaction mode, the number of milliseconds to wait after the user 
 *  interaction has occured before showing the component in a visually down state.
 * 
 *  <p>The reason for this delay is because when a user initiates a scroll gesture, we don't want 
 *  components to flicker as they touch the screen.  By having a reasonable delay, we make 
 *  sure that the user still gets feedback when they press down on a component, but that the 
 *  feedback doesn't come too quickly that it gets displayed during a scroll gesture 
 *  operation.</p>
 *  
 *  <p>If the mobile theme is applied, the default value for this style is 100 ms for 
 *  components inside of a Scroller and 0 ms for components outside of a Scroller.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4.5
 */
//[Style(name="touchDelay", type="Number", format="Time", inherit="yes", minValue="0.0")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusThickness", kind="style")]

/**
 *  The GroupBase class defines the base class for components that display visual elements.
 *  A group component does not control the layout of the visual items that it contains. 
 *  Instead, the layout is handled by a separate layout component.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:GroupBase&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:GroupBase
 *    <strong>Properties</strong>
 *    autoLayout="true"
 *    clipAndEnableScrolling="false"
 *    horizontalScrollPosition="null"
 *    luminosityClip="false"
 *    luminosityInvert="false"
 *    layout="BasicLayout"
 *    mask=""
 *    maskType="clip"
 *    mouseEnabledWhereTransparent="true"
 *    resizeMode="noScale"
 *    verticalScrollPosition="no default"
 *  
 *    <strong>Styles</strong>
 *    accentColor="0x0099FF"
 *    alignmentBaseline="useDominantBaseline"
 *    alternatingItemColors="undefined"
 *    baselineShift="0"
 *    blockProgression="tb"
 *    breakOpportunity="auto"
 *    cffHinting="horizontalStem"
 *    chromeColor="0xCCCCCC"
 *    color="0x000000"
 *    contentBackgroundAlpha="1.0"
 *    contentBackgroundColor="0xFFFFFF"
 *    clearFloats="none"
 *    digitCase="default"
 *    digitWidth="default"
 *    direction="ltr"
 *    disabledAlpha="0.5"
 *    dominantBaseline="auto"
 *    firstBaselineOffset="auto"
 *    focusColor="0x70B2EE"
 *    focusedTextSelectionColor="A8C6EE"
 *    fontFamily="Arial"
 *    fontLookup="device"
 *    fontSize="12"
 *    fontStyle="normal"
 *    fontWeight="normal"
 *    inactiveTextSelectionColor="E8E8E8"
 *    justificationRule="auto"
 *    justificationStyle="auto"
 *    kerning="auto"
 *    leadingModel="auto"
 *    ligatureLevel="common"
 *    lineHeight="120%"
 *    lineThrough="false"
 *    listAutoPadding="40"
 *    listStylePosition="outside"
 *    listStyleType="disc"
 *    locale="en"
 *    paragraphEndIndent="0"
 *    paragraphSpaceAfter="0"
 *    paragraphSpaceBefore="0"
 *    paragraphStartIndent="0"
 *    renderingMode="cff"
 *    rollOverColor="0xCEDBEF"
 *    symbolColor="0x000000"
 *    tabStops="null"
 *    textAlign="start"
 *    textAlignLast="start"
 *    textAlpha="1"
 *    textDecoration="none"
 *    textIndent="0"
 *    textJustify="interWord"
 *    textRotation="auto"
 *    trackingLeft="0"
 *    trackingRight="0"
 *    typographicCase="default"
 *    unfocusedTextSelectionColor="0xE8E8E8"
 *    whiteSpaceCollapse="collapse"
 *    wordSpacing="100%,50%,150%"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.layouts.supportClasses.LayoutBase
 *  @see spark.components.ResizeMode
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class GroupBase extends UIComponent implements ILayoutParent, IContainer, IViewport
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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function GroupBase()
    {
        super();
        //showInAutomationHierarchy = false;
    }
        
    /*
    * IContainer
    */
    
    /**
     *  @private
     */
    public function childrenAdded():void
    {
        dispatchEvent(new ValueEvent("childrenAdded"));
    }
    
    /**
     * @copy org.apache.royale.core.IContentViewHost#strandChildren
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public function get strandChildren():IParent
    {
        return this;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  alpha
    //----------------------------------
    
   // private var _explicitAlpha:Number = 1.0;
    
    /**
     *  @private
     */
    /* override public function set alpha(value:Number):void
    {
        if (enabled)
            super.alpha = value;
        _explicitAlpha = value;
    } */
    
    //----------------------------------
    //  baselinePosition
    //----------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function get baselinePosition():Number
    {
        if (!validateBaselinePosition())
            return NaN;

        // Unless the height is very small, the baselinePosition
        // of a generic UIComponent is calculated as if there was
        // a UITextField using the component's styles
        // whose top coincides with the component's top.
        // If the height is small, the baselinePosition is calculated
        // as if there were text within whose ascent the component
        // is vertically centered.
        // At the crossover height, these two calculations
        // produce the same result.

        return FTETextUtil.calculateFontBaseline(this, height, moduleFactory);
    } */

    //----------------------------------
    //  mouseChildren
    //----------------------------------

   /*  private var _explicitMouseChildren:Boolean = true;
 */
    /**
     *  @private
     */
   /*  override public function set mouseChildren(value:Boolean):void
    {
        if (enabled)
            super.mouseChildren = value;
        _explicitMouseChildren = value;
    } */

    //----------------------------------
    //  mouseEnabled
    //----------------------------------

    //private var _explicitMouseEnabled:Boolean = true;

    /**
     *  @private
     */
    /* override public function set mouseEnabled(value:Boolean):void
    {
        if (enabled)
            super.mouseEnabled = value;
        _explicitMouseEnabled = value;
    } */

    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     */
    /* override public function set enabled(value:Boolean):void
    {
        super.enabled = value;

        // If enabled, reset the mouseChildren, mouseEnabled to the previously
        // set explicit value, otherwise disable mouse interaction.
        super.mouseChildren = value ? _explicitMouseChildren : false;
        super.mouseEnabled  = value ? _explicitMouseEnabled  : false;
        
        if (value)
            super.alpha = _explicitAlpha;
        else
        {
            var disabledAlpha:Number = getStyle("disabledAlpha");
            
            if (!isNaN(disabledAlpha))
                super.alpha = disabledAlpha;
            // else if it is NaN, it'll get handled in styleChanged()
        }
    } */

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
        
    //----------------------------------
    //  layout
    //----------------------------------    
    
    // layout is initialized in createChildren() if layout 
    // hasn't been set yet by someone else
    private var _layout:Object;//LayoutBase;
   // private var _layoutProperties:Object = null;
   // private var layoutInvalidateSizeFlag:Boolean = false;
   // private var layoutInvalidateDisplayListFlag:Boolean = false;
    public function set contentBackgroundColor(value:uint):void {} // not implemented
    
    [Inspectable(category="General")]
    
    /**
     *  The layout object for this container.  
     *  This object is responsible for the measurement and layout of 
     *  the visual elements in the container.
     * 
     *  @default spark.layouts.BasicLayout
     *
     *  @see spark.layouts.supportClasses.LayoutBase
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get layout():Object//LayoutBase
    {
        return _layout;
    } 
        
    /**
     *  @private
     * 
     *  Three properties are delegated to the layout: clipAndEnableScrolling,
     *  verticalScrollPosition, horizontalScrollPosition.
     *  If the layout is reset, we copy the properties from the old
     *  layout to the new one (we don't copy verticalScrollPosition
     *  and horizontalScrollPosition from an old layout object to a new layout 
     *  object because this information might not translate correctly).   
     *  If the new layout is null, then we
     *  temporarily store the delegated properties in _layoutProperties. 
     */
     public function set layout(value:Object):void
    {
        if (_layout == value)
            return;
        
       /*  if (_layout)
        {
            _layout.target = null;
            _layout.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);

            if (clipAndEnableScrollingExplicitlySet)
            {
                // when the layout changes, we don't want to transfer over 
                // horizontalScrollPosition and verticalScrollPosition
                _layoutProperties = {clipAndEnableScrolling: _layout.clipAndEnableScrolling};
            }
        } */

        _layout = value; 

        if (_layout)
        {
            _layout.target = this;
        }
        /*
            _layout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);

            if (_layoutProperties)
            {
                if (_layoutProperties.clipAndEnableScrolling !== undefined)
                    value.clipAndEnableScrolling = _layoutProperties.clipAndEnableScrolling;
                
                if (_layoutProperties.verticalScrollPosition !== undefined)
                    value.verticalScrollPosition = _layoutProperties.verticalScrollPosition;
                
                if (_layoutProperties.horizontalScrollPosition !== undefined)
                    value.horizontalScrollPosition = _layoutProperties.horizontalScrollPosition;
                
                _layoutProperties = null;
            }
        }

        invalidateSize();
        invalidateDisplayList(); */
    }
    
     
     /*
     * ILayoutParent
     */
     
     /**
      * Returns the ILayoutHost which is its view. From ILayoutParent.
      *
      *  @langversion 3.0
      *  @playerversion Flash 10.2
      *  @playerversion AIR 2.6
      *  @productversion Royale 0.8
      */
     public function getLayoutHost():ILayoutHost
     {
         return view as ILayoutHost;
     }
     
     //----------------------------------
     //  getLayoutChildAt for compatibility
     //----------------------------------
     
     public function getLayoutChildAt(index:int):IUIComponent
     {
         return getElementAt(index) as IUIComponent;
     }
     
    /**
     *  @private
     *  Redispatch the bindable LayoutBase properties that we expose (that we "facade"). 
     */
    /* private function redispatchLayoutEvent(event:Event):void
    {
        var pce:PropertyChangeEvent = event as PropertyChangeEvent;
        if (pce)
            switch (pce.property)
            {
                case "verticalScrollPosition":
                case "horizontalScrollPosition":
                    dispatchEvent(event);
                    break;
            }
    }  */   
    
    override public function get measuredWidth():Number
    {
        if (isNaN(_measuredWidth))
            measure();
        if (isNaN(_measuredWidth))
             return width;
        return _measuredWidth;
    }

    override public function get measuredHeight():Number
    {
        if (isNaN(_measuredHeight))
            measure();
        if (isNaN(_measuredHeight))
            return height;
        return _measuredHeight;
    }
    
    //----------------------------------
    //  horizontalScrollPosition
    //----------------------------------
        
    [Bindable]
    [Inspectable(minValue="0.0")]

    /**
     *  @copy spark.core.IViewport#horizontalScrollPosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get horizontalScrollPosition():Number 
    {
        if (_layout)
        {
            return _layout.horizontalScrollPosition;
        }
        /*
        else if (_layoutProperties && 
                _layoutProperties.horizontalScrollPosition !== undefined)
        {
            return _layoutProperties.horizontalScrollPosition;
        }
        else
        {*/
            return 0;
        /*}*/
    }

    /**
     *  @private
     */
    /* public function set horizontalScrollPosition(value:Number):void 
    {
        if (_layout)
        {
            _layout.horizontalScrollPosition = value;
        }
        else if (_layoutProperties)
        {
            _layoutProperties.horizontalScrollPosition = value;
        }
        else
        {
            _layoutProperties = {horizontalScrollPosition: value};
        }
    } */
    
    //----------------------------------
    //  verticalScrollPosition
    //----------------------------------
    
    [Bindable]
    [Inspectable(minValue="0.0")]
    
    /**
     *  @copy spark.core.IViewport#verticalScrollPosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get verticalScrollPosition():Number 
    {
        if (_layout)
        {
            return _layout.verticalScrollPosition;
        }
        /*
        else if (_layoutProperties && 
                _layoutProperties.verticalScrollPosition !== undefined)
        {
            return _layoutProperties.verticalScrollPosition;
        }
        else
        {*/
            return 0;
        /*}*/
    }

    /**
     *  @private
     */
    /* public function set verticalScrollPosition(value:Number):void 
    {
        if (_layout)
        {
            _layout.verticalScrollPosition = value;
        }
        else if (_layoutProperties)
        {
            _layoutProperties.verticalScrollPosition = value;
        }
        else
        {
            _layoutProperties = {verticalScrollPosition: value};
        }
    } */
    
    //----------------------------------
    //  clipAndEnableScrolling
    //----------------------------------

    private var _clipAndEnableScrolling:Boolean = false;
    
    /**
     *  @copy spark.core.IViewport#clipAndEnableScrolling
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get clipAndEnableScrolling():Boolean 
    {
        COMPILE::JS
        {
            return element.style.overflow == "auto";
        }
        COMPILE::SWF
        {
            return _clipAndEnableScrolling;
        }
    }

    /**
     *  @private
     */
    public function set clipAndEnableScrolling(value:Boolean):void 
    {
        COMPILE::JS
        {
            element.style.overflow = value ? "auto" : "none";
        }
        COMPILE::SWF
        {
            _clipAndEnableScrolling = value;
        }
    }
    
    //----------------------------------
    //  scrollRect
    //----------------------------------
    
    //private var _scrollRectSet:Boolean = false;
    
    /**
     * @private
     * GroupBase workaround for a FP bug.  Ignore attempts to reset the
     * DisplayObject scrollRect property to null (its default value) if we've
     * never set it.  Similarly, don't read the DisplayObject scrollRect
     * property if its value has not been set.
     */
    /*  override public function get scrollRect():Rectangle
     {
         return (!_scrollRectSet) ? null : super.scrollRect;
     } */

     /**
      * @private 
      */
   /*  override public function set scrollRect(value:Rectangle):void
    {
        if (!_scrollRectSet && !value)
            return;
        _scrollRectSet = true;
        super.scrollRect = value;
    } */
    
    //----------------------------------
    //  autoLayout
    //----------------------------------

    /**
     *  @private
     *  Storage for the autoLayout property.
     */
    private var _autoLayout:Boolean = true;

    [Inspectable(defaultValue="true")]

    /**
     *  If <code>true</code>, measurement and layout are done
     *  when the position or size of a child is changed.
     *  If <code>false</code>, measurement and layout are done only once,
     *  when children are added to or removed from the container.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get autoLayout():Boolean
    {
        return _autoLayout;
    }

    /**
     *  @private
     */
    public function set autoLayout(value:Boolean):void
    {
        if (_autoLayout == value)
            return;

        _autoLayout = value;

        /*
        // If layout is being turned back on, trigger a layout to occur now.
        if (value)
        {
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
        }*/
    }

    //----------------------------------
    //  overlay
    //----------------------------------

    /**
     *  @private
     *  Storage for the overlay property 
     */
    /* mx_internal var _overlay:DisplayLayer;

    [Inspectable(category="General")] */

    /**
     *  The overlay plane for this group.
     *  All objects of the overlay plane render on top of the Group elements.
     *
     *  <p><b>Note: </b>Do not retain this object because the group destroys and creates it on demand.</p>
     *   
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get overlay():DisplayLayer
    {
        if (!_overlay)
        {
            _overlay = new DisplayLayer();
            _overlay.addEventListener(DisplayLayerObjectExistenceEvent.OBJECT_ADD, overlay_objectAdd);
            _overlay.addEventListener(DisplayLayerObjectExistenceEvent.OBJECT_REMOVE, overlay_objectRemove);
            
            // Invalidate properties, so that if nothing was actually added to the
            // overlay object, we'll clean it up:
            invalidateProperties();
        }
        return _overlay;
    } */
    
    /**
     *  @private
     *  Event listener to add overlay objects when added to the overlay DisplayLayer.
     */
   /*  private function overlay_objectAdd(event:DisplayLayerObjectExistenceEvent):void
    {
        super.addChildAt(event.object, event.index + numChildren - _overlay.numDisplayObjects + 1);
    } */
    
    /**
     *  @private
     *  Event listener to remove overlay objects when removed from the overlay
     *  DisplayLayer.
     */
    /* private function overlay_objectRemove(event:DisplayLayerObjectExistenceEvent):void
    {
        // Remove the object from the display list
        super.removeChild(event.object);
        
        // Is this the last display object?
        if (_overlay.numDisplayObjects == 1)
            invalidateProperties();
    } */
    
    /**
     *  Destroys the overlay object. This method gets called on commitProperties
     *  when the overlay doesn't contain any objects. 
     */
    /* private function destroyOverlay():void
    {
        _overlay.removeEventListener(DisplayLayerObjectExistenceEvent.OBJECT_ADD, overlay_objectAdd);
        _overlay.removeEventListener(DisplayLayerObjectExistenceEvent.OBJECT_REMOVE, overlay_objectRemove);
        _overlay = null;
    } */

    //----------------------------------
    //  resizeMode
    //----------------------------------
    
    /* private var _resizeMode:String = ResizeMode.NO_SCALE; 
    
    [Inspectable(category="General", enumeration="noScale,scale", defaultValue="noScale")] */

    /**
     *  The ResizeMode for this container. If the resize mode
     *  is set to <code>ResizeMode.NO_SCALE</code>, resizing is done by laying 
     *  out the children with the new width and height. If the 
     *  resize mode is set to <code>ResizeMode.SCALE</code>, all of the children 
     *  keep their unscaled width and height and the children 
     *  are scaled to change size.
     * 
     * <p>The default value is <code>ResizeMode.NO_SCALE</code>, corresponding to "noScale".</p>
     * 
     * @see spark.components.ResizeMode
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get resizeMode():String
    {
        return _resizeMode; 
    }
    
    public function set resizeMode(value:String):void
    {
        if (_resizeMode == value)
            return;

        // If old value was scale, reset it            
        if (_resizeMode == ResizeMode.SCALE)
            setStretchXY(1, 1);

        _resizeMode = value;
        
        // We need the measured values and _resizeMode affects
        // our measure (skipMeasure implementation checks resizeMode) so
        // we need to invalidate the size.
        invalidateSize();
        
        // Invalidate the display list so that our validateMatrix() gets called.
        invalidateDisplayList();
    } */

    //----------------------------------
    //  mouseOpaque
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the mouseOpaque property
     */
   /*  private var _mouseEnabledWhereTransparent:Boolean = true;
    private var mouseEventReferenceCount:int;

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]
     */
    /**
     *  When <code>true</code>, this property 
     *  ensures that the entire bounds of the Group respond to 
     *  mouse events such as click and roll over.
     * 
     *  This property only goes in to effect if mouse, touch, or
     *  flash player gesture events are added to this instance.  In addition, 
     *  it assumes that the calls to addEventListener()/removeEventListener()
     *  are not superfluous.
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get mouseEnabledWhereTransparent():Boolean
    {
        return _mouseEnabledWhereTransparent;
    } */
    
    /**
     *  @private
     */
    /* public function set mouseEnabledWhereTransparent(value:Boolean):void
    {
        if (value == _mouseEnabledWhereTransparent)
            return;
            
        _mouseEnabledWhereTransparent = value;

        if (_hasMouseListeners)
            invalidateDisplayList();
    } */
     
    /**
     *  @private
     *  Renders a background for the container, if necessary.  It is used to fill in
     *  a transparent background fill as necessary to support the _mouseEnabledWhereTransparent flag.  It 
     *  is also used in ItemRenderers when handleBackgroundColor is set to true.
     *  We assume for now that we are the first layer to be rendered into the graphics
     *  context.
     */
    /* mx_internal function drawBackground():void
    {
        if (!_mouseEnabledWhereTransparent || !_hasMouseListeners)
            return;
        
        var w:Number = (_resizeMode == ResizeMode.SCALE) ? measuredWidth : unscaledWidth;
        var h:Number = (_resizeMode == ResizeMode.SCALE) ? measuredHeight : unscaledHeight;

        if (isNaN(w) || isNaN(h))
            return;

        graphics.clear();
        graphics.beginFill(0xFFFFFF, 0);
        
        if (layout && layout.useVirtualLayout)
            graphics.drawRect(horizontalScrollPosition, verticalScrollPosition, w, h);
        else
        {
            const tileSize:int = 4096;
            const maxX:int = Math.round(Math.max(w, contentWidth));
            const maxY:int = Math.round(Math.max(h, contentHeight));
            for (var x:int = 0; x < maxX; x += tileSize)
                for (var y:int = 0; y < maxY; y += tileSize)
                {
                    var tileWidth:int = Math.min(maxX - x, tileSize);
                    var tileHeight:int = Math.min(maxY - y, tileSize);
                    graphics.drawRect(x, y, tileWidth, tileHeight); 
                }
        }

        graphics.endFill();
    } */

    //----------------------------------
    //  hasMouseListeners
    //----------------------------------
    
   // private var _hasMouseListeners:Boolean = false;
    
    /**
     * @private
     * 
     * This is a protected helper property used when selectively rendering
     * the fill layer for mouseOpaque (we only render when we have active
     * mouse event listeners).
     * 
     */  
    /* mx_internal function set hasMouseListeners(value:Boolean):void
    {
        if (_mouseEnabledWhereTransparent)
            $invalidateDisplayList();
    _hasMouseListeners = value;
    } */
    
    /**
     * @private
     */  
    /* mx_internal function get hasMouseListeners():Boolean
    {
        return _hasMouseListeners;
    } */
        
    /**
     *  @private
     */
    /* override protected function canSkipMeasurement():Boolean
    {
        // We never want to skip measure, if we resize by scaling
        return _resizeMode == ResizeMode.SCALE ? false : super.canSkipMeasurement();
    } */

    /**
     *  @private
     */
    /* override public function invalidateSize():void
    {
        super.invalidateSize();
        layoutInvalidateSizeFlag = true;
    } */

    /**
     *  @private
     */
    /* override public function invalidateDisplayList():void
    {
        super.invalidateDisplayList();
        layoutInvalidateDisplayListFlag = true;
    } */
    
    /**
     *  @private
     *  Called when the child transform changes (currently x and y on UIComponent),
     *  so that the Group has a chance to invalidate the layout. 
     */
    /* override mx_internal function childXYChanged():void
    {
        if (autoLayout)
        {
            invalidateSize();
            invalidateDisplayList();
        }
    } */
    
    /**
     *  @private
     *  Invalidates the size, but doesn't run layout measure pass. This is useful
     *  for subclasses like Group that perform additional work there - like running
     *  the graphic element measure pass.
     */
   /*  mx_internal function $invalidateSize():void
    {
        super.invalidateSize();
    } */
    
    /**
     *  @private
     *  Invalidates the display list, but doesn't run layout updateDisplayList pass.
     *  This is useful for subclasses like Group that perform additional work on
     *  updateDisplayList - like redrawing the graphic elements.
     */
    /* mx_internal function $invalidateDisplayList():void
    {
        super.invalidateDisplayList();
    } */
    
    override public function addedToParent():void
    {
        if (!initialized) {
            // each MXML file can also have styles in fx:Style block
            ValuesManager.valuesImpl.init(this);
        }
        
        super.addedToParent();		
        
        // Load the layout bead if it hasn't already been loaded.
        if (loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this))
        {
            dispatchEvent(new Event("initComplete"));
            if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
                (isWidthSizedToContent() || !isNaN(explicitWidth)))
                dispatchEvent(new Event("layoutNeeded"));
        }
    }
    
    /**
     *  <p>If the layout object has not been set yet, 
     *  createChildren() assigns this container a 
     *  default layout object, BasicLayout.</p>
     *  
     *  @copy mx.core.UIComponent:createChildren()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4.5
     */ 
    override protected function createChildren():void
    {
        if (!layout)
            layout = new BasicLayout();
        
        super.createChildren();
        
        if (getBeadByType(DataBindingBase) == null && mxmlDocument == this)
            addBead(new ContainerDataBinding());
        
        dispatchEvent(new Event("initBindings"));
    }

    /**
     *  @private
     */ 
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        // Cleanup the _overlay object when there are no more overlay objects
       /*  if (_overlay && _overlay.numDisplayObjects == 0)
            destroyOverlay(); */
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        /* if (_layout && layoutInvalidateSizeFlag)
        {
            var oldMeasuredWidth:Number = measuredWidth;
            var oldMeasuredHeight:Number = measuredHeight;
            
            super.measure();
        
            layoutInvalidateSizeFlag = false;
        */
            _layout.measure();
            
        /*
            // Special case: If the group clips content, or resizeMode is "scale"
            // then measured minimum size is zero
            if (clipAndEnableScrolling || resizeMode == ResizeMode.SCALE)
            {
                measuredMinWidth = 0;
                measuredMinHeight = 0;
            }

            // Make sure that we invalidate the display list if the measured
            // size changes, as we always size our content at the measured size when in scale mode.
            if (_resizeMode == ResizeMode.SCALE && (measuredWidth != oldMeasuredWidth || measuredHeight != oldMeasuredHeight))
                invalidateDisplayList();
        } */
    }

    /**
     *  @private
     */
    /* override protected function validateMatrix():void
    {
        // Update the stretchXY before the matrix gets validates
        if (_resizeMode == ResizeMode.SCALE)
        {
            var stretchX:Number = 1;
            var stretchY:Number = 1;            

            if (measuredWidth != 0)
                stretchX = width / measuredWidth;
            if (measuredHeight != 0)
                stretchY = height / measuredHeight;

            setStretchXY(stretchX, stretchY);
        }
        super.validateMatrix();
    } */

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
       /*  var shaderFilter:ShaderFilter; 
        
        if (_resizeMode == ResizeMode.SCALE)
        {
            unscaledWidth = measuredWidth;
            unscaledHeight = measuredHeight;
        }

        super.updateDisplayList(unscaledWidth, unscaledHeight);

        if (maskChanged)
        {
            maskChanged = false;
            if (_mask)
            {
                maskTypeChanged = true;
            
                if (!_mask.parent)
                {
                    // TODO (jszeto): Does this need to be attached to a sibling?
                    overlay.addDisplayObject(_mask, OverlayDepth.MASK);
                    
                    MaskUtil.applyMask(_mask, null);
                }
            }
        }
        
        if (luminositySettingsChanged)
        {
            luminositySettingsChanged = false; 
            
            if (_mask && _maskType == MaskType.LUMINOSITY && _mask.filters.length > 0)
            {
                // Grab the shader filter 
                var shaderFilterIndex:int; 
                var len:int = _mask.filters.length; 
                for (shaderFilterIndex = 0; shaderFilterIndex < len; shaderFilterIndex++)
                {
                    if (_mask.filters[shaderFilterIndex] is ShaderFilter && 
                        ShaderFilter(_mask.filters[shaderFilterIndex]).shader is LuminosityMaskShader)
                    {
                        shaderFilter = _mask.filters[shaderFilterIndex];
                        break; 
                    }
                }
                
                if (shaderFilter && (shaderFilter.shader is LuminosityMaskShader))
                {
                    // Reset the mode property  
                    LuminosityMaskShader(shaderFilter.shader).mode = calculateLuminositySettings();
                    
                    // Re-apply the filter to the mask 
                    _mask.filters[shaderFilterIndex] = shaderFilter; 
                    _mask.filters = _mask.filters; 
                }
            }
        }
        
        if (maskTypeChanged)    
        {
            maskTypeChanged = false;
            
            if (_mask)
            {
                if (_maskType == MaskType.CLIP)
                {
                    // Turn off caching on mask
                    _mask.cacheAsBitmap = false; 
                    // Save the original filters and clear the filters property
                    originalMaskFilters = _mask.filters;
                    _mask.filters = []; 
                }
                else if (_maskType == MaskType.ALPHA)
                {
                    _mask.cacheAsBitmap = true;
                    cacheAsBitmap = true;
                }
                else if (_maskType == MaskType.LUMINOSITY)
                {
                    _mask.cacheAsBitmap = true;
                    cacheAsBitmap = true;
                    
                    // Create the shader class which wraps the pixel bender filter 
                    var luminosityMaskShader:LuminosityMaskShader = new LuminosityMaskShader();
                    
                    // Sets up the shader's mode property based on 
                    // whether the luminosityClip and 
                    // luminosityInvert properties are on or off. 
                    luminosityMaskShader.mode = calculateLuminositySettings(); 
                    
                    // Create the shader filter 
                    shaderFilter = new ShaderFilter(luminosityMaskShader);
                    
                    // Apply the shader filter to the mask
                    _mask.filters = [shaderFilter];
                }
            }
        }     

        if (layoutInvalidateDisplayListFlag)
        {
            layoutInvalidateDisplayListFlag = false;
        */
            if (autoLayout && _layout)
                _layout.updateDisplayList(unscaledWidth, unscaledHeight);
        /*        
            if (_layout)
                _layout.updateScrollRect(unscaledWidth, unscaledHeight);
        } */
    }
    
    /**
     *  @private
     *  Calculates the luminosity mask shader's mode property which 
     *  determines how the shader is drawn. 
     */
    /* private function calculateLuminositySettings():int
    {
        var mode:int = 0;
        if (luminosityInvert)
            mode += 1; 
        if (luminosityClip) 
            mode += 2;  
        return mode; 
    } */
    
    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
        
        if (!enabled && (allStyles || styleProp == "disabledAlpha"))
        {
            var disabledAlpha:Number = getStyle("disabledAlpha");
            
            if (!isNaN(disabledAlpha))
                super.alpha = disabledAlpha;
        }
    }
    
    /**
     *  @private 
     */ 
    override public function globalToLocal(point:Point):Point
    {
		/*
        if (resizeMode == ResizeMode.SCALE && _layoutFeatures != null)
        {
            // If resize mode is scale, then globalToLocal shouldn't account for 
            // stretchX/Y
            var sX:Number = _layoutFeatures.stretchX;
            var sY:Number = _layoutFeatures.stretchY;
            _layoutFeatures.stretchX = 1;
            _layoutFeatures.stretchY = 1;
            //applyComputedMatrix();
            
            var p:Point = super.globalToLocal(point);
            
            // Restore stretch
            _layoutFeatures.stretchX = sX;
            _layoutFeatures.stretchY = sY;
            //applyComputedMatrix();
            
            return p;
        }
        else
        {
            return super.globalToLocal(point);    
        }
		*/
		return null;
    }
    
    /**
     *  @private 
     */ 
    /* override public function localToGlobal(point:Point):Point
    {
        if (resizeMode == ResizeMode.SCALE && _layoutFeatures != null)
        {
            // If resize mode is scale, then localToGlobal shouldn't account for 
            // stretchX/Y
            var sX:Number = _layoutFeatures.stretchX;
            var sY:Number = _layoutFeatures.stretchY;
            _layoutFeatures.stretchX = 1;
            _layoutFeatures.stretchY = 1;
            applyComputedMatrix();
            
            var p:Point = super.localToGlobal(point);
            
            // Restore stretch
            _layoutFeatures.stretchX = sX;
            _layoutFeatures.stretchY = sY;
            applyComputedMatrix();
            
            return p;
        }
        else
        {
            return super.localToGlobal(point);    
        }
    } */
    
    //----------------------------------
    //  horizontal,verticalScrollPositionDelta
    //----------------------------------

    /**
     *  @copy spark.layouts.supportClasses.LayoutBase#getHorizontalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
    {
        return (layout) ? layout.getHorizontalScrollPositionDelta(navigationUnit) : 0;     
    } */
    
    /**
     *  @copy spark.layouts.supportClasses.LayoutBase#getVerticalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
    {
        return (layout) ? layout.getVerticalScrollPositionDelta(navigationUnit) : 0;     
    } */
    
    /**
     *  @private
     *  @copy spark.layouts.supportClasses.LayoutBase#isElementVisible()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4 
     */
    /* mx_internal function isElementVisible(elt:ILayoutElement):Boolean
    {
        return layout && layout.isElementVisible(elt);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  IViewport properties
    //
    //--------------------------------------------------------------------------        

    //----------------------------------
    //  contentWidth
    //---------------------------------- 
    
    private var _contentWidth:Number = 0;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]

    /**
     *  @copy spark.core.IViewport#contentWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get contentWidth():Number 
    {
        return _contentWidth;
    }
    
    /**
     *  @private
     */
    private function setContentWidth(value:Number):void 
    {
        if (value == _contentWidth)
            return;
        var oldValue:Number = _contentWidth;
        _contentWidth = value;
        dispatchPropertyChangeEvent("contentWidth", oldValue, value);        
    }

    //----------------------------------
    //  contentHeight
    //---------------------------------- 
    
    private var _contentHeight:Number = 0;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]

    /**
     *  @copy spark.core.IViewport#contentHeight
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get contentHeight():Number 
    {
        return _contentHeight;
    }
    
    /**
     *  @private
     */
    private function setContentHeight(value:Number):void 
    {            
        if (value == _contentHeight)
            return;
        var oldValue:Number = _contentHeight;
        _contentHeight = value;
        dispatchPropertyChangeEvent("contentHeight", oldValue, value);        
    }

    /**
     *  Sets the <code>contentWidth</code> and <code>contentHeight</code>
     *  properties.
     * 
     *  This method is intended for layout class developers who should
     *  call it from <code>updateDisplayList()</code> methods.
     *
     *  @param width The new value of <code>contentWidth</code>.
     * 
     *  @param height The new value of <code>contentHeight</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function setContentSize(width:Number, height:Number):void
    {
        if ((width == _contentWidth) && (height == _contentHeight))
           return;
        setContentWidth(width);
        setContentHeight(height);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: EventDispatcher
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  We render a transparent background fill by default when we have mouse
     *  listeners.
     */
    /* override public function addEventListener(type:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0,
        useWeakReference:Boolean = false):void
    {
        super.addEventListener(type, listener, useCapture, priority, 
            useWeakReference);

        // This code below is not really accurate for two reasons:
        // 1) MouseEvents bubble so someone up the chain
        //    may be listening for this event, and we woudln't 
        //    detect it here.
        // 2) addEventListener()/removeEventListener() may be called 
        //    multiple times with the same handler and may have no 
        //    real effect on the component, but we're still incrementing
        //    and decrementing the mouseEventReferenceCount here
        //  Neither of these issues seem worth fixing as there aren't 
        //  really great fixes for them, so it's just something we will 
        //  document and live with for now.
        
        // mouse events, then touch events, then gesture events
        switch (type)
        {
            
            case MouseEvent.CLICK:
            case MouseEvent.DOUBLE_CLICK:
            case MouseEvent.MOUSE_DOWN:
            case MouseEvent.MOUSE_MOVE:
            case MouseEvent.MOUSE_OVER:
            case MouseEvent.MOUSE_OUT:
            case MouseEvent.ROLL_OUT:
            case MouseEvent.ROLL_OVER:
            case MouseEvent.MOUSE_UP:
            case MouseEvent.MOUSE_WHEEL:
            case TouchEvent.TOUCH_BEGIN:
            case TouchEvent.TOUCH_END:
            case TouchEvent.TOUCH_MOVE:
            case TouchEvent.TOUCH_OUT:
            case TouchEvent.TOUCH_OVER:
            case TouchEvent.TOUCH_ROLL_OUT:
            case TouchEvent.TOUCH_ROLL_OVER:
            case TouchEvent.TOUCH_TAP:
            case GestureEvent.GESTURE_TWO_FINGER_TAP:
            case PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP:
            case TransformGestureEvent.GESTURE_PAN:
            case TransformGestureEvent.GESTURE_ROTATE:
            case TransformGestureEvent.GESTURE_SWIPE:
            case TransformGestureEvent.GESTURE_ZOOM:
                if (mouseEventReferenceCount++ == 0)
                    hasMouseListeners = true;
        }
    } */

    /**
     *  @private
     *  We no longer render our default transparent background fill when we have 
     *  no mouse listeners.
     */
   /*  override public function removeEventListener( type:String, listener:Function,
        useCapture:Boolean = false):void
    {
        super.removeEventListener(type, listener, useCapture);

        // see comment above in addEventListener()
        // mouse events, then touch events, then gesture events
        switch (type)
        {
            
            case MouseEvent.CLICK:
            case MouseEvent.DOUBLE_CLICK:
            case MouseEvent.MOUSE_DOWN:
            case MouseEvent.MOUSE_MOVE:
            case MouseEvent.MOUSE_OVER:
            case MouseEvent.MOUSE_OUT:
            case MouseEvent.ROLL_OUT:
            case MouseEvent.ROLL_OVER:
            case MouseEvent.MOUSE_UP:
            case MouseEvent.MOUSE_WHEEL:
            case TouchEvent.TOUCH_BEGIN:
            case TouchEvent.TOUCH_END:
            case TouchEvent.TOUCH_MOVE:
            case TouchEvent.TOUCH_OUT:
            case TouchEvent.TOUCH_OVER:
            case TouchEvent.TOUCH_ROLL_OUT:
            case TouchEvent.TOUCH_ROLL_OVER:
            case TouchEvent.TOUCH_TAP:
            case GestureEvent.GESTURE_TWO_FINGER_TAP:
            case PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP:
            case TransformGestureEvent.GESTURE_PAN:
            case TransformGestureEvent.GESTURE_ROTATE:
            case TransformGestureEvent.GESTURE_SWIPE:
            case TransformGestureEvent.GESTURE_ZOOM:
                if (--mouseEventReferenceCount == 0)
                    hasMouseListeners = false;
        }
    } */
    
    /**
     *  @private
     *  Automation requires a version of addEventListener that does not
     *  affect behavior of the underlying component.
     */  
    /* mx_internal function $addEventListener(
                            type:String, listener:Function,
                            useCapture:Boolean = false,
                            priority:int = 0,
                            useWeakReference:Boolean = false):void
    {
        super.addEventListener(type, listener, useCapture,
                               priority, useWeakReference);
    } */

    /**
     *  @private
     *  Automation requires a version of removeEventListener that does not
     *  affect behavior of the underlying component.
     */  
    /* mx_internal function $removeEventListener(
                              type:String, listener:Function,
                              useCapture:Boolean = false):void
    {
        super.removeEventListener(type, listener, useCapture);
    } */
           
    //--------------------------------------------------------------------------
    //
    //  Properties: Overridden Focus management
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  focusPane
    //----------------------------------

    /**
     *  @private
     *  Storage for the focusPane property.
     */
   /*  private var _focusPane:Sprite;

    [Inspectable(environment="none")] */

    /**
     *  @private
     */
    /* override public function get focusPane():Sprite
    {
        return _focusPane;
    } */

    /**
     *  @private
     */
    /* override public function set focusPane(value:Sprite):void
    {
        if (value)
        {
            overlay.addDisplayObject(value, OverlayDepth.FOCUS_PANE);

            value.x = 0;
            value.y = 0;
            value.scrollRect = null;

            _focusPane = value;
        }
        else
        {
            overlay.removeDisplayObject(_focusPane);
             
            // TODO (jszeto): remove mask?  SDK-15310
            _focusPane = null;
        }
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Layout item iteration
    //
    //  Iterators used by Layout objects. For visual items, the layout item
    //  is the item itself. For data items, the layout item is the item renderer
    //  instance that is associated with the item.
    //
    //  These methods and getters are really abstract methods that are 
    //  implemented in Group and DataGroup.  We need them here in BaseGroup 
    //  so that layouts can use these methods.
    //--------------------------------------------------------------------------
    
    /**
     *  @copy mx.core.IVisualElementContainer#numElements
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
    override public function get numElements():int
    {
        return -1;
    } 
     */
    
    /**
     *  @copy mx.core.IVisualElementContainer#getElementAt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /*  public function getElementAt(index:int):IVisualElement
    {
		return null;
    }   */
    
    /**
     *  Layouts that honor the <code>useVirtualLayout</code> flag will use this 
     *  method at updateDisplayList() time to get layout elements that are "in view", 
     *  i.e. that overlap the Group's scrollRect.
     * 
     *  <p>If the element to be returned wasn't already a visible child, i.e. if 
     *  it was created or recycled, and either eltWidth or eltHeight is specified,
     *  then the element's initial size is set with setLayoutBoundsSize() before 
     *  it's validated.  This is important for components, like text, that reflow 
     *  when the layout is justified to the Group's width or height.</p>
     *  
     *  <p>The returned layout element will have been validated.</p>
     * 
     *  <p>This method will lazily create or "recycle" and validate layout
     *  elements as needed.</p>
     * 
     *  <p>This method is not intended to be called directly, layouts that
     *  support virutalization will call it.</p>
     * 
     *  @param index The index of the element to retrieve.
     *  @param eltWidth If specified, the newly created or recycled element's initial width.
     *  @param eltHeight If specified, the newly created or recycled element's initial height.
     *  @return The validated element at the specified index.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function getVirtualElementAt(index:int, eltWidth:Number=NaN, eltHeight:Number=NaN):IVisualElement
    {
        return getElementAt(index) as IVisualElement;            
    }
    
    /**
     *  @copy mx.core.IVisualElementContainer#getElementIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function getElementIndex(element:IVisualElement):int
    {
        return -1;
    } */
    
    /**
     *  Determines whether the specified IVisualElement is a 
     *  child of the container instance or the instance
     *  itself. The search is deep, i.e. if the element is
     *  a child, grandchild, great-grandchild, etc., of this
     *  container, this returns true.
     *  
     *  @param element the child object to test
     *  @return true if the element is a descendant of the container
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4.5
     * 
     */    
    /* public function containsElement(element:IVisualElement):Boolean
    {
        while (element)
        {
            if (element == this)
                return true;
            
            if (element.parent is IVisualElement)
                element = IVisualElement(element.parent);
            else
                return false;
        }
        
        return false;
    } */
    
    //----------------------------------
    //  mask
    //----------------------------------
    
    /* private var _mask:DisplayObject;
    mx_internal var maskChanged:Boolean;
    
    [Inspectable(category="General")] */
    
    /**
     *  Sets the mask. The mask will be added to the display list. The mask must
     *  not already on a display list nor in the elements array.  
     *
     *  @see flash.display.DisplayObject#mask
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    /* override public function get mask():DisplayObject
    {
        return _mask;
    } */
    
    /**
     *  @private
     */ 
    /* override public function set mask(value:DisplayObject):void
    {
        if (_mask !== value)
        {
            if (_mask && _mask.parent === this)
            {
                overlay.removeDisplayObject(_mask);
            }     
            
            _mask = value;
            maskChanged = true;
            invalidateDisplayList();            
        }
        super.mask = value;         
    }  */
    
    //----------------------------------
    //  maskType
    //----------------------------------
    
   /*  private var _maskType:String = MaskType.CLIP;
    private var maskTypeChanged:Boolean;
    private var originalMaskFilters:Array;
    
    [Bindable("propertyChange")]
    [Inspectable(category="General", enumeration="clip,alpha,luminosity", defaultValue="clip")] */
    
    /**
     *  <p>The mask type. Possible values are <code>MaskType.CLIP</code>, <code>MaskType.ALPHA</code> 
     *  or <code>MaskType.LUMINOSITY</code>.</p> 
     *
     *  <p><b>Clip Masking</b></p>
     * 
     *  <p>When masking in clip mode, a clipping masks is reduced to 1-bit.  This means that a mask will 
     *  not affect the opacity of a pixel in the source content; it either leaves the value unmodified, 
     *  if the corresponding pixel in the mask is has a non-zero alpha value, or makes it fully 
     *  transparent, if the mask pixel value has an alpha value of zero.</p>
     * 
     *  <p><b>Alpha Masking</b></p>
     * 
     *  <p>In alpha mode, the opacity of each pixel in the source content is multiplied by the opacity 
     *  of the corresponding region of the mask.  i.e., a pixel in the source content with an opacity of 
     *  1 that is masked by a region of opacity of .5 will have a resulting opacity of .5.  A source pixel 
     *  with an opacity of .8 masked by a region with opacity of .5 will have a resulting opacity of .4.</p>
     * 
     *  <p><b>Luminosity Masking</b></p>
     * 
     *  <p>A luminosity mask, sometimes called a 'soft mask', works very similarly to an alpha mask
     *  except that both the opacity and RGB color value of a pixel in the source content is multiplied
     *  by the opacity and RGB color value of the corresponding region in the mask.</p>
     * 
     *  <p>Luminosity masking is not native to Flash but is common in Adobe Creative Suite tools like Adobe 
     *  Illustrator and Adobe Photoshop. In order to accomplish the visual effect of a luminosity mask in 
     *  Flash-rendered content, a graphic element specifying a luminosity mask actually instantiates a shader
     *  filter that mimics the visual look of a luminosity mask as rendered in Adobe Creative Suite tools.</p>
     * 
     *  <p>Objects being masked by luminosity masks can set properties to control the RGB color value and 
     *  clipping of the mask. See the luminosityInvert and luminosityClip attributes.</p>
     * 
     *  @default MaskType.CLIP 
     *
     *  @see  spark.core.MaskType
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get maskType():String
    {
        return _maskType;
    }
     */
    /**
     *  @private
     */
   /*  public function set maskType(value:String):void
    {
        if (_maskType != value)
        {
            _maskType = value;
            maskTypeChanged = true;
            invalidateDisplayList(); 
        }
    } */
    
    //----------------------------------
    //  luminosityInvert
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the luminosityInvert property.
     */
   // private var _luminosityInvert:Boolean = false; 
    
    /**
     *  @private
     */
   /*  private var luminositySettingsChanged:Boolean;

    [Inspectable(category="General", enumeration="true,false", defaultValue="false")]
     */
    /**
     *  A property that controls the calculation of the RGB 
     *  color value of a graphic element being masked by 
     *  a luminosity mask. If true, the RGB color value of a  
     *  pixel in the source content is inverted and multipled  
     *  by the corresponding region in the mask. If false, 
     *  the source content's pixel's RGB color value is used 
     *  directly. 
     * 
     *  @default false 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get luminosityInvert():Boolean
    {
        return _luminosityInvert;
    } */

    /**
     *  @private
     */
    /* public function set luminosityInvert(value:Boolean):void
    {
        if (_luminosityInvert == value)
            return;

        _luminosityInvert = value;
        luminositySettingsChanged = true;
        invalidateDisplayList(); 
    } */

    //----------------------------------
    //  luminosityClip
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the luminosityClip property.
     */
    /* private var _luminosityClip:Boolean = false; 
    
    [Inspectable(category="General", enumeration="true,false", defaultValue="false")]
     */
    /**
     *  A property that controls whether the luminosity 
     *  mask clips the masked content. This property can 
     *  only have an effect if the graphic element has a 
     *  mask applied to it that is of type 
     *  MaskType.LUMINOSITY.  
     * 
     *  @default false 
     *  @see #maskType 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get luminosityClip():Boolean
    {
        return _luminosityClip;
    } */

    /**
     *  @private
     */
    /* public function set luminosityClip(value:Boolean):void
    {
        if (_luminosityClip == value)
            return;

        _luminosityClip = value;
        luminositySettingsChanged = true;
        invalidateDisplayList();
    } */
    
   /**
     *  @private
     * 
     *  A simple insertion sort.  This works well for small lists (under 12 or so), uses
     *  no aditional memory, and most importantly, is stable, meaning items with comparable
     *  values will stay in the same order relative to each other. For layering, we guarantee
     *  first the layer property, and then the item order, so a stable sort is important (and the 
     *  built in flash sort is not stable).
     */
    /* mx_internal static function sortOnLayer(a:Vector.<IVisualElement>):void
    {
        var len:Number = a.length;
        var tmp:IVisualElement;
        if (len<= 1)
            return;
        for (var i:int = 1;i<len;i++)
        {
            for (var j:int = i;j > 0;j--)
            {
                if ( a[j].depth < a[j-1].depth )
                {
                    tmp = a[j];
                    a[j] = a[j-1];
                    a[j-1] = tmp;
                }
                else
                    break;
            }
        }
    } */
    
}

}
