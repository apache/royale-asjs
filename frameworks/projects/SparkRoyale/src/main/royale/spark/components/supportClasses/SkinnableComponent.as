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
COMPILE::JS
{
    import goog.DEBUG;
}

/*
import flash.display.DisplayObject;*/
import mx.collections.IList;
import mx.core.IFactory;
import mx.core.mx_internal;

import org.apache.royale.events.Event;
import org.apache.royale.reflection.TypeDefinition;
import org.apache.royale.reflection.VariableDefinition;
import org.apache.royale.reflection.MetaDataDefinition;
import org.apache.royale.reflection.MetaDataArgDefinition;
import org.apache.royale.reflection.describeType;
use namespace mx_internal;

import mx.core.UIComponent;
import spark.components.DataGroup;
//import spark.events.SkinPartEvent;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  @copy spark.components.supportClasses.GroupBase#style:chromeColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="chromeColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  Name of the skin class to use for this component when a validation error occurs. 
 *  
 *  @default spark.skins.spark.ErrorSkin
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="errorSkin", type="Class")]

/**
 *  Name of the skin class to use for this component. The skin must be a class 
 *  that extends UIComponent. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="skinClass", type="Class")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="themeColor", kind="style")]
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

//--------------------------------------
//  Other metadata
//--------------------------------------

//[ResourceBundle("components")]

/**
 *  The SkinnableComponent class defines the base class for skinnable components. 
 *  The skins used by a SkinnableComponent class are typically child classes of 
 *  the Skin class.
 *
 *  <p>Associate a skin class with a component class by setting the <code>skinClass</code> style property of the 
 *  component class. You can set the <code>skinClass</code> property in CSS, as the following example shows:</p>
 *
 *  <pre>MyComponent
 *  {
 *    skinClass: ClassReference("my.skins.MyComponentSkin")
 *  }</pre>
 *
 *  <p>The following example sets the <code>skinClass</code> property in MXML:</p>
 *
 *  <pre>
 *  &lt;MyComponent skinClass="my.skins.MyComponentSkin"/&gt;</pre>
 *
 *
 *  @see spark.components.supportClasses.Skin
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class SkinnableComponent extends UIComponent
{
//    include "../../core/Version.as";

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
    public function SkinnableComponent()
    {
        addEventListener("layoutNeeded", layoutSkinNeeded);
    }
	
    private function layoutSkinNeeded(event:Event):void
    {
        if (skin)
            skin.dispatchEvent(new Event("layoutNeeded"));
    }
    
    //--------------------------------------------------------------------------
    //  Properties
    //--------------------------------------------------------------------------
	
    override public function get chromeColor():uint
    {
       return null;
    }
        
    override public function set chromeColor(value:uint):void
    {
      
    }
	
	
    

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    /**
     *  Specifies whether the UIComponent object receives <code>doubleClick</code> events.
     *  The default value is <code>false</code>, which means that the UIComponent object
     *  does not receive <code>doubleClick</code> events.
     *
     *  <p>The <code>mouseEnabled</code> property must also be set to <code>true</code>,
     *  its default value, for the object to receive <code>doubleClick</code> events.</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get skinClass():Class
    {
        return getStyle("skinClass");
    }
        
    /**
     *  @private
     */
    public function set skinClass(value:Class):void
    {
        setStyle("skinClass", value);
    }
        
    //----------------------------------
    //  enabled
    //----------------------------------

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
        super.enabled = value;
        invalidateSkinState();
    }
  
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

    }

 
    /**
     *  Marks the component so that the new state of the skin is set
     *  during a later screen update.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function invalidateSkinState():void
    {
        if (GOOG::DEBUG)
            trace("invalidateSkinState not implemented");
    }
	
	
	
	//----------------------------------
    //  skin
    //----------------------------------
    
    /**
     * @private 
     * Storage for skin instance
     */ 
    private var _skin:UIComponent;
    
    [Bindable("skinChanged")]
    
    /**
     *  The instance of the skin class for this component instance. 
     *  This is a read-only property that gets set automatically when Flex
     *  calls the <code>attachSkin()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get skin():UIComponent
    {
        return _skin;
    }
    
    /**
     *  @private
     *  Setter for the skin instance.  This is so the bindable event
     *  is dispatched
     */ 
    mx_internal function setSkin(value:UIComponent):void
    {
        if (value === _skin)
           return;
        
        _skin = value;
        findSkinParts();
        dispatchEvent(new Event("skinChanged"));
    }
    
    /**
     * @private 
     * 
     * Contains a flat list of all the skin parts. This includes
     * inherited skin parts. It is best to use a for...in to loop
     * through the skin parts. The property name will be the name of the 
     * skin part and it's value will be a boolean specifying if it is required
     * or not.
     * 
     * The actual return value of this method will be generated by the
     * compiler and may not be null.
     * 
     */
    protected function get skinParts():Object
    {
        var parts:Object = {};
        
        var td:TypeDefinition = describeType(this);
        var vars:Array = td.variables;
        for each (var vd:VariableDefinition in vars)
        {
            var metadata:Array = vd.metadata;
            for each (var md:MetaDataDefinition in metadata)
            {
                if (md.name == "SkinPart")
                {
                    var required:Boolean = false;
                    var args:Array = md.args;
                    for each (var arg:MetaDataArgDefinition in args)
                    {
                        if (arg.name == "required")
                            required = (arg.value == "true");
                    }
                    parts[vd.name] = required;
                }
            }
        }
        return parts;
    }

    /**
     *  Find the skin parts in the skin class and assign them to the properties of the component.
     *  You do not call this method directly. 
     *  Flex calls it automatically when it calls the <code>attachSkin()</code> method.
     *  Typically, a subclass of SkinnableComponent does not override this method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function findSkinParts():void
    {
        if (skinParts)
        {
            for (var id:String in skinParts)
            {
                if (skinParts[id] == true)
                {
                    if (!(id in skin))
                        throw(new Error(resourceManager.getString("components", "requiredSkinPartNotFound", [id])));
                }
                
                if (id in skin)
                {
                    this[id] = skin[id];
                    
                    // If the assigned part has already been instantiated, call partAdded() here,
                    // but only for static parts.
                    if (this[id] != null && !(this[id] is IFactory))
                        partAdded(id, this[id]);
                }
            }
        }
    }

    /**
     *  Called when a skin part is added. 
     *  You do not call this method directly. 
     *  For static parts, Flex calls it automatically when it calls the <code>attachSkin()</code> method. 
     *  For dynamic parts, Flex calls it automatically when it calls 
     *  the <code>createDynamicPartInstance()</code> method. 
     *
     *  <p>Override this function to attach behavior to the part. 
     *  If you want to override behavior on a skin part that is inherited from a base class, 
     *  do not call the <code>super.partAdded()</code> method. 
     *  Otherwise, you should always call the <code>super.partAdded()</code> method.</p>
     *
     *  @param partname The name of the part.
     *
     *  @param instance The instance of the part.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function partAdded(partName:String, instance:Object):void
    {
        /*
        // Dispatch a partAdded event.
        // This event is an internal implementation detail subject to change.
        // The accessibility implementation classes listen for this to know
        // when to add their event listeners to skin parts being added.
        var event:SkinPartEvent = new SkinPartEvent(SkinPartEvent.PART_ADDED);
        event.partName = partName;
        event.instance = instance;
        dispatchEvent(event);
        */
    }

    protected function partRemoved(partName:String, instance:Object):void {} // not implemented

	//dataGroup copied from SkinnableDataContainer
	/**
     *  An optional skin part that defines the DataGroup in the skin class 
     *  where data items get pushed into, rendered, and laid out.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
     */
    public var dataGroup:DataGroup;

	// getCurrentSkinState copied from SkinnableContainerBase
	/* override */ protected function getCurrentSkinState():String
    {
        return enabled ? "normal" : "disabled";
    }
}

}
