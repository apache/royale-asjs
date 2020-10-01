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

package spark.components 
{
import mx.core.UIComponent;
import mx.core.IUIComponent;
import spark.components.supportClasses.GroupBase;
import mx.core.mx_internal;
import mx.core.IVisualElement;
/*
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.FlexVersion;
import mx.core.IFlexModule;
import mx.core.IFontContextComponent;
import mx.core.IUIComponent;
import mx.core.IUITextField;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.graphics.shaderClasses.ColorBurnShader;
import mx.graphics.shaderClasses.ColorDodgeShader;
import mx.graphics.shaderClasses.ColorShader;
import mx.graphics.shaderClasses.ExclusionShader;
import mx.graphics.shaderClasses.HueShader;
import mx.graphics.shaderClasses.LuminosityShader;
import mx.graphics.shaderClasses.SaturationShader;
import mx.graphics.shaderClasses.SoftLightShader;
import mx.styles.AdvancedStyleClient;
import mx.styles.IAdvancedStyleClient;
import mx.styles.ISimpleStyleClient;
import mx.styles.IStyleClient;
import mx.styles.StyleProtoChain;

import spark.components.supportClasses.GroupBase;
import spark.core.DisplayObjectSharingMode;
import spark.core.IGraphicElement;
import spark.core.IGraphicElementContainer;
import spark.core.ISharedDisplayObject;
import spark.events.ElementExistenceEvent;

use namespace mx_internal;
*/
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when a visual element is added to the content holder.
 *  <code>event.element</code> is the visual element that was added.
 *
 *  @eventType spark.events.ElementExistenceEvent.ELEMENT_ADD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Event(name="elementAdd", type="spark.events.ElementExistenceEvent")]

/**
 *  Dispatched when a visual element is removed from the content holder.
 *  <code>event.element</code> is the visual element that's being removed.
 *
 *  @eventType spark.events.ElementExistenceEvent.ELEMENT_REMOVE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Event(name="elementRemove", type="spark.events.ElementExistenceEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Color of text shadows.
 * 
 *  @default #FFFFFF
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textShadowColor", type="uint", format="Color", inherit="yes", theme="mobile")]

/**
 *  Alpha of text shadows.
 * 
 *  @default 0.55
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="textShadowAlpha", type="Number",inherit="yes", minValue="0.0", maxValue="1.0", theme="mobile")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------
/*
[Exclude(name="addChild", kind="method")]
[Exclude(name="addChildAt", kind="method")]
[Exclude(name="removeChild", kind="method")]
[Exclude(name="removeChildAt", kind="method")]
[Exclude(name="setChildIndex", kind="method")]
[Exclude(name="swapChildren", kind="method")]
[Exclude(name="swapChildrenAt", kind="method")]
[Exclude(name="numChildren", kind="property")]
[Exclude(name="getChildAt", kind="method")]
[Exclude(name="getChildIndex", kind="method")]
*/
//--------------------------------------
//  Other metadata
//--------------------------------------

//[ResourceBundle("components")]

[DefaultProperty("mxmlContent")] 

//[IconFile("Group.png")]

