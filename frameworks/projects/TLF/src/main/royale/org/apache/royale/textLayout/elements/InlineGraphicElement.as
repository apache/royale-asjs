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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ElementFormat;
	import org.apache.royale.text.engine.GraphicElement;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.engine.TextBaseline;
	import org.apache.royale.text.engine.TextRotation;
	import org.apache.royale.textLayout.compose.ISWFContext;
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.events.StatusChangeEvent;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Float;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.property.Property;
	import org.apache.royale.textLayout.property.PropertyFactory;

	// import org.apache.royale.utils.OSUtils;
	/** The InlineGraphicElement class handles graphic objects that display inline in the text. 
	 * 
	 * <p>You can embed a graphic or any DisplayObject or specify a URl for the location of the graphic. 
	 * The <code>height</code> and <code>width</code> properties of InlineGraphicElement control the actual size 
	 * of the graphic to display.  These values also control how much space to allocate
	 * for the graphic in the ITextLine object that contains the graphic.
	 * The <code>height</code> and <code>width</code> properties each can be one of:</p>
	 * <ol>
	 * <li>A number of pixels</li>
	 * <li>A percent of the measured size of the image</li>
	 * <li>The constant, "auto", which computes the size (Default value)</li>
	 * </ol>
	 * There are three properties, or accessors, pertaining to the width and height of a graphic:
	 * <ul>
	 * <li>The <code>width</code> and <code>height</code> properties</li>
	 * <li>The <code>measuredWidth</code> and <code>measuredHeight</code> properties, which are the width or height of the graphic at load time</li>
	 * <li>The <code>actualWidth</code> and <code>actualHeight</code> properties, which are the actual display and compose width and height of the graphic as computed from <code>width</code> or <code>height</code> and <code>measuredWidth</code> or <code>measuredHeight</code></li>
	 * </ul>
	 * <p>The values of the <code>actualWidth</code> and <code>actualHeight</code> properties are always zero until the graphic 
	 * is loaded.</p>
	 *
	 * <p>If <code>source</code> is specified as a URI, the graphic is loaded asynchronously. If it's a DisplayObject, TextLayout uses the <code>width</code> and 
	 * <code>height</code> at the time the graphic is set into the InlineGraphicElement object as <code>measuredHeight</code> and <code>measuredWidth</code>; 
	 * its width and height are read immediately.</p>
	 * <p><strong>Notes</strong>: For graphics that are loaded asynchronously the user must listen for a 
	 * StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE event on the TextFlow and call <code>IFlowComposer.updateAllControllers()</code> to have the 
	 * graphic appear. The value of <code>measuredWidth</code> and <code>measuredHeight</code> for graphics that are in the 
	 * process of loading is zero.</p>
	 *
	 * <p>Some inline graphics are animations or videos that possibly have audio. They begin to run the first time they are composed after they finish loading.  
	 * They don't stop running until the flowComposer on the TextFlow is set to null.  At that time they are stopped and unloaded.</p>
	 * 
	 * The following restrictions apply to InLineGraphicElement objects:
	 * <ol>
	 *  <li>On export of TLFMarkup, source is converted to a string. If the graphic element is 
	 *      a class, the Text Layout Framework can't export it properly</li>.
	 *  <li>When doing a copy/paste operation of an InlineGraphicElement, if source can't be 
	 *      used to create a new InLineGraphicElement, it won't be pasted.  For example if 
	 *      source is a DisplayObject, or if the graphic is set directly, it can't be 
	 *      duplicated.  Best results are obtained if the source is the class of an embedded graphic 
	 *      though that doesn't export/import.</li>
	 *  <li>InLineGraphicElement objects work in the factory (TextFlowTextLineFactory) only if 
	 *      the source is a class or if you explicitly set the graphic to a loaded graphic. 
	 *      InlineGraphic objects that require delayed loads generally do not show up.</li>
	 * </ol>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see #actualHeight
	 * @see #actualWidth
	 * @see flash.display.DisplayObject DisplayObject
	 * @see org.apache.royale.textLayout.compose.IFlowComposer#updateAllControllers()
	 * @see org.apache.royale.textLayout.events.StatusChangeEvent StatusChangeEvent
	 * @see TextFlow
	 */
	public final class InlineGraphicElement extends FlowLeafElement implements IInlineGraphicElement
	{
		private var _source:Object;
		private var _graphic:IUIBase;
		private var _placeholderGraphic:IParentIUIBase;     // a fake IUIBase we put in the ITextLine so it generates an atom
		private var _elementWidth:Number;
		private var _elementHeight:Number;
		// internal status of the graphic.  there are more status here than publicly shown
		private var _graphicStatus:Object;
		// set when its ok - must delay until on the stage for dynamically loaded images
		private var okToUpdateHeightAndWidth:Boolean;
		private var _width:*;
		private var _height:*;
		// stash away the actual width and height of the graphic
		private var _measuredWidth:Number;
		private var _measuredHeight:Number;
		private var _float:*;
		static private const graphicElementText:String = "\FDEF";

		/** Constructor - create new InlineGraphicElement object
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function InlineGraphicElement()
		{
			super();
			// The width/height on the FE.fe don't actually take until the InlineGraphicElement is loaded.
			okToUpdateHeightAndWidth = false;
			_measuredWidth = 0;
			_measuredHeight = 0;
			internalSetWidth(undefined);
			internalSetHeight(undefined);
			_graphicStatus = InlineGraphicElementStatus.LOAD_PENDING;
			setTextLength(1);
			_text = graphicElementText;     // echo text property we get from FTE
		}

		override public function get className():String
		{
			return "InlineGraphicElement";
		}

		/** @private */
		override public function createContentElement():void
		{
			if (_blockElement)
				return;

			calculateComputedFormat(); // BEFORE creating the element
			var graphicElement:GraphicElement = new GraphicElement();
			_blockElement = graphicElement;
			CONFIG::debug
			{
				Debugging.traceFTECall(_blockElement, null, "new GraphicElement()"); }

			updateContentElement();

			super.createContentElement();
		}

		private function updateContentElement():void
		{
			var graphicElement:GraphicElement = _blockElement as GraphicElement;
			// Setting textRotation throws if any of the parent GroupElements have textRotation other than ROTATE_0
			CONFIG::debug
			{
				assert(_blockElement.textRotation == TextRotation.ROTATE_0, "invalid text Rotation in ILG"); }
			// CONFIG::debug { Debugging.traceFTEAssign(_blockElement,"textRotation",String(rotationPropertyDefinition.defaultValue)); }

			// we need to keep a place holder in the ge.graphic in order to be able to navigate
			// to the element.  Without it, the FTE model will remove the atom and selection will not be
			// possible. - gak 12.12.08
			if (!_placeholderGraphic)
				_placeholderGraphic = new UIBase();
			graphicElement.graphic = _placeholderGraphic;

			if (effectiveFloat != Float.NONE)
			{
				if (graphicElement.elementHeight != 0)
					graphicElement.elementHeight = 0 ;
				if (graphicElement.elementWidth != 0)
					graphicElement.elementWidth = 0;
			}
			else
			{
				var height:Number = elementHeightWithMarginsAndPadding();
				if (graphicElement.elementHeight != height)
					graphicElement.elementHeight = height;
				var width:Number = elementWidthWithMarginsAndPadding();
				if (graphicElement.elementWidth != width)
					graphicElement.elementWidth = width;
			}
			CONFIG::debug
			{
				Debugging.traceFTEAssign(_blockElement, "elementHeight", graphicElement.elementHeight); }
			CONFIG::debug
			{
				Debugging.traceFTEAssign(_blockElement, "elementWidth", graphicElement.elementWidth); }
			CONFIG::debug
			{
				Debugging.traceFTEAssign(graphicElement, "graphic", graphic); }   // needs float fix
		}

		// Recalculate graphicElement width & height after a format change
		/** @private */
		public override function get computedFormat():ITextLayoutFormat
		{
			var updateGraphicElement:Boolean = _computedFormat == null;
			super.computedFormat;
			if (updateGraphicElement && _blockElement)
				updateContentElement();

			return _computedFormat;
		}

		/** @private */
		public function elementWidthWithMarginsAndPadding():Number
		{
			// no textflow is no padding
			var textFlow:ITextFlow = getTextFlow();
			if (!textFlow)
				return elementWidth;
			var paddingAmount:Number = textFlow.computedFormat.blockProgression == BlockProgression.RL ? getEffectivePaddingTop() + getEffectivePaddingBottom() : getEffectivePaddingLeft() + getEffectivePaddingRight();
			return elementWidth + paddingAmount;
		}

		/** @private */
		public function elementHeightWithMarginsAndPadding():Number
		{
			// no textflow is no padding
			var textFlow:ITextFlow = getTextFlow();
			if (!textFlow)
				return elementHeight;
			var paddingAmount:Number = textFlow.computedFormat.blockProgression == BlockProgression.RL ? getEffectivePaddingLeft() + getEffectivePaddingRight() : getEffectivePaddingTop() + getEffectivePaddingBottom();
			return elementHeight + paddingAmount;
		}

		// internal values for _graphicStatus.  It can also be an error code.
		/** load initiated */
		static private const LOAD_INITIATED:String = "loadInitiated";
		/** public status string for open event received status.  @see flash.display.LoaderInfo.Events.open */
		static private const OPEN_RECEIVED:String = "openReceived";
		/** load complete received status.  @see flash.display.LoaderInfo.Events.open */
		static private const LOAD_COMPLETE:String = "loadComplete";
		/** loaded from embed */
		static private const EMBED_LOADED:String = "embedLoaded";
		/** specified as a DisplayObject */
		static private const DISPLAY_OBJECT:String = "displayObject";
		/** null graphic */
		static private const NULL_GRAPHIC:String = "nullGraphic";

		// private static var isMac:Boolean = OSUtils.getOS() ==  OSUtils.MAC_OS;
		/** The embedded graphic. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get graphic():IUIBase
		{
			return _graphic;
		}

		private function setGraphic(value:IUIBase):void
		{
			_graphic = value;
			// I think this should do a model change. But it will break paste because when we paste we do a reimport,
			// which will cause a delayed update, which will bump the generation number *after* the command. Which 
			// will cause undo of the command not to work.
			// modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength);
		}

		/** @private */
		public function get placeholderGraphic():IParentIUIBase
		{
			return _placeholderGraphic;
		}

		/** Width used by composition for laying out text around the graphic. @private */
		public function get elementWidth():Number
		{
			return _elementWidth;
		}

		/** Width used by composition for laying out text around the graphic. @private */
		public function set elementWidth(value:Number):void
		{
			_elementWidth = value;

			if (_blockElement)
			{
				(_blockElement as GraphicElement).elementWidth = (effectiveFloat != Float.NONE) ? 0 : elementWidthWithMarginsAndPadding();
				CONFIG::debug
				{
					Debugging.traceFTEAssign(GraphicElement(_blockElement as GraphicElement), "elementWidth", GraphicElement(_blockElement).elementWidth); }
			}

			modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength, true, false);
		}

		/** Height used by composition for laying out text around the graphic. @private */
		public function get elementHeight():Number
		{
			return _elementHeight;
		}

		/** Height used by composition for laying out text around the graphic. @private */
		public function set elementHeight(value:Number):void
		{
			_elementHeight = value;

			if (_blockElement)
			{
				(_blockElement as GraphicElement).elementHeight = (effectiveFloat != Float.NONE) ? 0 : elementHeightWithMarginsAndPadding();
				CONFIG::debug
				{
					Debugging.traceFTEAssign((_blockElement as GraphicElement), "elementHeight", GraphicElement(_blockElement).elementHeight); }
			}
			modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength, true, false);
		}

		/** Definition of the height property @private */
		static private var _heightPropertyDefinition:Property;
		static public function get heightPropertyDefinition():Property{
			if(_heightPropertyDefinition == null)
				_heightPropertyDefinition = PropertyFactory.numPercentEnum("height", "auto", false, null, 0, 32000, "0%", "1000000%", "auto");
			
			return _heightPropertyDefinition;
		}
		/** Definition of the width property @private */
		static private var _widthPropertyDefinition:Property;
		static public function get widthPropertyDefinition():Property{
			if(_widthPropertyDefinition == null)
				_widthPropertyDefinition = PropertyFactory.numPercentEnum("width", "auto", false, null, 0, 32000, "0%", "1000000%", "auto");
			
			return _widthPropertyDefinition;
		}
		/** Disabled due to player bug.  @private */
		static private var _rotationPropertyDefinition:Property;
		static public function get rotationPropertyDefinition():Property{
			if(_rotationPropertyDefinition == null)
				_rotationPropertyDefinition = PropertyFactory.enumString("rotation", "rotate0", false, null, "rotate0", "rotate90", "rotate180", "rotate270");
			
			return _rotationPropertyDefinition;
		}
		/** Definition of the float property @private */
		static private var _floatPropertyDefinition:Property;
		static public function get floatPropertyDefinition():Property{
			if(_floatPropertyDefinition == null)
				_floatPropertyDefinition = PropertyFactory.enumString("float", "none", false, null, "none", "left", "right", "start", "end");
			
			return _floatPropertyDefinition;
		}

		/** The current status of the image. On each status change the owning TextFlow sends a StatusChangeEvent.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @return one of LOAD_PENDING, LOADING, SIZE_PENDING, READY, ERROR
		 * @see org.apache.royale.textLayout.elements.InlineGraphicElementStatus
		 * @see org.apache.royale.textLayout.events.StatusChangeEvent
		 */
		public function get status():String
		{
			switch (_graphicStatus)
			{
				case LOAD_INITIATED:
				case OPEN_RECEIVED:
					return InlineGraphicElementStatus.LOADING;
				case LOAD_COMPLETE:
				case EMBED_LOADED:
				case DISPLAY_OBJECT:
				case NULL_GRAPHIC:
					return InlineGraphicElementStatus.READY;
				case InlineGraphicElementStatus.LOAD_PENDING:
				case InlineGraphicElementStatus.SIZE_PENDING:
					return String(_graphicStatus);
			}
			// CONFIG::debug { assert(_graphicStatus is ErrorEvent,"unexpected _graphicStatus"); }
			return InlineGraphicElementStatus.ERROR;
		}

		/** @private
		 */
		public override function getText(relativeStart:int = 0, relativeEnd:int = -1, paragraphSeparator:String = "\n"):String
		{
			if (relativeEnd == -1)
				relativeEnd = textLength;

			// We could probably just return _text (U+FDEF), but this allows clients to change _text to some other value
			// and getText() will still work. (Of course, I cannot think of a reason you'd want to do that...)
			return _text ? _text.substring(relativeStart, relativeEnd) : "";
		}

		private function changeGraphicStatus(stat:Object):void
		{
			var oldStatus:String = status;
			_graphicStatus = stat;
			var newStatus:String = status;
			if (oldStatus != newStatus)// TODO do we need this?  || stat is ErrorEvent
			{
				var tf:ITextFlow = getTextFlow();
				if (tf)
				{
					if (newStatus == InlineGraphicElementStatus.SIZE_PENDING)
						tf.processAutoSizeImageLoaded(this);
					tf.dispatchEvent(new StatusChangeEvent(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, false, false, this, newStatus));// TODO removed the following: stat as ErrorEvent (instead of null)
				}
			}
		}

		/** The width of the graphic. The value can be 'auto', a number of pixels or a percent of the measured width of the image.
		 * 
		 * <p>Legal values are org.apache.royale.textLayout.formats."auto" and org.apache.royale.textLayout.formats.FormatValue.INHERIT.</p>
		 * <p>Legal values as a number are from 0 to 32000.</p>
		 * <p>Legal values as a percent are numbers from 0 to 1000000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined or "inherit" the InlineGraphicElement will use the default value of "auto".</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #actualWidth
		 * @see #measuredWidth
		 */
		public function get width():*
		{
			return _width;
		}

		public function set width(w:*):void
		{
			internalSetWidth(w);
			modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength);
		}

		/** The natural width of the graphic. This is the width of the graphic at load time.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #actualWidth
		 * @see #width
		 */
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}

		/** The actual width in effect. This is the display and compose width that's computed from the
		 * <code>width</code> and <code>measuredWidth</code> properties.
		 *
		 * <p>The values of the <code>actualWidth</code>property are computed according to the 
		 * following table:</p>
		 * <table class="innertable" width="100%">
		 * <tr>
		 *   <th>width property</th> 
		 *   <th>actualWidth</th>
		 * </tr>
		 * <tr>
		 *   <td>auto</td>
		 *   <td>measuredWidth</td>
		 * </tr>
		 * <tr>
		 *   <td>w a Percent</td>
		 *   <td>w percent of measuredWidth</td>
		 * </tr>
		 * <tr>
		 *   <td>w a Number</td>
		 *   <td>w</td>
		 * </tr>
		 * </table>
		 *
		 * <p><strong>Notes</strong>: If the inline graphic is a IUIBase, its width and height are read immediately.
		 * If <code>measuredWidth</code> or <code>measuredHeight</code> are zero, then any auto calculations that would cause a divide by zero sets the result to zero.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #measuredWidth
		 * @see #width
		 *
		 */
		public function get actualWidth():Number
		{
			return elementWidth;
		}

		private function widthIsComputed():Boolean
		{
			return internalWidth is String;
		}

		private function get internalWidth():Object
		{
			return _width === undefined ? widthPropertyDefinition.defaultValue : _width;
		}

		private function computeWidth():Number
		{
			CONFIG::debug
			{
				assert(widthIsComputed(), "bad call to InlineGraphicElement.computeWidth"); }
			if (internalWidth == "auto")
			{
				if (internalHeight == "auto")
					return _measuredWidth;
				if (_measuredHeight == 0 || _measuredWidth == 0)
					return 0;
				// can't rely on height being calculated yet
				var effHeight:Number = heightIsComputed() ? computeHeight() : Number(internalHeight);
				return effHeight / _measuredHeight * _measuredWidth;
			}
			return widthPropertyDefinition.computeActualPropertyValue(internalWidth, _measuredWidth);
		}

		private function internalSetWidth(w:*):void
		{
			_width = widthPropertyDefinition.setHelper(width, w);
			elementWidth = widthIsComputed() ? 0 : Number(internalWidth);
			if (okToUpdateHeightAndWidth && graphic)
			{
				if (widthIsComputed())
					elementWidth = computeWidth();
				graphic.width = elementWidth;
				CONFIG::debug
				{
					Debugging.traceFTEAssign(graphic, "width", elementWidth); }
				if (internalHeight == "auto")
				{
					elementHeight = computeHeight();
					graphic.height = elementHeight;
					CONFIG::debug
					{
						Debugging.traceFTEAssign(graphic, "height", elementHeight); }
				}
			}
		}

		/** The height of the image. May be 'auto', a number of pixels or a percent of the measured height. 
		 *
		 * <p>Legal values are org.apache.royale.textLayout.formats."auto" and org.apache.royale.textLayout.formats.FormatValue.INHERIT.</p>
		 * <p>Legal values as a number are from 0 to 32000.</p>
		 * <p>Legal values as a percent are numbers from 0 to 1000000.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined or "inherit" the InlineGraphicElement will use the default value of "auto".</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #actualHeight
		 * @see #measuredHeight
		 */
		public function get height():*
		{
			return _height;
		}

		public function set height(h:*):void
		{
			internalSetHeight(h);
			modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength);
		}

		private function get internalHeight():Object
		{
			return _height === undefined ? heightPropertyDefinition.defaultValue : _height;
		}

		/** @private */
		public function get computedFloat():*
		{
			if (_float === undefined)
				return floatPropertyDefinition.defaultValue;
			return _float;
		}

		private var _effectiveFloat:String;     // how it was last composed

		/** @private */
		public function get effectiveFloat():*
		{
			return _effectiveFloat ? _effectiveFloat : computedFloat;
		}

		/** @private */
		public function setEffectiveFloat(floatValue:String):void
		{
			if (_effectiveFloat != floatValue)
			{
				_effectiveFloat = floatValue;
				if (_blockElement)
					updateContentElement();
			}
		}


		[Inspectable(enumeration="none,left,right,start,end")]
		/** 
		 * Controls the placement of the graphic relative to the text. It can be part of the line, or can be beside the line with the text 
		 * wrapped around it. 
		 * <p>Legal values are <code>org.apache.royale.textLayout.formats.Float.NONE</code>, <code>org.apache.royale.textLayout.formats.Float.LEFT</code>, 
		 * <code>org.apache.royale.textLayout.formats.Float.RIGHT</code>, <code>org.apache.royale.textLayout.formats.Float.START</code>, and <code>org.apache.royale.textLayout.formats.Float.END</code>.</p>
		 * <p>Default value is undefined indicating not set.</p>
		 * <p>If undefined will be treated as <code>Float.NONE</code>.</p>
		 * 
		 * @throws RangeError when set value is not within range for this property
		 * 
		 * @see org.apache.royale.textLayout.formats.Float
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 2.0
		 * @langversion 3.0
		 */
		public function get float():*
		{
			return _float;
		}

		public function set float(value:*):void
		{
			value = floatPropertyDefinition.setHelper(float, value) as String;
			if (_float != value)
			{
				_float = value;
				if (_blockElement)
					updateContentElement();
				modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength);
			}
		}

		/** The natural height of the graphic. This is the height of the graphic at load time.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @see #actualHeight
		 * @see #height
		 */
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}

		/** The actual height in effect. This is the display and compose height that's computed from the
		 * <code>height</code> and <code>measuredHeight</code> properties.
		 *
		 * <p>The values of the <code>actualHeight</code> property are computed according to the following table:</p>
		 * <table class="innertable" width="100%">
		 * <tr>
		 *   <th>height property</th>
		 *   <th>actualHeight</th>
		 * </tr>
		 * <tr>
		 *   <td>auto</td>
		 *   <td>measuredheight</td>
		 * </tr>
		 * <tr>
		 *   <td>h a Percent</td>
		 *   <td>h percent of measuredheight</td>
		 * </tr>
		 * <tr>
		 *   <td>h a Number</td>
		 *   <td>h</td>
		 * </tr>
		 * </table>
		 * <p><strong>Notes</strong>: If the inline graphic is a IUIBase, its width and height are read immmediately.
		 * If <code>measuredWidth</code> or <code>measuredHeight</code> are zero, then any auto calculations that would cause a divide by zero sets the result to zero.</p>
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see #height
		 * @see #measuredHeight
		 */
		public function get actualHeight():Number
		{
			return elementHeight;
		}

		private function heightIsComputed():Boolean
		{
			return internalHeight is String;
		}

		private function computeHeight():Number
		{
			CONFIG::debug
			{
				assert(heightIsComputed(), "bad call to InlineGraphicElement.computeWidth"); }
			if (internalHeight == "auto")
			{
				if (internalWidth == "auto")
					return _measuredHeight;
				if (_measuredHeight == 0 || _measuredWidth == 0)
					return 0;
				// can't rely on width being calculated yet
				var effWidth:Number = widthIsComputed() ? computeWidth() : Number(internalWidth);
				return effWidth / _measuredWidth * _measuredHeight;
			}
			return heightPropertyDefinition.computeActualPropertyValue(internalHeight, _measuredHeight);
		}

		private function internalSetHeight(h:*):void
		{
			_height = heightPropertyDefinition.setHelper(height, h);
			elementHeight = heightIsComputed() ? 0 : Number(internalHeight);
			if (okToUpdateHeightAndWidth && graphic != null)
			{
				if (heightIsComputed())
					elementHeight = computeHeight();
				graphic.height = elementHeight;
				CONFIG::debug
				{
					Debugging.traceFTEAssign(graphic, "height", elementHeight); }

				if (internalWidth == "auto")
				{
					elementWidth = computeWidth();
					graphic.width = elementWidth;
					CONFIG::debug
					{
						Debugging.traceFTEAssign(graphic, "width", elementWidth); }
				}
			}
		}

		// private function loadCompleteHandler(e:Event):void
		// {
		// CONFIG::debug { Debugging.traceFTECall(null,null,"loadCompleteHandler",this); }
		// removeDefaultLoadHandlers(graphic as Loader);
		// CONFIG::debug { assert(okToUpdateHeightAndWidth == false,"invalid call to loadCompleteHandler"); }
		// okToUpdateHeightAndWidth = true;
		//
		// var g:IUIBase = graphic;
		// _measuredWidth = g.width;
		// _measuredHeight = g.height;
		//
		// //bug #2931005 TLF cannot show Flex SWF after loading it as an ILG
		// if(graphic is Loader && Loader(graphic).contentLoaderInfo.contentType == "application/x-shockwave-flash" && Loader(graphic).content != null && Loader(graphic).content.hasOwnProperty("setActualSize") && (!widthIsComputed() || !heightIsComputed()) )
		// Object(Loader(graphic).content).setActualSize(elementWidth, elementHeight);
		// else
		// {
		// if (!widthIsComputed())
		// g.width  = elementWidth;
		// if (!heightIsComputed())
		// g.height = elementHeight;
		// }
		//
		// if (e is IOErrorEvent)
		// changeGraphicStatus(e);
		// else if (widthIsComputed() || heightIsComputed())
		// {
		// g.visible = false;
		// // triggers a delayedElementUpdate
		// changeGraphicStatus(InlineGraphicElementStatus.SIZE_PENDING);
		// }
		// else
		// changeGraphicStatus(LOAD_COMPLETE);
		// }
		//
		// private function openHandler(e:Event):void
		// {
		// changeGraphicStatus(OPEN_RECEIVED);
		// }
		// private function addDefaultLoadHandlers(loader:Loader):void
		// {
		// var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
		// CONFIG::debug { Debugging.traceFTECall(loaderInfo,loader,"contentLoaderInfo"); }
		//
		// loaderInfo.addEventListener(Event.OPEN, openHandler, false, 0, true);
		// CONFIG::debug { Debugging.traceFTECall(null,loaderInfo,"addEventListener",Event.OPEN, "openHandler", false, 0, true); }
		// loaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler,false,0,true);
		// CONFIG::debug { Debugging.traceFTECall(null,loaderInfo,"addEventListener",Event.COMPLETE, "loadCompleteHandler", false, 0, true); }
		// loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadCompleteHandler,false,0,true);
		// CONFIG::debug { Debugging.traceFTECall(null,loaderInfo,"addEventListener",IOErrorEvent.IO_ERROR, "loadCompleteHandler", false, 0, true); }
		// }
		/*        private function removeDefaultLoadHandlers(loader:Loader):void
		{
		CONFIG::debug{ assert(loader != null,"bad call to removeDefaultLoadHandlers"); }
		loader.contentLoaderInfo.removeEventListener(Event.OPEN, openHandler);
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadCompleteHandler);
		}
		 */
		/** Sets the source for the graphic. 
		 * 
		 * The value can be either a String that is interpreted as a URI, a Class that's interpreted as the class of an 
		 * embeddded IUIBase, a IUIBase instance, or a URLRequest. Creates a IUIBase and,
		 * if the InlineGraphicElement object is added into a ParagraphElement in a TextFlow object, causes it to appear
		 * inline in the text.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get source():Object
		{
			return _source;
		}

		public function set source(value:Object):void
		{
			// stop(true);
			_source = value;
			changeGraphicStatus(InlineGraphicElementStatus.LOAD_PENDING);
			modelChanged(ModelChange.ELEMENT_MODIFIED, this, 0, textLength);
		}

		/** @private This method starts and stops ILGs.  Generally TLF delays starting an ILG until the first compose.  It shuts them down when they
		 * are deleted from the TextFlow or the TextFlow has its flowComposer removed.  Some cases are ambigious, for example removeAllControllers doesn't stop ILGs
		 * but the client may desire it too.  In cases where ILGs don't get stopped or started there are two public functions on TextFlow:
		 * unloadGraphics - unloads and stops all ILGs
		 * prepareGraphicsForLoad - puts all ILGs that are not loaded in a list so that they are loaded on the next compose.
		 * This function is also called when an auto-size or percentage sized graphic is loaded.  In that case the same list as prepareGraphicsForLoad is used.
		 * */
		public override function applyDelayedElementUpdate(textFlow:ITextFlow, okToUnloadGraphics:Boolean, hasController:Boolean):void
		{
			if (textFlow != this.getTextFlow())
				hasController = false;

			// TODO fix this
			/*
			 * I commented this whole thing out because it has lots of Flash dependencies. 
			 * It will take time figuring out how to migrate this functionality to Royale
			 *  
			CONFIG::debug { assert(textFlow != null,"ILG:applyDelayedElementUpdate: null textFlow"); }      
			if (_graphicStatus == InlineGraphicElementStatus.LOAD_PENDING)
			{
			// trace("FEX LOADING", this.toString());
			if (hasController)
			{
			var source:Object = _source;
			if (source is String)
			{
			var inlineGraphicResolver:Function = textFlow.configuration.inlineGraphicResolverFunction;
			if (inlineGraphicResolver != null)
			source = inlineGraphicResolver(this);
			}
                    
			var elem:DisplayObject;
			// change the bug#2929161
			var cILGStatus:String = null;
			if (source is String || source is URLRequest)
			{
			okToUpdateHeightAndWidth = false;
			var loader:Loader = new Loader();
			CONFIG::debug { Debugging.traceFTECall(loader,null,"new Loader()"); }

			// set the width/height on COMPLETE or IOError
			try
			{
			addDefaultLoadHandlers(loader);
			if (source is String)
			{
			var myPattern:RegExp = /\\/g;                           
			var src:String = source as String;
			src = src.replace(myPattern, "/");
			// workaround for Watson bug 1896186.  FlashPlayer requres that file
			// names be encoded on Macintosh, but not on Windows.  Grouped this
			// bug with FlashPlayer Watson bug 1899687
			var pictURLReq:URLRequest;
			if (isMac)
			{
			pictURLReq = new URLRequest(encodeURI(src));
			CONFIG::debug { Debugging.traceFTECall(pictURLReq,null,"new URLRequest",encodeURI(src)); }
			}
			else
			{
			pictURLReq = new URLRequest(src);   
			CONFIG::debug { Debugging.traceFTECall(pictURLReq,null,"new URLRequest",src); }                                 
			}
                                
			loader.load(pictURLReq);
			CONFIG::debug { Debugging.traceFTECall(null,loader,"load",pictURLReq); }                                    
			}
			else
			loader.load(URLRequest(source));
                                    
			setGraphic(loader);     
			changeGraphicStatus(LOAD_INITIATED);
			cILGStatus = LOAD_INITIATED;
			}
			catch(e:Error)
			{
			// the load didn't initiate
			removeDefaultLoadHandlers(loader);
			elem = new Shape();
			changeGraphicStatus(NULL_GRAPHIC);
			cILGStatus = NULL_GRAPHIC;
			}
			}
			else if (source is Class)   // value is class --> it is an Embed
			{
			var cls:Class = source as Class;
			elem = DisplayObject(new cls());
			// change the bug#2929161
			cILGStatus = EMBED_LOADED;
			}
			else if (source is DisplayObject)
			{
			elem = DisplayObject(source);
			// change the bug#2929161
			cILGStatus = DISPLAY_OBJECT;
			}
			else
			{
			elem = new Shape();
			// change the bug#2929161
			cILGStatus = NULL_GRAPHIC;
			}
                    
			// complete setup of width and height
			if (cILGStatus != LOAD_INITIATED)
			{
			okToUpdateHeightAndWidth = true;
			_measuredWidth = elem ? elem.width : 0;
			_measuredHeight = elem ? elem.height : 0;

			if (widthIsComputed())
			{
			if (elem)
			{
			elem.width = elementWidth = computeWidth();
			CONFIG::debug { Debugging.traceFTEAssign(elem,"width",elem.width); }
			}
			else
			elementWidth = 0;
			}
			else
			{
			elem.width = Number(width);
			CONFIG::debug { Debugging.traceFTEAssign(elem,"width",elem.width); }
			}
                            
			if (heightIsComputed())
			{
			if (elem)
			{
			elem.height = elementHeight = computeHeight();
			CONFIG::debug { Debugging.traceFTEAssign(elem,"height",elem.height); }
			}
			else
			elementHeight = 0;
			}
			else
			{
			elem.height = Number(height);
			CONFIG::debug { Debugging.traceFTEAssign(elem,"height",elem.height); }
			}
                        
			setGraphic(elem);
			// change the bug#2929161
			if(cILGStatus!=null)
			changeGraphicStatus(cILGStatus);
			}
			}
			}
			else
			{
			if (_graphicStatus == InlineGraphicElementStatus.SIZE_PENDING)
			{
			// this is width/height auto case hasn't been set yet - the graphic is hidden!
			updateAutoSizes();
			graphic.visible = true;
			changeGraphicStatus(LOAD_COMPLETE);
			}
			if (!hasController)
			{
			// shutdown the audio on any movie clips
			stop(okToUnloadGraphics);
			}
			}*/
		}

		/** @private This API supports the inputmanager */
		public override function updateForMustUseComposer(textFlow:ITextFlow):Boolean
		{
			applyDelayedElementUpdate(textFlow, false, true);
			return status != InlineGraphicElementStatus.READY;
		}

		/** This function updates the size of the graphic element when the size is expressed as a percentage of the graphic's actual size. */
		private function updateAutoSizes():void
		{
			if (widthIsComputed())
			{
				elementWidth = computeWidth();
				graphic.width = elementWidth;
			}
			if (heightIsComputed())
			{
				elementHeight = computeHeight();
				graphic.height = elementHeight;
			}
		}

		// /** @private Stop this inlinegraphicelement - if its a movieclip will stop noise and playing - if a load is in process it cancels the load */
		// public function stop(okToUnloadGraphics:Boolean):Boolean
		// {
		//
		// // watch for changing the source while we've got an event listener on the current graphic
		// // if so cancel the load and remove the listeners
		// if (_graphicStatus == OPEN_RECEIVED || _graphicStatus == LOAD_INITIATED)
		// {
		// var loader:Loader = graphic as Loader;
		// try
		// {
		// loader.close(); // cancels in process load
		// }
		// catch (e:Error)
		// { /* ignore */ }
		// removeDefaultLoadHandlers(loader);
		// }
		//
		// // shutdown any running movieclips - this graphic will no longer be referenced
		// // for graphics that the client has passed us - just ignore they own the responsibliity
		// if (_graphicStatus != DISPLAY_OBJECT)
		// {
		// if (okToUnloadGraphics)
		// {
		// recursiveShutDownGraphic(graphic);
		// setGraphic(null);
		// }
		// if (widthIsComputed())
		// elementWidth = 0;
		// if (heightIsComputed())
		// elementHeight = 0;
		// changeGraphicStatus(InlineGraphicElementStatus.LOAD_PENDING);
		// }
		// return true;
		// }
		// This entire function is probably not needed as it seems specific to Flash movies
		// searches through the graphic and stops any playing grpahics
		// private static function recursiveShutDownGraphic(graphic:IUIBase):void
		// {
		// if (graphic is Loader)
		// Loader(graphic).unloadAndStop();
		// else if (graphic)
		// {
		// var container:DisplayObjectContainer = graphic as DisplayObjectContainer;
		// if (container)
		// {
		// for (var idx:int = 0; idx < container.numChildren; idx++)
		// {
		// recursiveShutDownGraphic(container.getChildAt(idx));
		// }
		// }
		//
		// if (graphic is MovieClip)
		// MovieClip(graphic).stop();
		// }
		//
		// }
		/** @private */
		public override function getEffectiveFontSize():Number
		{
			if (effectiveFloat != Float.NONE)
				return 0;
			var defaultLeading:Number = super.getEffectiveFontSize();
			return Math.max(defaultLeading, elementHeightWithMarginsAndPadding());
		}

		/** Returns the calculated lineHeight from this element's properties.  @private */
		public override function getEffectiveLineHeight(blockProgression:String):Number
		{
			if (effectiveFloat != Float.NONE)
				return 0;
			return super.getEffectiveLineHeight(blockProgression);
		}

		/** Returns the typographic ascent of the image (i.e. relative to the line's Roman baseline). @private */
		public function getTypographicAscent(textLine:ITextLine):Number
		{
			if (effectiveFloat != Float.NONE)
				return 0;

			var effectiveHeight:Number = elementHeightWithMarginsAndPadding();

			var dominantBaselineString:String;
			if (this._computedFormat.dominantBaseline != "auto")
			{
				dominantBaselineString = this._computedFormat.dominantBaseline;
			}
			else
			{
				dominantBaselineString = this.getParagraph().getEffectiveDominantBaseline();
			}

			var elementFormat:ElementFormat = _blockElement ? _blockElement.elementFormat : computeElementFormat();
			var alignmentBaseline:String = (elementFormat.alignmentBaseline == org.apache.royale.text.engine.TextBaseline.USE_DOMINANT_BASELINE ? dominantBaselineString : elementFormat.alignmentBaseline);

			var top:Number = 0;

			// Calcluate relative to dominant baseline; remains 0 for ASCENT and IDEOGRAPHIC_TOP
			if (dominantBaselineString == org.apache.royale.text.engine.TextBaseline.IDEOGRAPHIC_CENTER)
				top += effectiveHeight / 2;
			else if (dominantBaselineString == org.apache.royale.text.engine.TextBaseline.IDEOGRAPHIC_BOTTOM || dominantBaselineString == org.apache.royale.text.engine.TextBaseline.DESCENT || dominantBaselineString == org.apache.royale.text.engine.TextBaseline.ROMAN)
				top += effectiveHeight;

			// re-jig to be relative to the ROMAN baseline rather than whatever baseline is used for alignment
			top += textLine.getBaselinePosition(org.apache.royale.text.engine.TextBaseline.ROMAN) - textLine.getBaselinePosition(alignmentBaseline);

			// finally, account for baseline shift
			top += elementFormat.baselineShift;

			return top;
		}

		/** @private 
		 * Get the "inline box" for the element as defined by the CSS visual formatting model (http://www.w3.org/TR/CSS2/visuren.html)
		 * For an inline graphic, lineHeight is ignored. The box dimensions are governed by the element height with padding. 
		 * Alignment relative to the baseline (using baselineShift, dominantBaseline, alignmentBaseline) is taken into account.
		 * @return Null if the element is not "inline" (i.e., is a float). Otherwise, a rectangle representing the inline box. 
		 * Top and Bottom are relative to the line's Roman baseline. Left and Right are ignored.
		 */
		override public function getCSSInlineBox(blockProgression:String, textLine:ITextLine, para:IParagraphElement = null, swfContext:ISWFContext = null):Rectangle
		{
			if (effectiveFloat != Float.NONE)
				return null;

			var inlineBox:Rectangle = new Rectangle();
			inlineBox.top = -(getTypographicAscent(textLine));
			inlineBox.height = elementHeightWithMarginsAndPadding();
			inlineBox.width = elementWidth;

			return inlineBox;
		}

		/** @private */
		public override function shallowCopy(startPos:int = 0, endPos:int = -1):IFlowElement
		{
			if (endPos == -1)
				endPos = textLength;

			var retFlow:InlineGraphicElement = super.shallowCopy(startPos, endPos) as InlineGraphicElement;
			retFlow.source = source;
			retFlow.width = width;
			retFlow.height = height;
			retFlow.float = float;

			return retFlow;
		}

		/** @private */
		override protected function get abstract():Boolean
		{
			return false;
		}

		/** @private */
		public override function get defaultTypeName():String
		{
			return "img";
		}

		/** @private */
		public override function appendElementsForDelayedUpdate(tf:ITextFlow, changeType:String):void
		{
			if (changeType == ModelChange.ELEMENT_ADDED)
				tf.incGraphicObjectCount();
			else if (changeType == ModelChange.ELEMENT_REMOVAL)
				tf.decGraphicObjectCount();

			if (status != InlineGraphicElementStatus.READY || changeType == ModelChange.ELEMENT_REMOVAL)
				tf.appendOneElementForUpdate(this);
		}
		// ****************************************
		// Begin debug support code
		// ****************************************
		/** @private */
		CONFIG::debug
		public override function toString():String
		{
			return super.toString() + " " + source;
		}
		/** @private */
		CONFIG::debug
		public override function debugCheckFlowElement(depth:int = 0, extraData:String = ""):int
		{
			// debugging function that asserts if the flow element tree is in an invalid state

			var rslt:int = super.debugCheckFlowElement(depth, extraData + " url:" + source);

			if (_blockElement)
				rslt += assert(textLength == (_blockElement as GraphicElement).rawText.length, "image is different than its textElement");
			rslt += assert(this != getParagraph().getLastLeaf(), "last Leaf in paragraph cannot be image");

			return rslt;
		}
	}
}
