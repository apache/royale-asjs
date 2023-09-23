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
package org.apache.royale.html.accessories
{
	COMPILE::JS
	{
		import goog.events.BrowserEvent;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IRenderedObject;
	
	/**
	 *  The RestrictToColorTextInputBead class is a specialty bead that can be used with
	 *  any TextInput control. The bead prevents characters that will not yield a hexa color from being 
	 *  entered into the text input area.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	public class RestrictToColorTextInputBead extends Bead
	{
		private var _validValue:String = "";
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function RestrictToColorTextInputBead()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				var host:IRenderedObject = _strand as IRenderedObject;
				host.element.addEventListener("input", validateInput, false);
			}
		}
		
        
		/**
		 *  @royaleignorecoercion HTMLInputElement 
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		COMPILE::JS
		private function validateInput(event:BrowserEvent):void
		{            
			var host:IRenderedObject = _strand as IRenderedObject;
			var data:String = (host.element as HTMLInputElement).value;
			
			if (data != null)
			{
				var regex:RegExp = new RegExp("^[0-9a-fA-F]{0,6}$");
				if (regex.test(data)) 
				{
					_validValue = data;
				} else
				{
					event["returnValue"] = false;
					if (event.preventDefault) event.preventDefault();
					(host.element as HTMLInputElement).value = _validValue;                    
				}
			}
		}
	}
}
