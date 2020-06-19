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
    import org.apache.royale.core.StyledUIBase;
    
	/**
	 *  The SimpleLoader class is widget used to show some progressing.
     *  It could be while loading dome data, or waiting for interface to complete 
     *  some task.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class SimpleLoader extends StyledUIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function SimpleLoader()
		{
			super();

            typeNames = "jewel loader segment";
			
		}
		
		COMPILE::JS
		private var animation:Animation;

		private var _indeterminate:Boolean;
		/**
		 * stop the animation to indicate load end
		 */
		public function get start():Boolean
		{
			return _indeterminate;
		}
		/**
		 * start the animation to indicate a loading state
		 */
		public function set indeterminate(value:Boolean):void
		{
			if(_indeterminate !== value)
			{
				_indeterminate = value;

				if(_indeterminate)
				{
					COMPILE::JS
					{
					if(!animation)
					{
						var timings:Object = {
							"duration": 1000, 
							"iterations": Infinity
						}						
						animation = element["animate"](
							[//keyframes
								{ "transform": "rotate(0deg)"},
								{ "transform": "rotate(360deg)"}]
							,
								timings
							);
					} else
						animation.play();
					}
				}
				else
				{
					COMPILE::JS
					{
					if(animation)
						animation.pause(); 
					}
				}
			}
		}
	}
}