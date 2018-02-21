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
package org.apache.royale.html.beads
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
    import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IToggleButtonModel;
	import org.apache.royale.events.Event;
	
    /**
     *  The CheckBoxView class is the default view for
     *  the org.apache.royale.html.CheckBox class.
     *  It displays a simple checkbox with an 'x' if checked,
     *  and a label on the right.  There are no styles or
     *  properties to configure the look of the 'x' or the
     *  position of the label relative to the checkbox as
     *  there are no equivalents in the standard HTML checkbox.
     * 
     *  A more complex CheckBox could implement more view
     *  configuration.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CheckBoxView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CheckBoxView()
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
			}
		}
		
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
		private var upAndSelectedSprite:Sprite;
		private var downAndSelectedSprite:Sprite;
		private var overAndSelectedSprite:Sprite;
		
		private var sprites:Array;
		
		private var _toggleButtonModel:IToggleButtonModel;

        // TODO: Can we remove this?
		private function get toggleButtonModel() : IToggleButtonModel
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
            
			_toggleButtonModel = value.getBeadByType(IToggleButtonModel) as IToggleButtonModel;
			_toggleButtonModel.addEventListener("textChange", textChangeHandler);
			_toggleButtonModel.addEventListener("htmlChange", htmlChangeHandler);
			_toggleButtonModel.addEventListener("selectedChange", selectedChangeHandler);
			if (_toggleButtonModel.text !== null)
				text = _toggleButtonModel.text;
            for each( var s:Sprite in sprites )
            {
                var tf:CSSTextField = s.getChildByName("textField") as CSSTextField;
                tf.styleParent = value;
            }
            
			layoutControl();
			
			var hitArea:Shape = new Shape();
			hitArea.graphics.beginFill(0x000000);
			hitArea.graphics.drawRect(0,0,upSprite.width, upSprite.height);
			hitArea.graphics.endFill();
			
			SimpleButton(value).upState = upSprite;
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = hitArea;
			
			if (toggleButtonModel.text !== null)
				text = toggleButtonModel.text;
			if (toggleButtonModel.html !== null)
				html = toggleButtonModel.html;
		}
		
        /**
         *  @copy org.apache.royale.html.Label#text
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
		
        /**
         *  @private
         */
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
         *  @copy org.apache.royale.html.Label#html
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
		
        /**
         *  @private
         */
		public function set html(value:String):void
		{
			for each(var s:Sprite in sprites)
			{
				var tf:CSSTextField = s.getChildByName('textField') as CSSTextField;
				tf.htmlText = value;
			}
			
			layoutControl();
		}
		
		private function textChangeHandler(event:Event):void
		{
			text = toggleButtonModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = toggleButtonModel.html;
		}
		
		private var _selected:Boolean;
		
        /**
         *  @copy org.apache.royale.core.IToggleButtonModel#selected
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get selected():Boolean
		{
			return _selected;
		}
		
        /**
         *  @private
         */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			layoutControl();
			
			if( value ) {
				SimpleButton(_strand).upState = upAndSelectedSprite;
				SimpleButton(_strand).downState = downAndSelectedSprite;
				SimpleButton(_strand).overState = overAndSelectedSprite;
				
			} else {
				SimpleButton(_strand).upState = upSprite;
				SimpleButton(_strand).downState = downSprite;
				SimpleButton(_strand).overState = overSprite;
			}
		}
		
		private function selectedChangeHandler(event:Event):void
		{
			selected = toggleButtonModel.selected;
		}
		
        /**
         *  Display the icon and text label
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected function layoutControl() : void
		{
			for each(var s:Sprite in sprites)
			{
				var icon:Shape = s.getChildByName("icon") as Shape;
				var tf:CSSTextField = s.getChildByName("textField") as CSSTextField;
				
				drawCheckBox(icon);
				
				var mh:Number = Math.max(icon.height,tf.height);
				
				icon.x = 0;
				icon.y = (mh - icon.height)/2;
				
				tf.x = icon.x + icon.width + 1;
				tf.y = (mh - tf.height)/2;
			}
			
		}
		
        /**
         *  Draw the checkbox
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected function drawCheckBox(icon:Shape) : void
		{
			icon.graphics.clear();
			icon.graphics.beginFill(0xf8f8f8);
			icon.graphics.lineStyle(1,0x808080);
			icon.graphics.drawRect(0,0,10,10);
			icon.graphics.endFill();
			
			if( _toggleButtonModel.selected ) {
                icon.graphics.lineStyle(2,0);
				icon.graphics.moveTo(3,4);
				icon.graphics.lineTo(5,7);
				icon.graphics.lineTo(9,0);
			}
		}
	}
}
