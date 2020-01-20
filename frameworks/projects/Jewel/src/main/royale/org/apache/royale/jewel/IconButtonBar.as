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
	/**
	 *  The Jewel IconButtonBar class is a component that displays a set of IconButtons. The IconButtonBar
	 *  is actually a ButtonBar with an itemRenderer that produces Jewel IconButtons.
	 *  
	 *  By default buttons are equally sized, by setting `widthType` to NaN.
	 *  
	 *  The IconButtonBar uses the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model for the ButtonBar, including the dataProvider.
	 *  org.apache.royale.core.IBeadView: constructs the parts of the component.
	 *  org.apache.royale.core.IBeadController: handles input events.
	 *  org.apache.royale.core.IBeadLayout: sizes and positions the component parts.
	 *  org.apache.royale.core.IDataProviderItemRendererMapper: produces itemRenderers.
	 *  org.apache.royale.core.IItemRenderer: the class or class factory to use.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class IconButtonBar extends ButtonBar
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function IconButtonBar()
		{
			super();
		}

		private var _rightPosition:Boolean;
        /**
		 *  icon's position regarding the text content 
         *  Can be false ("left") or true ("right"). defaults to false ("left")
         *  Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get rightPosition():Boolean
        {
            return _rightPosition;
        }
        public function set rightPosition(value:Boolean):void
        {
			if (_rightPosition != value)
            {
            	_rightPosition = value;
			}
        }

		private var _iconField:String = "icon";

		/**
		 *  The name of the field within the data to use as a icon.
		 *  Defaults to "icon".
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get iconField():String
		{
			return _iconField;
		}
		public function set iconField(value:String):void
		{
			if(_iconField != value)
			{
				_iconField = value;
			}
		}

		private var _material:Boolean;
        /**
         *  Use the Material Icons
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get material():Boolean
        {
            return _material;
        }
        public function set material(value:Boolean):void
        {
            if (_material != value)
            {
                _material = value;
            }
        }
	}
}
