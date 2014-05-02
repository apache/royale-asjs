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
package org.apache.cordova.camera
{
	public class Camera
	{
		public static var DestinationType:Object = {
			DATA_URL : 0,      // Return image as base64-encoded string
			FILE_URI : 1,      // Return image file URI
			NATIVE_URI : 2     // Return image native URI (e.g., assets-library:// on iOS or content:// on Android)
		};
		
		public static var PictureSourceType:Object = {
			PHOTOLIBRARY : 0,
			CAMERA : 1,
			SAVEDPHOTOALBUM : 2
		};
		
		public static var EncodingType:Object = {
			JPEG : 0,               // Return JPEG encoded image
			PNG : 1                 // Return PNG encoded image
		};
		
		public static var MediaType:Object = {
			PICTURE: 0,    // allow selection of still pictures only. DEFAULT. Will return format specified via DestinationType
			VIDEO: 1,      // allow selection of video only, WILL ALWAYS RETURN FILE_URI
			ALLMEDIA : 2   // allow selection from all media types
		};
		
		public static var Direction:Object = {
			BACK : 0,      // Use the back-facing camera
			FRONT : 1      // Use the front-facing camera
		};

		public function Camera()
		{
			pictureSourceType = Camera.PictureSourceType.PHOTOLIBRARY;
			destinationType = Camera.DestinationType.DATA_URL;
			mediaType = Camera.MediaType.PICTURE;
			encodingType = Camera.EncodingType.JPEG;
			direction = Camera.Direction.BACK;
		}
		
		public var pictureSourceType:int;
		public var destinationType:int;
		public var mediaType:int;
		public var encodingType:int;
		public var direction:int;
		
		public function getPicture( cameraSuccess:Function, cameraError:Function, cameraOptions:Object ) : void
		{
			// stub for JavaScript version
		}
		
		public function cleanup( cameraSuccess:Function, cameraError:Function ) : void
		{
			// stub for JavaScript version
		}
	}
}