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
package org.apache.royale.jewel.beads.controls.checkbox
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.CheckBox;
	import org.apache.royale.utils.css.addDynamicSelector;
	
    /**
     *  The CheckBoxSize class
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class CheckBoxSize implements IBead
	{
		public static const CHECK_DEFAULT_SIZE:Number = 22;

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function CheckBoxSize()
		{	
		}

		private var _checkWidth:Number;
        /**
         *  Check Width
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        [Bindable("checkWidthChange")]
        public function get checkWidth():Number
		{
			return _checkWidth;
		}
        public function set checkWidth(value:Number):void
		{
            if(_checkWidth != value)
            {
			    _checkWidth = value;
            }
		}
        
        private var _checkHeight:Number;
        /**
         *  Check Height
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        [Bindable("checkHeightChange")]
        public function get checkHeight():Number
		{
			return _checkHeight;
		}
        public function set checkHeight(value:Number):void
		{
            if(_checkHeight != value)
            {
			    _checkHeight = value;
            }
		}

		/**
		 * the _strand
		 */
		private var checkbox:CheckBox;
		
		COMPILE::JS
        private var input:HTMLInputElement;

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
			checkbox = value as CheckBox;

			COMPILE::JS
			{
			input = checkbox.input;

			checkbox.addEventListener("widthChanged",sizeChangeHandler);
			checkbox.addEventListener("heightChanged",sizeChangeHandler);
            checkbox.addEventListener("sizeChanged",sizeChangeHandler);

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
			if(checkWidth || checkHeight) {
				ruleName = "chkb" + ((new Date()).getTime() + "-" + Math.floor(Math.random()*1000));
				checkbox.className = ruleName;
			}
			
			if(checkWidth) {
				input.style.width = checkWidth + "px";
				beforeSelector += "width: "+ checkWidth +"px;";
			} 
			else {
				input.style.width = CHECK_DEFAULT_SIZE + "px";
				beforeSelector += "width: "+ CHECK_DEFAULT_SIZE +"px;";
			}

			if(checkHeight) {
				input.style.height = checkHeight + "px";
				beforeSelector += "height: "+ checkHeight +"px;";
			} 
			else {
				input.style.height = CHECK_DEFAULT_SIZE + "px";
				beforeSelector += "height: "+ CHECK_DEFAULT_SIZE +"px;";
			}

			if(checkWidth || checkHeight) {
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
