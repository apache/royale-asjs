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
package org.apache.flex.html.beads
{

	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.ValueEvent;

	COMPILE::SWF {
		import org.apache.flex.html.accessories.ToolTipBead;
	}

/**
	 *  The AccessibilityAltBead class is a bead that can be used with
	 *  any Image control. The bead places add an alt text attribute
	 *  on a image.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class AccessibilityAltBead implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function AccessibilityAltBead()
		{
		}
		
		private var _strand:IStrand;
		private var _alt:String;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.flex.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{	
			_strand = value;
			updateHost();
		}
		
		public function get alt():String
		{
			return _alt;
		}

		/**
		 *  @private
		 */
		public function set alt(value:String):void
		{
			if (value != _alt)
			{
				_alt = value;
				updateHost();
			}
		}

		private function updateHost():void
		{
			if(!_strand)
				return;

			COMPILE::SWF {
				//TODO may want to do something else on he AS side
				var toolTip:ToolTipBead = _strand.getBeadByType(ToolTipBead) as ToolTipBead;

				if (toolTip) {
                    toolTip.toolTip = _alt;
                }
			}
			
			COMPILE::JS {
                (_strand as Object).element.alt = _alt;
            }

			IEventDispatcher(_strand).dispatchEvent(new ValueEvent("altChange", alt));
				
		}
		
	}
}
