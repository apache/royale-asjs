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
/* 
import mx.core.IVisualElement;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;

import spark.core.IDisplayText;
import spark.components.supportClasses.TextBase;
import spark.utils.LabelUtil;
 use namespace mx_internal;
    
 */
 import spark.components.supportClasses.DropDownListBase;
 import spark.components.beads.DropDownListView;


//--------------------------------------
//  Other metadata
//--------------------------------------

//[IconFile("DropDownList.png")]

/**
 * Because this component does not define a skin for the mobile theme, Adobe
 * recommends that you not use it in a mobile application. Alternatively, you
 * can define your own mobile skin for the component. For more information,
 * see <a href="http://help.adobe.com/en_US/flex/mobileapps/WS19f279b149e7481c698e85712b3011fe73-8000.html">Basics of mobile skinning</a>.
 */
//[DiscouragedForProfile("mobileDevice")]

/**
 *  The DropDownList control contains a drop-down list
 *  from which the user can select a single value.
 *  Its functionality is very similar to that of the
 *  SELECT form element in HTML.
 *
 *  <p>The DropDownList control consists of the anchor button, 
 *  prompt area, and drop-down-list, 
 *  Use the anchor button to open and close the drop-down-list. 
 *  The prompt area displays a prompt String, or the selected item 
 *  in the drop-down-list.</p>
 *
 *  <p>When the drop-down list is open:</p>
 *  <ul>
 *    <li>Clicking the anchor button closes the drop-down list 
 *      and commits the currently selected data item.</li>
 *    <li>Clicking outside of the drop-down list closes the drop-down list 
 *      and commits the currently selected data item.</li>
 *    <li>Clicking on a data item selects that item and closes the drop-down list.</li>
 *    <li>If the <code>requireSelection</code> property is <code>false</code>, 
 *      clicking on a data item while pressing the Control key deselects 
 *      the item and closes the drop-down list.</li>
 *  </ul>
 *
 *  <p><b>Note: </b>The Spark list-based controls (the Spark ListBase class and its subclasses
 *  such as ButtonBar, ComboBox, DropDownList, List, and TabBar) do not support the BasicLayout class
 *  as the value of the <code>layout</code> property. 
 *  Do not use BasicLayout with the Spark list-based controls.</p>
 *
 *  <p>To use this component in a list-based component, such as a List or DataGrid, 
 *  create an item renderer.
 *  For information about creating an item renderer, see 
 *  <a href="http://help.adobe.com/en_US/flex/using/WS4bebcd66a74275c3-fc6548e124e49b51c4-8000.html">
 *  Custom Spark item renderers</a>. </p>
 *  
 *  <p>The DropDownList control has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>112 pixels wide and 21 pixels high</td></tr>
 *     <tr><td>Minimum size</td><td>112 pixels wide and 21 pixels high</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *     <tr><td>Default skin class</td><td>spark.skins.spark.DropDownListSkin</td></tr>
 *  </table>
 *
 *  @mxml <p>The <code>&lt;s:DropDownList&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:DropDownList 
 *    <strong>Properties</strong>
 *    prompt=""
 *    typicalItem="null"
 * 
 *    <strong>Events</strong>
 *    closed="<i>No default</i>"
 *    open="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.skins.spark.DropDownListSkin
 *  @see spark.components.supportClasses.DropDownController
 *
 *  @includeExample examples/DropDownListExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class DropDownList extends DropDownListBase
{
    //include "../core/Version.as";
    
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
    public function DropDownList()
    {
        super();
        typeNames += " DropDownList";
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin parts
    //
    //--------------------------------------------------------------------------    
    
    //----------------------------------
    //  labelDisplay
    //----------------------------------

   // [SkinPart(required="false")]

    /**
     *  An optional skin part that holds the prompt or the text of the selected item. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   // public var labelDisplay:IDisplayText;
       
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	private var labelChanged:Boolean = false;
    /* 
    private var labelDisplayExplicitWidth:Number; 
    private var labelDisplayExplicitHeight:Number; 
    private var sizeSetByTypicalItem:Boolean;
     */
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  baselinePosition
    //----------------------------------
    
    /**
     *  @private
     */
    /* override public function get baselinePosition():Number
    {
        return getBaselinePositionForPart(labelDisplay as IVisualElement);
    } */

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  prompt
    //----------------------------------

    /**
     *  @private
     */
    private var _prompt:String = "";

    [Inspectable(category="General", defaultValue="")]
    
    /**
     *  The prompt for the DropDownList control. 
     *  The prompt is a String that is displayed in the
     *  DropDownList when <code>selectedIndex</code> = -1.  
     *  It is usually a String such as "Select one...". 
     *  Selecting an item in the drop-down list replaces the 
     *  prompt with the text from the selected item.
     *  
     *  @default ""
     *       
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get prompt():String
    {
        return _prompt;
    }

    /**
     *  @private
     */
    public function set prompt(value:String):void
    {
        if (_prompt == value)
            return;
            
        _prompt = value;
        labelChanged = true;
        invalidateProperties();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //[Inspectable(category="Data")]
    
    /**
     *  Layouts use the preferred size of the <code>typicalItem</code>
     *  when fixed row or column sizes are required, but a specific 
     *  <code>rowHeight</code> or <code>columnWidth</code> value is not set.
     *  Similarly virtual layouts use this item to define the size 
     *  of layout elements that have not been scrolled into view.
     *
     *  <p>The container  uses the typical data item, and the associated item renderer, 
     *  to determine the default size of the container children. 
     *  By defining the typical item, the container does not have to size each child 
     *  as it is drawn on the screen.</p>
     *
     *  <p>Setting this property sets the <code>typicalLayoutElement</code> property
     *  of the layout.</p>
     * 
     *  <p>Restriction: if the <code>typicalItem</code> is an IVisualItem, it must not 
     *  also be a member of the data provider.</p>
     * 
     *  <p>Note: Setting <code>typicalItem</code> overrides any explicit width or height
     *  set on the <code>labelDisplay</code> skin part. </p>
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function set typicalItem(value:Object):void
    {
        super.typicalItem = value;
        invalidateSize();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */ 
    /* override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (labelChanged)
        {
            labelChanged = false;
            updateLabelDisplay();
        }
    } */
    
    /**
     *  @private
     */ 
    /* override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == labelDisplay)
        {
            labelChanged = true;
            invalidateProperties();
        }
    } */
    
    /**
     *  @private
     */
    /* override protected function measure():void
    {
        var labelComp:TextBase = labelDisplay as TextBase;
        
        // If typicalItem is set, then use it for measurement
        if (labelComp && typicalItem != null)
        {   
            // Save the labelDisplay's dimensions in case we clear out typicalItem
            if (!sizeSetByTypicalItem)
            {
                labelDisplayExplicitWidth = labelComp.explicitWidth;
                labelDisplayExplicitHeight = labelComp.explicitHeight;
                sizeSetByTypicalItem = true;
            }
            
            labelComp.explicitWidth = NaN;
            labelComp.explicitHeight = NaN;
            
            // Swap in the typicalItem into the labelDisplay
            updateLabelDisplay(typicalItem);
            UIComponentGlobals.layoutManager.validateClient(skin, true);
            
            // Force the labelDisplay to be sized to the measured size
            labelComp.width = labelComp.measuredWidth;
            labelComp.height = labelComp.measuredHeight;
            
            // Set the labelDisplay back to selectedItem
            updateLabelDisplay();
        }
        else if (labelComp && sizeSetByTypicalItem && typicalItem == null)
        {
            // Restore the labelDisplay to its original size
            labelComp.width = labelDisplayExplicitWidth;
            labelComp.height = labelDisplayExplicitHeight;
            sizeSetByTypicalItem = false;
        }
        
        super.measure();
    } */
    
    /**
     *  @private
     *  Called whenever we need to update the text passed to the labelDisplay skin part
     */
    // TODO (jszeto): Make this protected and make the name more generic (passing data to skin) 
    /* override mx_internal function updateLabelDisplay(displayItem:* = undefined):void
    {
        if (labelDisplay)
        {
              if (displayItem == undefined)
                  displayItem = selectedItem;
              if (displayItem != null && displayItem != undefined)
                  labelDisplay.text = LabelUtil.itemToLabel(displayItem, labelField, labelFunction);
              else
                  labelDisplay.text = prompt;
		}
    } */
    
    /**
     *  @private
     *  Because DropDown extends List which overrides numChildren to point to
     *  the DataGroup, the default measurement code will be incorrect
     *  
     *  @royaleignorecoercion spark.components.beads.DropDownListView 
     */
    override public function get measuredWidth():Number
    {
        var mw:Number = super.measuredWidth;
        if (mw == 0)
            mw = (view as DropDownListView).label.measuredWidth;
        return mw;
    }
    
    /**
     *  @private
     *  Because DropDown extends List which overrides numChildren to point to
     *  the DataGroup, the default measurement code will be incorrect
     *  
     *  @royaleignorecoercion spark.components.beads.DropDownListView 
     */
    override public function get measuredHeight():Number
    {
        var mh:Number = super.measuredHeight;
        if (mh == 0)
            mh = (view as DropDownListView).label.measuredHeight;
        return mh;
    }
}
}