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

package mx.controls
{
	/* import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	
	import spark.components.richTextEditorClasses.AlignTool;
	import spark.components.richTextEditorClasses.BoldTool;
	import spark.components.richTextEditorClasses.BulletTool;
	import spark.components.richTextEditorClasses.ColorTool;
	import spark.components.richTextEditorClasses.FontTool;
	import spark.components.richTextEditorClasses.ItalicTool;
	import spark.components.richTextEditorClasses.LinkTool;
	import spark.components.richTextEditorClasses.SizeTool;
	import spark.components.richTextEditorClasses.UnderlineTool;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.ColorChangeEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.ElementRange;
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
 */
	// for asdoc
	/* [Experimental]
	[Event(name = "change", type = "flash.events.Event")]
	[Style(name = "borderColor", inherit = "no", type = "unit")]
	[Style(name = "focusColor", inherit = "yes", type = "unit")]
	*/
	import mx.core.UIComponent;
	public class RichTextEditor extends UIComponent
	{
	
	/*
		private var _htmlText:String;
		private var _htmlTextChanged:Boolean = false;
		private var _prompt:String = "";
		private var _stylesChanged:Dictionary = new Dictionary;
		private var _text:String;
		private var _textFlow:TextFlow;
		private var _linkSelected:Boolean = false;
		private var _urlRegExpression:RegExp = new RegExp("^(https?://(www\\.)?|www\\.)[-._~:/?#\\[\\]@!$&'()*+,;=a-z0-9]+$", 'i');
		private const _defaultLinkText:String = "http://";
		private var _linkEl:LinkElement
		private var _lastRange:ElementRange;
		
		[SkinPart(required="true")]
		public var textArea:TextArea;
		[SkinPart(required="false")]
		public var fontTool:FontTool;
		[SkinPart(required="false")]
		public var sizeTool:SizeTool;
		[SkinPart(required="false")]
		public var boldTool:BoldTool;
		[SkinPart(required="false")]
		public var italicTool:ItalicTool;
		[SkinPart(required="false")]
		public var underlineTool:UnderlineTool;
		[SkinPart(required="false")]
		public var colorTool:ColorTool;
		[SkinPart(required="false")]
		public var alignTool:AlignTool;
		[SkinPart(required="false")]
		public var bulletTool:BulletTool;
		[SkinPart(required="false")]
		public var linkTool:LinkTool;
 */
		public function RichTextEditor()
		{
			super();
			//this.textFlow = new TextFlow; //Prevents a stack trace that happends when you try to access the textflow on click.
		}

		// [Bindable("change")]
		/**
		 *  The htmlText property is here for convenience. It converts the textFlow to TextConverter.TEXT_FIELD_HTML_FORMAT.
		 */
		/* public function get htmlText():String
		{
			if (_htmlTextChanged)
			{
				if (text == "")
				{
					_htmlText = "";
				}
				else
				{
					_htmlText = TextConverter.export(textFlow, TextConverter.TEXT_FIELD_HTML_FORMAT, ConversionType.STRING_TYPE) as String;
				}
				_htmlTextChanged = false;
			}
			return _htmlText;
		} */

		/**
		 *  The htmlText property is here for convenience. It converts the textFlow to TextConverter.TEXT_FIELD_HTML_FORMAT.
		 */
		/* public function set htmlText(value:String):void
		{
			if (htmlText != value)
			{
				_htmlText = value;
				if (textFlow)
				{
					textFlow = TextConverter.importToFlow(_htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT);
				}
			}
		} */

		/**
		 *  @private
		 */
		/* public function get prompt():String
		{
			return _prompt;
		} */

		/**
		 *  @private
		 */
		/* public function set prompt(value:String):void
		{
			_prompt = value;
			if (textArea)
			{
				textArea.prompt = _prompt;
			}
		} */

		/**
		 *  @private
		 */
		/* public override function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			_stylesChanged[styleProp] = getStyle(styleProp);
			this.invalidateDisplayList();
		}
 */
		//[Bindable("change")]
		/**
		 *  The text in the textArea
		 */
		/* public function get text():String
		{
			if (textArea)
			{
				return textArea.text;
			}
			else
			{
				return _text;
			}
		} */

		/**
		 *  @private
		 */
		/* public function set text(value:String):void
		{
			_text = value;
			if (textArea)
			{
				textArea.text = value;
			}
		} */

		//[Bindable("change")]
		/**
		 *  The textFlow
		 */
		/* public function get textFlow():TextFlow
		{
			return _textFlow;
		} */

		/**
		 *  @private
		 */
		/* public function set textFlow(value:TextFlow):void
		{
			_textFlow = value;
			if (textArea)
			{
				textArea.textFlow = value;
			}
		} */

		/**
		 *  @private
		 */
		/* protected override function partAdded(partName:String, instance:Object):void
		{ 
			super.partAdded(partName, instance); 
			if (instance == textArea)
			{
				textArea.addEventListener(TextOperationEvent.CHANGE, handleChange);
				textArea.addEventListener(FlexEvent.SELECTION_CHANGE, handleSelectionChange);
				textArea.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				textArea.prompt = prompt;
				textArea.textFlow = textFlow;
				if (_htmlText)
				{
					textFlow = TextConverter.importToFlow(_htmlText, TextConverter.TEXT_FIELD_HTML_FORMAT);
				}
				else if (_text)
				{
					textArea.text = _text;
				}
			}
			if (instance == fontTool)
			{ 
				fontTool.addEventListener(IndexChangeEvent.CHANGE, handleFontChange);
			}
			if (instance == sizeTool)
			{ 
				sizeTool.addEventListener(IndexChangeEvent.CHANGE, handleSizeChange);
			} 
			if (instance == boldTool)
			{  
				boldTool.addEventListener(MouseEvent.CLICK, handleBoldClick);
			} 
			if (instance == italicTool)
			{ 
				italicTool.addEventListener(MouseEvent.CLICK, handleItalicClick);
			} 
			if (instance == underlineTool)
			{ 
				underlineTool.addEventListener(MouseEvent.CLICK, handleUnderlineClick);
			} 
			if (instance == colorTool)
			{ 
				colorTool.addEventListener(ColorChangeEvent.CHOOSE, handleColorChoose);
			} 
			if (instance == alignTool)
			{ 
				alignTool.addEventListener(IndexChangeEvent.CHANGE, handleAlignChange);
			} 
			if (instance == bulletTool)
			{ 
				bulletTool.addEventListener(MouseEvent.CLICK, handleBulletClick);
			} 
			if (instance == linkTool)
			{ 
				linkTool.addEventListener(KeyboardEvent.KEY_DOWN, handleLinkKeydown);
				linkTool.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleLinkUpdate);
			}
			handleSelectionChange();
		}
		 */
		/**
		 *  @private
		 */
		/* protected override function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if (instance == textArea)
			{
				textArea.removeEventListener(TextOperationEvent.CHANGE, handleChange);
				textArea.removeEventListener(FlexEvent.SELECTION_CHANGE, handleSelectionChange);
				textArea.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			}
			if (instance == fontTool)
			{ 
				fontTool.removeEventListener(IndexChangeEvent.CHANGE, handleFontChange);
			}
			if (instance == sizeTool)
			{ 
				sizeTool.removeEventListener(IndexChangeEvent.CHANGE, handleSizeChange);
			} 
			if (instance == boldTool)
			{  
				boldTool.removeEventListener(MouseEvent.CLICK, handleBoldClick);
			} 
			if (instance == italicTool)
			{ 
				italicTool.removeEventListener(MouseEvent.CLICK, handleItalicClick);
			} 
			if (instance == underlineTool)
			{ 
				underlineTool.removeEventListener(MouseEvent.CLICK, handleUnderlineClick);
			} 
			if (instance == colorTool)
			{ 
				colorTool.removeEventListener(ColorChangeEvent.CHOOSE, handleColorChoose);
			} 
			if (instance == alignTool)
			{ 
				alignTool.removeEventListener(IndexChangeEvent.CHANGE, handleAlignChange);
			} 
			if (instance == bulletTool)
			{ 
				bulletTool.removeEventListener(MouseEvent.CLICK, handleBulletClick);
			} 
			if (instance == linkTool)
			{ 
				linkTool.removeEventListener(KeyboardEvent.KEY_DOWN, handleLinkKeydown);
				linkTool.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleLinkUpdate);
			} 
		}

		/**
		 *  @private
		 */
		/* protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (textArea)
			{
				for (var key:String in _stylesChanged)
				{
					textArea.setStyle(key, _stylesChanged[key]);
				}
				_stylesChanged = new Dictionary; //Clear it out
			}
		} */ 
		
		/**
		 *  @private
		 *  Actually apply the link to the selection. Repair the formating in the process.
		 */
		/* private function applyLink(href:String, target:String = null, extendToLinkBoundary:Boolean = false, operationState:SelectionState = null):void
		{
			if (textArea && textArea.textFlow && textArea.textFlow.interactionManager is IEditManager)
			{
				//Get the current format
				var txtLayFmt:TextLayoutFormat = textArea.textFlow.interactionManager.getCommonCharacterFormat();
				//Set the link
				if (operationState == null && _linkEl != null)
				{
					operationState = new SelectionState(textArea.textFlow, _linkEl.getAbsoluteStart(), _linkEl.getAbsoluteStart() + _linkEl.textLength);
				}
				var linkElement:LinkElement = IEditManager(textArea.textFlow.interactionManager).applyLink(href, target, extendToLinkBoundary, operationState);
				//Fix the formatting
				if(linkElement)
				{
					IEditManager(textArea.textFlow.interactionManager).clearFormatOnElement(linkElement.getChildAt(0), txtLayFmt);
				}
				var selectionEnd:int = Math.max(textArea.selectionActivePosition, textArea.selectionAnchorPosition);
				textArea.selectRange(selectionEnd, selectionEnd);
				IEditManager(textArea.textFlow.interactionManager).applyLeafFormat(txtLayFmt);
			}
		}
		 */
		/**
		 *  @private
		 *  Automatically add a link if the previous text looks like a link
		 */
		/* private function checkLinks():void
		{
			var position:int = textArea.selectionActivePosition;
			//Find the firt non-whitespace character
			while (position > 0)
			{
				if (!isWhitespace(textArea.textFlow.getCharCodeAtPosition(position)))
				{
					break;
				}
				position--;
			}
			//Find the next whitespace character
			while (position > 0)
			{
				if (isWhitespace(textArea.textFlow.getCharCodeAtPosition(position)))
				{
					position++; //Back up one character
					break;
				}
				position--;
			}
			var testText:String = textArea.textFlow.getText(position, textArea.selectionActivePosition);
			var result:Array = testText.match(_urlRegExpression);
			if (result != null && result.length > 0)
			{
				if (textArea.textFlow.interactionManager is IEditManager)
				{
					var selectionState:SelectionState = new SelectionState(textArea.textFlow, position, textArea.selectionActivePosition);
					if (testText.substr(0, 3) == "www")
					{
						testText = "http://" + testText; //Add a missing 'http://' if needed
					}
					applyLink(testText, "_blank", true, selectionState);
					textArea.setFocus();
				}
			}
		} */
		
		/**
		 *  @private
		 */
		/* private function getBulletSelectionState():SelectionState
		{
			if (textArea.textFlow)
			{
				var selectionManager:ISelectionManager = textArea.textFlow.interactionManager;
				var selectionState:SelectionState = selectionManager.getSelectionState();
				var startleaf:FlowLeafElement = textArea.textFlow.findLeaf(selectionState.absoluteStart);
				var endleaf:FlowLeafElement = textArea.textFlow.findLeaf(selectionState.absoluteEnd);
				if (startleaf != null)
				{
					selectionState.absoluteStart = startleaf.getAbsoluteStart();
				}
				if (endleaf != null)
				{
					selectionState.absoluteEnd = endleaf.getAbsoluteStart() + endleaf.parentRelativeEnd - endleaf.parentRelativeStart;
				}
				return selectionState;
			}
			return null;
		}
		 */
		/**
		 *  @private
		 */
		/* private function handleAlignChange(e:Event):void
		{
			if (alignTool.selectedItem)
			{
				var txtLayFmt:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
				txtLayFmt.textAlign = alignTool.selectedItem.value;
				textArea.setFormatOfRange(txtLayFmt, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
				textArea.setFocus();
				textArea.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			}
		} */
		
		/**
		 *  @private
		 */
		/* private function handleBoldClick(e:MouseEvent):void
		{
			var format:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			format.fontWeight = (format.fontWeight == FontWeight.BOLD) ? FontWeight.NORMAL : FontWeight.BOLD;
			textArea.setFormatOfRange(format, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			textArea.setFocus();
			textArea.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
		} */
		
		/**
		 *  @private
		 */
		/* private function handleBulletClick(e:MouseEvent):void
		{
			if (textArea.textFlow && textArea.textFlow.interactionManager is IEditManager)
			{
				var editManager:IEditManager = IEditManager(textArea.textFlow.interactionManager);
				var doCreate:Boolean = true;
				var selectionState:SelectionState = getBulletSelectionState();
				var listElements:Array = textArea.textFlow.getElementsByTypeName("list");
				for each (var listElement:ListElement in listElements)
				{
					var start:int = listElement.getAbsoluteStart();
					var end:int = listElement.getAbsoluteStart() + listElement.parentRelativeEnd - listElement.parentRelativeStart;
					if (selectionState.absoluteStart == start && selectionState.absoluteEnd == end)
					{ //Same
						removeList(listElement);
						doCreate = false;
						break;
					}
					else if (selectionState.absoluteStart == start && selectionState.absoluteEnd <= end)
					{ //Inside touching start
						selectionState = new SelectionState(textArea.textFlow, end, selectionState.absoluteEnd);
						removeList(listElement);
						editManager.createList(null, null, selectionState);
						doCreate = false;
						break;
					}
					else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd == end)
					{ //Inside touching end
						selectionState = new SelectionState(textArea.textFlow, selectionState.absoluteStart, start);
						removeList(listElement);
						editManager.createList(null, null, selectionState);
						doCreate = false;
						break;
					}
					else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd <= end)
					{ //Inside
						var firstRange:SelectionState = new SelectionState(textArea.textFlow, selectionState.absoluteStart, start);
						var secondRange:SelectionState = new SelectionState(textArea.textFlow, end, selectionState.absoluteEnd);
						removeList(listElement);
						editManager.createList(null, null, firstRange);
						editManager.createList(null, null, secondRange);
						doCreate = false;
						break;
					}
					else if ((selectionState.absoluteStart >= start && selectionState.absoluteStart <= end) || (selectionState.absoluteEnd >= start && selectionState.absoluteEnd <= end))
					{ //Overlap. Include this list in the selection
						selectionState = new SelectionState(textArea.textFlow, Math.min(start, selectionState.absoluteStart), Math.max(end, selectionState.absoluteEnd));
						removeList(listElement);
					}
					else if (selectionState.absoluteStart <= start && selectionState.absoluteEnd >= end)
					{ //surround. Remove this list since it will get added back in, only expanded.
						removeList(listElement);
					}
				}
				if (doCreate)
				{
					IEditManager(textArea.textFlow.interactionManager).createList(null, null, selectionState);
				}
				textArea.textFlow.interactionManager.setFocus();
			}
		}
		 */
		/**
		 *  @private
		 */
		/* private function handleColorChoose(e:ColorChangeEvent):void
		{
			var format:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			format.color = e.color
			textArea.setFormatOfRange(format, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			textArea.setFocus();
			textArea.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
		}
		 */
		/**
		 *  @private
		 */
		/* private function handleFontChange(e:Event):void
		{
			if (fontTool.selectedItem)
			{
				var format:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
				format.fontFamily = fontTool.selectedItem;
				textArea.setFormatOfRange(format, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
				textArea.setFocus();
				textArea.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			}
		} */
		
		/**
		 *  @private
		 */
		/* private function handleItalicClick(e:MouseEvent):void
		{
			var format:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			format.fontStyle = (format.fontStyle == FontPosture.ITALIC) ? FontPosture.NORMAL : FontPosture.ITALIC;
			textArea.setFormatOfRange(format, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			textArea.setFocus();
			textArea.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
		} */
		
		/**
		 *  @private
		 */
		/* private function handleKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.SPACE || e.keyCode == Keyboard.TAB)
			{
				checkLinks();
			}
		} */
		
		/**
		 *  @private
		 */
		/* private function handleLinkKeydown(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			if (e.keyCode == Keyboard.ENTER)
			{
				handleLinkUpdate();
				textArea.setFocus();
			}
		} */
		
		/**
		 *  @private
		 *  Handle link set by applying the link to the selected text
		 */
		/* private function handleLinkUpdate(e:Event = null):void
		{
			var urlText:String = linkTool.selectedLink == _defaultLinkText ? '' : linkTool.selectedLink;
			applyLink(urlText, "_blank", true);
			//Set focus to textFlow
			textArea.textFlow.interactionManager.setFocus();
		} */
		
		/**
		 *  @private
		 */
		/* private function handleSelectionChange(e:FlexEvent = null):void
		{
			if (textArea != null)
			{
				var format:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
				if (fontTool != null)
				{ 
					fontTool.selectedFontFamily = format.fontFamily;
				}
				if (sizeTool != null)
				{ 
					sizeTool.selectedFontSize = format.fontSize;
				} 
				if (boldTool != null)
				{  
					boldTool.selectedFontWeight = format.fontWeight;
				} 
				if (italicTool != null)
				{ 
					italicTool.selectedFontStyle = format.fontStyle;
				} 
				if (underlineTool != null)
				{ 
					underlineTool.selectedTextDecoration = format.textDecoration;
				} 
				if (colorTool != null)
				{ 
					colorTool.selectedTextColor = format.color;
				} 
				if (alignTool != null)
				{ 
					alignTool.selectedTextAlign = format.textAlign;
				} 
				if (bulletTool != null)
				{ 
					if (textArea.textFlow)
					{
						var willRemoveBulletsIfClicked:Boolean = false;
						var selectionState:SelectionState = getBulletSelectionState();
						var listElements:Array = textArea.textFlow.getElementsByTypeName("list");
						for each (var listElement:ListElement in listElements)
						{
							var start:int = listElement.getAbsoluteStart();
							var end:int = listElement.getAbsoluteStart() + listElement.parentRelativeEnd - listElement.parentRelativeStart;
							if (selectionState.absoluteStart == start && selectionState.absoluteEnd == end)
							{ //Same
								willRemoveBulletsIfClicked = true;
								break;
							}
							else if (selectionState.absoluteStart >= start && selectionState.absoluteEnd <= end)
							{ //Inside
								willRemoveBulletsIfClicked = true;
								break;
							}
						}
						bulletTool.selected = willRemoveBulletsIfClicked;
						
					}
				} 
				if (linkTool != null)
				{ 
					var bulletSelectionState:SelectionState = textArea.textFlow.interactionManager.getSelectionState();
					if (bulletSelectionState.absoluteStart != -1 && bulletSelectionState.absoluteEnd != -1)
					{
						var range:ElementRange = ElementRange.createElementRange(bulletSelectionState.textFlow, bulletSelectionState.absoluteStart, bulletSelectionState.absoluteEnd);
						if (range)
						{
							var linkString:String = _defaultLinkText;
							_linkEl = range.firstLeaf.getParentByType(LinkElement) as LinkElement;
							if (_linkEl != null)
							{
								var linkElStart:int = _linkEl.getAbsoluteStart();
								var linkElEnd:int = linkElStart + _linkEl.textLength;
								if (linkElEnd < linkElStart)
								{
									var temp:int = linkElStart;
									linkElStart = linkElEnd;
									linkElEnd = temp;
								}
								
								var beginRange:int = range.absoluteStart;
								var endRange:int = range.absoluteEnd;
								
								var beginPara:ParagraphElement = range.firstParagraph;
								if (endRange == (beginPara.getAbsoluteStart() + beginPara.textLength))
								{
									endRange--;
								}
								
								if ((beginRange == endRange) || (endRange <= linkElEnd))
								{
									linkString = LinkElement(_linkEl).href;
								}
							}
							var newLinkSelected:Boolean = _linkEl != null;
							if (_linkSelected != newLinkSelected)
							{
								_linkSelected = newLinkSelected;
								this.dispatchEvent(new Event("linkSelectedChange"));
							}
							
							linkTool.selectedLink = linkString;
							
							_lastRange = range;
						}
						else
						{
							_lastRange = null;
						}
					}
					linkTool.enabled = textArea.selectionAnchorPosition != textArea.selectionActivePosition || _linkSelected;
				}
			}
		}
		 */
		/**
		 *  @private
		 */
		/* private function handleSizeChange(e:Event):void
		{
			if (sizeTool.selectedItem)
			{
				var format:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
				format.fontSize = sizeTool.selectedItem;
				textArea.setFormatOfRange(format, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
				textArea.setFocus();
				textArea.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			}
		} */
		
		/**
		 *  @private
		 */
		/* private function handleUnderlineClick(e:MouseEvent):void
		{
			var format:TextLayoutFormat = textArea.getFormatOfRange(null, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			format.textDecoration = (format.textDecoration == TextDecoration.UNDERLINE) ? TextDecoration.NONE : TextDecoration.UNDERLINE;
			textArea.setFormatOfRange(format, textArea.selectionAnchorPosition, textArea.selectionActivePosition);
			textArea.setFocus();
			textArea.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
		} */

		/**
		 *  @private
		 */
		/* private function handleChange(e:Event):void
		{
			_htmlTextChanged = true;
			this.dispatchEvent(e);
		} */
		
		/**
		 *  @private
		 */
		/* private function removeList(listElement:ListElement):void
		{
			var editManager:IEditManager = IEditManager(textArea.textFlow.interactionManager);
			
			var target:FlowGroupElement = listElement.parent;
			var targetIndex:int = target.getChildIndex(listElement);
			editManager.moveChildren(listElement, 0, listElement.numChildren, target, targetIndex);
		} */
		
		/**
		 *  @private
		 *  Return true if the character is a whitespace character
		 */
		/* private function isWhitespace(charCode:uint):Boolean
		{
			return charCode === 0x0009 || charCode === 0x000A || charCode === 0x000B || charCode === 0x000C || charCode === 0x000D || charCode === 0x0020 || charCode === 0x0085 || charCode === 0x00A0 || charCode === 0x1680 || charCode === 0x180E || charCode === 0x2000 || charCode === 0x2001 || charCode === 0x2002 || charCode === 0x2003 || charCode === 0x2004 || charCode === 0x2005 || charCode === 0x2006 || charCode === 0x2007 || charCode === 0x2008 || charCode === 0x2009 || charCode === 0x200A || charCode === 0x2028 || charCode === 0x2029 || charCode === 0x202F || charCode === 0x205F || charCode === 0x3000;
		} */
	}
}
