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
package org.apache.flex.html.beads
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.IBead;
    import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IScrollBarModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IParent;
    import org.apache.flex.core.ValuesManager;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.VScrollBar;

    /**
     *  The TextAreaView class is the default view for
     *  the org.apache.flex.html.TextArea class.
     *  It implements the classic desktop-like TextArea with
     *  a border and scrollbars.  It does not support right-to-left text.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class TextAreaView extends TextFieldViewBase implements IStrand
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
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
		
        /**
         *  The border.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get border():Border
		{
			return _border;
		}
		
		private var _vScrollBar:VScrollBar;
		
        /**
         *  The vertical ScrollBar.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get vScrollBar():VScrollBar
		{
			if (!_vScrollBar)
				_vScrollBar = createScrollBar();
			return _vScrollBar;
		}
		
        /**
         *  @private
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            for each (var bead:IBead in beads)
                addBead(bead);
            
			// add a border to this
			_border = new Border();
			_border.model = new (ValuesManager.valuesImpl.getValue(value, "iBorderModel")) as IBeadModel;
			_border.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);
            IParent(host).addElement(border);
			
			var vb:VScrollBar = vScrollBar;
			
			// Default size
			var ww:Number = host.width;
			if( isNaN(ww) || ww == 0 ) host.width = 100;
			var hh:Number = host.height;
			if( isNaN(hh) || hh == 0 ) host.height = 42;
			
			// for input, listen for changes to the _textField and update
			// the model
			textField.$textField.addEventListener(Event.SCROLL, textScrollHandler);
			
			IEventDispatcher(host).addEventListener("widthChanged", sizeChangedHandler);
			IEventDispatcher(host).addEventListener("heightChanged", sizeChangedHandler);
			sizeChangedHandler(null);
		}
				
		private function createScrollBar():VScrollBar
		{
			var vsb:VScrollBar;
			vsb = new VScrollBar();
			var vsbm:ScrollBarModel = new ScrollBarModel();
			vsbm.maximum = 100;
			vsbm.minimum = 0;
			vsbm.pageSize = 10;
			vsbm.pageStepSize = 10;
			vsbm.snapInterval = 1;
			vsbm.stepSize = 1;
			vsbm.value = 0;
			vsb.model = vsbm;
            IParent(host).addElement(vsb);
			
			vsb.addEventListener("scroll", scrollHandler);
			
			return vsb;
		}
		
		private function textScrollHandler(event:Event):void
		{
			var tf:TextField = textField.$textField;
			var visibleLines:int = tf.bottomScrollV - tf.scrollV + 1;
			var scrollableLines:int = textField.numLines - visibleLines + 1;
			var vsbm:ScrollBarModel = ScrollBarModel(vScrollBar.model);
			vsbm.minimum = 0;
			vsbm.maximum = textField.numLines+1;
			vsbm.value = tf.scrollV;
			vsbm.pageSize = visibleLines;
			vsbm.pageStepSize = visibleLines;
		}
		
		private function sizeChangedHandler(event:Event):void
		{
			var ww:Number = host.width;
            if( !isNaN(ww) && ww > 0 )
                _border.width = ww;
            
            ww -= DisplayObject(vScrollBar).width;
			if( !isNaN(ww) && ww > 0 )
				textField.width = ww;
			
			var hh:Number = host.height;
			if( !isNaN(hh) && hh > 0 ) 
            {
				textField.height = hh;
				_border.height = hh;
			}
			
			var sb:DisplayObject = DisplayObject(vScrollBar);
			sb.y = 1;
			sb.x = textField.width - 1;
			sb.height = textField.height;
		}
		
		private function scrollHandler(event:Event):void
		{
			var vpos:Number = IScrollBarModel(vScrollBar.model).value;
			textField.$textField.scrollV = vpos;
		}
		
        /**
         *  @copy org.apache.flex.core.UIBase#beads
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;

        /**
         *  @copy org.apache.flex.core.UIBase#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}
		
        /**
         *  @copy org.apache.flex.core.UIBase#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
        /**
         *  @copy org.apache.flex.core.UIBase#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
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
