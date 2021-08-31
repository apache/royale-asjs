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
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.IStrand;

	/**
	 *  SelectableBead changes selectability of text controls such as Label
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class SelectableBead extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function SelectableBead()
		{
		}
		
		private var _selectable:Boolean;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			updateHost();
		}
		
		public function set selectable(value:Boolean):void
		{
			if (value != _selectable)
			{
				_selectable = value;
				if (_strand)
				{
					updateHost();
				}
			}
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		private function updateHost():void
		{
			COMPILE::JS
			{
				(_strand as IRenderedObject).element.style["user-select"] = _selectable ? "auto" : "none";
				(_strand as IRenderedObject).element.style["-webkit-touch-callout"] = _selectable ? "auto" : "none";
				(_strand as IRenderedObject).element.style["-webkit-user-select"] = _selectable ? "auto" : "none";
				(_strand as IRenderedObject).element.style["-moz-user-select"] = _selectable ? "auto" : "none";
				(_strand as IRenderedObject).element.style["-ms-user-select"] = _selectable ? "auto" : "none";
			}
		}
	}
}
