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
package org.apache.flex.createjs
{
    COMPILE::AS3
    {
        import org.apache.flex.core.ITextModel;
        import org.apache.flex.html.Button;            
    }
    COMPILE::JS
    {
        import createjs.Container;
        import createjs.Text;
        import createjs.Shape;
        import createjs.Stage;
        
        import org.apache.flex.createjs.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }

    COMPILE::AS3
	public class TextButton extends Button
	{
		public function TextButton()
		{
			super();
		}
		
		public function get text():String
		{
			return ITextModel(model).text;
		}
		public function set text(value:String):void
		{
			ITextModel(model).text = value;
		}
		
		public function get html():String
		{
			return ITextModel(model).html;
		}
		public function set html(value:String):void
		{
			ITextModel(model).html = value;
		}
				
	}
    
    COMPILE::JS
    public class TextButton extends UIBase
    {
        private var buttonBackground:Shape;
        private var buttonLabel:Text;
        private var button:Container;
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        override public function createElement():WrappedHTMLElement
        {
            buttonBackground = new createjs.Shape(null);
            buttonBackground.name = 'background';
            buttonBackground.graphics.beginFill('red').
                drawRoundRect(0, 0, 200, 60, 10);
            
            buttonLabel = new createjs.Text('button', 'bold 24px Arial',
                '#FFFFFF');
            buttonLabel.name = 'label';
            buttonLabel.textAlign = 'center';
            buttonLabel.textBaseline = 'middle';
            buttonLabel.x = 200 / 2;
            buttonLabel.y = 60 / 2;
            
            button = new createjs.Container();
            button.name = 'button';
            button.x = 50;
            button.y = 25;
            button.addChild(buttonBackground);
            button.addChild(buttonLabel);
            
            positioner = element = button as WrappedHTMLElement;
            element.flexjs_wrapper = this;
            return element;
        }
        
        
        /**
         * @flexjsignorecoercion createjs.Text
         */
        public function get text():String
        {
            return buttonLabel.text;
        }
        
        /**
         * @flexjsignorecoercion createjs.Text
         */
        public function set text(value:String):void
        {
            buttonLabel.text = value;
        }
    }
}
