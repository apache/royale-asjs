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
package org.apache.royale.svg
{
	import org.apache.royale.core.IBinaryImage;
	import org.apache.royale.core.IBinaryImageModel;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.IBinaryImageLoader;
	import org.apache.royale.utils.BinaryData;

 	/**
	 *  The Image class is a component that displays a bitmap. The Image uses
	 *  the following beads:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model for the Image, including the url/binary property.
	 *  org.apache.royale.core.IBeadView: constructs the visual elements of the component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class BinaryImage extends Image implements IBinaryImage
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function BinaryImage()
		{
			super();
		}
		
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IBinaryImageLoader
		 */
		override public function addedToParent():void
		{
			var c:Class = ValuesManager.valuesImpl.getValue(this, "iBinaryImageLoader");
			if (c)
			{
				var loader:IBinaryImageLoader = (new c()) as IBinaryImageLoader;
				addBead(loader);
			}
			super.addedToParent();
		}
		
		/**
		 *  The binary bitmap data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.IBinaryImageModel
		 */
		public function get binary():BinaryData
		{
			return (model as IBinaryImageModel).binary;
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IBinaryImageModel
		 */
		public function set binary(value:BinaryData):void
		{
			(model as IBinaryImageModel).binary = value;
		}
        
	}
}
