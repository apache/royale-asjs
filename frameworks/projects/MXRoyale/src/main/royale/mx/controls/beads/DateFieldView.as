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
    COMPILE::SWF
    {
        import flash.display.Sprite;
    }
    import org.apache.royale.html.Button;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ITextInput;
    import org.apache.royale.html.beads.DateFieldView;
    import mx.controls.TextInput;
	
    /**
     *  The NumericStepperView class overrides the Basic
     *  NumericStepperView and sets default sizes to better 
     *  emulate Flex.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DateFieldView extends org.apache.royale.html.beads.DateFieldView
	{
        public function setFocus():void
        {
            COMPILE::SWF
            {
                var host:Sprite = getHost() as Sprite;
                host.stage.focus = host;
            }
        }
        
        override public function set strand(value:IStrand):void
        {
            _textInput = new TextInput();
            COMPILE::JS
            {
                (_textInput as TextInput).isAbsolute = false;
            }
            super.strand = value;
        }
        
        public function set textInputField(value:Object):void
        {
            _textInput = value as ITextInput;
        }

	}
}
