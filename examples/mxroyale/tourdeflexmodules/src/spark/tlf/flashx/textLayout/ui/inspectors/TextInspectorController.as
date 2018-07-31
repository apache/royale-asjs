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

package flashx.textLayout.ui.inspectors
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.ElementRange;
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TCYElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.SelectionEvent;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.ui.rulers.RulerBar;
	
	use namespace tlf_internal;

	public class TextInspectorController extends EventDispatcher
	{
		public static const CHAR_DOMAIN:String = "char"
		public static const PAR_DOMAIN:String = "par"
		public static const CONT_DOMAIN:String = "cont"
		public static const FLOW_DOMAIN:String = "flow"
		public static const SCROLL_DOMAIN:String = "sp"
		public static const TCY_DOMAIN:String = "tcy"
		public static const LINK_DOMAIN:String = "link"
		
		public static const FONT_SIZE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.fontSizeProperty.name;
		public static const FONT_FAMILY_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.fontFamilyProperty.name;
		public static const FONT_LOOKUP_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.fontLookupProperty.name;
		public static const TRACKING_RIGHT_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.trackingRightProperty.name;
		public static const TRACKING_LEFT_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.trackingLeftProperty.name;
		public static const KERNING_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.kerningProperty.name;
		public static const LINE_HEIGHT_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.lineHeightProperty.name;
		public static const COLOR_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.colorProperty.name;
		public static const BGCOLOR_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.backgroundColorProperty.name;
		public static const FONT_WEIGHT_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.fontWeightProperty.name;
		public static const FONT_STYLE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.fontStyleProperty.name;
		public static const TEXT_DECORATION_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.textDecorationProperty.name;
		public static const LINE_THROUGH_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.lineThroughProperty.name;
		public static const DIGIT_CASE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.digitCaseProperty.name;
		public static const DIGIT_WIDTH_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.digitWidthProperty.name;
		public static const DOMINANT_BASELINE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.dominantBaselineProperty.name;
		public static const ALIGNMENT_BASELINE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.alignmentBaselineProperty.name;
		public static const BASELINE_SHIFT_SUPER_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.baselineShiftProperty.name + "#super";
		public static const BASELINE_SHIFT_SUB_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.baselineShiftProperty.name + "#sub";
		public static const BASELINE_SHIFT_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.baselineShiftProperty.name;
		public static const TYPOGRAPHIC_CASE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.typographicCaseProperty.name;
		public static const LIGATURE_LEVEL_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.ligatureLevelProperty.name;
		public static const TEXT_ROTATION_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.textRotationProperty.name;
		public static const TEXT_ALPHA_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.textAlphaProperty.name;
		public static const BACKGROUND_ALPHA_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.backgroundAlphaProperty.name;
		public static const LOCALE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.localeProperty.name;
		public static const BREAK_OPPORTUNITY_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.breakOpportunityProperty.name;
		public static const RENDERING_MODE_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.renderingModeProperty.name;
		public static const CFF_HINTING_UIPROP:String = CHAR_DOMAIN + "/" + TextLayoutFormat.cffHintingProperty.name;
		
		public static const PARA_LOCALE_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.localeProperty.name;
		public static const TEXT_INDENT_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.textIndentProperty.name;
		public static const START_INDENT_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.paragraphStartIndentProperty.name;
		public static const END_INDENT_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.paragraphEndIndentProperty.name;
		public static const SPACE_BEFORE_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.paragraphSpaceBeforeProperty.name;
		public static const SPACE_AFTER_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.paragraphSpaceAfterProperty.name;
		public static const TEXT_ALIGN_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.textAlignProperty.name;
		public static const TEXT_ALIGN_LAST_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.textAlignLastProperty.name;
		public static const JUSTIFICATION_RULE_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.justificationRuleProperty.name;
		public static const TEXT_JUSTIFY_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.textJustifyProperty.name;
		public static const JUSTIFICATION_STYLE_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.justificationStyleProperty.name;
		public static const DIRECTION_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.directionProperty.name;
		public static const LEADING_MODEL_UIPROP:String = PAR_DOMAIN + "/" + TextLayoutFormat.leadingModelProperty.name;

		public static const VERTICAL_ALIGN_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.verticalAlignProperty.name;
		public static const COLUMN_COUNT_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.columnCountProperty.name;
		public static const COLUMN_WIDTH_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.columnWidthProperty.name;
		public static const COLUMN_GAP_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.columnGapProperty.name;
		public static const PADDING_LEFT_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.paddingLeftProperty.name;
		public static const PADDING_TOP_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.paddingTopProperty.name;
		public static const PADDING_RIGHT_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.paddingRightProperty.name;
		public static const PADDING_BOTTOM_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.paddingBottomProperty.name;
		public static const FIRST_BASELINE_UIPROP:String = CONT_DOMAIN + "/" + TextLayoutFormat.firstBaselineOffsetProperty.name;

		public static const BLOCK_PROGRESSION_UIPROP:String = FLOW_DOMAIN + "/" + TextLayoutFormat.blockProgressionProperty.name;
		public static const FLOW_DIRECTION_UIPROP:String = FLOW_DOMAIN + "/" + TextLayoutFormat.directionProperty.name;
		public static const LINE_BREAK_UIPROP:String = FLOW_DOMAIN + "/" + TextLayoutFormat.lineBreakProperty.name;

		public static const VERTICAL_SCROLL_UIPROP:String = SCROLL_DOMAIN + "/" + "verticalScrollPolicy";
		public static const HORIZONTAL_SCROLL_UIPROP:String = SCROLL_DOMAIN + "/" + "horizontalScrollPolicy";

		public static const TCY_UIPROP:String = TCY_DOMAIN + "/" + "tcy";

		public static const LINK_URL_UIPROP:String = LINK_DOMAIN + "/" + "linkURL";
		public static const LINK_TARGET_UIPROP:String = LINK_DOMAIN + "/" + "linkTarget";
		public static const LINK_EXTEND_UIPROP:String = LINK_DOMAIN + "/" + "linkExtend";
		private static var sInstance:TextInspectorController = null;
		
		private var processingCharacterFormatChange:Boolean = false;
		
		public function TextInspectorController(target:IEventDispatcher=null)
		{
			super(target);
			if (sInstance != null)
				throw new Error("Can't create another TextEditingController. Call TextEditingController.Instance.");
		}
		
		public static function Instance():TextInspectorController
		{
			if (!sInstance)
				sInstance = new TextInspectorController();
			return sInstance;
		}
		
		public function set activeFlow(inFlow:TextFlow):void
		{
			if (inFlow && !inFlow.interactionManager is IEditManager)
				throw new Error("Can't set the active flow to a flow without an EditManager.");
			if (mActiveFlow)
			{
				mActiveFlow.removeEventListener(SelectionEvent.SELECTION_CHANGE, onTextSelectionChanged);
				mEditManager = null;
			}
			mActiveFlow = inFlow;
			if (mActiveFlow)
			{
				mEditManager = mActiveFlow.interactionManager as IEditManager;
				mActiveFlow.addEventListener(SelectionEvent.SELECTION_CHANGE, onTextSelectionChanged);
			}
			else
				onTextSelectionChanged(null);
			for each (var ruler:RulerBar in mRulers)
				ruler.activeFlow = mActiveFlow;
		}
		
		public function get activeFlow():TextFlow
		{
			return mActiveFlow;
		}
		
		public function set rulerVisible(inVisible:Boolean):void
		{
			for each (var ruler:RulerBar in mRulers)
			{
				ruler.active = inVisible;
				if (inVisible)
				{
					ruler.RedrawRuler();
				}
			}
			if (mActiveFlow && (mActiveFlow.interactionManager))
			{
				mActiveFlow.interactionManager.setFocus();
			}
		}
		
		public function get rulerVisible():Boolean
		{
			if (mRulers.length > 0)
				return mRulers[0].active;
			return false;
		}

		public function AddRuler(inRuler:RulerBar):void
		{
			mRulers.push(inRuler);
		}
		
 		private function onTextSelectionChanged(e:SelectionEvent):void
		{
			if ((processingCharacterFormatChange) && (mEditManager.absoluteStart == mEditManager.absoluteEnd)) return;
			
			if (e)
			{
				var selState:SelectionState = e.selectionState;
				var selectedElementRange:ElementRange =  selState ? ElementRange.createElementRange(selState.textFlow, selState.absoluteStart, selState.absoluteEnd) : null;
				if (selectedElementRange)
				{
					var format:Object = GetFormatFromRange(selectedElementRange,selState.pointFormat);
					if (mLastFormat == null || FormatChanged(mLastFormat, format))
					{
						dispatchEvent(new SelectionUpdateEvent(format));
						mLastFormat = format;
					}
				}
			}
			else
			{
				dispatchEvent(new SelectionUpdateEvent(new Object()));
				mLastFormat = null;
			}
		}
		
		public function forceBroadcastFormats():void
		{
			if (mEditManager)
			{
				var format:Object = GetFormatFromRange(ElementRange.createElementRange(mActiveFlow, mActiveFlow.interactionManager.anchorPosition, mActiveFlow.interactionManager.activePosition),null);
				dispatchEvent(new SelectionUpdateEvent(format));
				mLastFormat = format;
			}
		}
		
		private function FormatChanged(format1:Object, format2:Object):Boolean
		{
			if (format1.numProps == format2.numProps)
			{
				for(var key:String in format1)
				{
					if (format2[key] == null)
						return true;
					var prop1:Array = format1[key];
					var prop2:Array = format2[key];
					var n:int = prop1.length;
					if (n != prop2.length)
						return true;
					for (var i:int = 0; i < n; ++i)
						if (prop1[i] != prop2[i])
							return true;
				}
				return false;
			}
			return true;
		}

		private function GetFormatFromRange(inRange:ElementRange,pendingFormat:ITextLayoutFormat):Object
		{
			var format:Object = new Object();
			format.numProps = 0;
			format.setPropertyIsEnumerable("numProps", false);
			var leafIter:FlowLeafElement = inRange.firstLeaf;
			while (leafIter)
			{
				var charFormat:ITextLayoutFormat = leafIter.computedFormat;
				if (pendingFormat)
				{
					var scratch:TextLayoutFormat = new TextLayoutFormat(charFormat);
					scratch.apply(pendingFormat);
					charFormat = scratch;
				}
				AddAttributeToFormat(format, FONT_FAMILY_UIPROP, charFormat.fontFamily);
				if (!IsMetaFontName(charFormat.fontFamily))
					AddAttributeToFormat(format, FONT_LOOKUP_UIPROP, charFormat.fontLookup);
				AddAttributeToFormat(format, FONT_SIZE_UIPROP, charFormat.fontSize);
				AddAttributeToFormat(format, TRACKING_RIGHT_UIPROP, charFormat.trackingRight);
				AddAttributeToFormat(format, TRACKING_LEFT_UIPROP, charFormat.trackingLeft);
				AddAttributeToFormat(format, KERNING_UIPROP, charFormat.kerning);
				AddAttributeToFormat(format, LINE_HEIGHT_UIPROP, charFormat.lineHeight);
				AddAttributeToFormat(format, COLOR_UIPROP, charFormat.color);
				AddAttributeToFormat(format, BGCOLOR_UIPROP, charFormat.backgroundColor);
				AddAttributeToFormat(format, FONT_WEIGHT_UIPROP, charFormat.fontWeight);
				AddAttributeToFormat(format, FONT_STYLE_UIPROP, charFormat.fontStyle);
				AddAttributeToFormat(format, TEXT_DECORATION_UIPROP, charFormat.textDecoration);
				AddAttributeToFormat(format, LINE_THROUGH_UIPROP, charFormat.lineThrough);
				// This little kludge allows me to have two controls operate on the same property
				AddAttributeToFormat(format, BASELINE_SHIFT_SUPER_UIPROP,
						charFormat.baselineShift == flashx.textLayout.formats.BaselineShift.SUPERSCRIPT ?
														flashx.textLayout.formats.BaselineShift.SUPERSCRIPT :
														0);
				AddAttributeToFormat(format, BASELINE_SHIFT_SUB_UIPROP,
						charFormat.baselineShift == flashx.textLayout.formats.BaselineShift.SUBSCRIPT ?
														flashx.textLayout.formats.BaselineShift.SUBSCRIPT :
														0);
				AddAttributeToFormat(format, DIGIT_CASE_UIPROP, charFormat.digitCase);
				AddAttributeToFormat(format, DIGIT_WIDTH_UIPROP, charFormat.digitWidth);
				AddAttributeToFormat(format, DOMINANT_BASELINE_UIPROP, charFormat.dominantBaseline);
				AddAttributeToFormat(format, ALIGNMENT_BASELINE_UIPROP, charFormat.alignmentBaseline);
				AddAttributeToFormat(format, BASELINE_SHIFT_UIPROP, charFormat.baselineShift);
				AddAttributeToFormat(format, TYPOGRAPHIC_CASE_UIPROP, charFormat.typographicCase);
				AddAttributeToFormat(format, LIGATURE_LEVEL_UIPROP, charFormat.ligatureLevel);
				AddAttributeToFormat(format, TEXT_ROTATION_UIPROP, charFormat.textRotation);
				AddAttributeToFormat(format, TEXT_ALPHA_UIPROP, charFormat.textAlpha);
				AddAttributeToFormat(format, BACKGROUND_ALPHA_UIPROP, charFormat.backgroundAlpha);
				AddAttributeToFormat(format, LOCALE_UIPROP, charFormat.locale);
				AddAttributeToFormat(format, BREAK_OPPORTUNITY_UIPROP, charFormat.breakOpportunity);
				AddAttributeToFormat(format, RENDERING_MODE_UIPROP, charFormat.renderingMode);
				if (charFormat.renderingMode == flash.text.engine.RenderingMode.CFF)
					AddAttributeToFormat(format, CFF_HINTING_UIPROP, charFormat.cffHinting);
				
				
				var paragraph:ParagraphElement = leafIter.getParagraph();
	  			var paraFormat:ITextLayoutFormat = paragraph.computedFormat;
	  			AddAttributeToFormat(format, PARA_LOCALE_UIPROP, paraFormat.locale);
	  			AddAttributeToFormat(format, TEXT_INDENT_UIPROP, paraFormat.textIndent);
	  			AddAttributeToFormat(format, START_INDENT_UIPROP, paraFormat.paragraphStartIndent);
	  			AddAttributeToFormat(format, END_INDENT_UIPROP, paraFormat.paragraphEndIndent);
	  			AddAttributeToFormat(format, SPACE_BEFORE_UIPROP, paraFormat.paragraphSpaceBefore);
	  			AddAttributeToFormat(format, SPACE_AFTER_UIPROP, paraFormat.paragraphSpaceAfter);
	  			AddAttributeToFormat(format, TEXT_ALIGN_UIPROP, paraFormat.textAlign);
	  			if (paraFormat.textAlign == TextAlign.JUSTIFY)
	  				AddAttributeToFormat(format, TEXT_ALIGN_LAST_UIPROP, paraFormat.textAlignLast);
	  			AddAttributeToFormat(format, JUSTIFICATION_RULE_UIPROP, paraFormat.justificationRule);
	  			AddAttributeToFormat(format, TEXT_JUSTIFY_UIPROP, paraFormat.textJustify);
	  			AddAttributeToFormat(format, JUSTIFICATION_STYLE_UIPROP, paraFormat.justificationStyle);
	  			AddAttributeToFormat(format, DIRECTION_UIPROP, paraFormat.direction);
	  			AddAttributeToFormat(format, LEADING_MODEL_UIPROP, paraFormat.leadingModel);
	  			
	  			addLinkSettings(format, leafIter);
	  			
	  			if (leafIter == inRange.lastLeaf)
	  				break;

				leafIter = leafIter.getNextLeaf();
				
				//if this is a single point selection between differing elements, we don't want to pick up the second one
				//is start == end, break...
				if(inRange.absoluteStart == inRange.absoluteEnd)
					break;
			}
 	 		var containerFormat:ITextLayoutFormat = null;
 			var selStart:int = Math.min(mActiveFlow.interactionManager.activePosition, mActiveFlow.interactionManager.anchorPosition);
 			var selEnd:int = Math.max(mActiveFlow.interactionManager.activePosition, mActiveFlow.interactionManager.anchorPosition);
 			var line:TextFlowLine = mActiveFlow.flowComposer.findLineAtPosition(selStart);
 			
 			// this is some odd logic - probably because ElementRange is not telling about the containercontroller range
 			if (line && line.controller)
 			{
				var controller:ContainerController = line.controller;
	 			line = mActiveFlow.flowComposer.findLineAtPosition(selEnd);
	 			var lastController:ContainerController = null;
	 			if (line && line.controller)
	 				lastController = line.controller;
	 			while (controller)
	 			{
		 			containerFormat = controller.computedFormat;
					AddAttributeToFormat(format, VERTICAL_ALIGN_UIPROP, containerFormat.verticalAlign);
					AddAttributeToFormat(format, COLUMN_COUNT_UIPROP, containerFormat.columnCount);
					AddAttributeToFormat(format, COLUMN_WIDTH_UIPROP, containerFormat.columnWidth);
					AddAttributeToFormat(format, COLUMN_GAP_UIPROP, containerFormat.columnGap);
					AddAttributeToFormat(format, PADDING_LEFT_UIPROP, containerFormat.paddingLeft);
					AddAttributeToFormat(format, PADDING_TOP_UIPROP, containerFormat.paddingTop);
					AddAttributeToFormat(format, PADDING_RIGHT_UIPROP, containerFormat.paddingRight);
					AddAttributeToFormat(format, PADDING_BOTTOM_UIPROP, containerFormat.paddingBottom);
		// Note: These attributes are in the API but don't cause anything to be drawn. It looks like support
		// for drawing borders on text containers is probably post-1.0. I have left in the XML description of
		// how to build a UI for these properties, but commented this code out. If the DynamicPropertyEditorBase
		// is never givena  value for these properties, it will not display the UI.
		//			AddAttributeToFormat(format, BORDER_COLOR_UIPROP, containerFormat.borderColor);
		//			AddAttributeToFormat(format, BORDER_STYLE_UIPROP, containerFormat.borderStyle);
		//			AddAttributeToFormat(format, BORDER_THICKNESS_UIPROP, containerFormat.borderThickness);
					AddAttributeToFormat(format, FIRST_BASELINE_UIPROP, containerFormat.firstBaselineOffset);

					if (controller == lastController)
						break;
					var myIdx:int = controller.flowComposer.getControllerIndex(controller);
					controller = myIdx+1 == controller.flowComposer.numControllers ? null : controller.flowComposer.getControllerAt(myIdx+1);
	 			}
			}
			containerFormat = inRange.containerFormat;
			var tf:TextFlow = inRange.firstLeaf.getTextFlow();
			AddAttributeToFormat(format, BLOCK_PROGRESSION_UIPROP, tf.computedFormat.blockProgression);
			AddAttributeToFormat(format, FLOW_DIRECTION_UIPROP, tf.computedFormat.direction);
			AddAttributeToFormat(format, LINE_BREAK_UIPROP, tf.computedFormat.lineBreak);
			
			// TODO: uses first container only
			AddAttributeToFormat(format, VERTICAL_SCROLL_UIPROP, mActiveFlow.flowComposer.getControllerAt(0).verticalScrollPolicy);
			AddAttributeToFormat(format, HORIZONTAL_SCROLL_UIPROP, mActiveFlow.flowComposer.getControllerAt(0).horizontalScrollPolicy);

			if (isTCYEnabled())
   				AddAttributeToFormat(format, TCY_UIPROP, TCY(inRange));
   				
			if (shouldExtendLink(format))
				AddAttributeToFormat(format, LINK_EXTEND_UIPROP, true);
   			
			return format;
		}
		
		private function addLinkSettings(format:Object, leaf:FlowElement):void
		{
			var linkElement:LinkElement = leaf.getParentByType(LinkElement) as LinkElement;
			if (linkElement)
			{
	    		AddAttributeToFormat(format, LINK_URL_UIPROP, linkElement.href);
    			AddAttributeToFormat(format, LINK_TARGET_UIPROP, linkElement.target ? linkElement.target : "");
			}
			else
			{
	    		AddAttributeToFormat(format, LINK_URL_UIPROP, "");
	    		// Don't show link target or extend link if there's no URL property in the selection
			}
			
		}
		
		private function shouldExtendLink(format:Object):Boolean
		{
			// Check box is added if the selection contains mixed link settings (more than one, and at least one a valid link)
			var extendLink:Boolean = false;
			var urlArray:Array = format[LINK_URL_UIPROP];
			if (urlArray && urlArray.length > 1)
			{
				for each (var urlString:String in urlArray)
					if (urlString.length > 1)
					{
						extendLink = true;
						break;
					}
			}
			return extendLink;
		}
		
		private function isTCYEnabled():Boolean
		{
			var okToTurnOnTCY:Boolean = false;
			if (mActiveFlow.interactionManager.isRangeSelection())
			{
				//have to also check if more than just the end of paragraph markers
				//are selected
								
				var selBegIdx:int = mActiveFlow.interactionManager.anchorPosition;
				var selEndIdx:int = mActiveFlow.interactionManager.activePosition;
				if (selBegIdx > selEndIdx)
				{
					var tempInt:int = selBegIdx;
					selBegIdx = selEndIdx;
					selEndIdx = tempInt;
				}
				
				var para:ParagraphElement;
				var startParaPos:int;
				var endParaPos:int;
				var beginCheckPos:int;
				var endCheckPos:int;
				while ((!okToTurnOnTCY) && (selBegIdx < selEndIdx))
				{
					para = mActiveFlow.findAbsoluteParagraph(selBegIdx);
					startParaPos = para.getAbsoluteStart();
					endParaPos = startParaPos + para.textLength;
					
					if (startParaPos > selBegIdx) 
						beginCheckPos = startParaPos;
					else 
						beginCheckPos = selBegIdx
						
					if (endParaPos > selEndIdx)
						endCheckPos = selEndIdx;
					else
						endCheckPos = endParaPos;
					
					var numSelInPar:int = endCheckPos - beginCheckPos;
					if ((numSelInPar > 1) || ((numSelInPar == 1) && (endCheckPos != endParaPos)))
					{
						okToTurnOnTCY = true;
					} else {
						selBegIdx = endParaPos;
					}
				}
			}
			return okToTurnOnTCY;
		}
		
		public function TCY(range:ElementRange):Boolean
		{
			if(range != null)
			{
				var anchorEl:FlowElement = range.firstLeaf;
				var endEl:FlowElement = range.lastLeaf;
				if ((endEl is SpanElement) && ((endEl as SpanElement).hasParagraphTerminator) && (endEl.textLength == 1))
				{
					endEl = endEl.getTextFlow().findLeaf(endEl.getAbsoluteStart() - 1);
				}
				
				var anchorIsTCY:Boolean = false;
				var endIsTCY:Boolean = false;
				
				//if this or any of it's parents are TCY, then anchorIsTCY is true
				while(anchorEl != null && !anchorIsTCY)
				{
					if(anchorEl is TCYElement)
						anchorIsTCY = true;
					
					anchorEl = anchorEl.parent;
				}
				
				//if this or any of it's parents are TCY, then anchorIsTCY is true
				//NOTE: anchorEl and endEl may differing parent counts.
				while(endEl != null && !endIsTCY)
				{
					if(endEl is TCYElement)
						endIsTCY = true;
					
					endEl = endEl.parent;
				}
				
				return endIsTCY && anchorIsTCY;
			}
			else
				return false;
		}
		
		private function IsMetaFontName(inFont:String):Boolean
		{
			return (inFont == "_sans" || inFont == "_serif" || inFont == "_typewriter");
		}
		
		private function AddAttributeToFormat(inFormat:Object, key:String, value:Object):void
		{
			if (inFormat[key] == null)
			{
				inFormat[key] = [];
				++inFormat.numProps;
			}
			if (inFormat[key].indexOf(value) == -1)
				inFormat[key].push(value);
		}

		public function SetTextProperty(inKey:String, inValue:Object):void
		{
			var slashIndex:int = inKey.indexOf("/");
			if (slashIndex == -1)
				throw new Error("Expected a key with a slash in it.");
			var domain:String = inKey.slice(0, slashIndex);
			var key:String = inKey.slice(slashIndex + 1);
			// This little kludge allows me to have two controls operate on the same property
			var hashIndex:int = key.indexOf("#");
			if (hashIndex > -1)
				key = key.slice(0, hashIndex);
			if (mEditManager)
			{
				// scratch vars
				var pa:TextLayoutFormat;
				var cont:TextLayoutFormat;
				var ca:TextLayoutFormat;
				
				switch(domain) {
				case CHAR_DOMAIN:
					ca = new TextLayoutFormat();
					if (key == "color")
					{
						inValue = uint(inValue);
						if (mActiveFlow)
						{
							mActiveFlow.interactionManager.setFocus();
						}
					}
					if (key == "backgroundColor")
					{
						inValue = uint(inValue);
					}
					if (key == "lineThrough")
						inValue = inValue == "true" ? true : false;
					ca[key] = inValue;
					if (key == "fontFamily" && IsMetaFontName(inValue as String))
						ca["fontLookup"] = flash.text.engine.FontLookup.DEVICE;
					processingCharacterFormatChange = true;						
					mEditManager.applyLeafFormat(ca);
					processingCharacterFormatChange = false;											
					break;
				case PAR_DOMAIN:
					pa = new TextLayoutFormat();
					pa[key] = inValue;
					mEditManager.applyParagraphFormat(pa);
					break;
				case FLOW_DOMAIN:
					pa = new TextLayoutFormat();
					pa[key] = inValue;
					mEditManager.applyFormatToElement(mActiveFlow,pa);
					break;
				case CONT_DOMAIN:
					cont = new TextLayoutFormat();
					cont[key] = inValue;

					// always modify the containers
					mEditManager.applyContainerFormat(cont,null);
					break;
				case SCROLL_DOMAIN:	// scroll policy props
					mActiveFlow.flowComposer.getControllerAt(0)[key] = inValue;
					mActiveFlow.flowComposer.updateAllControllers();
					break;
				case TCY_DOMAIN:
					if (key == "tcy")
  						mEditManager.applyTCY(inValue == "true" ? true : false);
					break;
				case LINK_DOMAIN:
					if (key == "linkURL")
  						mEditManager.applyLink(inValue as String);
					break;
				}
			}
			mLastFormat = null;
		}

		private var mActiveFlow:TextFlow = null;
		private var mEditManager:IEditManager = null;
		private var mLastFormat:Object = null;
		private var mRulers:Array = [];

	}
}
