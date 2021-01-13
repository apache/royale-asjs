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
/* import mx.core.ContainerCreationPolicy;
import mx.core.IDeferredContentOwner;
import mx.core.IDeferredInstance;
import mx.core.IFlexModuleFactory;
import mx.core.IVisualElementContainer;
import mx.events.FlexEvent;
import mx.utils.BitFlagUtil;

import spark.events.ElementExistenceEvent;
*/
import mx.core.IUIComponent;
import spark.components.supportClasses.Skin;
import mx.core.IVisualElement;
import mx.core.mx_internal;

import spark.components.supportClasses.SkinnableContainerBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.components.supportClasses.GroupBase;
import spark.components.beads.SkinnableContainerView;
import spark.layouts.supportClasses.LayoutBase;
import spark.layouts.BasicLayout;

use namespace mx_internal;

import org.apache.royale.binding.ContainerDataBinding;
import org.apache.royale.binding.DataBindingBase;
import org.apache.royale.core.ContainerBaseStrandChildren;
import org.apache.royale.core.IBeadLayout;
import org.apache.royale.core.IBeadView;
import org.apache.royale.core.IChild;
import org.apache.royale.core.IContainer;
import org.apache.royale.core.IContainerBaseStrandChildrenHost;
import org.apache.royale.core.ILayoutHost;
import org.apache.royale.core.IParent;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.ValueEvent;
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.utils.MXMLDataInterpreter;
import org.apache.royale.utils.loadBeadFromValuesManager;

/**
 *  Dispatched after the content for this component has been created. With deferred 
 *  instantiation, the content for a component may be created long after the 
 *  component is created.
 *
 *  @eventType mx.events.FlexEvent.CONTENT_CREATION_COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="contentCreationComplete", type="mx.events.FlexEvent")]

/**
 *  Dispatched when a visual element is added to the content holder.
 *  <code>event.element</code> is the visual element that was added.
 *
 *  @eventType spark.events.ElementExistenceEvent.ELEMENT_ADD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
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
 *  @productversion Royale 0.9.4
 */
//[Event(name="elementRemove", type="spark.events.ElementExistenceEvent")]

 include "../styles/metadata/BasicInheritingTextStyles.as"
/*include "../styles/metadata/AdvancedInheritingTextStyles.as"
include "../styles/metadata/SelectionFormatTextStyles.as"
 */
/**
 *  @copy spark.components.supportClasses.GroupBase#style:accentColor
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
 *  @copy spark.components.supportClasses.GroupBase#style:alternatingItemColors
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  Alpha level of the background for this component.
 *  Valid values range from 0.0 to 1.0. 
 *  
 *  @default 1.0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="backgroundAlpha", type="Number", inherit="no", theme="spark, mobile")]

/**
 *  Background color of a component.
 *  
 *  @default 0xFFFFFF
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="backgroundColor", type="uint", format="Color", inherit="no", theme="spark, mobile")]

/**
 *  The alpha of the content background for this component.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:contentBackgroundColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:downColor
 *   
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="downColor", type="uint", format="Color", inherit="yes", theme="mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:focusColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:rollOverColor
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
 *  @copy spark.components.supportClasses.GroupBase#style:symbolColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:touchDelay
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="touchDelay", type="Number", format="Time", inherit="yes", minValue="0.0")]

/**
 *  Color of text shadows.
 * 
 *  @default #FFFFFF
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
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
 *  @productversion Royale 0.9.4
 */
//[Style(name="textShadowAlpha", type="Number",inherit="yes", minValue="0.0", maxValue="1.0", theme="mobile")]

//[IconFile("SkinnableContainer.png")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

//[DefaultProperty("mxmlContentFactory")]
[DefaultProperty("mxmlContent")]

