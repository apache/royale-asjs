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
package mx.controls.beads
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IValueToggleButtonModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	
    import mx.controls.RadioButton;
    
	/**
	 *  The RadioButtonView class creates the visual elements of the org.apache.royale.html.RadioButton 
	 *  component. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class RadioButtonView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function RadioButtonView()
		{
			sprites = [ upSprite = new Sprite(),
				        downSprite = new Sprite(),
						overSprite = new Sprite(),
						upAndSelectedSprite = new Sprite(),
						downAndSelectedSprite = new Sprite(),
						overAndSelectedSprite = new Sprite() ];
			
			for each( var s:Sprite in sprites )
			{
				var tf:CSSTextField = new CSSTextField();
				tf.type = TextFieldType.DYNAMIC;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.name = "textField";
				var icon:Shape = new Shape();
				icon.name = "icon";
				s.addChild(icon);
				s.addChild(tf);
                s.mouseEnabled = false;
			}
		}
		
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
		private var upAndSelectedSprite:Sprite;
		private var downAndSelectedSprite:Sprite;
		private var overAndSelectedSprite:Sprite;
		
		private var sprites:Array;
		
		private var _toggleButtonModel:IValueToggleButtonModel;
		
        private var host:Sprite;

		/**
		 *  The model used for the RadioButton.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get toggleButtonModel() : IValueToggleButtonModel
		{
			return _toggleButtonModel;
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_toggleButtonModel = value.getBeadByType(IValueToggleButtonModel) as IValueToggleButtonModel;
			_toggleButtonModel.addEventListener("textChange", textChangeHandler);
			_toggleButtonModel.addEventListener("htmlChange", htmlChangeHandler);
			_toggleButtonModel.addEventListener("selectedValueChange", selectedValueChangeHandler);
			if (_toggleButtonModel.text != null)
				text = _toggleButtonModel.text;
			if (_toggleButtonModel.html != null)
				html = _toggleButtonModel.html;
            for each( var s:Sprite in sprites )
            {
                var tf:CSSTextField = s.getChildByName("textField") as CSSTextField;
                tf.styleParent = value;
            }
			
			layoutControl();
			
            UIBase(value).$sprite_addChild(upSprite);
            UIBase(value).$sprite_addChild(downSprite);
            UIBase(value).$sprite_addChild(overSprite);
            UIBase(value).$sprite_addChild(upAndSelectedSprite);
            UIBase(value).$sprite_addChild(downAndSelectedSprite);
            UIBase(value).$sprite_addChild(overAndSelectedSprite);
            host = Sprite(value);
            host.mouseEnabled = true;
            host.buttonMode = true;
            host.mouseChildren = false;
            host.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            host.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            host.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            host.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            host.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            
            /* TODO switch sprites on mouse state 
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = hitArea;
            */
            
			if (toggleButtonModel.text !== null)
				text = toggleButtonModel.text;
			if (toggleButtonModel.html !== null)
				html = toggleButtonModel.html;
			
			selected = (toggleButtonModel.selected && toggleButtonModel.value == value);
            
            host.addEventListener("selectedChanged", selectionChangeHandler);
		}
		
		/**
		 *  The string label for the org.apache.royale.html.RadioButton.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get text():String
		{
			var tf:CSSTextField = upSprite.getChildByName('textField') as CSSTextField;
			return tf.text;
		}
		public function set text(value:String):void
		{
			for each( var s:Sprite in sprites )
			{
				var tf:CSSTextField = s.getChildByName('textField') as CSSTextField;
				tf.text = value;
			}
			
			layoutControl();
		}
		
		/**
		 *  The HTML string for the org.apache.royale.html.RadioButton.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get html():String
		{
			var tf:CSSTextField = upSprite.getChildByName('textField') as CSSTextField;
			return tf.htmlText;
		}
		public function set html(value:String):void
		{
			for each(var s:Sprite in sprites)
			{
				var tf:CSSTextField = s.getChildByName('textField') as CSSTextField;
				tf.htmlText = value;
			}
			
			layoutControl();
		}
		
		/**
		 * @private
		 */
		private function textChangeHandler(event:Event):void
		{
			text = toggleButtonModel.text;
		}
		
		/**
		 * @private
		 */
		private function htmlChangeHandler(event:Event):void
		{
			html = toggleButtonModel.html;
		}
		
		private var _selected:Boolean;
		
		/**
		 * The selection state of the RadioButton
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			if( value ) {
                downAndSelectedSprite.visible = true;
                upAndSelectedSprite.visible = false;
                overAndSelectedSprite.visible = false;
                upSprite.visible = false;
                downSprite.visible = false;
                overSprite.visible = false;
			} else {
                downAndSelectedSprite.visible = false;
                upAndSelectedSprite.visible = false;
                overAndSelectedSprite.visible = false;
                upSprite.visible = false;
                downSprite.visible = true;
                overSprite.visible = false;
			}
			
			layoutControl();
		}
		
		/**
		 * @private
		 */
		private function selectedValueChangeHandler(event:Event):void
		{
			selected = _toggleButtonModel.value == _toggleButtonModel.selectedValue;
		}
		
		/**
		 * @private
		 */
		protected function layoutControl() : void
		{
			for each(var s:Sprite in sprites)
			{
				var icon:Shape = s.getChildByName("icon") as Shape;
				var tf:CSSTextField = s.getChildByName("textField") as CSSTextField;
				
				drawRadioButton(icon);
				
				var mh:Number = Math.max(icon.height,tf.height);
				
				icon.x = 0;
				icon.y = (mh - icon.height)/2;
				
				tf.x = icon.x + icon.width + 1;
				tf.y = (mh - tf.height)/2;
			}
			
		}
		
		/**
		 * @private
		 */
		protected function drawRadioButton(icon:Shape) : void
		{
			icon.graphics.clear();
			icon.graphics.beginFill(0xf8f8f8);
			icon.graphics.lineStyle(1,0x808080);
			icon.graphics.drawEllipse(0,0,10,10);
			icon.graphics.endFill();
			
			if( selected ) {
				icon.graphics.beginFill(0);
				icon.graphics.drawEllipse(3,3,4,4);
				icon.graphics.endFill();
			}
		}
        
        private function mouseOverHandler(event:MouseEvent):void
        {
            downAndSelectedSprite.visible = false;
            upAndSelectedSprite.visible = false;
            overAndSelectedSprite.visible = selected;
            upSprite.visible = false;
            downSprite.visible = false;
            overSprite.visible = !selected;           
        }
        
        private function mouseOutHandler(event:MouseEvent):void
        {
            downAndSelectedSprite.visible = false;
            upAndSelectedSprite.visible = selected;
            overAndSelectedSprite.visible = false;
            upSprite.visible = !selected;
            downSprite.visible = false;
            overSprite.visible = false;           
        }

        private function mouseUpHandler(event:MouseEvent):void
        {
            downAndSelectedSprite.visible = false;
            upAndSelectedSprite.visible = selected;
            overAndSelectedSprite.visible = false;
            upSprite.visible = !selected;
            downSprite.visible = false;
            overSprite.visible = false;           
        }
        
        private function mouseDownHandler(event:MouseEvent):void
        {
            downAndSelectedSprite.visible = selected;
            upAndSelectedSprite.visible = false;
            overAndSelectedSprite.visible = false;
            upSprite.visible = false;
            downSprite.visible = !selected;
            overSprite.visible = false;           
        }
        
        private function mouseClickHandler(event:MouseEvent):void
        {
            selected = !selected;
            RadioButton(host).selected = selected;
        }
        
        private function selectionChangeHandler(event:Event):void
        {
            selected = !selected;
        }
	}
}
