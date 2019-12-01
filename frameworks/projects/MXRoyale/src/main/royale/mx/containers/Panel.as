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

package mx.containers
{

/*
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextLineMetrics;
import flash.utils.getQualifiedClassName;
import mx.automation.IAutomationObject;
import mx.containers.utilityClasses.BoxLayout;
import mx.containers.utilityClasses.CanvasLayout;
import mx.containers.utilityClasses.ConstraintColumn;
import mx.containers.utilityClasses.ConstraintRow;
import mx.containers.utilityClasses.IConstraintLayout;
import mx.containers.utilityClasses.Layout;
import mx.controls.Button;
import mx.core.EdgeMetrics;
import mx.core.EventPriority;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IFontContextComponent;
import mx.core.IUIComponent;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UIComponentCachePolicy;
import mx.core.UITextField;
import mx.core.UITextFormat;
import mx.core.mx_internal;
import mx.effects.EffectManager;
import mx.events.CloseEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.ISystemManager;
import mx.styles.ISimpleStyleClient;
import mx.styles.IStyleClient;
import mx.styles.StyleProxy;

use namespace mx_internal;
*/
    
import mx.containers.beads.PanelView;
import mx.containers.beads.models.PanelModel;
import mx.core.Container;
import mx.core.UIComponent;

import org.apache.royale.core.IBeadView;
import org.apache.royale.core.IChild;
import org.apache.royale.events.Event;
import org.apache.royale.events.ValueEvent;

//--------------------------------------
//  Styles
//--------------------------------------
/*
include "../styles/metadata/AlignStyles.as";
include "../styles/metadata/GapStyles.as";
include "../styles/metadata/ModalTransparencyStyles.as";
*/
/**
 *  Alpha of the title bar, control bar and sides of the Panel.
 *
 *  The default value for the Halo theme is <code>0.4</code>.
 *  The default value for the Spark theme is <code>0.5</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderAlpha", type="Number", inherit="no", theme="halo, spark")]

/**
 *  Thickness of the bottom border of the Panel control.
 *  If this style is not set and the Panel control contains a ControlBar
 *  control, the bottom border thickness equals the thickness of the top border
 *  of the panel; otherwise the bottom border thickness equals the thickness
 *  of the left border.
 *
 *  @default NaN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderThicknessBottom", type="Number", format="Length", inherit="no", theme="halo")]

/**
 *  Thickness of the left border of the Panel.
 *
 *  @default 10
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderThicknessLeft", type="Number", format="Length", inherit="no", theme="halo")]

/**
 *  Thickness of the right border of the Panel.
 *
 *  @default 10
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderThicknessRight", type="Number", format="Length", inherit="no", theme="halo")]

/**
 *  Thickness of the top border of the Panel.
 *
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderThicknessTop", type="Number", format="Length", inherit="no", theme="halo")]

/**
 *  Name of the CSS style declaration that specifies styles to apply to 
 *  any control bar child subcontrol.
 * 
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="controlBarStyleName", type="String", inherit="no")]

/**
 *  Radius of corners of the window frame.
 *
 *  The default value for the Halo theme is <code>4</code>.
 *  The default value for the Spark theme is <code>0</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no", theme="halo, spark")]

/**
 *  Boolean property that controls the visibility
 *  of the Panel container's drop shadow.
 *
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dropShadowEnabled", type="Boolean", inherit="no", theme="halo")]

/**
 *  Array of two colors used to draw the footer
 *  (area for the ControlBar container) background. 
 *  The first color is the top color. 
 *  The second color is the bottom color.
 *  The default values are <code>null</code>, which
 *  makes the control bar background the same as
 *  the panel background.
 *
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="footerColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="halo")]

/**
 *  Array of two colors used to draw the header.
 *  The first color is the top color.
 *  The second color is the bottom color.
 *  The default values are <code>null</code>, which
 *  makes the header background the same as the
 *  panel background.
 *
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="halo")]

/**
 *  Height of the header.
 *  The default value is based on the style of the title text.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerHeight", type="Number", format="Length", inherit="no")]

/**
 *  Alphas used for the highlight fill of the header.
 *
 *  @default [0.3,0]
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="highlightAlphas", type="Array", arrayType="Number", inherit="no", theme="halo")]

/**
 *  Number of pixels between the container's lower border
 *  and its content area.
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's top border
 *  and its content area.
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  Flag to enable rounding for the bottom two corners of the container.
 *  Does not affect the upper two corners, which are normally round. 
 *  To configure the upper corners to be square, 
 *  set <code>cornerRadius</code> to 0.
 *
 *  @default false
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="roundedBottomCorners", type="Boolean", inherit="no", theme="halo")]

/**
 *  Direction of drop shadow.
 *  Possible values are <code>"left"</code>, <code>"center"</code>,
 *  and <code>"right"</code>.
 *
 *  @default "center"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="shadowDirection", type="String", enumeration="left,center,right", inherit="no", theme="halo")]

/**
 *  Distance of drop shadow.
 *  Negative values move the shadow above the panel.
 *
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="shadowDistance", type="Number", format="Length", inherit="no", theme="halo")]

/**
 *  Style declaration name for the status in the title bar.
 *
 *  @default "windowStatus"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
 
//[Style(name="statusStyleName", type="String", inherit="no")]

/**
 *  The title background skin.
 *
 *  The default value for the Halo theme is <code>mx.skins.halo.TitleBackground</code>.
 *  The default value for the Spark theme is <code>mx.core.UIComponent</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="titleBackgroundSkin", type="Class", inherit="no")]

/**
 *  Style declaration name for the text in the title bar.
 *  The default value is <code>"windowStyles"</code>,
 *  which causes the title to have boldface text.
 *
 *  @default "windowStyles"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="titleStyleName", type="String", inherit="no")]

//--------------------------------------
//  Effects
//--------------------------------------

/**
 *  Specifies the effect to play after a Resize effect finishes playing.
 *  To disable the default Dissolve effect, so that the children are hidden
 *  instantaneously, set the value of the
 *  <code>resizeEndEffect</code> property to <code>"none"</code>.  
 *
 *  @default "Dissolve"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Effect(name="resizeEndEffect", event="resizeEnd")]

/**
 *  Specifies the effect to play before a Resize effect begins playing.
 *  To disable the default Dissolve effect, so that the children are hidden
 *  instantaneously, set the value of the
 *  <code>resizeStartEffect</code> property to <code>"none"</code>.  
 *
 *  @default "Dissolve"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Effect(name="resizeStartEffect", event="resizeStart")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="focusIn", kind="event")]
[Exclude(name="focusOut", kind="event")]

[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusSkin", kind="style")]
[Exclude(name="focusThickness", kind="style")]

[Exclude(name="focusInEffect", kind="effect")]
[Exclude(name="focusOutEffect", kind="effect")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.PanelAccImpl")]

//[IconFile("Panel.png")]

[Alternative(replacement="spark.components.Panel", since="4.0")]

/**
 *  A Halo Panel container consists of a title bar, a caption, a border,
 *  and a  content area for its children.
 *  Typically, you use Panel containers to wrap top-level application modules.
 *  For example, you could include a shopping cart in a Panel container.
 * 
 *  <p><b>Note:</b> Adobe recommends that, when possible, you use the 
 *  Spark Panel container instead of the Halo Panel container.</p>
 *
 *  <p>The Panel container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Height is large enough to hold all of its children at the default height of the children, 
 *               plus any vertical gaps between the children, the top and bottom padding, the top and bottom borders, 
 *               and the title bar.<br/>
 *               Width is the larger of the default width of the widest child plus the left and right padding of the 
 *               container, or the width of the title text, plus the border.</td>
 *        </tr>
 *        <tr>
 *           <td>Padding</td>
 *           <td>4 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:Panel&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:Panel
 *   <strong>Properties</strong>
 *   layout="vertical|horizontal|absolute"
 *   status=""
 *   title=""
 *   titleIcon="null"
 *  
 *   <strong>Styles</strong>
 *   borderAlpha="0.4"
 *   borderThicknessBottom="NaN"
 *   borderThicknessLeft="10"
 *   borderThicknessRight="10"
 *   borderThicknessTop="2"
 *   controlBarStyleName="null"
 *   cornerRadius="4"
 *   dropShadowEnabled="true|false"
 *   footerColors="null"
 *   headerColors="null"
 *   headerHeight="<i>Based on style of title</i>"
 *   highlightAlphas="[0.3,0]"
 *   horizontalAlign="left|center|right"
 *   horizontalGap="8"
 *   modalTransparency="0.5"
 *   modalTransparencyBlur="3"
 *   modalTransparencyColor="#DDDDDD"
 *   modalTransparencyDuration="100"
 *   paddingBottom="0"
 *   paddingTop="0"
 *   roundedBottomCorners="false|true"
 *   shadowDirection="center|left|right"
 *   shadowDistance="2"
 *   statusStyleName="windowStatus"
 *   titleBackgroundSkin="TitleBackground"
 *   titleStyleName="windowStyles"
 *   verticalAlign="top|middle|bottom"
 *   verticalGap="6"
 *  
 *   <strong>Effects</strong>
 *   resizeEndEffect="Dissolve"
 *   resizeStartEffect="Dissolve"
 *   &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/mx:Panel&gt;
 *  </pre>
 *  
 *  @includeExample examples/SimplePanelExample.mxml
 *
 *  @see spark.components.Panel
 *  @see mx.containers.ControlBar
 *  @see mx.containers.VBox
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Panel extends Container
    /*implements IConstraintLayout, IFontContextComponent*/
{
    /*include "../core/Version.as";*/

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

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
    public function Panel()
    {
        super();
        typeNames += " Panel";
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

        
    //----------------------------------
    //  layout
    //----------------------------------

    [Bindable("layoutChanged")]
    [Inspectable(category="General", enumeration="vertical,horizontal,absolute", defaultValue="vertical")]

    /**
     *  Specifies the layout mechanism used for this container. 
     *  Panel containers can use <code>"vertical"</code>, <code>"horizontal"</code>, 
     *  or <code>"absolute"</code> positioning. 
     *  Vertical positioning lays out the child components vertically from
     *  the top of the container to the bottom in the specified order.
     *  Horizontal positioning lays out the child components horizontally
     *  from the left of the container to the right in the specified order.
     *  Absolute positioning does no automatic layout and requires you to
     *  explicitly define the location of each child component. 
     *
     *  @default "vertical"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion mx.containers.beads.models.PanelModel
     */
    public function get layout():String
    {
        return (model as PanelModel).layout;
    }

    /**
     *  @private
     *  @royaleignorecoercion mx.containers.beads.models.PanelModel
     */
    public function set layout(value:String):void
    {
        (model as PanelModel).layout = value;
    }

    //----------------------------------
    //  status
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the status property.
     */
    private var _status:String = "";
    
    /**
     *  @private
     */
    //private var _statusChanged:Boolean = false;
    
    [Bindable("statusChanged")]
    [Inspectable(category="General", defaultValue="")]
    
    /**
     *  Text in the status area of the title bar.
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get status():String
    {
        return _status;
    }
    
    /**
     *  @private
     */
    public function set status(value:String):void
    {
        _status = value;
        //_statusChanged = true;
        
        //invalidateProperties();
        
        dispatchEvent(new Event("statusChanged"));
    }


    //----------------------------------
    //  title
    //----------------------------------

    /**
     *  @private
     *  Storage for the title property.
     */ 
    private var _title:String = "";
    
    /**
     *  @private
     */
    private var _titleChanged:Boolean = false;

    [Bindable("titleChanged")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  Title or caption displayed in the title bar.
     *
     *  @default ""
     *
     *  @tiptext Gets or sets the title/caption displayed in the title bar
     *  @helpid 3991
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion mx.containers.beads.models.PanelModel
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
    
    /**
     *  dropShadowVisible (was a style in Flex)
     * 
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dropShadowVisible():String
    {
        trace("Panel:dropShadowVisible not implemented");
        return null;
    }
    public function set dropShadowVisible(value:String):void
    {
        trace("Panel:dropShadowVisible not implemented");
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        var panelView:PanelView = view as PanelView;
        if ((panelView.contentArea as UIComponent).systemManager == null)
            (panelView.contentArea as UIComponent).systemManager = systemManager;
        if (panelView.contentArea == this)
            super.addElement(c, dispatchEvent);
        else
            panelView.contentArea.addElement(c, dispatchEvent);
        if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth)))
            this.dispatchEvent(new Event("layoutNeeded"));
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
    {
        var panelView:PanelView = view as PanelView;
        if ((panelView.contentArea as UIComponent).systemManager == null)
            (panelView.contentArea as UIComponent).systemManager = systemManager;
        if (panelView.contentArea == this)
            super.addElementAt(c, index, dispatchEvent);
        else
            panelView.contentArea.addElementAt(c, index, dispatchEvent);
        if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth)))
            this.dispatchEvent(new Event("layoutNeeded"));
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function getElementIndex(c:IChild):int
    {
        var panelView:PanelView = view as PanelView;
        if (panelView.contentArea == this)
            return super.getElementIndex(c);
        return panelView.contentArea.getElementIndex(c);
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        var panelView:PanelView = view as PanelView;
        if (panelView.contentArea == this)
            super.removeElement(c, dispatchEvent);
        panelView.contentArea.removeElement(c, dispatchEvent);
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function get numElements():int
    {
        // the view getter below will instantiate the view which can happen
        // earlier than we would like (when setting mxmlDocument) so we
        // see if the view bead exists on the strand.  If not, nobody
        // has added any children so numElements must be 0
        if (!getBeadByType(IBeadView))
            return 0;
        var panelView:PanelView = view as PanelView;
        if (panelView.contentArea == this)
            return super.numElements;
        return panelView.contentArea.numElements;
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function getElementAt(index:int):IChild
    {
        var panelView:PanelView = view as PanelView;
        if (panelView.contentArea == this)
            return super.getElementAt(index);
        return panelView.contentArea.getElementAt(index);
    }

    // override and proxy to content area.  Otherwise Panel's TitleBar and other chrome will
    // have this padding between the border and chrome
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function get paddingLeft():Object
    {
        var panelView:PanelView = view as PanelView;
        if (panelView.contentArea == this)
            return super.paddingLeft;
        var contentView:UIComponent = panelView.contentArea as UIComponent;
        return contentView.paddingLeft;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel 
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set paddingLeft(value:Object):void
    {
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingLeft = value as String;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
            {
                super.paddingLeft = value;
                return;
            }
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.paddingLeft = value;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function get paddingRight():Object
    {
        var panelView:PanelView = view as PanelView;
        var contentView:UIComponent = panelView.contentArea as UIComponent;
        if (panelView.contentArea == this)
            return super.paddingRight;
        return contentView.paddingRight;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel 
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set paddingRight(value:Object):void
    {
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingRight = value as String;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
            {
                super.paddingRight = value;
                return;
            }
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.paddingRight = value;
        }
    }
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function get paddingTop():Object
    {
        var panelView:PanelView = view as PanelView;
        if (panelView.contentArea == this)
            return super.paddingTop;
        var contentView:UIComponent = panelView.contentArea as UIComponent;
        return contentView.paddingTop;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel 
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set paddingTop(value:Object):void
    {
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingTop = value as String;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
            {
                super.paddingTop = value;
                return;
            }
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.paddingTop = value;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function get paddingBottom():Object
    {
        var panelView:PanelView = view as PanelView;
        if (panelView.contentArea == this)
            return super.paddingBottom;
        var contentView:UIComponent = panelView.contentArea as UIComponent;
        return contentView.paddingBottom;
    }
    
    /**
     * @royaleignorecoercion mx.core.UIComponent 
     * @royaleignorecoercion String
     * @royaleignorecoercion mx.containers.beads.models.PanelModel 
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set paddingBottom(value:Object):void
    {
        
        if (typeof(value) !== "string")
            value = value.toString() + "px";
        (model as PanelModel).paddingBottom = value as String;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
            {
                super.paddingBottom = value;
                return;                
            }
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.paddingBottom = value;
        }
    }
    
    // because padding creates the view early, the setuplayout logic
    // may get run before percentWidth/Height are set, so we have
    // to make sure the contentArea gets set up correctly
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set percentWidth(value:Number):void
    {
        super.percentWidth = value;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
                return;                
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.percentWidth = 100;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set explicitWidth(value:Number):void
    {
        super.explicitWidth = value;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
                return;                
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.percentWidth = 100;
        }
    }

    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set percentHeight(value:Number):void
    {
        super.percentHeight = value;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
                return;                
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.percentHeight = 100;
        }
    }
    
    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function set explicitHeight(value:Number):void
    {
        super.explicitHeight = value;
        if (parent)
        {
            var panelView:PanelView = view as PanelView;
            if (panelView.contentArea == this)
                return;                
            var contentView:UIComponent = panelView.contentArea as UIComponent;
            contentView.percentHeight = 100;
        }
    }
    

    /**
     * @private
     * @royaleignorecoercion mx.containers.beads.PanelView
     */
    override public function childrenAdded():void
    {
        var panelView:PanelView = view as PanelView;
        var contentView:UIComponent = panelView.contentArea as UIComponent;
        panelView.contentArea.dispatchEvent(new ValueEvent("childrenAdded"));
        super.childrenAdded();
    }
    


}

}
