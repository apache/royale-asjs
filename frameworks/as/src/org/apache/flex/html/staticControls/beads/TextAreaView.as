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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IParent;
	import org.apache.flex.html.staticControls.beads.models.ScrollBarModel;
	import org.apache.flex.html.staticControls.beads.models.SingleLineBorderModel;
	import org.apache.flex.html.staticControls.supportClasses.Border;
	import org.apache.flex.html.staticControls.supportClasses.ScrollBar;

	public class TextAreaView extends TextFieldViewBase implements IStrand
	{
		public function TextAreaView()
		{
			super();
			
			textField.selectable = true;
			textField.type = TextFieldType.INPUT;
			textField.mouseEnabled = true;
			textField.multiline = true;
			textField.wordWrap = true;
		}
		
		private var _border:Border;
		
		public function get border():Border
		{
			return _border;
		}
		
		private var _vScrollBar:ScrollBar;
		
		public function get vScrollBar():ScrollBar
		{
			if (!_vScrollBar)
				_vScrollBar = createScrollBar();
			return _vScrollBar;
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			// add a border to this
			_border = new Border();
			_border.model = new SingleLineBorderModel();
			_border.addBead(new SingleLineBorderBead());
            IParent(strand).addElement(border);
			
			var vb:ScrollBar = vScrollBar;
			
			// Default size
			var ww:Number = DisplayObject(strand).width;
			if( isNaN(ww) || ww == 0 ) DisplayObject(strand).width = 100;
			var hh:Number = DisplayObject(strand).height;
			if( isNaN(hh) || hh == 0 ) DisplayObject(strand).height = 42;
			
			// for input, listen for changes to the _textField and update
			// the model
			textField.addEventListener(Event.CHANGE, inputChangeHandler);
			textField.addEventListener(Event.SCROLL, textScrollHandler);
			
			IEventDispatcher(strand).addEventListener("widthChanged", sizeChangedHandler);
			IEventDispatcher(strand).addEventListener("heightChanged", sizeChangedHandler);
			sizeChangedHandler(null);
		}
				
		private function createScrollBar():ScrollBar
		{
			var vsb:ScrollBar;
			vsb = new ScrollBar();
			var vsbm:ScrollBarModel = new ScrollBarModel();
			vsbm.maximum = 100;
			vsbm.minimum = 0;
			vsbm.pageSize = 10;
			vsbm.pageStepSize = 10;
			vsbm.snapInterval = 1;
			vsbm.stepSize = 1;
			vsbm.value = 0;
			vsb.model = vsbm;
			vsb.width = 16;
            IParent(strand).addElement(vsb);
			
			vsb.addEventListener("scroll", scrollHandler);
			
			return vsb;
		}
		
		private function inputChangeHandler(event:Event):void
		{
			textModel.text = textField.text;
		}
		
		private function textScrollHandler(event:Event):void
		{
			var visibleLines:int = textField.bottomScrollV - textField.scrollV + 1;
			var scrollableLines:int = textField.numLines - visibleLines + 1;
			var vsbm:ScrollBarModel = ScrollBarModel(vScrollBar.model);
			vsbm.minimum = 0;
			vsbm.maximum = textField.numLines+1;
			vsbm.value = textField.scrollV;
			vsbm.pageSize = visibleLines;
			vsbm.pageStepSize = visibleLines;
		}
		
		private function sizeChangedHandler(event:Event):void
		{
			var ww:Number = DisplayObject(strand).width - DisplayObject(vScrollBar).width;
			if( !isNaN(ww) && ww > 0 ) {
				textField.width = ww;
				_border.width = ww;
			}
			
			var hh:Number = DisplayObject(strand).height;
			if( !isNaN(hh) && hh > 0 ) {
				textField.height = hh;
				_border.height = hh;
			}
			
			var sb:DisplayObject = DisplayObject(vScrollBar);
			sb.y = 0;
			sb.x = textField.width - 1;
			sb.height = textField.height;
		}
		
		private function scrollHandler(event:Event):void
		{
			var vpos:Number = IScrollBarModel(vScrollBar.model).value;
			textField.scrollV = vpos;
		}
		
		// beads declared in MXML are added to the strand.
		// from AS, just call addBead()
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}
		
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
					return bead;
				}
			}
			return null;
		}
	}
}