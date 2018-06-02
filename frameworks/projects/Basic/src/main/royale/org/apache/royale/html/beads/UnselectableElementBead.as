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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.IStrand;

	/**
	 *  UnselectableElement bead prevents from text selection of html element
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class UnselectableElementBead implements IBead
	{
		/**
		 * @royaleignorecoercion HTMLStyleElement
		 */
		private static function insertRule():void
		{
			// only do this once...
			if(ruleInserted)
				return;
			ruleInserted = true;
			// Inject a new css selector
			COMPILE::JS
			{
				var style:HTMLStyleElement = document.createElement('style') as HTMLStyleElement;
				style.type = 'text/css';
				style.innerHTML = '.unselectable {-moz-user-select: none;-webkit-user-select: none;-ms-user-select: none;user-select: none;}';
				document.getElementsByTagName('head')[0].appendChild(style);
			}

		}
		private static var ruleInserted:Boolean;

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function UnselectableElementBead()
		{
		}

        private var _strand:IStrand;

        /**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function set strand(value:IStrand):void
		{
			insertRule();
			_strand = value;

			COMPILE::JS
			{
				var host:IUIBase = value as IUIBase;
				host.element.classList.add("unselectable");
			}
		}
	}
}
