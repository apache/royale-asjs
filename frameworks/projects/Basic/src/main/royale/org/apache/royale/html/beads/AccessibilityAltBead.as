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

	COMPILE::SWF {
		import org.apache.royale.html.accessories.ToolTipBead;
	}

	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.utils.sendEvent;
	import org.apache.royale.utils.sendStrandEvent;


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
	public class AccessibilityAltBead extends Bead
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
		
		private var _alt:String;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		override public function set strand(value:IStrand):void
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
		/**
     * @royaleignorecoercion Object
		 */
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

			sendStrandEvent(_strand,new ValueEvent("altChange", alt));
				
		}
		
	}
}
