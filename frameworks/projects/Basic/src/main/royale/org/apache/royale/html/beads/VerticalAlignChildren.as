////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
    import org.apache.royale.events.ValueEvent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.Bead;

	/**
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 * 
	 * VerticalAlignChildren is a bead for groups and containers which specifiy the alignment property of the children.
	 * Alignment can be any of the valid css properties for vertical-align
	 * see https://developer.mozilla.org/en-US/docs/Web/CSS/vertical-align
	 */
    public class VerticalAlignChildren extends Bead
    {
		public function VerticalAlignChildren()
		{
				
		}
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			listenOnStrand("childrenAdded",setAlignment);
		}
		private var _alignment:String;

		/**
		 *  The alignment of the children
		 * Alignment can be any of the valid css properties for vertical-align
		 * see https://developer.mozilla.org/en-US/docs/Web/CSS/vertical-align
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get alignment():String
		{
			return _alignment;
		}

		public function set alignment(value:String):void
		{
			_alignment = value;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.IParent
		 */
		private function setAlignment(ev:ValueEvent):void{
			if(_alignment)
			{
				if(ev && ev.value){
					COMPILE::JS
					{
						(ev.value as IUIBase).element.style.verticalAlign = _alignment;
					}
				} else {
					COMPILE::JS
					{
						var host:IParent = _strand as IParent;
						var len:int = host.numElements;
						for(var i:int = 0; i<len;i++)
						{
							host.getElementAt(i).element.style.verticalAlign = _alignment;
						}
					}
				}
			}
		}
	}
}