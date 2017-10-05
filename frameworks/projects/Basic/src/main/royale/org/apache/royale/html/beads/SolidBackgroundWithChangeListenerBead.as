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
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.StyleChangeEvent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.beads.SolidBackgroundBead;
	
	/**
	 * Same as SolidBackgroundBead except it listens for StyleChangeEvent events
	 * and reacts by refreshing the background of its strand.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 */
	public class SolidBackgroundWithChangeListenerBead extends SolidBackgroundBead
	{
		/**
		 * Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function SolidBackgroundWithChangeListenerBead()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			IEventDispatcher(value).addEventListener(StyleChangeEvent.STYLE_CHANGE, handleStyleChange);

		}
		
		/**
		 * @private
		 */
		private function handleStyleChange(event:StyleChangeEvent):void
		{
			setupStyle();
			changeHandler(null);
		}
	}
}
