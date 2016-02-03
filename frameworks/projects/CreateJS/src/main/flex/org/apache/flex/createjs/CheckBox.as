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
        import org.apache.flex.html.CheckBox;            
    }
    COMPILE::JS
    {
        import createjs.Container;
        import createjs.Shape;
        import createjs.Stage;
        import createjs.Text;
        
        import org.apache.flex.createjs.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.events.Event;
    }
	
    COMPILE::AS3
	public class CheckBox extends org.apache.flex.html.CheckBox
	{	
	}
    
    COMPILE::JS
    public class CheckBox extends UIBase
    {
        private var checkMark:Shape;
        private var checkMarkBackground:Shape;
        private var checkBoxLabel:Text;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        override public function createElement():WrappedHTMLElement
        {
            checkMarkBackground = new createjs.Shape(null);
            checkMarkBackground.name = 'checkmarkbackground';
            checkMarkBackground.graphics.beginFill('red').
                drawRoundRect(0, 0, 40, 40, 8);
            
            checkMark = new createjs.Shape(null);
            checkMark.name = 'checkmark';
            checkMark.graphics.beginFill('white').drawRoundRect(0, 0, 32, 32, 6);
            checkMark.x = 4;
            checkMark.y = 4;
            checkMark.visible = false;
            
            checkBoxLabel = new createjs.Text('checkbox', '20px Arial', '#ff7700');
            checkBoxLabel.name = 'label';
            checkBoxLabel.textAlign = 'left';
            checkBoxLabel.textBaseline = 'middle';
            checkBoxLabel.x = 45;
            checkBoxLabel.y = 40 / 2;
            
            var container:createjs.Container = new createjs.Container();
            element = container as WrappedHTMLElement;
            container.name = 'checkbox';
            container.addChild(this.checkMarkBackground);
            container.addChild(this.checkBoxLabel);
            container.addChild(this.checkMark);
            container.onClick = clickHandler;
            
            this.positioner = this.element;
            
            return this.element;
        }
        
        public function get text():String
        {
            return checkBoxLabel.text;   
        }
        
        public function set text(value:String):void
        {
            checkBoxLabel.text = value;
        }
            
        public function get selected():Boolean
        {
            return checkMark.visible;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function set selected(value:Boolean):void
        {
            checkMark.visible = value;
            var stage:Stage = (element as Container).getStage();
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
