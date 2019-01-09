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

package mx.charts
{

import org.apache.royale.events.MouseEvent;
import org.apache.royale.geom.Rectangle;

import mx.charts.chartClasses.IChartElement;
import mx.charts.renderers.BoxItemRenderer;
import mx.charts.styles.HaloDefaults;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.graphics.SolidColor;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;
import mx.core.IFlexModuleFactory;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

//include "../styles/metadata/GapStyles.as"
//include "../styles/metadata/PaddingStyles.as"
include "styles/metadata/TextStyles.as"

/**
 *  Specifies an IFill object that defines the fill for the legend element.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fill", type="Object", inherit="no")]

/**
 *  Specifies the label placement of the legend element. Recognized values are 
 *  <code>"top"</code>, <code>"bottom"</code>, <code>"left"</code>, and <code>"right"</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelPlacement", type="String", enumeration="top,bottom,right,left", inherit="yes")]

/**
 *  Specifies the class that renders the marker portion of the legend item.
 *  Typically the marker is provided by the chart element that
 *  generates the legend item.
 *  When you create a legend manually, however, this style specifies
 *  what class is used to render the marker. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="legendMarkerRenderer", type="mx.core.IFactory", inherit="no")]

/** 
 *  Specifies the height of the legend element.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="markerHeight", type="Number", format="Length", inherit="yes")]

/**
 *  Specifies the width of the legend element.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="markerWidth", type="Number", format="Length", inherit="yes")]

/**
 *  Specifies the line stroke for the legend element.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="stroke", type="Object", inherit="no")]

/**
 *  Controls the individual legend elements in a chart legend.
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:LegendItem&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:LegendItem
 *    <strong>Properties</strong>
 *    element="<i>No default</i>"    
 *    label="<i>No default</i>"
 *    source="<i>No default</i>"
 *    legendData="<i>No default</i>"
 *    marker="<i>No default</i>"
 *    markerAspectRatio="<i>No default</i>"
 * 
 *    <strong>Styles</strong>
 *    fill="<i>IFill; no default.</i>"
 *    fontWeight="normal|bold"
 *    fontSize="10"
 *    horizontalGap="8"
 *    labelPlacement="right|left|top|bottom"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    markerHeight="15"
 *    markerWidth="10"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    stroke="<i>IStroke; no default</i>"
 * 	  textDecoration="underline|none"
 *    verticalGap="6"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.Legend
 *  @see mx.charts.chartClasses.LegendData
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class LegendItem extends UIComponent
{
//    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class initialization
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
	public function LegendItem()
	{
		super();
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
	 *  @private
	 */
	private var nameLabel:IUITextField;

	/**
	 *  @private
	 */
	private var labelChanged:Boolean = false;

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  element
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  The chart element that is responsible for generating this legend item.
	 *  When a Legend control's contents are automatically generated by a chart,
	 *  this field refers to the element (usually a series)
	 *  that this item represents.
	 *  In some cases, multiple items refer to the same element.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var chartElement:IChartElement;

	//----------------------------------
	//  label
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the label property.
	 */
	private var _label:String = "";

	[Inspectable(category="General")]
	
	/**
	 *  Specifies the text that Flex displays alongside the legend element.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get label():String
	{
		return _label;
	}

	/**
	 *  @private
	 */
	public function set label(value:String):void
	{
		_label = value;
		labelChanged = true;

		invalidateSize();
		invalidateDisplayList();
	}

	//----------------------------------
	//  legendData
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the legendData property.
	 */
	private var _legendData:Object;

	[Inspectable(environment="none")]

	/**
	 *  The LegendData instance that this LegendItem object represents.
	 *  When a chart generates the contents of a Legend control,
	 *  the elements of the chart generate one or more
	 *  LegendData structures for display in the Legend.
	 *  Each LegendData structure generates one LegendItem object.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set legendData(value:Object):void
	{
		_legendData = value;

		if (_marker is IDataRenderer)
			(_marker as IDataRenderer).data = _legendData;
	}

	//----------------------------------
	//  marker
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for the marker property.
	 */
	private var _marker:IFlexDisplayObject;

	[Inspectable]

	/**
	 *  The marker displayed by this legend item.
	 *  Markers are typically assigned by the chart element
	 *  that generated the LegendData associated with this item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get marker():IFlexDisplayObject
	{
		return _marker;
	}
	
	/**
	 *  @private
	 */
	public function set marker(value:IFlexDisplayObject):void
	{
		if (_marker)
			removeChild(_marker as UIComponent);
		
		_marker = value;
		
		if (_marker)
			addChild(_marker as UIComponent);

		if (_marker is IDataRenderer)
			(_marker as IDataRenderer).data = _legendData;

		invalidateDisplayList();
	}

	//----------------------------------
	//  markerAspectRatio
	//----------------------------------

	[Inspectable(category="General")]

	/**
	 *  The aspect ratio for the marker associated with this legend item.
	 *  Some markers provided by chart series are intended for display
	 *  at a particular aspect ratio.
	 *  If this property is set, the legend item guarantees
	 *  the aspect ratio of the marker during layout.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var markerAspectRatio:Number;

	//----------------------------------
	//  source
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  Contains a reference
	 *  to the data series that the LegendItem was generated from
	 *  if you bind the <code>dataProvider</code> property
	 *  of the parent Legend control to a chart control.
	 *  Otherwise, this property contains a reference
	 *  to the object associated with the LegendItem.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get source():Object
	{
		return chartElement;
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
	 *  @private
	 */
	override protected function createChildren():void
    {
        nameLabel = IUITextField(createInFontContext(UITextField));
		//nameLabel.selectable = false;
		nameLabel.styleName = this;
		addChild(UIComponent(nameLabel));

        super.createChildren();

        if (!nameLabel)
		{
			nameLabel = IUITextField(createInFontContext(UITextField));
			//nameLabel.selectable = false;
			nameLabel.styleName = this;
			addChild(UIComponent(nameLabel));
		}
    }

	/**
	 *  @private
	 */
	override protected function measure():void
	{
		super.measure();

		var txt:String = _label;
		
		var labelPlacement:String = getStyle("labelPlacement");
		if (labelPlacement == "" && parent)
			labelPlacement = UIComponent(parent).getStyle("labelPlacement");

		var itemW:Number = 0;
		var itemH:Number = 0;
		
		// If the text is empty (or undefined), make the preferred
		// size big enough to hold a capital and decending character
		// using the current font.
		if (txt == null || txt == "" || txt.length < 2)
			txt = "Wj";

		if (labelChanged)
		{
			labelChanged = false;
			nameLabel.htmlText = _label;
		}

		var textW:Number = nameLabel.textWidth + UITextField.TEXT_WIDTH_PADDING;
		var textH:Number = nameLabel.textHeight + UITextField.TEXT_HEIGHT_PADDING;

		if (isNaN(textW))
			textW = 0;
		if (isNaN(textH))
			textH = 0;

		if (textW > 0 || calculateMarkerWidth() > 0)
		{
			itemW += getStyle("paddingLeft") + getStyle("paddingRight");
			itemH += getStyle("paddingTop") + getStyle("paddingBottom");

			if (labelPlacement == "top" || labelPlacement == "bottom")
			{
				itemW += Math.max(textW, calculateMarkerWidth());
				itemH += getStyle("verticalGap") + calculateMarkerHeight() + textH;
			}
			else
			{
				itemW += getStyle("horizontalGap") + calculateMarkerWidth() + textW;
				itemH += Math.max(textH, calculateMarkerHeight());
			}
		}

		measuredWidth = itemW;
		measuredHeight = itemH;

		// Set the labelField size here.
		// This way the width getter will return the proper value
		// when the resize event is fired.
		nameLabel.setActualSize(getExplicitOrMeasuredWidth(), measuredHeight);
	}

	/**
	 *  @private
	 */
	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var labelPlacement:String = getStyle("labelPlacement");

		var labelX:Number = 0;
		var labelY:Number = 0;

		var markerX:Number = 0;
		var markerY:Number = 0;

		var paddingLeft:Number = getStyle("paddingLeft");
		var paddingRight:Number = getStyle("paddingRight");
		var paddingTop:Number = getStyle("paddingTop");

		var mAvailableWidth:Number = calculateMarkerWidth();
		var mAvailableHeight:Number = calculateMarkerHeight();

		var markerH:Number = mAvailableHeight;
		var markerW:Number = mAvailableWidth;

		var txt:String = _label;

		if (txt == null || txt.length < 2)
			txt = "Wj";

		if (labelChanged)
		{
			labelChanged = false;
			nameLabel.text = _label;
		}

		var textW:Number = nameLabel.textWidth + UITextField.TEXT_WIDTH_PADDING;
		var textH:Number = nameLabel.textHeight + UITextField.TEXT_HEIGHT_PADDING;

		var cx:Number;

		if (isNaN(textW))
			textW = 0;
		if (isNaN(textH))
			textH = 0;

		switch (labelPlacement)
		{
			case "top":
			{
				labelY = paddingTop;
				markerY = labelY + getStyle("verticalGap") + textH;

				cx = paddingLeft +
					 (unscaledWidth - paddingLeft - paddingRight) / 2;
				labelX = cx - textW / 2;
				markerX = cx - markerW / 2;
				
				break;
			}

			case "bottom":
			{
				markerY = paddingTop;
				labelY = markerY + getStyle("verticalGap") + markerH;

				cx = paddingLeft +
					 (unscaledWidth - paddingLeft - paddingRight) / 2;
				labelX = cx - textW / 2;
				markerX = cx - markerW / 2;
				
				break;
			}

			case "left":
			{
				markerX = unscaledWidth - markerW - paddingRight;
				labelX = markerX - getStyle("horizontalGap") - textW;

				labelY = markerY = paddingTop;
				if (textH < markerH)
					labelY += (markerH - textH) / 2;
				else
					markerY += (textH - markerH) / 2;
				
				break;
			}

			default: // default is right
			{
				markerX = paddingLeft;
				labelX = markerX + getStyle("horizontalGap") + markerW;

				markerY = labelY = paddingTop;
				if (markerH < textH)
					markerY += (textH - markerH) / 2;
				else
					labelY += (markerH - textH) / 2;
			
				break;
			}
		}

		nameLabel.move(labelX, labelY);

		if (!isNaN(markerAspectRatio))
		{
			var availableAR:Number = markerW / markerH;
			if (availableAR > markerAspectRatio)
				markerW = markerAspectRatio * markerH;
			else
				markerH = markerW / markerAspectRatio;
		}

		var rc:Rectangle = new Rectangle((mAvailableWidth - markerW) / 2,
										 (mAvailableHeight - markerH) / 2,
										 markerW, markerH);

		if (!_marker)
		{
			var markerClass:IFactory = getStyle("legendMarkerRenderer");
			
			if (markerClass)
				marker = markerClass.newInstance();
			else
				marker = new BoxItemRenderer();

			if (_marker is ISimpleStyleClient)
			{
				(_marker as ISimpleStyleClient).styleName =
					(!chartElement) ? this : chartElement;
			}
		}

		_marker.x = markerX + (mAvailableWidth - markerW) / 2;
		_marker.y = markerY + (mAvailableHeight - markerH) / 2;
		
		_marker.setActualSize(markerW, markerH);
	}

	/**
	 *  @private
	 */
	override public function styleChanged(styleProp:String):void
	{
		invalidateDisplayList();
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function calculateMarkerWidth():Number
	{
		var out:Number = getStyle("markerWidth");
		if (isNaN(out))
			out = 10;
		return out;
	}

	/**
	 *  @private
	 */
	private function calculateMarkerHeight():Number
	{
		var out:Number = getStyle("markerHeight");
		if (isNaN(out))
			out = 15;
		return out;
	}
    
    override public function addedToParent():void
    {
        super.addedToParent();
        commitProperties();
        measure();
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function setActualSize(w:Number, h:Number):void
    {        
        super.setActualSize(w, h);
        updateDisplayList(w, h);
    }

}

}
