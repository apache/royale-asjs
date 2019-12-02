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
package org.apache.royale.jewel
{
	import org.apache.royale.jewel.Group;

	/**
	 *  The Card class is a container that surronds other components.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Card extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Card()
		{
			super();

            typeNames = "jewel card";
		}

        // public function get gap():Boolean
        // {
        //     return layout.gap;
        // }

        // public function set gap(value:Boolean):void
        // {
		// 	typeNames = StringUtil.removeWord(typeNames, " gap");
		// 	typeNames += " gap";

		// 	COMPILE::JS
        //     {
		// 		if (parent)
        //         	setClassName(computeFinalClassNames()); 
		// 	}

		// 	layout.gap = value;
        // }

		//protected var _shadow:Number = 0;
        /**
		 *  A boolean flag to activate "shadow-Xdp" effect selector.
		 *  Assigns variable shadow depths (0, 2, 3, 4, 6, 8, or 16) to card
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        // public function get shadow():Number
        // {
        //     return _shadow;
        // }

        // public function set shadow(value:Number):void
        // {
		// 	if (_shadow != value)
        //     {
        //         COMPILE::JS
        //         {
        //             if (value == 2 || value == 3 || value == 4 || value == 6 || value == 8 || value == 16)
        //             {
        //                 var classVal:String = "shadow-" + _shadow + "dp";
        //                 classSelectorList.remove(classVal);

        //                 classVal = "shadow-" + value + "dp";
		// 				classSelectorList.add(classVal);

        //                 _shadow = value;
        //             }
        //         }
        //     }
        // }
	}
}