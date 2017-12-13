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
package org.apache.royale.createjs
{
    COMPILE::SWF
    {
        import org.apache.royale.html.CheckBox;            
    }
    COMPILE::JS
    {
        import createjs.Container;
		import createjs.DisplayObject;
        import createjs.Shape;
        import createjs.Stage;
        import createjs.Text;
		
		import org.apache.royale.createjs.core.CreateJSBase;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.events.Event;
    }
	
	import org.apache.royale.core.IToggleButtonModel;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.SolidColor;
	
    COMPILE::SWF
	public class CheckBox extends org.apache.royale.html.CheckBox
	{			
		/**
		 * @private
		 */
		public function get fill():IFill
		{
			return null;
		}
		public function set fill(value:IFill):void
		{
		}
				
		/**
		 * The color of the text.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get textColor():IFill
		{
			return null;
		}
		public function set textColor(value:IFill):void
		{
		}
				
		/**
		 * The font to use for the text. Any CSS-style font name may be used.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get fontName():String
		{
			return null;
		}
		public function set fontName(value:String):void
		{
		}	
	}
    
    COMPILE::JS
    public class CheckBox extends CreateJSBase
    {
        private var checkMark:Shape;
        private var checkBoxLabel:Text;
		private var checkBackground:Shape;
        
        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {
            checkMark = new createjs.Shape(null);
            checkMark.name = 'checkmark';
            
            checkBoxLabel = new createjs.Text('checkbox', '20px Arial');
            checkBoxLabel.name = 'label';
            checkBoxLabel.textAlign = 'left';
            checkBoxLabel.textBaseline = 'middle';
			
			checkBackground = new createjs.Shape(null);
			checkBackground.name = 'checkbackground';
            
            var container:createjs.Container = new createjs.Container();
            element = container as WrappedHTMLElement;
            container.name = 'checkbox';
			container.addChild(this.checkBackground);
            container.addChild(this.checkBoxLabel);
            container.addChild(this.checkMark);
			
			checkBoxLabel.addEventListener("click", clickHandler);
			checkMark.addEventListener("click", clickHandler);
            
            this.positioner = this.element;
            
            return this.element;
        }
        
        public function get text():String
        {
            return IToggleButtonModel(model).text;   
        }
        
        public function set text(value:String):void
        {
			IToggleButtonModel(model).text = value;
			redrawShape();
        }
            
        public function get selected():Boolean
        {
            return IToggleButtonModel(model).selected;;
        }
        
        /**
         * @royaleignorecoercion createjs.Container
         */
        public function set selected(value:Boolean):void
        {
			IToggleButtonModel(model).selected = value;
            redrawShape();
			
			dispatchEvent( new org.apache.royale.events.Event("change") );
        }
		
		private var _fontName:String = "18px Arial"
		
		/**
		 * The font to use for the text. Any CSS-style font name may be used.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get fontName():String
		{
			return _fontName;
		}
		public function set fontName(value:String):void
		{
			_fontName = value;
			redrawShape();
		}
		
		/**
		 * @private
		 * @royaleignorecoercion createjs.Container
		 */
		override protected function redrawShape():void
		{
			var color:String = "black";
			if (textColor != null) {
				color = convertColorToString((textColor as SolidColor).color, 1.0);
			}
			
			var fillColor:String = "DeepSkyBlue";
			var fillAlpha:Number = 1.0;
			if (fill != null) {
				fillAlpha = (fill as SolidColor).alpha;
				fillColor = convertColorToString((fill as SolidColor).color, fillAlpha);
			}
			
			var label:createjs.Text = element as createjs.Text;
			checkBoxLabel.text = text;
			checkBoxLabel["font"] = fontName;
			checkBoxLabel["color"] = color;
			
			checkBoxLabel.x = 45;
			checkBoxLabel.y = 40 / 2;
			
			checkMark.graphics.setStrokeStyle(1);
			checkMark.graphics.beginStroke('gray');
			checkMark.graphics.beginFill(selected?fillColor:'white');
			checkMark.graphics.drawRoundRect(0, 0, 32, 32, 6);
			checkMark.graphics.endFill();
			checkMark.graphics.endStroke();
			checkMark.x = 4;
			checkMark.y = 4;
						
			var stage:Stage = checkBoxLabel.getStage();
			if (stage)
				stage.update();
		}
        
        
        /**
         * @param event The event.
         */
        private function clickHandler(event:Event):void
        {
            selected = !selected;
        }

        
    }

}
