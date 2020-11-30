///////////////////////////////////////////////////////////////////////////////
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
	COMPILE::JS {
		import org.apache.royale.core.WrappedHTMLElement;
	}
	
	/**
	 *  The StyleInheritanceWithObserverBead extends StyleInheritace and makes
	 *  sure that new descendants inherit as well.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 9.3
	 */
	public class StyleInheritanceWithObserverBead extends StyleInheritanceBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 9.3
		 */
		public function StyleInheritanceWithObserverBead()
		{
			super();
		}
		
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 9.3
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			COMPILE::JS {
				var observer:MutationObserver = new MutationObserver(mutationDetected);
				observer.observe(hostElement, {'childList': true, 'subtree': true});
			}
		}
		
		/**
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 *  @royaleignorecoercion MutationRecord
		 *  @royaleignorecoercion NodeList
		 */
		COMPILE::JS
		private function mutationDetected(mutationsList:Array):void
		{
			for (var j:int = 0; j < mutationsList.length; j++)
			{
				var mutationRecord:MutationRecord = mutationsList[j] as MutationRecord;
				var addedElements:NodeList = mutationRecord.addedNodes as NodeList;
				for (var i:int = 0; i < addedElements.length; i++)
				{
					var addedElement:WrappedHTMLElement = addedElements[i] as WrappedHTMLElement;
					addedElement.style[styleName] = 'inherit';
				}
			}
		}

	}
}
