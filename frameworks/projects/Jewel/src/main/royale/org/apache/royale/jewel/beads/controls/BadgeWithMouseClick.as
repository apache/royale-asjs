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
package org.apache.royale.jewel.beads.controls
{
	import org.apache.royale.jewel.Label;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.beads.controls.Badge;

	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

	/**
	 *  The Badge class provides a small status descriptors for UI elements.
	 *
	 *  A Badge is an onscreen notification element consists of a small circle,
     *  typically containing a number or other characters, that appears in
     *  proximity to another object
	 *
	 *  The BadgeWithMouseClick class is a Badge extension that dispatches the MouseClick Event.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class BadgeWithMouseClick extends org.apache.royale.jewel.beads.controls.Badge
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function BadgeWithMouseClick()
		{
			super();
		}
		/**
		 * used to create the badge ui element
		 * that will be a Label
		 */
		override protected function createBadge():Label
		{
			var tmpbadge:Label = super.createBadge();

			tmpbadge.addEventListener("click", function():void{
				dispatchEvent(new MouseEvent("click"));
			});
			return tmpbadge;
		}

	}

}