/**
 *  The SkinnableContainer class is the base class for skinnable containers that have 
 *  visual content.
 *  The SkinnableContainer container takes as children any components that implement 
 *  the IVisualElement interface. 
 *  All Spark and Halo components implement the IVisualElement interface, as does
 *  the GraphicElement class. 
 *  That means the container can use the graphics classes, such as Rect and Ellipse, as children.
 *
 *  <p>To improve performance and minimize application size, 
 *  you can use the Group container. The Group container cannot be skinned.</p>
 *
 *  <p>The SkinnableContainer container has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *  </table>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:SkinnableContainer&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:SkinnableContainer
 *    <strong>Properties</strong>
 *    autoLayout="true"
 *    creationPolicy="auto"
 *    layout="BasicLayout"
 *  
 *    <strong>Styles</strong>
 *    accentColor="0x0099FF"
 *    alignmentBaseline="useDominantBaseline"
 *    alternatingItemColors=""
 *    backgroundAlpha="1.0"
 *    backgroundColor="0xFFFFFF"
 *    baselineShift="0.0"
 *    blockProgression="TB"
 *    breakOpportunity="auto"
 *    cffHinting="horizontal_stem"
 *    clearFloats="none"
 *    color="0"
 *    contentBackgroundAlpha=""
 *    contentBackgroundColor=""
 *    digitCase="default"
 *    digitWidth="default"
 *    direction="LTR"
 *    dominantBaseline="auto"
 *    downColor=""
 *    firstBaselineOffset="auto"
 *    focusColor=""
 *    focusedTextSelectionColor=""
 *    fontFamily="Arial"
 *    fontLookup="device"
 *    fontSize="12"
 *    fontStyle="normal"
 *    fontWeight="normal"
 *    inactiveTextSelectionColor="0xE8E8E8"
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
 *    renderingMode="CFF"
 *    rollOverColor=""
 *    symbolColor=""
 *    tabStops="null"
 *    textAlign="start"
 *    textAlignLast="start"
 *    textAlpha="1"
 *    textDecoration="none"
 *    textIndent="0"
 *    textJustify="inter_word"
 *    textRotation="auto"
 *    trackingLeft="0"
 *    trackingRight="0"
 *    typographicCase="default"
 *    unfocusedTextSelectionColor=""
 *    verticalScrollPolicy="auto"
 *    whiteSpaceCollapse="collapse"
 *    wordSpacing="100%,50%,150%"
 *   
 *    <strong>Events</strong>
 *    elementAdd="<i>No default</i>"
 *    elementRemove="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see SkinnableDataContainer
 *  @see Group
 *  @see spark.skins.spark.SkinnableContainerSkin
 *
 *  @includeExample examples/SkinnableContainerExample.mxml
 *  @includeExample examples/MyBorderSkin.mxml -noswf
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class SkinnableContainer extends SkinnableContainerBase implements IContainer, IContainerBaseStrandChildrenHost
{// SkinnableContainerBase 
 //    implements IDeferredContentOwner, IVisualElementContainer
   // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    //private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1 << 0;
    
    /**
     *  @private
     */
    //private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;

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
    public function SkinnableContainer()
    {
        super();
        typeNames = "SkinnableContainer";
    }
    
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
    //  textDecoration
    //----------------------------------
	
    public function get textDecoration():String 
     {
	return "";
     }
     
    public function set textDecoration(val:String):void
     {
	
     }
	
	
        public function get blockProgression():String 
	{
		return "";
	}
	public function set blockProgression(val:String):void
	{
	
	}
    
	
	public function get contentBackgroundColor():uint{
	return 0;
	}
	public function set contentBackgroundColor(val:uint):void {
	}
    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------
    
    /* [Bindable]
    [SkinPart(required="false")]
     */
    /**
     *  An optional skin part that defines the Group where the content 
     *  children get pushed into and laid out.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
	 *  @royalesuppresspublicvarwarning
	 */
    public var contentGroup:Object;//Group;
    
    /**
     *  @private
     *  Several properties are proxied to contentGroup.  However, when contentGroup
     *  is not around, we need to store values set on SkinnableContainer.  This object 
     *  stores those values.  If contentGroup is around, the values are stored 
     *  on the contentGroup directly.  However, we need to know what values 
     *  have been set by the developer on the SkinnableContainer (versus set on 
     *  the contentGroup or defaults of the contentGroup) as those are values 
     *  we want to carry around if the contentGroup changes (via a new skin). 
     *  In order to store this info effeciently, contentGroupProperties becomes 
     *  a uint to store a series of BitFlags.  These bits represent whether a 
     *  property has been explicitely set on this SkinnableContainer.  When the 
     *  contentGroup is not around, contentGroupProperties is a typeless 
     *  object to store these proxied properties.  When contentGroup is around,
     *  contentGroupProperties stores booleans as to whether these properties 
     *  have been explicitely set or not.
     */
    //private var contentGroupProperties:Object = {};
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties 
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  moduleFactory
    //----------------------------------
    /**
     *  @private
     */
    /* override public function set moduleFactory(moduleFactory:IFlexModuleFactory):void
    {
        super.moduleFactory = moduleFactory;
        
        // Register the _creationPolicy style as inheriting. See the creationPolicy
        // getter for details on usage of this style.
        styleManager.registerInheritingStyle("_creationPolicy");
    }
     */
    //--------------------------------------------------------------------------
    //
    //  Properties 
    //
    //--------------------------------------------------------------------------

    // Used to hold the content until the contentGroup is created. 
    //private var _placeHolderGroup:Group;
    
    /* mx_internal function get currentContentGroup():Group
    {          
        createContentIfNeeded();
    
        if (!contentGroup)
        {
            if (!_placeHolderGroup)
            {
                _placeHolderGroup = new Group();
                 
                if (_mxmlContent)
                {
                    _placeHolderGroup.mxmlContent = _mxmlContent;
                    _mxmlContent = null;
                }
                
                _placeHolderGroup.addEventListener(
                    ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                _placeHolderGroup.addEventListener(
                    ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
            }
            return _placeHolderGroup;
        }
        else
        {
            return contentGroup;    
        }
    }
     */
    //----------------------------------
    //  creationPolicy
    //----------------------------------
        
    // Internal flag used when creationPolicy="none".
    // When set, the value of the backing store _creationPolicy
    // style is "auto" so descendants inherit the correct value.
    //private var creationPolicyNone:Boolean = false;
    
    //[Inspectable(enumeration="auto,all,none", defaultValue="auto")]
        
    /**
     *  @inheritDoc
     *
     *  @default auto
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     public function get creationPolicy():String
    {
       return "";
    }
     
    /**
     *  @private
     */
     public function set creationPolicy(value:String):void
    {
        
    } 

    //--------------------------------------------------------------------------
    //
    //  Properties proxied to contentGroup
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  autoLayout
    //----------------------------------

    //[Inspectable(defaultValue="true")]

    /**
     *  @copy spark.components.supportClasses.GroupBase#autoLayout
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get autoLayout():Boolean
    {
        if (contentGroup)
            return contentGroup.autoLayout;
        else
        {
            // want the default to be true
            var v:* = contentGroupProperties.autoLayout;
            return (v === undefined) ? true : v;
        }
    } */

    /**
     *  @private
     */
    /* public function set autoLayout(value:Boolean):void
    {
        if (contentGroup)
        {
            contentGroup.autoLayout = value;
            contentGroupProperties = BitFlagUtil.update(contentGroupProperties as uint, 
                                                        AUTO_LAYOUT_PROPERTY_FLAG, true);
        }
        else
            contentGroupProperties.autoLayout = value;
    }
     */
    //----------------------------------
    //  layout
    //----------------------------------
    
    private var _layout:LayoutBase;
    
    //[Inspectable(category="General")]
    
    /**
     *  @copy spark.components.supportClasses.GroupBase#layout
     *
     *  @default BasicLayout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get layout():LayoutBase
    {
        /*
        return (contentGroup) 
            ? contentGroup.layout 
            : contentGroupProperties.layout;
        */
        //if (!_layout)
        //    _layout = new BasicLayout();
        return _layout;
    }
    
    /**
     * @private
     * @royaleignorecoercion spark.components.beads.SkinnableContainerView
     * @royaleignorecoercion spark.components.supportClasses.GroupBase
     */
    public function set layout(value:LayoutBase):void
    {
        /*
        if (contentGroup)
        {
            contentGroup.layout = value;
            contentGroupProperties = BitFlagUtil.update(contentGroupProperties as uint, 
                                                        LAYOUT_PROPERTY_FLAG, true);
        }
        else
            contentGroupProperties.layout = value;
        */
        _layout = value;
        if (getBeadByType(IBeadView))
        {
            ((view as SkinnableContainerView).contentView as GroupBase).layout = value;
            if (parent)
                ((view as SkinnableContainerView).contentView as GroupBase).dispatchEvent(new Event("layoutNeeded"));       
        }
    }
    
    //----------------------------------
    //  mxmlContent
    //----------------------------------    
    
    /**
     *  @private
     *  Variable used to store the mxmlContent when the contentGroup is 
     *  not around, and there hasnt' been a need yet for the placeHolderGroup.
     */
    //private var _mxmlContent:Array;
    
    /**
     *  @private
     *  Variable that represents whether the content has been explicitely set 
     *  (via mxmlContent setter or with the mutation APIs, like addElement).  
     *  This is used to figure out whether we should override the default "content"
     *  that is in the contentGroup of a skin.
     */
    /* private var _contentModified:Boolean = false;
    
    [ArrayElementType("mx.core.IVisualElement")]
     */
    /**
     *  @copy spark.components.Group#mxmlContent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function set mxmlContent(value:Array):void
    {
        if (contentGroup)
            contentGroup.mxmlContent = value;
        else if (_placeHolderGroup)
            _placeHolderGroup.mxmlContent = value;
        else
            _mxmlContent = value;
        
        if (value != null)
            _contentModified = true;
    }
     */
     
    /**
     *  override setting of children
     */
    /* override protected function addMXMLChildren(comps:Array):void
    {
        mxmlContent = comps;
    } */
    
    //----------------------------------
    //  mxmlContentFactory
    //----------------------------------
    
    /** 
     *  @private
     *  Backing variable for the contentFactory property.
     */
    private var _mxmlContentFactory:Object;//IDeferredInstance;

    /**
     *  @private
     *  Flag that indicates whether or not the content has been created.
     */
    /* private var mxmlContentCreated:Boolean = false;
    
    [InstanceType("Array")]
    [ArrayElementType("mx.core.IVisualElement")] */

    /**
     *  A factory object that creates the initial value for the
     *  <code>content</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function set mxmlContentFactory(value:Object):void
    {
        if (value == _mxmlContentFactory)
            return;
        
        _mxmlContentFactory = value;
       // mxmlContentCreated = false;
    } 
         
    //--------------------------------------------------------------------------
    //
    //  Methods proxied to contentGroup
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get numElements():int
    {
	
       return currentContentGroup.numElements;
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
	/* public function getElementAt(index:int):IVisualElement
    {
        return currentContentGroup.getElementAt(index);
    } */
    
        
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function getElementIndex(element:IVisualElement):int
    {
        return currentContentGroup.getElementIndex(element);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
	/* public function addElement(element:IVisualElement):IVisualElement
    {
         _contentModified = true;
        return currentContentGroup.addElement(element); 
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function addElementAt(element:IVisualElement, index:int):IVisualElement
    {
        _contentModified = true;
        return currentContentGroup.addElementAt(element, index);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function removeElement(element:IVisualElement):IVisualElement
    {
         _contentModified = true;
        return currentContentGroup.removeElement(element); 
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function removeElementAt(index:int):IVisualElement
    {
        _contentModified = true;
        return currentContentGroup.removeElementAt(index);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function removeAllElements():void
    {
        /* _contentModified = true;
        currentContentGroup.removeAllElements(); */

        // Copied from mx.core.Container
        while (numChildren > 0)
        {
            removeChildAt(0);
        }
    } 
    
    /*
    * IContainer
    */
    
    /**
     *  @private
     */
    public function childrenAdded():void
    {
        if (skin)
        {
            var skinDispatcher:IEventDispatcher = (view as SkinnableContainerView).contentView as IEventDispatcher;
            skinDispatcher.dispatchEvent(new ValueEvent("childrenAdded"));
        }
        dispatchEvent(new ValueEvent("childrenAdded"));
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    public function setElementIndex(element:IVisualElement, index:int):void
    {
     /*    _contentModified = true;
        currentContentGroup.setElementIndex(element, index); */
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function swapElements(element1:IVisualElement, element2:IVisualElement):void
    {
        _contentModified = true;
        currentContentGroup.swapElements(element1, element2);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function swapElementsAt(index1:int, index2:int):void
    {
        _contentModified = true;
        currentContentGroup.swapElementsAt(index1, index2);
    }
     */
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  IMXMLDocument et al
    //
    //--------------------------------------------------------------------------
    
    private var _mxmlDescriptor:Array;
    private var _mxmlDocument:Object = this;
    
    override public function addedToParent():void
    {
        if (!initialized) {
            // each MXML file can also have styles in fx:Style block
            ValuesManager.valuesImpl.init(this);
        }
        
        super.addedToParent();		
        
        // Load the layout bead if it hasn't already been loaded.
        loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);
        
        dispatchEvent(new Event("beadsAdded"));
        dispatchEvent(new Event("initComplete"));
        if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth)))
            dispatchEvent(new Event("layoutNeeded"));
    }
    
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


    /**
     *  @private
     */
    override protected function measure():void
    {
	    if (_layout)
	    {
		_layout.measure();
	    } else if (skin)
	    {
		(skin as Skin).layout.measure();
	    } else
	    {
		    super.measure();
	    }
    }

    override protected function createChildren():void
    {
        super.createChildren();
        
        if (getBeadByType(DataBindingBase) == null)
            addBead(new ContainerDataBinding());
        
        dispatchEvent(new Event("initBindings"));
    }
   
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    override protected function partAdded(partName:String, instance:Object):void
    { 
        super.partAdded(partName, instance);

        /* 
        if (instance == contentGroup)
        {
            if (_contentModified)
            {
                if (_placeHolderGroup != null)
                {
                    var sourceContent:Array = _placeHolderGroup.getMXMLContent();
                    
                    // TODO (rfrishbe): Also look at why we need a defensive copy for mxmlContent in Group, 
                    // especially if we make it mx_internal.  Also look at controlBarContent.
                    
                    // If a child element has been addElemented() to the placeHolderGroup, 
                    // then it wouldn't been added to the display list and we can't just 
                    // copy the mxmlContent from the placeHolderGroup, but we must also 
                    // call removeElement() on those children.
                    
                    // remove listener prior to removal of elements
                    // or else we'll accidentally null out the owner field
                    _placeHolderGroup.removeEventListener(
                        ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
                    
                    for (var i:int = _placeHolderGroup.numElements; i > 0; i--)
                    {
                        _placeHolderGroup.removeElementAt(0);  
                    }
                    
                    contentGroup.mxmlContent = sourceContent ? sourceContent.slice() : null;

                }
                else if (_mxmlContent != null)
                {
                    contentGroup.mxmlContent = _mxmlContent;
                    _mxmlContent = null;
                }
            }
            
            // copy proxied values from contentGroupProperties (if set) to contentGroup
            
            var newContentGroupProperties:uint = 0;
            
            if (contentGroupProperties.autoLayout !== undefined)
            {
                contentGroup.autoLayout = contentGroupProperties.autoLayout;
                newContentGroupProperties = BitFlagUtil.update(newContentGroupProperties, 
                                                               AUTO_LAYOUT_PROPERTY_FLAG, true);
            }
            
            if (contentGroupProperties.layout !== undefined)
            {
                contentGroup.layout = contentGroupProperties.layout;
                newContentGroupProperties = BitFlagUtil.update(newContentGroupProperties, 
                                                               LAYOUT_PROPERTY_FLAG, true);
            }
            
            contentGroupProperties = newContentGroupProperties;
            
            contentGroup.addEventListener(
                ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
            contentGroup.addEventListener(
                ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
            
            if (_placeHolderGroup)
            {
                _placeHolderGroup.removeEventListener(
                    ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                _placeHolderGroup.removeEventListener(
                    ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
                
                _placeHolderGroup = null;
            }
        } */
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
     /* override protected function partRemoved(partName:String, instance:Object):void
    {
         super.partRemoved(partName, instance);

         if (instance == contentGroup)
        {
            contentGroup.removeEventListener(
                ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
            contentGroup.removeEventListener(
                ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
            
            // copy proxied values from contentGroup (if explicitely set) to contentGroupProperties
            
            var newContentGroupProperties:Object = {};
            
            if (BitFlagUtil.isSet(contentGroupProperties as uint, AUTO_LAYOUT_PROPERTY_FLAG))
                newContentGroupProperties.autoLayout = contentGroup.autoLayout;
            
            if (BitFlagUtil.isSet(contentGroupProperties as uint, LAYOUT_PROPERTY_FLAG))
                newContentGroupProperties.layout = contentGroup.layout;
                
            contentGroupProperties = newContentGroupProperties;
            
            var myMxmlContent:Array = contentGroup.getMXMLContent();
            
            if (_contentModified && myMxmlContent)
            {
                _placeHolderGroup = new Group();
                     
                _placeHolderGroup.mxmlContent = myMxmlContent;
                
                _placeHolderGroup.addEventListener(
                    ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
                _placeHolderGroup.addEventListener(
                    ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
            }
            
            contentGroup.mxmlContent = null;
            contentGroup.layout = null;
        } 
    }*/
     
    //--------------------------------------------------------------------------
    //
    //  IDeferredContentOwner methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Create the content for this component. 
     *  When the <code>creationPolicy</code> property is <code>auto</code> or
     *  <code>all</code>, this function is called automatically by the Flex framework.
     *  When <code>creationPolicy</code> is <code>none</code>, you call this method to initialize
     *  the content.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function createDeferredContent():void
    {
        var children:Array =  this.MXMLDescriptor;
        if (children)
        {
			creatingDeferredContent = true;
            generateMXMLInstances(document, children);
			creatingDeferredContent = false;
            mxmlContentCreated = true; // keep the code from recursing back into here.
            _deferredContentCreated = true; 
            dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
            return;
        }
        
        if (!mxmlContentCreated)
        {
            mxmlContentCreated = true;
            
            if (_mxmlContentFactory)
            {
                var deferredContent:Object = _mxmlContentFactory.getInstance();
                mxmlContent = deferredContent as Array;
                _deferredContentCreated = true;
                dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
            }
        }
    }

    private var _deferredContentCreated:Boolean;
    */
    /**
     *  Contains <code>true</code> if deferred content has been created.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get deferredContentCreated():Boolean
    {
        return _deferredContentCreated;
    } */

    /**
     *  @private
     */
    /* private function createContentIfNeeded():void
    {
        if (!mxmlContentCreated && creationPolicy != ContainerCreationPolicy.NONE)
            createDeferredContent();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    /* private function contentGroup_elementAddedHandler(event:ElementExistenceEvent):void
    {
        event.element.owner = this
        
        // Re-dispatch the event
        dispatchEvent(event);
    }
    
    private function contentGroup_elementRemovedHandler(event:ElementExistenceEvent):void
    {
        event.element.owner = null;
        
        // Re-dispatch the event
        dispatchEvent(event);
    } */
     
     //--------------------------------------------------------------------------
     //  StrandChildren
     //--------------------------------------------------------------------------
     
     private var _strandChildren:ContainerBaseStrandChildren;
     
     /**
      * @copy org.apache.royale.core.IContentViewHost#strandChildren
      *  
      *  @langversion 3.0
      *  @playerversion Flash 10.2
      *  @playerversion AIR 2.6
      *  @productversion Royale 0.8
      */
     
     /**
      * @private
      */
     public function get strandChildren():IParent
     {
         if (_strandChildren == null) {
             _strandChildren = new ContainerBaseStrandChildren(this);
         }
         return _strandChildren;
     }
     
     //--------------------------------------------------------------------------
     //
     //  element/child handlers
     //
     //--------------------------------------------------------------------------
         
     /*
     * The following functions are for the SWF-side only and re-direct element functions
     * to the content area, enabling scrolling and clipping which are provided automatically
     * in the JS-side. 
     */
     
     /**
      * @private
      */
     override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
     {
         var contentView:IParent = getLayoutHost().contentView as IParent;
         if (c == contentView)
         {
             super.addElement(c); // ContainerView uses addElement to add inner contentView
             if (c == skin)
                 findSkinParts();
             return;
         }
         contentView.addElement(c, dispatchEvent);
         if (dispatchEvent)
             this.dispatchEvent(new ValueEvent("childrenAdded", c));
     }
     
     /**
      * @private
      */
     override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
     {
         var contentView:IParent = getLayoutHost().contentView as IParent;
         contentView.addElementAt(c, index, dispatchEvent);
         if (dispatchEvent)
             this.dispatchEvent(new ValueEvent("childrenAdded", c));
     }
     
     /**
      * @private
      */
     override public function getElementIndex(c:IChild):int
     {
         var layoutHost:ILayoutHost = view as ILayoutHost;
         var contentView:IParent = layoutHost.contentView as IParent;
         return contentView.getElementIndex(c);
     }
     
     /**
      * @private
      */
     override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
     {
         var layoutHost:ILayoutHost = view as ILayoutHost;
         var contentView:IParent = layoutHost.contentView as IParent;
         contentView.removeElement(c, dispatchEvent);
         //TODO This should possibly be ultimately refactored to be more PAYG
         if(dispatchEvent)
             this.dispatchEvent(new ValueEvent("childrenRemoved", c));
     }
     
     /**
      * @private
      */
     override public function get numElements():int
     {
         // the view getter below will instantiate the view which can happen
         // earlier than we would like (when setting mxmlDocument) so we
         // see if the view bead exists on the strand.  If not, nobody
         // has added any children so numElements must be 0
         if (!getBeadByType(IBeadView))
             return 0;
         var layoutHost:ILayoutHost = view as ILayoutHost;
         if (!layoutHost) return 0; // view is null when called in addingChild from MXMLDataInterpreter before children are added
         var contentView:IParent = layoutHost.contentView as IParent;
         return contentView.numElements;
     }
     
     /**
      * @private
      */
     override public function getElementAt(index:int):IChild
     {
         var layoutHost:ILayoutHost = view as ILayoutHost;
         var contentView:IParent = layoutHost.contentView as IParent;
         return contentView.getElementAt(index);
     }
     
     [SWFOverride(returns="flash.display.DisplayObject"))]
     COMPILE::SWF
     override public function getChildAt(index:int):IUIComponent
     {
         var layoutHost:ILayoutHost = view as ILayoutHost;
         var contentView:IParent = layoutHost.contentView as IParent;
         return contentView.getElementAt(index) as IUIComponent;
     }
     
     /*
     * IContainerBaseStrandChildrenHost
     *
     * These "internal" function provide a backdoor way for proxy classes to
     * operate directly at strand level. While these function are available on
     * both SWF and JS platforms, they really only have meaning on the SWF-side. 
     * Other subclasses may provide use on the JS-side.
     *
     * @see org.apache.royale.core.IContainer#strandChildren
     */
     
     /**
      * @private
      * @suppress {undefinedNames}
      * Support strandChildren.
      */
     public function get $numElements():int
     {
         return super.numElements;
     }
     
     /**
      * @private
      * @suppress {undefinedNames}
      * Support strandChildren.
      */
     public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
     {
         super.addElement(c, dispatchEvent);
     }
     
     /**
      * @private
      * @suppress {undefinedNames}
      * Support strandChildren.
      */
     public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
     {
         super.addElementAt(c, index, dispatchEvent);
     }
     
     /**
      * @private
      * @suppress {undefinedNames}
      * Support strandChildren.
      */
     public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
     {
         super.removeElement(c, dispatchEvent);
     }
     
     /**
      * @private
      * @suppress {undefinedNames}
      * Support strandChildren.
      */
     public function $getElementIndex(c:IChild):int
     {
         return super.getElementIndex(c);
     }
     
     /**
      * @private
      * @suppress {undefinedNames}
      * Support strandChildren.
      */
     public function $getElementAt(index:int):IChild
     {
         return super.getElementAt(index);
     }

}

}
