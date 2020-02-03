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

import spark.components.beads.SkinnableContainerView;
import mx.containers.beads.models.PanelModel;
import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.core.mx_internal;

import org.apache.royale.core.IBeadView;
import org.apache.royale.core.IChild;
import org.apache.royale.core.IParent;
import org.apache.royale.events.Event;
import org.apache.royale.events.ValueEvent;

//import mx.utils.BitFlagUtil;

//import spark.core.IDisplayText;
//import spark.layouts.supportClasses.LayoutBase;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  The alpha of the border for this component.
 *
 *  @default 0.5
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="borderAlpha", type="Number", inherit="no", theme="spark")]

/**
 *  The color of the border for this component.
 *
 *  @default 0
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="spark")]

/**
 *  Controls the visibility of the border for this component.
 *
 *  @default true
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Style(name="borderVisible", type="Boolean", inherit="no")]

/**
 *  The radius of the corners for this component.
 *
 *  @default 0
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="spark")]

/**
 *  Controls the visibility of the drop shadow for this component.
 *
 *  @default true
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Style(name="dropShadowVisible", type="Boolean", inherit="no", theme="spark")]

//--------------------------------------
//  Skin states
//--------------------------------------

/**
 *  Normal State of the Panel
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("normal")]

/**
 *  Disabled State of the Panel
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("disabled")]

/**
 *  Normal State with ControlBar of the Panel
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("normalWithControlBar")]

/**
 *  Disabled State with ControlBar of the Panel
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("disabledWithControlBar")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.PanelAccImpl")]

//[IconFile("Panel.png")]

/**
 * Because this component does not define a skin for the mobile theme, Adobe
 * recommends that you not use it in a mobile application. Alternatively, you
 * can define your own mobile skin for the component. For more information,
 * see <a href="http://help.adobe.com/en_US/flex/mobileapps/WS19f279b149e7481c698e85712b3011fe73-8000.html">Basics of mobile skinning</a>.
 */
//[DiscouragedForProfile("mobileDevice")]