/**
 *  The Group class is the base container class for visual elements.
 *  The Group container takes as children any components that implement 
 *  the IUIComponent interface, and any components that implement 
 *  the IGraphicElement interface. 
 *  Use this container when you want to manage visual children, 
 *  both visual components and graphical components. 
 *
 *  <p>To improve performance and minimize application size, 
 *  the Group container cannot be skinned. 
 *  If you want to apply a skin, use the SkinnableContainer instead.</p>
 * 
 *  <p><b>Note:</b> The scale grid might not function correctly when there 
 *  are DisplayObject children inside of the Group, such as a component 
 *  or another Group.  If the children are GraphicElement objects, and 
 *  they all share the Group's DisplayObject, then the scale grid works 
 *  properly.</p> 
 * 
 *  <p>Setting any of the following properties on a GraphicElement child
 *  requires that GraphicElement to create its own DisplayObject,
 *  thus negating the scale grid properties on the Group.</p>  
 * 
 *  <pre>
 *  alpha
 *  blendMode other than BlendMode.NORMAL or "auto"
 *  colorTransform
 *  filters
 *  mask
 *  matrix
 *  rotation
 *  scaling
 *  3D properties
 *  bounds outside the extent of the Group
 *  </pre>
 *
 *  <p>The Group container has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *  </table>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:Group&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:Group
 *    <strong>Properties</strong>
 *    blendMode="auto"
 *    mxmlContent="null"
 *    scaleGridBottom="null"
 *    scaleGridLeft="null"
 *    scaleGridRight="null"
 *    scaleGridTop="null"
 *  
 *    <strong>Events</strong>
 *    elementAdd="<i>No default</i>"
 *    elementRemove="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.DataGroup
 *  @see spark.components.SkinnableContainer
 *
 *  @includeExample examples/GroupExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Group extends GroupBase /*implements IVisualElementContainer, 
                                                IGraphicElementContainer, 
                                                ISharedDisplayObject*/
{
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Group():void
    {
        super();    
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /*private var needsDisplayObjectAssignment:Boolean = false;
    private var layeringMode:uint = ITEM_ORDERED_LAYERING;
    private var numGraphicElements:uint = 0;
    private var deferredStyleClients:Dictionary = null;  // of IAdvancedStyleClient
    
    private static const ITEM_ORDERED_LAYERING:uint = 0;
    private static const SPARSE_LAYERING:uint = 1;    */

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
   
    /**
     *  @private
     */
    override public function set width(value:Number):void
    {
        /*if (_width != value)
        {
            if (mouseEnabledWhereTransparent && hasMouseListeners)
            {        
                // Re-render our mouse event fill if necessary.
                redrawRequested = true;
                super.$invalidateDisplayList();
            }
        }*/
        super.width = value;
    }
   
    public function set mouseEnabledWhereTransparent(value:Boolean):void
    {
	// not implemented
    }
    /**
     *  @private
     */
    override public function set height(value:Number):void
    {
        /*if (_height != value)
        {
            if (mouseEnabledWhereTransparent && hasMouseListeners)
            {        
                // Re-render our mouse event fill if necessary.
                redrawRequested = true;
                super.$invalidateDisplayList();
            }
        }*/
        super.height = value;
    }
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  alpha
    //----------------------------------

    [Inspectable(defaultValue="1.0", category="General", verbose="1")]

    /**
     *  @private
     */
    override public function set alpha(value:Number):void
    {
        if (super.alpha == value)
            return;
        
        /*if (_blendMode == "auto")
        {
            // If alpha changes from an opaque/transparent (1/0) and translucent
            // (0 < value < 1), then trigger a blendMode change
            if ((value > 0 && value < 1 && (super.alpha == 0 || super.alpha == 1)) ||
                ((value == 0 || value == 1) && (super.alpha > 0 && super.alpha < 1)))
            {
                blendModeChanged = true;
                invalidateDisplayObjectOrdering();
                invalidateProperties();
            }
        }*/
        
        super.alpha = value;
    }
    
    //----------------------------------
    //  blendMode
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the blendMode property.
     */
	private var _blendMode:String = "auto";  
    private var blendModeChanged:Boolean;
    private var blendShaderChanged:Boolean;

    [Inspectable(category="General", enumeration="auto,add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity", defaultValue="auto")]
	/**
     *  A value from the BlendMode class that specifies which blend mode to use. 
     *  A bitmap can be drawn internally in two ways. 
     *  If you have a blend mode enabled or an external clipping mask, the bitmap is drawn 
     *  by adding a bitmap-filled square shape to the vector render. 
     *  If you attempt to set this property to an invalid value, 
     *  Flash Player or Adobe AIR sets the value to <code>BlendMode.NORMAL</code>. 
     *
     *  <p>A value of "auto" (the default) is specific to Group's use of 
     *  blendMode and indicates that the underlying blendMode should be 
     *  <code>BlendMode.NORMAL</code> except when <code>alpha</code> is not
     *  equal to either 0 or 1, when it is set to <code>BlendMode.LAYER</code>. 
     *  This behavior ensures that groups have correct
     *  compositing of their graphic objects when the group is translucent.</p>
     * 
     *  @default "auto"
     *
     *  @see flash.display.DisplayObject#blendMode
     *  @see flash.display.BlendMode
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
	COMPILE::JS
    /*override*/ public function get blendMode():String
    {
        return _blendMode; 
    }
    /**
     *  @private
     */
	COMPILE::JS
    /*override*/ public function set blendMode(value:String):void
    {
        if (value == _blendMode)
            return;
        
        invalidateProperties();
        blendModeChanged = true;
        
        //The default blendMode in FXG is 'auto'. There are only
        //certain cases where this results in a rendering difference,
        //one being when the alpha of the Group is > 0 and < 1. In that
        //case we set the blendMode to layer to avoid the performance
        //overhead that comes with a non-normal blendMode. 
        
        if (value == "auto")
        {
            _blendMode = value;
            // SDK-29631: Use super.$blendMode instead of super.blendMode
            // since Group completely overrides blendMode and we 
            // want to bypass the extra logic in UIComponent which
            // has its own override.
            // TODO (egeorgie): figure out whether we can share some
            // of that logic in the future.
            /*if (((alpha > 0 && alpha < 1) && super.$blendMode != BlendMode.LAYER) ||
                ((alpha == 1 || alpha == 0) && super.$blendMode != BlendMode.NORMAL) )
            {
                invalidateDisplayObjectOrdering();
            }*/
        }
        else 
        {
            var oldValue:String = _blendMode;
            _blendMode = value;
            
            // If one of the non-native Flash blendModes is set, 
            // record the new value and set the appropriate 
            // blendShader on the display object. 
            /*if (isAIMBlendMode(value))
            {
                blendShaderChanged = true;
            }*/
        
            // Only need to re-do display object assignment if blendmode was normal
            // and is changing to something else, or the blend mode was something else 
            // and is going back to normal.  This is because display object sharing
            // only happens when blendMode is normal.
            /*if ((oldValue == BlendMode.NORMAL || value == BlendMode.NORMAL) && 
                !(oldValue == BlendMode.NORMAL && value == BlendMode.NORMAL))
            {
                invalidateDisplayObjectOrdering();
            }*/
        
        }
    }
	
    //----------------------------------
    //  mxmlContent
    //----------------------------------
    private var mxmlContentChanged:Boolean = false;
    private var _mxmlContent:Array;

    //[ArrayElementType("mx.core.IVisualElement")]
	
    /**
     *  The visual content children for this Group.
     * 
     *  This method is used internally by Flex and is not intended for direct
     *  use by developers.
     *
     *  <p>The content items should only be IVisualElement objects.  
     *  An <code>mxmlContent</code> Array should not be shared between multiple
     *  Group containers because visual elements can only live in one container 
     *  at a time.</p>
     * 
     *  <p>If the content is an Array, do not modify the Array 
     *  directly. Use the methods defined by the Group class instead.</p>
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    public function set mxmlContent(value:Array):void
    {
        if (createChildrenCalled)
        {
            setMXMLContent(value);
        }
        else
        {
            mxmlContentChanged = true;
            _mxmlContent = value;
            // we will validate this in createChildren();
        }
    }
     */
    
    /**
     *  @private
     */
    mx_internal function getMXMLContent():Array
    {
        if (_mxmlContent)
            return _mxmlContent.concat();
        else
            return null;
    }
   /**
     *  @private
     *  Adds the elements in <code>mxmlContent</code> to the Group.
     *  Flex calls this method automatically; you do not call it directly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    private function setMXMLContent(value:Array):void
    {
        var i:int;
        
        // if there's old content and it's different than what 
        // we're trying to set it to, then let's remove all the old 
        // elements first.
        /*
        if (_mxmlContent != null && _mxmlContent != value)
        {
            for (i = _mxmlContent.length - 1; i >= 0; i--)
            {
                elementRemoved(_mxmlContent[i], i);
            }
        }
        */
        
        _mxmlContent = (value) ? value.concat() : null;  // defensive copy
        
        if (_mxmlContent != null)
        {
            var n:int = _mxmlContent.length;
            for (i = 0; i < n; i++)
            {   
                var elt:IVisualElement = _mxmlContent[i];

                // A common mistake is to bind the viewport property of a Scroller
                // to a group that was defined in the MXML file with a different parent    
                /*if (elt.parent && (elt.parent != this))
                    throw new Error(resourceManager.getString("components", "mxmlElementNoMultipleParents", [elt]));

                elementAdded(elt, i);*/
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        /*invalidatePropertiesFlag = false;
        
        if (blendModeChanged)
        {
            blendModeChanged = false;
            
            // Figure out the correct blendMode value
            // to set. 
            // SDK-29631: Use super.$blendMode instead of super.blendMode
            // since Group completely overrides blendMode and we 
            // want to bypass the extra logic in UIComponent which
            // has its own override.
            // TODO (egeorgie): figure out whether we can share some
            // of that logic in the future.
            if (_blendMode == "auto")
            {
                if (alpha == 0 || alpha == 1) 
                    super.$blendMode = BlendMode.NORMAL;
                else
                    super.$blendMode = BlendMode.LAYER;
            }
            else if (!isAIMBlendMode(_blendMode))
            {
                super.$blendMode = _blendMode;
            }
            
            if (blendShaderChanged) 
            {
                // The graphic element's blendMode was set to a non-Flash 
                // blendMode. We mimic the look by instantiating the 
                // appropriate shader class and setting the blendShader
                // property on the displayObject. 
                blendShaderChanged = false; 
                switch(_blendMode)
                {
                    case "color": 
                    {
                        super.blendShader = new ColorShader();
                        break; 
                    }
                    case "colordodge":
                    {
                        super.blendShader = new ColorDodgeShader();
                        break; 
                    }
                    case "colorburn":
                    {
                        super.blendShader = new ColorBurnShader();
                        break; 
                    }
                    case "exclusion":
                    {
                        super.blendShader = new ExclusionShader();
                        break; 
                    }
                    case "hue":
                    {
                        super.blendShader = new HueShader();
                        break; 
                    }
                    case "luminosity":
                    {
                        super.blendShader = new LuminosityShader();
                        break; 
                    }
                    case "saturation": 
                    {
                        super.blendShader = new SaturationShader();
                        break; 
                    }
                    case "softlight":
                    {
                        super.blendShader = new SoftLightShader();
                        break; 
                    }
                }
            }
        }
        
        // Due to dependent properties alpha and blendMode there may be a need
        // for a second pass at committing properties (to ensure our new
        // blendMode or blendShader is assigned to our underlying display 
        // object).
        /*if (invalidatePropertiesFlag)
        {
            super.commitProperties();
            invalidatePropertiesFlag = false;
        }
        
        if (needsDisplayObjectAssignment)
        {
            needsDisplayObjectAssignment = false;
            assignDisplayObjects();
        }
        
        if (scaleGridChanged)
        {
            // Don't reset scaleGridChanged since we also check it in updateDisplayList
            if (isValidScaleGrid())
                resizeMode = ResizeMode.SCALE; // Force the resizeMode to scale 
        }*/
    }
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // let user's code (layout) run first before dealing with graphic element 
        // sharing because that's when redraws can be requested
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        // Clear the group's graphic because graphic elements might be drawing to it
        // This isn't needed for DataGroup because there's no DisplayObject sharing
        // This code exists in updateDisplayList() as opposed to validateDisplayList() 
        // because of compatibility issues since most of this code was 
        // refactored from updateDisplayList() and in to validateDisplayList().  User's code 
        // already assumed that they could call super.updateDisplayList() and then be able to draw 
        // into the Group's graphics object.  Because of that, the graphics.clear() call is left 
        // in updateDisplayList() instead of in validateDisplayList() with the rest of the graphic 
        // element sharing code.
        /*var sharedDisplayObject:ISharedDisplayObject = this;
        if (sharedDisplayObject.redrawRequested)
        {
            // clear the graphics here.  The pattern is usually to call graphics.clear() 
            // before calling super.updateDisplayList() so what happens in super.updateDisplayList() 
            // isn't erased.  However, in this case, what happens in super.updateDisplayList() isn't 
            // much, and we want to make sure super.updateDisplayList() runs first since the layout 
            // is what actually triggers the the shareDisplayObject to request to be redrawn.
            graphics.clear();
            drawBackground();
            
            // If a scaleGrid is set, make sure the extent of the groups bounds are filled so
            // the player will scale our contents as expected. 
            if (isValidScaleGrid() && resizeMode == ResizeMode.SCALE)
            {
                graphics.lineStyle();
                graphics.beginFill(0, 0);
                graphics.drawRect(0, 0, 1, 1);
                graphics.drawRect(measuredWidth - 1, measuredHeight - 1, 1, 1);
                graphics.endFill();
            }
        }*/
        
        /*if (scaleGridChanged)
        {
            scaleGridChanged = false;
        
            if (isValidScaleGrid())
            {
                // Check for DisplayObjects other than overlays
                var overlayCount:int = _overlay ? _overlay.numDisplayObjects : 0;
                if (numChildren - overlayCount > 0)
                    throw new Error(resourceManager.getString("components", "scaleGridGroupError"));

                super.scale9Grid = new Rectangle(scaleGridLeft, 
                                                 scaleGridTop,    
                                                 scaleGridRight - scaleGridLeft, 
                                                 scaleGridBottom - scaleGridTop);
            } 
            else
            {
                super.scale9Grid = null;
            }                              
        }*/
    }

}
}
