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

package spark.components.supportClasses
{
	import spark.components.Button;
	
    /**
	 */ 
	public class DropDownListButton extends Button
	{
		
		private static var instanceCounter:int = 0;
		
		/**
		 *  Constructor.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function DropDownListButton()
		{
			super();
			instanceId = instanceCounter.toString();
			instanceCounter++;
		}
		
		private var instanceId:String;
		
        override public function setActualSize(w:Number, h:Number):void
        {
            super.setActualSize(w, h);
            COMPILE::JS
            {
                updateSkin(w, h);
            }
        }
        
        COMPILE::JS
        override public function set label(value:String):void
        {
            super.label = value;
            updateSkin(width, height);
        }
        
        COMPILE::JS
        private function updateSkin(w:Number, h:Number):void
        {
			var clipid:String = "txtClip" + instanceId;
			if (h < 4) return;
            element.innerHTML = '<svg width="' + w + 'px" height="' +
                h + 'px" xmlns="http://www.w3.org/2000/svg"><clipPath id="' + clipid + '"><rect x="0" y="0" height="' + h + 
				'px" width="' + (w - 29) + 'px"/></clipPath><text y="3px" clip-path="url(#' + clipid + ')">' +
                label + '</text><style><![CDATA[' +
                'text{ dominant-baseline: hanging;' +
                /*    font: 12px Verdana, Helvetica, Arial, sans-serif;*/
                '}]]></style><rect x="' +
                (w - 26) + 'px" width="1px" height="' + (h - 4) + 'px"/><path d="M' +
                (w - 21) + ',5 L ' + (w - 13) + ',5 L ' +
                (w - 17) + ',12 L ' + (w - 21) + ',5"</path></svg>';    
            
        }
	}
}