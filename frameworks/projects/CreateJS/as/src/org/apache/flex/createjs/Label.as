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
        import org.apache.flex.html.Label;            
    }

    COMPILE::JS
    {
        import createjs.Text;
        import createjs.Stage;
        
        import org.apache.flex.createjs.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
    COMPILE::AS3
	public class Label extends org.apache.flex.html.Label
	{
		
	}
    
    COMPILE::JS
    public class Label extends UIBase
    {
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        override public function createElement():WrappedHTMLElement
        {
            var text:Text = new Text('default text', '20px Arial', '#ff7700');
            text.x = 0;
            text.y = 20;
            text.textBaseline = 'alphabetic';
            
            positioner = element = text as WrappedHTMLElement;
            return element;
        }
        
        
        /**
         * @flexjsignorecoercion createjs.Text
         */
        public function get text():String
        {
            return (element as Text).text;
        }
        
        /**
         * @flexjsignorecoercion createjs.Text
         */
        public function set text(value:String):void
        {
            var text:Text = element as Text;
            text.text = value;
            var stage:Stage = text.getStage();
            if (stage)
                stage.update();
        }
        
    }
}
