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
package org.apache.royale.jewel.supportClasses.card
{
	import org.apache.royale.jewel.Card;
	import org.apache.royale.jewel.VContainer;

	/**
	 *  The CardExpandedContent class is a container that expand inner content
	 *  removing paddings. This could be convinient for content that needs to
	 *  avoid gaps with the surronding container.
	 * 
	 *  For example a Jewel TabBar or Navigation that needs to fill 
	 *  all the available space.
	 *  
	 * 	Content are placed vertically by default.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class CardExpandedContent extends VContainer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function CardExpandedContent()
		{
			super();

			typeNames = "card-expanded-content";
		}
		
		/**
		 *  This container means Card structure is complex, so we remove Card's simple style
		 *  that is set by default on the Card
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			if(parent is Card)
			{
				var parentCard:Card = parent as Card;
				parentCard.gap = 0;
				parentCard.removeClass("simple");
			}
		}
	}
}
