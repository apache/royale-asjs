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
	import org.apache.royale.core.IBinaryImageModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.utils.BinaryData;
	
	/**
	 *  The ImageModel class bead defines the data associated with an org.apache.royale.html.Image
	 *  component, namely the source of the image.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class BinaryImageModel extends ImageModel implements IBinaryImageModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7
		 */
		public function BinaryImageModel()
		{
			super();
		}

		private var _binary:BinaryData;
		
		override public function set url(value:String):void
		{
			if (value && value != url)
				_binary = null;

			super.url = value;
		}

		/**
		 *  The BinaryData of the image.
		 *  This is used to set the image using binary content retrieved using HTTP requests or File APIs.
		 * 
		 *  @copy org.apache.royale.core.IImageModel#binary
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get binary():BinaryData
		{
			return _binary;
		}
		public function set binary(value:BinaryData):void
		{
			if (value != _binary) {
				_binary = value;
				if(value)
					_url = "";
				dispatchEvent( new Event("binaryChanged") );
			}
		}
	}
}
