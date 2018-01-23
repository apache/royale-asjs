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
package org.apache.royale.events
{

	[ExcludeClass]
	COMPILE::SWF
	public class ElementEvents
	{
        //--------------------------------------
        //   Static Property
        //--------------------------------------
        
        static public const elementEvents:Object = {
			'click': 1,
			'doubleClick': 1,
            'change': 1,
            'keyup': 1,
            'keydown': 1,
            'load': 1,
            'mouseOver': 1,
            'mouseOut': 1,
            'mouseUp': 1,
            'mouseDown': 1,
            'mouseMove': 1,
            'rollOver': 1,
			'rollOut': 1,
			'mouseWheel': 1
        };
	}

	COMPILE::JS
	public class ElementEvents
	{

		//--------------------------------------
		//   Static Property
		//--------------------------------------

		static public const elementEvents:Object = {
                'click': 1,
				'dblclick': 1,
                'change': 1,
                'keyup': 1,
                'keydown': 1,
                'load': 1,
				'mouseover': 1,
				'mouseout': 1,
				'mouseup': 1,
				'mousedown': 1,
				'mousemove': 1,
				'rollover': 1,
				'rollout': 1,
				'wheel': 1
			};
	}
}
