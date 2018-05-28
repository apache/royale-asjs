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
import mx.core.IVisualElement;
import mx.core.UIComponent;
//import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;
//import mx.graphics.shaderClasses.LuminosityMaskShader;

//import spark.components.ResizeMode;
//import spark.core.IViewport;
//import spark.core.MaskType;
//import spark.events.DisplayLayerObjectExistenceEvent;
//import spark.layouts.BasicLayout;
//import spark.layouts.supportClasses.LayoutBase;
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
public class GroupBase extends UIComponent 
{ //implements IViewport

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
        
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  alpha
    //----------------------------------
    
    private var _explicitAlpha:Number = 1.0;
    
    /**
     *  @private
     */
    override public function set alpha(value:Number):void
    {
        if (enabled)
            super.alpha = value;
        _explicitAlpha = value;
    } 
    
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
    private var _layoutProperties:Object = null;
    /*private var layoutInvalidateSizeFlag:Boolean = false;
    private var layoutInvalidateDisplayListFlag:Boolean = false;
    
    [Inspectable(category="General")] */
    
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
    public function set layout(value:Object):void//LayoutBase):void
    {
        if (_layout == value)
            return;
        
        if (_layout)
        {
            _layout.target = null;
            //_layout.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);

            if (clipAndEnableScrollingExplicitlySet)
            {
                // when the layout changes, we don't want to transfer over 
                // horizontalScrollPosition and verticalScrollPosition
                _layoutProperties = {clipAndEnableScrolling: _layout.clipAndEnableScrolling};
            }
        }

        _layout = value; 

        if (_layout)
        {
            _layout.target = this;
            //_layout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);

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
        invalidateDisplayList();
    }
    
    //----------------------------------
    //  clipAndEnableScrolling
    //----------------------------------

    private var clipAndEnableScrollingExplicitlySet:Boolean = false;
    
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
        if (_layout)
        {
            return _layout.clipAndEnableScrolling;
        }
        else if (_layoutProperties && 
                _layoutProperties.clipAndEnableScrolling !== undefined)
        {
            return _layoutProperties.clipAndEnableScrolling;
        }
        else
        {
            return false;
        }
    }

    /**
     *  @private
     */
    public function set clipAndEnableScrolling(value:Boolean):void 
    {
        clipAndEnableScrollingExplicitlySet = true;
        if (_layout)
        {
            _layout.clipAndEnableScrolling = value;
        }
        else if (_layoutProperties)
        {
            _layoutProperties.clipAndEnableScrolling = value;
        }
        else
        {
            _layoutProperties = {clipAndEnableScrolling: value};
        }

        // clipAndEnableScrolling affects measured minimum size
        invalidateSize();
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
            _layout.measure();
            
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
            if (autoLayout && _layout)
                _layout.updateDisplayList(unscaledWidth, unscaledHeight);
                
            if (_layout)
                _layout.updateScrollRect(unscaledWidth, unscaledHeight);
        } */
    }
    
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
    
    //----------------------------------
    //  mask
    //----------------------------------
    
    private var _mask:Object;//DisplayObject;
    /*mx_internal var maskChanged:Boolean;
    
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
	COMPILE::JS
    /*override*/ public function get mask():Object//:DisplayObject
    {
        return _mask;
    }
    
    /**
     *  @private
     */ 
	COMPILE::JS
    /*override*/ public function set mask(value:Object):void//DisplayObject):void
    {
        if (_mask !== value)
        {
            /*if (_mask && _mask.parent === this)
            {
                overlay.removeDisplayObject(_mask);
            }     */
            
            _mask = value;
            //maskChanged = true;
            invalidateDisplayList();            
        }
        //super.mask = value;         
    } 
    
}

}
