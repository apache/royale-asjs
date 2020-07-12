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
	COMPILE::JS {
		import org.apache.royale.events.IEventDispatcher;
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.Bead;
	
	/**
	 *  The StyleInheritanceBead class forces descendadants of an IStylableObject to inherit a style
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 9.3
	 */
	public class StyleInheritanceBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 9.3
		 */
		public function StyleInheritanceBead()
		{
		}
		
		private var _styleName:String;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 9.3
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			COMPILE::JS 
			{
				listenOnStrand('initComplete', initCompleteHandler);
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */	
		COMPILE::JS
		protected function get hostElement():WrappedHTMLElement
		{
			return (_strand as IRenderedObject).element;
		}
		
		COMPILE::JS
		protected function initCompleteHandler(e:Event):void
		{
			forceInheritanceOnDescendants();
		}
		
		/**
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		private function forceInheritanceOnDescendants():void
		{
			var elements:NodeList = hostElement.querySelectorAll("*");
			for (var i:int = 0; i < elements.length; i++)
			{
				var htmlElement:WrappedHTMLElement = elements[i] as WrappedHTMLElement;
				if (htmlElement)
				{
					htmlElement.style[styleName] = "inherit";
				}
			}			
		}
		
		/**
		 *  The name of the style that is to be inherited.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 9.3
		 */
		public function get styleName():String
		{
			return _styleName;
		}
		
		public function set styleName(value:String):void
		{
			_styleName = value;
		}
	}
}
