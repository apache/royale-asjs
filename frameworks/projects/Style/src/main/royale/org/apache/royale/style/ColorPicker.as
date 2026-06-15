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
package org.apache.royale.style
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.core.IRGBA;
	import org.apache.royale.core.RGBColor;
	import org.apache.royale.style.colors.AlphaSlider;
	import org.apache.royale.style.colors.ColorArea;
	import org.apache.royale.style.colors.HueSlider;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.style.stylebeads.flexgrid.AlignItems;
	import org.apache.royale.style.stylebeads.flexgrid.FlexDirection;
	import org.apache.royale.style.stylebeads.flexgrid.Gap;
	import org.apache.royale.style.stylebeads.flexgrid.JustifyContent;
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.sizing.WidthStyle;
	import org.apache.royale.style.stylebeads.spacing.Margin;
	import org.apache.royale.utils.HSV;
	import org.apache.royale.utils.number.pinValue;
	import org.apache.royale.utils.rgbToHsv;

	/**
	 *  ColorPicker composes a ColorSwatchButton trigger with a Popover
	 *  containing the color editing UI: an HSV ColorArea, a HueSlider,
	 *  an optional AlphaSlider, a preview swatch with hex input, and
	 *  optional Apply/Cancel buttons. All controls stay in sync via the
	 *  shared <code>color</code> property.
	 */
	[Event(name="colorChanged", type="org.apache.royale.events.ValueEvent")]
	[Event(name="colorCommit", type="org.apache.royale.events.ValueEvent")]
	[Event(name="cancel", type="org.apache.royale.events.Event")]
	[Event(name="openChanged", type="org.apache.royale.events.Event")]
	public class ColorPicker extends Group
	{
		public function ColorPicker()
		{
			super();
		}

		protected var trigger:ColorSwatchButton;
		protected var popover:Popover;
		protected var originalSwatch:ColorSwatchButton;
		protected var previewSwatch:ColorSwatchButton;
		protected var hexInput:TextInput;
		protected var hexLabel:Span;
		protected var inputRow:Div;
		protected var colorArea:ColorArea;
		protected var hueSlider:HueSlider;
		protected var alphaSlider:AlphaSlider;
		protected var alphaPercent:TextInput;
		protected var buttonRow:Div;
		protected var applyButton:Button;
		protected var cancelButton:Button;
		protected var swatchGrid:Div;
		protected var mainRow:Div;
		protected var rightColumn:Div;
		protected var sliderColumn:Div;
		protected var swatchPreviewRow:Div;

		// Guards re-entrant updates while propagating a color change to
		// all child controls.
		private var _syncing:Boolean = false;

		// The color the picker exposes (and that the trigger displays).
		private var _color:IRGBA;

		public function get color():IRGBA
		{
			return _color;
		}

		public function set color(value:IRGBA):void
		{
			if (value === _color) return;
			_color = value;
			updateSelectedIndexFromColor(false);
			syncControlsFromColor();
			dispatchEvent(new ValueEvent("colorChanged", _color));
		}

		public function get appliedColor():IRGBA
		{
			return color;
		}

		public function set appliedColor(value:IRGBA):void
		{
			color = value;
		}

		private function syncControlsFromColor():void
		{
			if (_syncing) return;
			_syncing = true;
			try
			{
				var valid:Boolean = _color != null && _color.isValid;
				if (trigger) trigger.color = _color;
				if (previewSwatch) previewSwatch.color = _color;
				if (hexInput && _color) hexInput.value = _color.hexString.replace(/^#/, "");
				if (colorArea && valid)
					colorArea.appliedColor = _color;
				if (colorArea)
					colorArea.thumbVisible = valid;
				if (hueSlider)
				{
					if (valid)
					{
						var hsv:HSV = rgbToHsv(_color.r, _color.g, _color.b);
						hueSlider.hue = hsv.h;
					}
					hueSlider.thumbVisible = valid;
				}
				if (alphaSlider && _color)
				{
					alphaSlider.baseColor = _color;
					alphaSlider.alphaValue = isNaN(_color.alpha) ? 1 : _color.alpha;
				}
				if (alphaSlider)
					alphaSlider.thumbVisible = valid;
				updateAlphaInput();
			}
			finally
			{
				_syncing = false;
			}
		}

		public function get colorValue():uint
		{
			return _color ? _color.colorValue : 0;
		}

		public function set colorValue(value:uint):void
		{
			var c:RGBColor = new RGBColor();
			c.colorValue = value;
			color = c;
		}

		private var _direction:String = "bottom";		/**
		 *  Side of the trigger the picker popup opens toward.
		 */
		public function get direction():String
		{
			return _direction;
		}

		[Inspectable(category="General", enumeration="top,right,bottom,left", defaultValue="bottom")]
		public function set direction(value:String):void
		{
			_direction = value;
			if (popover) popover.direction = value;
		}

		/**
		 *  Spectrum-compatible alias for direction.
		 */
		public function get position():String
		{
			return direction;
		}

		[Inspectable(category="General", enumeration="bottom,top,right,left", defaultValue="bottom")]
		public function set position(value:String):void
		{
			direction = value;
		}

		public function get open():Boolean
		{
			return popover ? popover.open : false;
		}

		public function set open(value:Boolean):void
		{
			if (popover) popover.open = value;
		}

		private var _showAlphaControls:Boolean = true;
		public function get showAlphaControls():Boolean { return _showAlphaControls; }
		public function set showAlphaControls(value:Boolean):void
		{
			if (value == _showAlphaControls) return;
			_showAlphaControls = value;
			applyApiState();
		}

		private var _showApplyButtons:Boolean = true;
		public function get showApplyButtons():Boolean { return _showApplyButtons; }
		public function set showApplyButtons(value:Boolean):void
		{
			if (value == _showApplyButtons) return;
			_showApplyButtons = value;
			applyApiState();
		}

		private var _showColorControls:Boolean = true;
		public function get showColorControls():Boolean { return _showColorControls; }
		public function set showColorControls(value:Boolean):void
		{
			if (value == _showColorControls) return;
			_showColorControls = value;
			applyApiState();
		}

		private var _showSelectionSwatch:Boolean = true;
		public function get showSelectionSwatch():Boolean { return _showSelectionSwatch; }
		public function set showSelectionSwatch(value:Boolean):void
		{
			if (value == _showSelectionSwatch) return;
			_showSelectionSwatch = value;
			applyApiState();
		}

		private var _preferredColumns:int = 0;
		public function get preferredColumns():int { return _preferredColumns; }
		public function set preferredColumns(value:int):void
		{
			if (value == _preferredColumns) return;
			_preferredColumns = value;
			applyApiState();
		}

		private var _preferredRows:int = 0;
		public function get preferredRows():int { return _preferredRows; }
		public function set preferredRows(value:int):void
		{
			if (value == _preferredRows) return;
			_preferredRows = value;
			applyApiState();
		}

		private var _hexEditable:Boolean = true;
		public function get hexEditable():Boolean { return _hexEditable; }
		public function set hexEditable(value:Boolean):void
		{
			if (value == _hexEditable) return;
			_hexEditable = value;
			applyApiState();
		}

		private var _areaSize:Number = 180;
		public function get areaSize():Number { return _areaSize; }
		public function set areaSize(value:Number):void
		{
			_areaSize = value;
			if (colorArea) colorArea.pickerSize = value;
			applyApiState();
		}

		private var _applyText:String = "Apply";
		public function get applyText():String { return _applyText; }
		public function set applyText(value:String):void
		{
			_applyText = value;
			if (applyButton) applyButton.text = value;
		}

		private var _cancelText:String = "Cancel";
		public function get cancelText():String { return _cancelText; }
		public function set cancelText(value:String):void
		{
			_cancelText = value;
			if (cancelButton) cancelButton.text = value;
		}

		// Snapshot of color when the popup was opened (used for cancel).
		private var _initialColor:IRGBA;

		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			if (_selectedIndex >= 0)
				selectDataProviderIndex(_selectedIndex, false);
			else if (!_color && getDataProviderLength() > 0)
				selectDataProviderIndex(0, false);
			buildSwatches();
		}

		private var _selectedIndex:int = -1;
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			selectDataProviderIndex(value, true);
		}

		public function get selectedItem():Object
		{
			return getDataProviderItem(_selectedIndex);
		}

		public function set selectedItem(value:Object):void
		{
			var index:int = getDataProviderItemIndex(value);
			if (index >= 0)
				selectDataProviderIndex(index, true);
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();

			trigger = new ColorSwatchButton();
			if (_color) trigger.color = _color;

			popover = new Popover();
			popover.direction = _direction;
			popover.trigger = trigger;
			popover.addEventListener("openChanged", handlePopoverOpenChanged);

			buildPopoverContent();
			addElement(popover);

			return elem;
		}

		private function buildPopoverContent():void
		{
			swatchGrid = new Div();
			COMPILE::JS
			{
				var gridStyle:CSSStyleDeclaration = (swatchGrid.element as HTMLElement).style;
				gridStyle.display = "grid";
				// Bracket notation: these CSS props are not in the bundled
				// CSSStyleDeclaration extern, so dotted access gets renamed
				// in the js-release (Closure ADVANCED) build.
				gridStyle["gridTemplateColumns"] = "repeat(10, 20px)";
				gridStyle["gap"] = "4px";
				gridStyle.marginBottom = "10px";
			}
			popover.addElement(swatchGrid);
			buildSwatches();

			mainRow = new Div();
			mainRow.setStyles([
				new Display("flex"),
				new AlignItems("stretch"),
				new Gap("16px")
			], true);
			popover.addElement(mainRow);

			// 1. HSV color area
			colorArea = new ColorArea();
			colorArea.pickerSize = _areaSize;
			colorArea.addEventListener("colorChanged", handleColorAreaChange);
			mainRow.addElement(colorArea);

			// Right-hand column: sliders row on top, preview swatches row below.
			rightColumn = new Div();
			rightColumn.setStyles([
				new Display("flex"),
				new FlexDirection("column"),
				new Gap("6px")
			], true);
			mainRow.addElement(rightColumn);

			sliderColumn = new Div();
			sliderColumn.setStyles([
				new Display("flex"),
				new Gap("16px")
			], true);
			sliderColumn.height = _areaSize;
			rightColumn.addElement(sliderColumn);

			// 2. Hue slider
			hueSlider = new HueSlider();
			hueSlider.vertical = true;
			hueSlider.width = 24;
			hueSlider.height = _areaSize;
			hueSlider.addEventListener("hueChanged", handleHueChange);
			sliderColumn.addElement(hueSlider);

			// 3. Alpha slider
			alphaSlider = new AlphaSlider();
			alphaSlider.vertical = true;
			alphaSlider.width = 24;
			alphaSlider.height = _areaSize;
			COMPILE::JS
			{
				(alphaSlider.element as HTMLElement).style.display = "inline-block";
			}
			alphaSlider.addEventListener("alphaChanged", handleAlphaChange);
			sliderColumn.addElement(alphaSlider);

			// 4. Original / preview swatches sit under the sliders, each
			// approximately aligned under its slider so users can compare
			// before/after color & alpha.
			swatchPreviewRow = new Div();
			swatchPreviewRow.setStyles([
				new Display("flex"),
				new JustifyContent("start")
			], true);
			rightColumn.addElement(swatchPreviewRow);

			originalSwatch = new ColorSwatchButton();
			originalSwatch.disabled = true;
			originalSwatch.width = 32;
			originalSwatch.height = 40;
			COMPILE::JS
			{
				var originalStyle:CSSStyleDeclaration = (originalSwatch.element as HTMLElement).style;
				originalStyle.display = "inline-block";
				originalStyle["borderTopRightRadius"] = "0";
				originalStyle["borderBottomRightRadius"] = "0";
			}
			swatchPreviewRow.addElement(originalSwatch);

			previewSwatch = new ColorSwatchButton();
			previewSwatch.disabled = true;
			previewSwatch.width = 32;
			previewSwatch.height = 40;
			COMPILE::JS
			{
				var previewStyle:CSSStyleDeclaration = (previewSwatch.element as HTMLElement).style;
				previewStyle.display = "inline-block";
				previewStyle["borderTopLeftRadius"] = "0";
				previewStyle["borderBottomLeftRadius"] = "0";
			}
			swatchPreviewRow.addElement(previewSwatch);

			// 5. Hex + alpha inputs
			inputRow = new Div();
			inputRow.setStyles([
				new Display("flex"),
				new AlignItems("center"),
				new Gap("6px"),
				new Margin(8, "px")
			], true);
			popover.addElement(inputRow);

			hexLabel = new Span();
			hexLabel.text = "#";
			inputRow.addElement(hexLabel);

			hexInput = new TextInput();
			hexInput.setStyles([
				new WidthStyle("80px")
			], true);
			hexInput.placeholder = "rrggbb";
			COMPILE::JS
			{
				(hexInput.element as HTMLElement).addEventListener("change", handleHexChange);
				(hexInput.element as HTMLElement).addEventListener("keydown", handleHexKeyDown);
				(hexInput.element as HTMLElement).addEventListener("input", handleHexInput);
				(hexInput.element as HTMLElement).addEventListener("focus", handleHexFocus);
			}
			inputRow.addElement(hexInput);

			alphaPercent = new TextInput();
			alphaPercent.setStyles([
				new WidthStyle("50px")
			], true);
			alphaPercent.value = "100%";
			COMPILE::JS
			{
				var alphaInput:HTMLInputElement = alphaPercent.element as HTMLInputElement;
				alphaInput.style.textAlign = "right";
				alphaInput.addEventListener("change", handleAlphaInputChange);
				alphaInput.addEventListener("keydown", handleAlphaInputKeyDown);
				alphaInput.addEventListener("input", handleAlphaInput);
				alphaInput.addEventListener("focus", handleAlphaFocus);
			}
			inputRow.addElement(alphaPercent);

			// 6. Apply / Cancel buttons (Apply first to match Spectrum)
			buttonRow = new Div();
			buttonRow.setStyles([
				new Display("flex"),
				new JustifyContent("end"),
				new Gap("6px"),
				new Margin(8, "px")
			], true);
			popover.addElement(buttonRow);

			applyButton = new Button();
			applyButton.text = _applyText;
			COMPILE::JS
			{
				(applyButton.element as HTMLElement).addEventListener("click", handleApplyClick);
			}
			buttonRow.addElement(applyButton);

			cancelButton = new Button();
			cancelButton.text = _cancelText;
			COMPILE::JS
			{
				(cancelButton.element as HTMLElement).addEventListener("click", handleCancelClick);
			}
			buttonRow.addElement(cancelButton);

			syncControlsFromColor();
			applyApiState();
		}

		private function applyApiState():void
		{
			if (mainRow) mainRow.visible = _showColorControls;
			if (inputRow) inputRow.visible = _showColorControls;
			if (swatchPreviewRow) swatchPreviewRow.visible = _showColorControls && _showSelectionSwatch;
			if (previewSwatch) previewSwatch.visible = _showSelectionSwatch;
			if (originalSwatch) originalSwatch.visible = _showSelectionSwatch;
			if (hexLabel) hexLabel.visible = _showColorControls;
			if (hexInput) hexInput.visible = _showColorControls;
			if (alphaSlider) alphaSlider.visible = _showColorControls && _showAlphaControls;
			if (alphaPercent) alphaPercent.visible = _showColorControls && _showAlphaControls;
			if (buttonRow) buttonRow.visible = _showApplyButtons;
			if (swatchGrid) swatchGrid.visible = getDataProviderLength() > 0;
			if (colorArea) colorArea.width = _areaSize;
			if (sliderColumn) sliderColumn.height = _areaSize;
			if (hueSlider) hueSlider.height = _areaSize;
			if (alphaSlider) alphaSlider.height = _areaSize;
			COMPILE::JS
			{
				if (hexInput)
					(hexInput.element as HTMLInputElement).readOnly = !_hexEditable;
				if (alphaPercent)
					(alphaPercent.element as HTMLInputElement).readOnly = !_hexEditable;
				if (swatchGrid)
				{
					var gridStyle:CSSStyleDeclaration = (swatchGrid.element as HTMLElement).style;
					gridStyle["gridTemplateColumns"] = _preferredColumns > 0
						? "repeat(" + _preferredColumns + ", 20px)"
						: "repeat(10, 20px)";
					gridStyle["maxHeight"] = _preferredRows > 0 ? String(Math.max(24, -4 + (_preferredRows * 24))) + "px" : "";
					gridStyle["overflowY"] = _preferredRows > 0 ? "auto" : "";
				}
			}
		}

		private function handleColorAreaChange(event:ValueEvent):void
		{
			if (_syncing) return;
			var c:RGBColor = event.value as RGBColor;
			if (!c) return;
			var next:RGBColor = c.clone() as RGBColor;
			if (_color && !isNaN(_color.alpha)) next.alpha = _color.alpha;
			_color = next;
			// don't re-sync the colorArea (it's the source); update the rest
			if (trigger) trigger.color = next;
			if (previewSwatch) previewSwatch.color = next;
			if (hexInput) hexInput.value = next.hexString.replace(/^#/, "");
			colorArea.thumbVisible = true;
			if (hueSlider) hueSlider.thumbVisible = true;
			if (alphaSlider) alphaSlider.thumbVisible = true;
			if (alphaSlider) alphaSlider.baseColor = next;
			updateAlphaInput();
			updateSelectedIndexFromColor(true);
			dispatchEvent(new ValueEvent("colorChanged", next));
		}

		private function handleHueChange(event:ValueEvent):void
		{
			if (_syncing) return;
			if (!colorArea) return;
			colorArea.hue = Number(event.value);
			var next:IRGBA = colorArea.appliedColor;
			if (!next) return;
			if (_color && !isNaN(_color.alpha)) next.alpha = _color.alpha;
			_color = next;
			if (trigger) trigger.color = next;
			if (previewSwatch) previewSwatch.color = next;
			if (hexInput) hexInput.value = next.hexString.replace(/^#/, "");
			colorArea.thumbVisible = true;
			if (hueSlider) hueSlider.thumbVisible = true;
			if (alphaSlider) alphaSlider.thumbVisible = true;
			if (alphaSlider) alphaSlider.baseColor = next;
			updateAlphaInput();
			updateSelectedIndexFromColor(true);
			dispatchEvent(new ValueEvent("colorChanged", next));
		}

		private function handleAlphaChange(event:ValueEvent):void
		{
			if (_syncing) return;
			if (!_color) return;
			var next:RGBColor = new RGBColor([_color.r, _color.g, _color.b, Number(event.value)]);
			_color = next;
			if (trigger) trigger.color = next;
			if (previewSwatch) previewSwatch.color = next;
			updateAlphaInput();
			updateSelectedIndexFromColor(true);
			dispatchEvent(new ValueEvent("colorChanged", next));
		}

		COMPILE::JS
		private function handleApplyClick(event:Object):void
		{
			dispatchEvent(new ValueEvent("colorCommit", _color));
			open = false;
		}

		COMPILE::JS
		private function handleCancelClick(event:Object):void
		{
			cancel();
		}

		COMPILE::JS
		private function handleHexChange(event:Object):void
		{
			commitHexFromInput(false);
		}

		COMPILE::JS
		private function handleHexKeyDown(event:Object):void
		{
			if (event.key == "Enter")
			{
				event.preventDefault();
				commitHexFromInput(true);
			}
			else if (event.key == "Escape")
			{
				cancel();
			}
		}

		COMPILE::JS
		private function handleHexInput(event:Object):void
		{
			var input:HTMLInputElement = hexInput.element as HTMLInputElement;
			input.value = input.value.replace(/[^#0-9A-Fa-f]/g, "").toUpperCase();
		}

		COMPILE::JS
		private function handleHexFocus(event:Object):void
		{
			var input:HTMLInputElement = hexInput.element as HTMLInputElement;
			input.setSelectionRange(0, input.value.length);
		}

		COMPILE::JS
		private function handleAlphaInputChange(event:Object):void
		{
			commitAlphaFromInput();
		}

		COMPILE::JS
		private function handleAlphaInput(event:Object):void
		{
			var input:HTMLInputElement = alphaPercent.element as HTMLInputElement;
			input.value = input.value.replace(/[^0-9%]/g, "");
		}

		COMPILE::JS
		private function handleAlphaFocus(event:Object):void
		{
			var input:HTMLInputElement = alphaPercent.element as HTMLInputElement;
			input.setSelectionRange(0, input.value.length);
		}

		COMPILE::JS
		private function handleAlphaInputKeyDown(event:Object):void
		{
			if (event.key == "Enter")
			{
				event.preventDefault();
				commitAlphaFromInput();
			}
			else if (event.key == "Escape")
			{
				cancel();
			}
			else if (event.key == "ArrowUp" || event.key == "ArrowDown")
			{
				event.preventDefault();
				var current:Number = alphaPercentToNumber(alphaPercent.value);
				if (isNaN(current)) current = 100;
				current += event.key == "ArrowUp" ? 1 : -1;
				alphaPercent.value = Math.round(pinValue(current, 0, 100)) + "%";
				commitAlphaFromInput();
				handleAlphaFocus(event);
			}
		}

		private function commitHexFromInput(closeAfter:Boolean):void
		{
			var raw:String = hexInput.value;
			if (raw == null) return;
			raw = raw.replace(/^#/, "");
			if (raw.length != 6) return;
			var c:RGBColor = RGBColor.fromHex(raw);
			if (!c.isValid) return;
			if (_color && !isNaN(_color.alpha)) c.alpha = _color.alpha;
			color = c;
			if (closeAfter)
			{
				dispatchEvent(new ValueEvent("colorCommit", _color));
				open = false;
			}
		}

		private function commitAlphaFromInput():void
		{
			if (!_color || !alphaPercent) return;
			var value:Number = alphaPercentToNumber(alphaPercent.value);
			if (isNaN(value)) return;
			value = pinValue(value, 0, 100);
			var next:RGBColor = new RGBColor([_color.r, _color.g, _color.b, value / 100]);
			color = next;
		}

		private function alphaPercentToNumber(value:String):Number
		{
			if (value == null) return NaN;
			return parseFloat(value.replace(/%/g, ""));
		}

		private function updateAlphaInput():void
		{
			if (!alphaPercent) return;
			alphaPercent.value = _color && !isNaN(_color.alpha)
				? Math.round(_color.alpha * 100) + "%" : "100%";
		}

		public function cancel():void
		{
			if (_initialColor)
				color = _initialColor;
			dispatchEvent(new Event("cancel"));
			open = false;
		}

		private function handlePopoverOpenChanged(event:Event):void
		{
			if (popover.open)
			{
				_initialColor = _color ? _color.clone() : null;
				if (originalSwatch) originalSwatch.color = _initialColor;
				syncControlsFromColor();
			}
			dispatchEvent(new Event("openChanged"));
		}

		private function selectDataProviderIndex(index:int, dispatchChange:Boolean):void
		{
			_selectedIndex = index;
			var item:Object = getDataProviderItem(index);
			if (item is IRGBA)
			{
				_color = (item as IRGBA).clone();
				syncControlsFromColor();
				if (dispatchChange)
					dispatchEvent(new ValueEvent("colorChanged", _color));
			}
			updateSwatchSelection();
		}

		private function getDataProviderLength():int
		{
			if (!_dataProvider) return 0;
			if (_dataProvider is Array) return (_dataProvider as Array).length;
			if (_dataProvider["length"] !== undefined) return int(_dataProvider["length"]);
			return 0;
		}

		private function getDataProviderItem(index:int):Object
		{
			if (!_dataProvider || index < 0 || index >= getDataProviderLength()) return null;
			if (_dataProvider is Array) return (_dataProvider as Array)[index];
			if (_dataProvider["getItemAt"] != null) return _dataProvider["getItemAt"](index);
			return _dataProvider[index];
		}

		private function getDataProviderItemIndex(value:Object):int
		{
			if (!_dataProvider || value == null) return -1;
			var len:int = getDataProviderLength();
			for (var i:int = 0; i < len; i++)
			{
				if (getDataProviderItem(i) == value)
					return i;
			}
			return -1;
		}

		private function buildSwatches():void
		{
			if (!swatchGrid) return;
			COMPILE::JS
			{
				var grid:HTMLElement = swatchGrid.element as HTMLElement;
				while (grid.firstChild) grid.removeChild(grid.firstChild);
			}
			var len:int = getDataProviderLength();
			swatchGrid.visible = len > 0;
			for (var i:int = 0; i < len; i++)
			{
				var item:IRGBA = getDataProviderItem(i) as IRGBA;
				var swatch:ColorSwatchButton = new ColorSwatchButton();
				swatch.color = item;
				swatch.width = 20;
				swatch.height = 20;
				COMPILE::JS
				{
					var swatchElem:HTMLElement = swatch.element as HTMLElement;
					swatchElem.setAttribute("data-index", String(i));
					swatchElem.addEventListener("click", handleSwatchClick);
				}
				swatchGrid.addElement(swatch);
			}
			updateSwatchSelection();
		}

		COMPILE::JS
		private function handleSwatchClick(event:Object):void
		{
			var target:HTMLElement = event.currentTarget as HTMLElement;
			var index:int = int(target.getAttribute("data-index"));
			selectDataProviderIndex(index, true);
		}

		private function updateSelectedIndexFromColor(resetWhenMissing:Boolean):void
		{
			var len:int = getDataProviderLength();
			var index:int = -1;
			for (var i:int = 0; i < len; i++)
			{
				var item:IRGBA = getDataProviderItem(i) as IRGBA;
				if (sameColor(item, _color))
				{
					index = i;
					break;
				}
			}
			if (index >= 0 || resetWhenMissing)
			{
				_selectedIndex = index;
				updateSwatchSelection();
			}
		}

		private function updateSwatchSelection():void
		{
			if (!swatchGrid) return;
			COMPILE::JS
			{
				var grid:HTMLElement = swatchGrid.element as HTMLElement;
				for (var i:int = 0; i < grid.children.length; i++)
				{
					var child:HTMLElement = grid.children[i] as HTMLElement;
					child.style.outline = i == _selectedIndex ? "2px solid #2680eb" : "";
					child.style["outlineOffset"] = "1px";
				}
			}
		}

		private function sameColor(a:IRGBA, b:IRGBA):Boolean
		{
			if (!a || !b) return false;
			var aa:Number = isNaN(a.alpha) ? 1 : a.alpha;
			var ba:Number = isNaN(b.alpha) ? 1 : b.alpha;
			return a.r == b.r && a.g == b.g && a.b == b.b && Math.round(aa * 100) == Math.round(ba * 100);
		}
	}
}
