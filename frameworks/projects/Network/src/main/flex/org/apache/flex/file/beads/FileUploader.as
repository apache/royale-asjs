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
package org.apache.flex.file.beads
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.file.FileProxy;
	import org.apache.flex.net.URLBinaryLoader;
	import org.apache.flex.net.URLRequest;

	COMPILE::SWF
	{
//		import flash.net.URLRequest;
	}
	
	COMPILE::JS
	{
		import org.apache.flex.events.Event;
		import org.apache.flex.core.WrappedHTMLElement;
		import goog.events;

	}
	
	/**
	 *  Indicates that the upload operation is complete
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.9
	 */
	[Event(name="complete", type="org.apache.flex.events.Event")]
	/**
	 *  The FileUploader class is a bead which adds to FileProxy
	 *  the ability to upload files.
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.9
	 */
	public class FileUploader implements IBead
	{
		private var _strand:IStrand;
		
		/**
		 *  Upload a file to the specified url.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.9
		 */
		public function upload(url:String):void
		{
//			COMPILE::SWF
//			{
//				var flashURL:flash.net.URLRequest = new URLRequest(url.url);
//				(host.model as FileModel).fileReference.upload(flashURL);
//			}
			var binaryUploader:URLBinaryLoader = new URLBinaryLoader();
			var req:URLRequest = new URLRequest();
			req.method = "POST";
			req.data = (host.model as FileModel).blob;
			req.url = url;
			binaryUploader.addEventListener(Event.COMPLETE, completeHandler);
			binaryUploader.load(req);
		}
		
		protected function completeHandler(event:Event):void
		{
			(event.target as IEventDispatcher).removeEventListener(Event.COMPLETE, completeHandler);
			(host as IEventDispatcher).dispatchEvent(event);
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		/**
		 * @private
		 */
		protected function get host():FileProxy
		{
			return _strand as FileProxy;
		}
		
	}
}