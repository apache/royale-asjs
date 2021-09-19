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

package mx.containers.accordionClasses
{

import mx.core.UIComponent;
import org.apache.royale.events.Event;
import mx.events.MouseEvent;
import mx.containers.Accordion;
import mx.controls.Button;
import mx.core.Container;
import mx.core.EdgeMetrics;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

//[AccessibilityClass(implementation="mx.accessibility.AccordionHeaderAccImpl")]

/**
 *  The AccordionHeader class defines the appearance of the navigation buttons
 *  of an Accordion.
 *  You use the <code>getHeaderAt()</code> method of the Accordion class to get a reference
 *  to an individual AccordionHeader object.
 *
 *  @see mx.containers.Accordion
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AccordionHeader extends Button implements IDataRenderer
{
	//include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class mixins
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Placeholder for mixin by AccordionHeaderAccImpl.
	 */
	mx_internal static var createAccessibilityImplementation:Function;

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
	public function AccordionHeader()
	{
		super();

		// Since we play games with allowing selected to be set without
		// toggle being set, we need to clear the default toggleChanged
		// flag here otherwise the initially selected header isn't
		// drawn in a selected state.
		//toggleChanged = false;
		mouseFocusEnabled = false;
		tabEnabled = false;
		tabFocusEnabled = false;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private var focusObj:UIComponent;

	/**
	 *  @private
	 */
	private var focusSkin:IFlexDisplayObject;

	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  data
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the _data property.
	 */
	private var _data:Object;

	/**
	 *  Stores a reference to the content associated with the header.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function get data():Object
	{
		return _data;
	}
	
	/**
	 *  @private
	 */
	override public function set data(value:Object):void
	{
		_data = value;
	}
	
	//----------------------------------
	//  selected
	//----------------------------------

	/**
	 *  @private
	 */
	public var _selected:Boolean = false;
	
	override public function set selected(value:Boolean):void
	{
		_selected = value;

		invalidateDisplayList();
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: UIComponent
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	/* override */ protected function initializeAccessibility():void
	{
		if (AccordionHeader.createAccessibilityImplementation != null)
			AccordionHeader.createAccessibilityImplementation(this);
	}
	
	/**
	 *  @private
	 */
	override public function drawFocus(isFocused:Boolean):void
	{
		// Accordion header focus is drawn inside the control.
		if (isFocused)  // && !isEffectStarted
		{
			if (!focusObj)
			{
				var focusClass:Class = getStyle("focusSkin");

				focusObj = new focusClass();

				var focusStyleable:ISimpleStyleClient = focusObj as ISimpleStyleClient;
				if (focusStyleable)
					focusStyleable.styleName = this;

				addChild(focusObj);

				// Call the draw method if it has one
				focusSkin = focusObj as IFlexDisplayObject;
			}

			if (focusSkin)
			{
				focusSkin.move(0, 0);
				focusSkin.setActualSize(unscaledWidth, unscaledHeight);
			}
			focusObj.visible = true;

			dispatchEvent(new Event("focusDraw"));
		}
		else if (focusObj)
		{
			focusObj.visible = false;
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Button
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	/* override */ mx_internal function layoutContents(unscaledWidth:Number,
											     unscaledHeight:Number,
											     offset:Boolean):void
	{
		//super.layoutContents(unscaledWidth, unscaledHeight, offset);

		// Move the focus object to front.
		// AccordionHeader needs special treatment because it doesn't
		// show focus by having the standard focus ring display outside.
		if (focusObj)
			setChildIndex(focusObj, numChildren - 1);
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden event handlers: Button
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	/* override */ protected function rollOverHandler(event:MouseEvent):void
	{
		//super.rollOverHandler(event);

		// The halo design specifies that accordion headers overlap
		// by a pixel when layed out. In order for the border to be
		// completely drawn on rollover, we need to set our index
		// here to bring this header to the front.
		var accordion:Accordion = Accordion(parent);
		if (accordion.enabled)
		{
			accordion.rawChildren.setChildIndex(this,
				accordion.rawChildren.numChildren - 1);
		}
	}
}

}
