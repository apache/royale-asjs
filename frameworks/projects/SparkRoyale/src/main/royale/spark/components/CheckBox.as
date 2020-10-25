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

/* import flash.events.Event;
import flash.events.MouseEvent;
 */
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import mx.core.mx_internal;

import spark.components.supportClasses.ToggleButtonBase;
COMPILE::JS
{
    
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.supportClasses.CheckBoxIcon;
    import org.apache.royale.html.util.addElementToWrapper;
}

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  The space between layout elements, in pixels.
 * 
 *  @default 5
 * 
 *  @langversion 3.0
 *  @playerversion Flash 11.8
 *  @playerversion AIR 3.8
 *  @productversion Royale 0.9.4
 */
//[Style(name="gap", type="int", inherit="no")]


/**
 *  Orientation of the icon in relation to the label.
 *  Valid MXML values are <code>right</code>, <code>left</code>,
 *  <code>bottom</code>, and <code>top</code>.
 *
 *  <p>In ActionScript, you can use the following constants
 *  to set this property:
 *  <code>IconPlacement.RIGHT</code>,
 *  <code>IconPlacement.LEFT</code>,
 *  <code>IconPlacement.BOTTOM</code>, and
 *  <code>IconPlacement.TOP</code>.</p>
 *
 *  @default IconPlacement.LEFT
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="iconPlacement", type="String", enumeration="top,bottom,right,left", inherit="no", theme="mobile")]


/**
 *  Orientation of the Label in relation to the CheckBox.
 *  Valid MXML values are <code>"left"</code>, <code>"right"</code>,
 *  <code>"top"</code>, and <code>"bottom"</code>.
 *
 *  <p>In ActionScript, you can use the following constants
 *  to set this property:
 *  <code>LabelPlacement.LEFT</code>,
 *  <code>LabelPlacement.RIGHT</code>,
 *  <code>LabelPlacement.TOP</code>, and
 *  <code>LabelPlacement.BOTTOM</code>.</p>
 *
 *  @see spark.components.supportClasses.LabelPlacement
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Style(name="labelPlacement", type="String", enumeration="top,bottom,left,right", inherit="yes")]


/**
 *  @copy spark.components.supportClasses.GroupBase#style:symbolColor
 *
 *  @default 0x000000
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="cornerRadius", kind="style")]
[Exclude(name="icon", kind="style")]
[Exclude(name="textAlign", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.CheckBoxAccImpl")]

//[IconFile("CheckBox.png")]

/**
 *  The CheckBox component consists of an optional label and a small box
 *  that can contain a check mark or not. 
 *
 *  <p>When a user clicks a CheckBox component or its associated text,
 *  the CheckBox component sets its <code>selected</code> property
 *  to <code>true</code> for checked, and to <code>false</code> for unchecked.</p>
 *
 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
 *  create an item renderer.
 *  For information about creating an item renderer, see 
 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
 *  Custom Spark item renderers</a>. </p>
 * 
 *  <p>The CheckBox control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Wide enough to display the text label of the control</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>18 pixels wide and 18 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin class</td>
 *           <td>spark.skins.spark.CheckBoxSkin</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:CheckBox&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following attributes:</p>
 *  <pre>
 *  &lt;s:CheckBox
 *    <strong>Properties</strong>
 *    symbolColor="0x000000"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/CheckBoxExample.mxml
 *  @see spark.skins.spark.CheckBoxSkin
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class CheckBox extends ToggleButtonBase
{
   // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by CheckBoxAccImpl.
     */
  //  mx_internal static var createAccessibilityImplementation:Function;

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
    public function CheckBox()
    {
        super();
		
    }


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  gap
    //----------------------------------

    /**
     *  The space between layout elements, in pixels.  This is mearly a wrapper for the
     *  <code>gap</code> style.
     *
     *  @langversion 3.0
     *  @playerversion Flash 11.8
     *  @playerversion AIR 3.8
     *  @productversion Royale 0.9.4
     */
    /* public function get gap():int
    {
        return int(getStyle("gap"));
    } */

    /**
     *  @private
     */
    /* public function set gap(value:int):void
    {
        setStyle("gap", value);
    } */
    
    public function set symbolColor(value:uint):void {} // not implemented


    //----------------------------------
    //  labelPlacement
    //----------------------------------

    /**
     *  Affects the placement of the label in relation to the checkbox.  This is mearly a wrapper for the
     *  <code>labelPlacement</code> style.
     *
     *  @default LabelPlacement.RIGHT
     *
     *  @langversion 3.0
     *  @playerversion Flash 11.8
     *  @playerversion AIR 3.8
     *  @productversion Royale 0.9.4
     */
    /* public function get labelPlacement():String
    {
        return String(getStyle("labelPlacement"));
    } */

    /**
     *  @private
     */
    /* public function set labelPlacement(value:String):void
    {
        setStyle("labelPlacement", value);
    } */


    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  suggestedFocusSkinExclusions
    //----------------------------------
    /** 
     * @private 
     */     
   // private static const focusExclusions:Array = ["labelDisplay"];
    
    /**
     *  @private
     */
    /* override public function get suggestedFocusSkinExclusions():Array
    {
        return focusExclusions;
    } */


    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
   /*  override protected function initializeAccessibility():void
    {
        if (CheckBox.createAccessibilityImplementation != null)
            CheckBox.createAccessibilityImplementation(this);
    } */

    COMPILE::JS
    private var _label:WrappedHTMLElement;
    COMPILE::JS
    private var _icon:CheckBoxIcon;
    
    COMPILE::JS
    private static var _checkNumber:Number = 0;
    
    /**
     * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     */
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
        var cb:HTMLInputElement;
        addElementToWrapper(this,'label');
        _label = element;
        _icon = new CheckBoxIcon();
        element.appendChild(_icon.element);
        
        element.appendChild(document.createTextNode(''));
		element.addEventListener("change", changeHandler);
        
        typeNames = 'CheckBox CheckBoxIcon';
        
        return element;
    }
    
    COMPILE::JS
    override public function get label():String
    {
        return _label.childNodes.item(1).nodeValue;
    }
    
    COMPILE::JS
    override public function set label(value:String):void
    {
        _label.childNodes.item(1).nodeValue = value;
    }
    
    [Bindable("change")]
    COMPILE::JS
    override public function get selected():Boolean
    {
        return (_icon.element as HTMLInputElement).checked;
    }
    
    COMPILE::JS
    override public function set selected(value:Boolean):void
    {
        (_icon.element as HTMLInputElement).checked = value;
    }
    
    COMPILE::JS
    override public function get measuredWidth():Number
    {
        var mw:Number = super.measuredWidth;
        return mw + 1; // factor in gap between icon and label?
    }

    COMPILE::JS
    private function changeHandler(event:Event):void
    {
		dispatchEvent(new Event("valueCommit"));
    }
}

}
