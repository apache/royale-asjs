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
package org.apache.royale.jewel.beads.controls.button
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.supportClasses.IInputButton;
	import org.apache.royale.utils.css.addDynamicSelector;
	
    /**
     *  The InputButtonSize class implements input button size for controls
	 *  like CheckBox or RadioButton that need to size the selectable button part.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class InputButtonSize implements IBead
	{
		public static const INPUTBUTTON_DEFAULT_SIZE:Number = 24;

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function InputButtonSize()
		{	
		}

		private var _width:Number;
        /**
         *  Input button width
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        [Bindable("inputButtonWidthChange")]
        public function get width():Number
		{
			return _width;
		}
        public function set width(value:Number):void
		{
            if(_width != value)
            {
			    _width = value;
            }
		}
        
        private var _height:Number;
        /**
         *  Input button height
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        [Bindable("inputButtonHeightChange")]
        public function get height():Number
		{
			return _height;
		}
        public function set height(value:Number):void
		{
            if(_height != value)
            {
			    _height = value;
            }
		}

		/**
		 * The IInputButton control that host the inputButton
		 */
		private var host:IInputButton;
		
		/**
		 * The input button
		 */
		COMPILE::JS
        private var inputButton:HTMLInputElement;

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function set strand(value:IStrand):void
		{
			host = value as IInputButton;

			COMPILE::JS
			{
			inputButton = host.inputButton;

			IEventDispatcher(host).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(host).addEventListener("heightChanged",sizeChangeHandler);
            IEventDispatcher(host).addEventListener("sizeChanged",sizeChangeHandler);

			// always run size change since there are no size change events
			sizeChangeHandler(null);
			}
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.jewel.CheckBox
		 */
		COMPILE::JS
		private function sizeChangeHandler(event:Event):void
		{
			var ruleName:String;
			var beforeSelector:String = "";
			if(width || height) {
				ruleName = "inpbtn" + ((new Date()).getTime() + "-" + Math.floor(Math.random()*1000));
				(host as StyledUIBase).className = ruleName;
			}
			
			if(width) {
				inputButton.style.width = width + "px";
				beforeSelector += "width: "+ width +"px;";
			} 
			else {
				inputButton.style.width = INPUTBUTTON_DEFAULT_SIZE + "px";
				beforeSelector += "width: "+ (INPUTBUTTON_DEFAULT_SIZE - 2) +"px;";
			}

			if(height) {
				inputButton.style.height = height + "px";
				beforeSelector += "height: "+ height +"px;";
			} 
			else {
				inputButton.style.height = INPUTBUTTON_DEFAULT_SIZE + "px";
				beforeSelector += "height: "+ (INPUTBUTTON_DEFAULT_SIZE - 2) +"px;";
			}

			if(width || height) {
				addDynamicSelector(".jewel." + ruleName + " input+span::before" , beforeSelector);
				addDynamicSelector(".jewel." + ruleName + " input+span::after" , beforeSelector);
			}

			// first reads
			//var widthToContent:Boolean = (input as UIBase).isWidthSizedToContent();
			// trace("widthToContent:" + widthToContent);
			// var inputWidth:String = input.style.width + "px";
			// var inputHeight:String = input.style.height + "px";

			// var strandWidth:Number;
			// if (!widthToContent)
			// {
			// 	strandWidth = (_strand as UIBase).width;
			// }
			
			// input.x = 0;
			// input.y = 0;
			// if (!widthToContent)
			// 		input.width = strandWidth
		}
	}
}
