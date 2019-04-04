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
import org.apache.royale.events.Event;
/*import flash.geom.Point;
import flash.utils.*;
import mx.core.FlexVersion;
import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

import spark.events.SkinPartEvent;
import spark.utils.FTETextUtil;

use namespace mx_internal;
*/
import mx.core.IFactory;
import mx.collections.IList;

import mx.core.UIComponent;
import spark.components.DataGroup;
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
        // TODO
        if (GOOG::DEBUG)
            trace("skinClass not implemented");
        return null;
    }
        
    /**
     *  @private
     */
    public function set skinClass(value:Class):void
    {
        // TODO
        if (GOOG::DEBUG)
            trace("skinClass not implemented");
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
    private function setSkin(value:UIComponent):void
    {
        if (value === _skin)
           return;
        
        _skin = value;
        dispatchEvent(new Event("skinChanged"));
    }
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
