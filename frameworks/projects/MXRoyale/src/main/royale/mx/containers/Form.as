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

COMPILE::SWF
{
import flash.display.DisplayObject;
}

import mx.containers.beads.BoxLayout;
import mx.controls.Label;
import mx.core.Container;
import mx.core.IFlexModuleFactory;
import mx.core.IInvalidating;
import mx.core.IUIComponent;
import mx.core.mx_internal;
import mx.styles.IStyleManager2;
//import mx.styles.StyleManager;
import org.apache.royale.core.IChild;

use namespace mx_internal;

//include "../styles/metadata/GapStyles.as";

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Number of pixels between the label and child components.
 *  The default value is 14.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="indicatorGap", type="Number", format="Length", inherit="yes")]

/**
 *  Width of the form labels.
 *  The default is the length of the longest label in the form.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="labelWidth", type="Number", format="Length", inherit="yes")]

/**
 *  Number of pixels between the container's bottom border
 *  and the bottom  edge of its content area.
 *  The default value is 16.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's top border
 *  and the top edge of its content area.
 *  The default value is 16.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

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

//[IconFile("Form.png")]

//[Alternative(replacement="spark.components.Form", since="4.5")] 

/**
 *  The Form container lets you control the layout of a form,
 *  mark form fields as required or optional, handle error messages,
 *  and bind your form data to the Flex data model to perform
 *  data checking and validation.
 *  It also lets you use style sheets to configure the appearance
 *  of your forms.
 *
 *  <p>The following table describes the components you use to create forms in Flex:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Component</th>
 *           <th>Tag</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Form</td>
 *           <td><code>&lt;mx:Form&gt;</code></td>
 *           <td>Defines the container for the entire form, including the overall form layout. 
 *               Use the FormHeading control and FormItem container to define content. 
 *               You can also insert other types of components in a Form container.</td>
 *        </tr>
 *        <tr>
 *           <td>FormHeading</td>
 *           <td><code>&lt;mx:FormHeading&gt;</code></td>
 *           <td>Defines a heading within your form. You can have multiple FormHeading controls within a single Form container.</td>
 *        </tr>
 *        <tr>
 *           <td>FormItem</td>
 *           <td><code>&lt;mx:FormItem&gt;</code></td>
 *           <td>Contains one or more form children arranged horizontally or vertically. Children can be controls or other containers. 
 *               A single Form container can hold multiple FormItem containers.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Form&gt;</code> tag inherits all the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Form
 *    <strong>Styles</strong>
 *    horizontalGap="8"
 *    indicatorGap="14"
 *    labelWidth="<i>Calculated</i>"
 *    paddingBottom="16"
 *    paddingTop="16"
 *    verticalGap="6"
 *    &gt;
 *    ...
 *      <i>child tags</i>
 *    ...
 *  &lt;/mx:Form&gt;
 *  </pre>
 *
 *  @includeExample examples/FormExample.mxml
 *
 *  @see mx.containers.FormHeading
 *  @see mx.containers.FormItem
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Form extends Container
{
//    include "../core/Version.as";

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
    public function Form()
    {
        super();
        
        //showInAutomationHierarchy = true;
        
        layoutObject.target = this;
        layoutObject.direction = BoxDirection.VERTICAL;
        addBead(layoutObject);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    mx_internal var layoutObject:BoxLayout = new BoxLayout();

    /**
     *  @private
     */
    private var measuredLabelWidth:Number;

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function set moduleFactory(moduleFactory:IFlexModuleFactory):void
    {
        super.moduleFactory = moduleFactory;
        
        /*
        styleManager.registerInheritingStyle("labelWidth");
        styleManager.registerSizeInvalidatingStyle("labelWidth");
        styleManager.registerInheritingStyle("indicatorGap");
        styleManager.registerSizeInvalidatingStyle("indicatorGap");
        */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  maxLabelWidth
    //----------------------------------
    
    [Bindable("updateComplete")]
    
    /**
     *  The maximum width, in pixels, of the labels of the FormItems containers in this Form.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxLabelWidth():Number
    {
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:FormItem = getChildAt(i) as FormItem;
            if (child != null)
            {
                var itemLabel:Label = child.itemLabel;
                if (itemLabel)
                    return itemLabel.width;
            }
        }
        
        return 0;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DisplayObjectContainer
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Discard the cached measuredLabelWidth if a child
     *  is added or removed.
     */
    override public function addChild(child:IUIComponent):IUIComponent
    {
        invalidateLabelWidth();
        
        return super.addChild(child);
    }
    
    /**
     * @private
     */
    override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        invalidateLabelWidth();
        super.addElement(c, dispatchEvent);
    }

    /**
     *  @private
     */
    override public function addChildAt(child:IUIComponent,
                                        index:int):IUIComponent
    {
        invalidateLabelWidth();
        
        return super.addChildAt(child, index);
    }

    /**
     * @private
     */
    override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
    {
        invalidateLabelWidth();
        super.addElementAt(c, index, dispatchEvent);
    }
    
    /**
     *  @private
     */
    override public function removeChild(child:IUIComponent):IUIComponent
    {
        invalidateLabelWidth();
        
        return super.removeChild(child);
    }

    /**
     * @private
     */
    override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        invalidateLabelWidth();
        super.removeElement(c, dispatchEvent);
    }
    
    /**
     *  @private
     */
    override public function removeChildAt(index:int):IUIComponent
    {
        invalidateLabelWidth();
        
        return super.removeChildAt(index);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  Calculates the preferred, minimum and maximum sizes of the Form.
     *  For more information about the <code>measure</code> method, 
     *  see the <code>UIComponent.measure()</code> method.
     *  <p>The <code>Form.measure()</code> method sets the
     *  <code>measuredWidth</code> property to the width of the
     *  largest child, plus the values of the <code>paddingLeft</code>
     *  and <code>paddingRight</code> style properties and the
     *  width of the border.</p>
     *
     *  <p>The <code>measuredHeight</code> property is set to the sum
     *  of the <code>measuredHeight</code>S of all children,
     *  plus <code>verticalGap</code> space between each child.
     *  The <code>paddingTop</code> and <code>paddingBottom</code>
     *  style properties and the height of the border are also added.</p>
     *
     *  <p>The <code>measuredMinWidth</code> property is set to the largest
     *  minimum width of the children.
     *  If the child has a percentage value for <code>width</code>,
     *  the <code>minWidth</code> property is used, otherwise the
     *  <code>measuredWidth</code> property is used.
     *  The values of the <code>paddingLeft</code> and
     *  <code>paddingRight</code> style properties and the width
     *  of the border are also added.</p>
     *
     *  <p>The <code>measuredMinHeight</code> property is set to the same value
     *  as that of the <code>measuredHeight</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function measure():void
    {
        super.measure();

        layoutObject.measure();
        
        calculateLabelWidth();
    }

    /**
     *  Responds to size changes by setting the positions
     *  and sizes of this container's children.
     *  For more information about the <code>updateDisplayList()</code> method,
     *  see the <code>UIComponent.updateDisplayList()</code> method. 
     *
     *  <p>The <code>Form.updateDisplayList()</code> method
     *  positions the children in a vertical column,
     *  spaced by the <code>verticalGap</code> style property.
     *  The <code>paddingLeft</code>, <code>paddingRight</code>,
     *  <code>paddingTop</code> and <code>paddingBottom</code>
     *  style properties are applied.</p>
     *
     *  <p>If a child has a percentage width,
     *  it is stretched horizontally to the specified
     *  percentage of the Form container; otherwise, it is set
     *  to its <code>measuredWidth</code> property.
     *  Each child is set to its <code>measuredHeight</code> property.</p>
     *
     *  <p>This method calls the <code>super.updateDisplayList()</code>
     *  method before doing anything else.</p>
     *
     *  @param unscaledWidth Specifies the width of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleX</code> property of the component.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleY</code> property of the component.   
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        layoutObject.updateDisplayList(unscaledWidth, unscaledHeight);
    }

    /**
     *  @private
    override public function styleChanged(styleProp:String):void
    {
        // Check to see if this is one of the style properties
        // that is known to affect layout.
        if (!styleProp ||
            styleProp == "styleName" ||
            styleManager.isSizeInvalidatingStyle(styleProp))
        {
            invalidateLabelWidth();
        }

        super.styleChanged(styleProp);
    }
     */

    /**
    *  @private
    * */
    override public function invalidateSize():void
    {
        super.invalidateSize();
        invalidateLabelWidth();
    }
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    internal function invalidateLabelWidth():void
    {
        // We only need to invalidate the label width
        // after we've been initialized.
        if (!isNaN(measuredLabelWidth)/* && initialized*/)
        {
            measuredLabelWidth = NaN;

            // Need to invalidate the size of all children
            // to make sure they respond to the label width change.
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var child:IUIComponent = IUIComponent(getChildAt(i));
                if (child is IInvalidating)
                    IInvalidating(child).invalidateSize();
            }
        }
    }
        
    /**
     *  @private
     */
    internal function calculateLabelWidth():Number
    {
        // See if we've already calculated it.
        if (!isNaN(measuredLabelWidth))
            return measuredLabelWidth;

        var labelWidth:Number = 0;
        var labelWidthSet:Boolean = false;

        // Determine best label width.
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:IUIComponent = getChildAt(i) as IUIComponent;

            if (child is FormItem && FormItem(child).includeInLayout)
            {
                labelWidth = Math.max(labelWidth,
                                      FormItem(child).getPreferredLabelWidth());
				// only set measuredLabelWidth yet if we have at least one FormItem child
				labelWidthSet = true;
            }
        }

		if (labelWidthSet && labelWidth > 0)
        	measuredLabelWidth = labelWidth;

        return labelWidth;
    }
}

}
