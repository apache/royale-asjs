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
package org.apache.royale.html.beads.models
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IColorModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
		
    /**
     *  The ColorModel class is the most basic data model for a
     *  component that displays or edits a color. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	public class ColorModel extends EventDispatcher implements IBead, IColorModel
	{
		private var _color:uint;
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function ColorModel()
		{
		}
		
		public function set strand(value:IStrand):void
		{
		}

        [Bindable("change")]
        /**
         *  @copy org.apache.royale.core.IColorModel#color
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function get color():Number
		{
			return _color;
		}
		
        /**
         *  @private
         */
		public function set color(value:Number):void
		{
			_color = value;
			dispatchEvent(new Event("change"));
		}
	}
}
