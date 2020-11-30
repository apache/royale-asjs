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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.StyleChangeEvent;

    /**
     *  The SingleLineBorderWithChangeListenerBead adds the ability to react to
	 *  changes in border style at runtime.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SingleLineBorderWithChangeListenerBead extends SingleLineBorderBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function SingleLineBorderWithChangeListenerBead()
		{
			super();
		}
		
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
			listenOnStrand(StyleChangeEvent.STYLE_CHANGE, handleStyleChange);
		}
		
		/**
		 * @private
		 */
		private function handleStyleChange(event:StyleChangeEvent):void
		{			
			// see if border style needs to be converted into an array
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(_strand, "border");
			if (borderStyles is String) {
				// it may be just "solid"
				var list:Array = String(borderStyles).split(" ");
				if (list.length == 3) {
					// set it on the strand's style (IValuesImpl does not have setStyle exposed).
					var host:IStyleableObject = _strand as IStyleableObject;
					// setting this will trigger this event listener again
					host.style.border = list;
				}
			} else {
				changeHandler(null);
			}
		}
	}
}
