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
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IToggleButtonModel;
    import org.apache.flex.core.StyleableCSSTextField;
    import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
    import org.apache.flex.utils.CSSUtils;
	
    /**
     *  The CSSContentAndTextToggleButtonView class is the default view for
     *  the org.apache.flex.html.CheckBox and RadioButton classes.
     *  It supports CSS content property for the
     *  icon.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class CSSContentAndTextToggleButtonView extends BeadViewBase implements IBeadView
	{
        /**
         *  map of pseudo states.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        private static var statesMap:Object = {
            "upSprite": null,
            "downSprite": "active",
            "overSprite": "hover",
            "upAndSelectedSprite": "checked",
            "downAndSelectedSprite": "checked",
            "overAndSelectedSprite": "checked"
        }
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CSSContentAndTextToggleButtonView()
		{
            for (var p:String in statesMap)
            {
                var s:Sprite = new Sprite();
                sprites.push(s);
                this[p] = s;
                
				var tf:CSSTextField = new CSSTextField();
				tf.type = TextFieldType.DYNAMIC;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.name = "textField";
                tf.parentHandlesPadding = true;
				var icon:StyleableCSSTextField = new StyleableCSSTextField();
				icon.name = "icon";
                icon.className = "icon-checked";
                icon.styleState = statesMap[p];
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
		
		private var sprites:Array = [];
		
		private var _toggleButtonModel:IToggleButtonModel;

        // TODO: Can we remove this?
		private function get toggleButtonModel() : IToggleButtonModel
		{
			return _toggleButtonModel;
		}
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.html.Label#text
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
                tf.styleParent = _strand;
				tf.text = value;
			}
			
			layoutControl();
		}
		
        /**
         *  @copy org.apache.flex.html.Label#html
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.IToggleButtonModel#selected
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
         */
		protected function layoutControl() : void
		{
            // TODO: Layout using descendant selectors (.checkbox .icons)
			for (var p:String in statesMap)
			{
                var s:Sprite = this[p];
                var state:String = statesMap[p];
				var icon:StyleableCSSTextField = s.getChildByName("icon") as StyleableCSSTextField;
                icon.autoSize = TextFieldAutoSize.LEFT;
				var tf:CSSTextField = s.getChildByName("textField") as CSSTextField;
				
                icon.CSSParent = _strand;
                var content:String = ValuesManager.valuesImpl.getValue(_strand, "content", state);
                if (content != null)
                    icon.text = content;
				var mh:Number = Math.max(icon.height,tf.height);
				
                var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding", state);
                var paddingLeft:Object = ValuesManager.valuesImpl.getValue(_strand,"padding-left", state);
                icon.x = CSSUtils.getLeftValue(paddingLeft, padding, s.width);
				icon.y = (mh - icon.height)/2;
				
				tf.x = icon.x + icon.width + 1;
				tf.y = (mh - tf.height)/2;
			}
			
		}
	}
}
