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

package mx.charts.chartClasses
{

import mx.display.Graphics;
import org.apache.royale.geom.Rectangle;
COMPILE::SWF
{
import flash.text.TextFieldAutoSize;
import flash.text.TextField;
}

import mx.text.TextFormat;
import mx.core.UITextFormat;

import mx.charts.HitData;
import mx.charts.styles.HaloDefaults;
import mx.core.IDataRenderer;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.events.FlexEvent;
import mx.graphics.IFill;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.styles.CSSStyleDeclaration;
import mx.core.IFlexModuleFactory;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when an object's state changes from visible to invisible.
 *
 *  @eventType mx.events.FlexEvent.HIDE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="hide", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the component becomes visible.
 *
 *  @eventType mx.events.FlexEvent.SHOW
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="show", type="mx.events.FlexEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

include "../styles/metadata/LeadingStyle.as"
//include "../styles/metadata/PaddingStyles.as"
include "../styles/metadata/TextStyles.as"

/**
 *  Background color of the component.
 *  You can either have a <code>backgroundColor</code>
 *  or a <code>backgroundImage</code>, but not both.
 *  Note that some components, like a Button, do not have a background
 *  because they are completely filled with the button face or other graphics.
 *  The DataGrid control also ignores this style.
 *  The default value is <code>undefined</code>.
 *  If both this style and the backgroundImage style are undefined,
 *  the control has a transparent background.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

/**
 *  Black section of a three-dimensional border,
 *  or the color section of a two-dimensional border.
 *  The following components support this style: Button, CheckBox, ComboBox,
 *  MenuBar, NumericStepper, ProgressBar, RadioButton, ScrollBar, Slider,
 *  and all components that support the <code>borderStyle</code> style.
 *  The default value depends on the component class;
 *  if not overriden for the class, it is <code>0xAAB3B3</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="borderColor", type="uint", format="Color", inherit="no")]

/**
 *  Bounding box style.
 *  The possible values are <code>"none"</code>, <code>"solid"</code>,
 *  <code>"inset"</code> and <code>"outset"</code>.
 *  The default value is <code>"inset"</code>.
 *
 *  <p>Note: The <code>borderStyle</code> style is not supported by the
 *  Button control or the Panel container.
 *  To make solid border Panels, set the <code>borderThickness</code>
 *  property, and set the <code>dropShadow</code> property to
 *  <code>false</code> if desired.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="borderStyle", type="String", enumeration="inset,outset,solid,none", inherit="no")]

/**
 *  Number of pixels between the datatip's bottom border and its content area.
 *  The default value is 0.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the datatip's top border and its content area.
 *  The default value is 0.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  Bottom inside color of a button's skin.
 *  A section of the three-dimensional border.
 *  The default value is <code>0xEEEEEE</code> (light gray).
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="shadowColor", type="uint", format="Color", inherit="yes")]

/**
 *  The DataTip control provides information
 *  about a data point to chart users.
 *  When a user moves their mouse over a graphical element, the DataTip
 *  control displays text that provides information about the element.
 *  You can use DataTip controls to guide users as they work with your
 *  application or customize the DataTips to provide additional functionality.
 *
 *  <p>To enable DataTips on a chart, set its <code>showDataTips</code>
 *  property to <code>true</code>.</p>
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DataTip extends UIComponent implements IDataRenderer
{
//    include "../../core/Version.as";
	
    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Class constnats
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const HEX_DIGITS:String = "0123456789ABCDEF";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    [Inspectable(environment="none")]

    /**
     *  Specifies the maximum width of the bounding box, in pixels,
     *  for new DataTip controls. 
     *  
     *  @default 300
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public static var maxTipWidth:Number = 300;

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
    public function DataTip()
    {
        super();

        mouseChildren = false;
        mouseEnabled = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
//	private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);
	
    /**
     *  @private.
     */
    private var _label:IUITextField;

    /**
     *  @private.
     */
    private var _format:TextFormat;

    /**
     *  @private.
     */
    private var _hitData:HitData;

    /**
     *  @private.
     */
    private var _labelWidth:Number;

    /**
     *  @private.
     */
    private var _labelHeight:Number;

    /**
     *  @private.
     */
    private var _shadowFill:IFill = IFill(new SolidColor(0xAAAAAA, 0.55));

    /**
     *  @private.
     */
    private var stroke:SolidColorStroke = new SolidColorStroke(0, 0, 1);

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The HitData structure describing the data point
     *  that the DataTip is rendering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get data():Object
    {
        return _hitData;
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        _hitData = HitData(value);
        stroke = new SolidColorStroke(_hitData.contextColor, 0, 100);
        setText(_hitData.displayText);
        
        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function set moduleFactory(factory:IFlexModuleFactory):void
	{
		super.moduleFactory = factory;
		
        /*
		if (_moduleFactoryInitialized[factory])
			return;
		
		_moduleFactoryInitialized[factory] = true;
        */
	}
	
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function createChildren():void
    {
        super.createChildren();

        // Create the TextField that displays the DataTip text.
        if (!_label)
        {
            _label = IUITextField(createInFontContext(UITextField));

            _label.x = getStyle("paddingLeft")
            _label.y = getStyle("paddingTop");
            COMPILE::SWF
            {
            (_label as TextField).autoSize = TextFieldAutoSize.LEFT;
            (_label as TextField).selectable = false;
            (_label as TextField).multiline = true;
            }

            addChild(UIComponent(_label));
        }
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function measure():void
    {
        super.measure();

        var borderMetrics:Rectangle = new Rectangle(1, 1, 0, 0);

        var leftInset:Number = borderMetrics.left + getStyle("paddingLeft");
        var topInset:Number = borderMetrics.top + getStyle("paddingTop");
        var rightInset:Number = borderMetrics.right + getStyle("paddingRight");
        var bottomInset:Number = borderMetrics.bottom + getStyle("paddingBottom");

        var widthSlop:Number = leftInset + rightInset;
        var heightSlop:Number = topInset + bottomInset;

        _label.wordWrap = false;

        if (_label.textWidth + widthSlop > DataTip.maxTipWidth)
        {
            _label.width = DataTip.maxTipWidth - widthSlop;
            _label.wordWrap = true;
            _label.width = _label.textWidth + widthSlop;
        }

        _labelWidth = _label.width + widthSlop;
        _labelHeight = _label.height + heightSlop;
		
		measuredWidth = _labelWidth + 6;
        measuredHeight = _labelHeight + 6;        
    }
    /**
     *  @inheritDoc
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

        var g:Graphics = graphics;
        g.clear();

        var xpos:Number = 0;
        var ypos:Number = 0;

        g.moveTo(measuredWidth, 2);
        _shadowFill.begin(g,
            new Rectangle(xpos, ypos, measuredWidth, measuredHeight),null);
        g.lineTo(measuredWidth + 2, 2);
        g.lineTo(measuredWidth + 2, measuredHeight + 2);
        g.lineTo(2,measuredHeight + 2);
        g.lineTo(2,measuredHeight);
        g.lineTo(measuredWidth - 2, measuredHeight - 2);
        g.lineTo(measuredWidth - 2, 2);
        _shadowFill.end(g);

        var fill:IFill = IFill(new SolidColor(getStyle("backgroundColor"), 0.8));

        GraphicsUtilities.fillRect(g, xpos, ypos, measuredWidth,
                                   measuredHeight, fill, stroke);

        _label.x = xpos + getStyle("paddingLeft")
        _label.y = ypos + getStyle("paddingTop");
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function setText(t:String):void
    {
        // Make sure the text styles are applied.
        // However, we don't want leftMargin and rightMargin
        // of the TextField's TextFormat to be set to the
        // paddingLeft and paddingRight of the ToolTip style.
        // We want these styles to affect the space between the
        // TextField and the border, but not the margins within
        // the TextField.
        var _format:UITextFormat = _label.getUITextFormat();
        _format.leftMargin = 0;
        _format.rightMargin = 0;
		_label.setTextFormat(_format);
       
        _label.htmlText = t;
        
        invalidateSize();
    }

    /**
     *  @private
     */
    private function decToColor(v:Number):String
    {
        var str:String = "#";
        for (var i:int = 5; i >= 0; i--)
        {
            str += HEX_DIGITS.charAt((v >> i*4) & 0xF);
        }
        return str;
    }
}

}
