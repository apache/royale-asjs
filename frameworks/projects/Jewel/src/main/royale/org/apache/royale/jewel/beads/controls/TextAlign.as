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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	
	/**
	 *  The TextAlign bead class is a specialty bead that make text align left, right or center.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TextAlign implements IBead
	{
		public static const LEFT:String = "left";
        public static const RIGHT:String = "right";
        public static const CENTER:String = "center";

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TextAlign()
		{
		}

		private var _align:String = LEFT;
		private var oldValue:String;

        /**
		 *  Add or remove align text class selectors. Possible values are:
		 *  left - alignTextLeft
		 *  right - alignTextRight
		 *  center - alignTextCenter
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get align():String
		{
				return _align;
		}

    	[Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
		public function set align(value:String):void
		{
			if(_align !== value)
            {
				oldValue = _align;
				_align = value;
                updateHost();
			}
		}

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			updateHost();
		}

		private function updateHost():void
		{
			var host:UIBase = _strand as UIBase;

			if (host)
            {
				COMPILE::JS
				{
					if(oldValue == LEFT)
						host.element.classList.remove("alignTextLeft");
					if(oldValue == RIGHT)
						host.element.classList.remove("alignTextRight");
					if(oldValue == CENTER)
						host.element.classList.remove("alignTextCenter");
					
					if(_align == LEFT)
						host.element.classList.add("alignTextLeft");
					if(_align == RIGHT)
						host.element.classList.add("alignTextRight");
					if(_align == CENTER)
						host.element.classList.add("alignTextCenter");
				}
            }
		}
	}
}