/**
 *  The Panel class defines a container that includes a title bar, 
 *  a caption, a border, and a content area for its children.
 *
 *  <p>The panel container has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
 *     <tr><td>Minimum size</td><td>131 pixels wide and 127 pixels high</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *  </table>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;s:Panel&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;s:Panel
 *   <strong>Properties</strong>
 *    controlBarContent="null"
 *    controlBarLayout="HorizontalLayout"
 *    controlBarVisible="true"
 *    title=""
 * 
 *   <strong>Styles</strong>
 *    borderAlpha="0.5"
 *    borderColor="0"
 *    borderVisible="true"
 *    cornerRadius="0"
 *    dropShadowVisible="true"
 *   &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/s:Panel&gt;
 *  </pre>
 *
 *  @includeExample examples/PanelExample.mxml
 *
 *  @see SkinnableContainer
 *  @see spark.skins.spark.PanelSkin
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class Panel extends SkinnableContainer
{
   // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    //mx_internal static const CONTROLBAR_PROPERTY_FLAG:uint = 1 << 0;
    
    /**
     *  @private
     */
   // mx_internal static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
    
    /**
     *  @private
     */
   // mx_internal static const VISIBLE_PROPERTY_FLAG:uint = 1 << 2;
    
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Placeholder for mixin by PanelAccImpl.
     */
   // mx_internal static var createAccessibilityImplementation:Function;
    
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
    public function Panel()
    {
        super();
        typeNames += " Panel";

        // default skin uses graphical dropshadow which 
        // we don't want to be hittable
       // mouseEnabled = false;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables 
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Several properties are proxied to controlBarGroup.  However, when controlBarGroup
     *  is not around, we need to store values set on SkinnableContainer.  This object 
     *  stores those values.  If controlBarGroup is around, the values are stored 
     *  on the controlBarGroup directly.  However, we need to know what values 
     *  have been set by the developer on the SkinnableContainer (versus set on 
     *  the controlBarGroup or defaults of the controlBarGroup) as those are values 
     *  we want to carry around if the controlBarGroup changes (via a new skin). 
     *  In order to store this info effeciently, controlBarGroupProperties becomes 
     *  a uint to store a series of BitFlags.  These bits represent whether a 
     *  property has been explicitely set on this SkinnableContainer.  When the 
     *  controlBarGroup is not around, controlBarGroupProperties is a typeless 
     *  object to store these proxied properties.  When controlBarGroup is around,
     *  controlBarGroupProperties stores booleans as to whether these properties 
     *  have been explicitely set or not.
     */
   // mx_internal var controlBarGroupProperties:Object = { visible: true };
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts 
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  controlBarGroup
    //---------------------------------- 
    
   // [SkinPart(required="false")]
    
    /**
     *  The skin part that defines the appearance of the 
     *  control bar area of the container.
     *  By default, the PanelSkin class defines the control bar area to appear at the bottom 
     *  of the content area of the Panel container with a grey background. 
     *
     *  @see spark.skins.spark.PanelSkin
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   // public var controlBarGroup:Group;
    
    //----------------------------------
    //  titleField
    //---------------------------------- 
    
    [SkinPart(required="false")]
    
    /**
     *  The skin part that defines the appearance of the 
     *  title text in the container.
     *
     *  @see spark.skins.spark.PanelSkin
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public var titleDisplay:Label; //IDisplayText;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  baselinePosition
    //----------------------------------
    
    /**
     *  @private
     */
   /*  override public function get baselinePosition():Number
    {
        return getBaselinePositionForPart(titleDisplay as IVisualElement);
    }  */
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  controlBarContent
    //---------------------------------- 
    
    //[ArrayElementType("mx.core.IVisualElement")]
    
    /**
     *  The set of components to include in the control bar area of the 
     *  Panel container. 
     *  The location and appearance of the control bar area of the Panel container 
     *  is determined by the spark.skins.spark.PanelSkin class. 
     *  By default, the PanelSkin class defines the control bar area to appear at the bottom 
     *  of the content area of the Panel container with a grey background. 
     *  Create a custom skin to change the default appearance of the control bar.
     *
     *  @default null
     *
     *  @see spark.skins.spark.PanelSkin
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function get controlBarContent():Array
    {
        if (controlBarGroup)
            return controlBarGroup.getMXMLContent();
        else
            return controlBarGroupProperties.controlBarContent;
    } */
    
    /**
     *  @private
     */
    /* public function set controlBarContent(value:Array):void
    {
        if (controlBarGroup)
        {
            controlBarGroup.mxmlContent = value;
            controlBarGroupProperties = BitFlagUtil.update(controlBarGroupProperties as uint, 
                CONTROLBAR_PROPERTY_FLAG, value != null);
        }
        else
            controlBarGroupProperties.controlBarContent = value;
        
        invalidateSkinState();
    } */
    
    //----------------------------------
    //  controlBarLayout
    //---------------------------------- 
    
    /**
     *  Defines the layout of the control bar area of the container.
     *
     *  @default HorizontalLayout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get controlBarLayout():LayoutBase
    {
        return (controlBarGroup) 
        ? controlBarGroup.layout 
            : controlBarGroupProperties.layout;
    } */
    
    /**
     *  @private
     */
    /* public function set controlBarLayout(value:LayoutBase):void
    {
        if (controlBarGroup)
        {
            controlBarGroup.layout = value;
            controlBarGroupProperties = BitFlagUtil.update(controlBarGroupProperties as uint, 
                LAYOUT_PROPERTY_FLAG, true);
        }
        else
            controlBarGroupProperties.layout = value;
    } */
    
    //----------------------------------
    //  controlBarVisible
    //---------------------------------- 
    
    /**
     *  If <code>true</code>, the control bar is visible.
     *  The flag has no affect if there is no value set for
     *  the <code>controlBarContent</code> property.
     *
     *  <p><b>Note:</b> The Panel container does not monitor the 
     *  <code>controlBarGroup</code> property. 
     *  If other code makes it invisible, the Panel container 
     *  might not update correctly.</p>
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get controlBarVisible():Boolean
    {
        return (controlBarGroup) 
        ? controlBarGroup.visible 
            : controlBarGroupProperties.visible;
    } */
    
    /**
     *  @private
     */
    /* public function set controlBarVisible(value:Boolean):void
    {
        if (controlBarGroup)
        {
            controlBarGroup.visible = value;
            controlBarGroupProperties = BitFlagUtil.update(controlBarGroupProperties as uint, 
                VISIBLE_PROPERTY_FLAG, value);
        }
        else
            controlBarGroupProperties.visible = value;
        
        invalidateSkinState();
        if (skin)
            skin.invalidateSize();
    } */
    
    //----------------------------------
    //  title
    //----------------------------------
        
    [Bindable]
    [Inspectable(category="General", defaultValue="")]
    
    /**
     *  Title or caption displayed in the title bar. 
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get title():String
    {
        return (model as PanelModel).title;
    }
    
    /**
     *  @private
     *  @royaleignorecoercion mx.containers.beads.models.PanelModel
     */
    public function set title(value:String):void
    {
        (model as PanelModel).title = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /* override protected function initializeAccessibility():void
    {
        if (Panel.createAccessibilityImplementation != null)
            Panel.createAccessibilityImplementation(this);
    } */
    
    /**
     *  @private
     */
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == titleDisplay)
        {
            titleDisplay.text = title;
        }
        else if (instance == controlBarGroup)
        {
            // copy proxied values from controlBarGroupProperties (if set) to contentGroup
            var newControlBarGroupProperties:uint = 0;
            
            if (controlBarGroupProperties.controlBarContent !== undefined)
            {
                controlBarGroup.mxmlContent = controlBarGroupProperties.controlBarContent;
                newControlBarGroupProperties = BitFlagUtil.update(newControlBarGroupProperties, 
                    CONTROLBAR_PROPERTY_FLAG, true);
            }
            
            if (controlBarGroupProperties.layout !== undefined)
            {
                controlBarGroup.layout = controlBarGroupProperties.layout;
                newControlBarGroupProperties = BitFlagUtil.update(newControlBarGroupProperties, 
                    LAYOUT_PROPERTY_FLAG, true);
            }
            
            if (controlBarGroupProperties.visible !== undefined)
            {
                controlBarGroup.visible = controlBarGroupProperties.visible;
                newControlBarGroupProperties = BitFlagUtil.update(newControlBarGroupProperties, 
                    VISIBLE_PROPERTY_FLAG, true);
            }
            
            controlBarGroupProperties = newControlBarGroupProperties;
        }
    } */
    
    /**
     *  @private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        
        if (instance == controlBarGroup)
        {
            // copy proxied values from contentGroup (if explicitely set) to contentGroupProperties
            
            var newControlBarGroupProperties:Object = {};
            
            if (BitFlagUtil.isSet(controlBarGroupProperties as uint, CONTROLBAR_PROPERTY_FLAG))
                newControlBarGroupProperties.controlBarContent = controlBarGroup.getMXMLContent();
            
            if (BitFlagUtil.isSet(controlBarGroupProperties as uint, LAYOUT_PROPERTY_FLAG))
                newControlBarGroupProperties.layout = controlBarGroup.layout;
            
            if (BitFlagUtil.isSet(controlBarGroupProperties as uint, VISIBLE_PROPERTY_FLAG))
                newControlBarGroupProperties.visible = controlBarGroup.visible;
            
            controlBarGroupProperties = newControlBarGroupProperties;
            
            controlBarGroup.mxmlContent = null;
            controlBarGroup.layout = null;
        }
    } */
    
    /**
     *  @private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function getCurrentSkinState():String
    {
        var state:String = enabled ? "normal" : "disabled";
        if (controlBarGroup)
        {
            if (BitFlagUtil.isSet(controlBarGroupProperties as uint, CONTROLBAR_PROPERTY_FLAG) &&
                BitFlagUtil.isSet(controlBarGroupProperties as uint, VISIBLE_PROPERTY_FLAG))
                state += "WithControlBar";
        }
        else
        {
            if (controlBarGroupProperties.controlBarContent &&
                controlBarGroupProperties.visible)
                state += "WithControlBar";
        }
        
        return state;
    } */
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     * @royaleignorecoercion org.apache.royale.core.IParent
    override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        (panelView.contentView as IParent).addElement(c, dispatchEvent);
        if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth)))
            this.dispatchEvent(new Event("layoutNeeded"));
    }
     */
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
    override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        (panelView.contentView as IParent).addElementAt(c, index, dispatchEvent);
        if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth)))
            this.dispatchEvent(new Event("layoutNeeded"));
    }
     */
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
    override public function getElementIndex(c:IChild):int
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        return (panelView.contentView as IParent).getElementIndex(c);
    }
     */
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
    override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        (panelView.contentView as IParent).removeElement(c, dispatchEvent);
    }
     */
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
    override public function get numElements():int
    {
        // the view getter below will instantiate the view which can happen
        // earlier than we would like (when setting mxmlDocument) so we
        // see if the view bead exists on the strand.  If not, nobody
        // has added any children so numElements must be 0
        if (!getBeadByType(IBeadView))
            return 0;
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        return (panelView.contentView as IParent).numElements;
    }
     */
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
    override public function getElementAt(index:int):IChild
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        return (panelView.contentView as IParent).getElementAt(index);
    }
     */
    
    // override and proxy to content area.  Otherwise Panel's TitleBar and other chrome will
    // have this padding between the border and chrome
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function get paddingLeft():Object
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        var contentView:UIComponent = panelView.contentView as UIComponent;
        return contentView.paddingLeft;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set paddingLeft(value:Object):void
    {
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingLeft = value as String;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.paddingLeft = value;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function get paddingRight():Object
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        var contentView:UIComponent = panelView.contentView as UIComponent;
        return contentView.paddingRight;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set paddingRight(value:Object):void
    {
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingRight = value as String;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.paddingRight = value;
        }
    }
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function get paddingTop():Object
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        var contentView:UIComponent = panelView.contentView as UIComponent;
        return contentView.paddingTop;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set paddingTop(value:Object):void
    {
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingTop = value as String;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.paddingTop = value;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function get paddingBottom():Object
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        var contentView:UIComponent = panelView.contentView as UIComponent;
        return contentView.paddingBottom;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set paddingBottom(value:Object):void
    {
        
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingBottom = value as String;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.paddingBottom = value;
        }
    }
    
    // because padding creates the view early, the setuplayout logic
    // may get run before percentWidth/Height are set, so we have
    // to make sure the contentArea gets set up correctly
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set percentWidth(value:Number):void
    {
        super.percentWidth = value;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.percentWidth = 100;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set explicitWidth(value:Number):void
    {
        super.explicitWidth = value;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.percentWidth = 100;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set percentHeight(value:Number):void
    {
        super.percentHeight = value;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.percentHeight = 100;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function set explicitHeight(value:Number):void
    {
        super.explicitHeight = value;
        if (parent)
        {
            var panelView:SkinnableContainerView = view as SkinnableContainerView;
            var contentView:UIComponent = panelView.contentView as UIComponent;
            contentView.percentHeight = 100;
        }
    }
    
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     */
    override public function childrenAdded():void
    {
        var panelView:SkinnableContainerView = view as SkinnableContainerView;
        var contentView:UIComponent = panelView.contentView as UIComponent;
        contentView.dispatchEvent(new ValueEvent("childrenAdded"));
        super.childrenAdded();
    }

    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == titleDisplay)
        {
            titleDisplay.text = title;
        }
    }
}
}
