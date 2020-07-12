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
	import org.apache.royale.core.IImageModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.DispatcherBead;
	
	/**
	 *  The ImageModel class bead defines the data associated with an org.apache.royale.html.Image
	 *  component, namely the source of the image.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ImageModel extends DispatcherBead implements IImageModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ImageModel()
		{
			super();
		}
		
		protected var _url:String;
		
		/**
		 *  The source of the image.
		 * 
		 *  @copy org.apache.royale.core.IImageModel#source
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			if (value != _url) {
				_url = value;
				dispatchEvent( new Event("urlChanged") );
			}
		}
	}
}
