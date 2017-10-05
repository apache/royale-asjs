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
package org.apache.royale.cordova
{
	COMPILE::SWF
	{
		import flash.display.BitmapData;
		import flash.display.DisplayObject;
		import flash.display.DisplayObjectContainer;
		import flash.display.Sprite;
		import flash.events.ActivityEvent;
		import flash.events.KeyboardEvent;
		import flash.events.MouseEvent;
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.geom.Rectangle;
		import flash.media.Camera;
		import flash.media.Video;
		import flash.ui.Keyboard;
		import flash.utils.ByteArray;
		
		import org.apache.royale.utils.PNGEncoder;
	}
		
	/**
	 * The Camera class implements the Cordova Camera
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 * @royalecordovaplugin cordova-plugin-camera
	 * @royaleignorecoercion FileEntry
	 * @royaleignorecoercion FileWriter
	 * @royaleignorecoercion window
     * @royaleignorecoercion Blob
	 */
	COMPILE::JS
	public class Camera
	{		
		public function Camera()
		{
		}
		
		public function capturePhoto(onPhotoDataSuccess:Function, onFail:Function):void
		{
			// Take picture using device camera and retrieve image as URI
			navigator['camera'].getPicture(onPhotoDataSuccess, onFail, { quality: 50,
				destinationType: navigator['camera'].DestinationType.FILE_URI });
		}
		
		public function getPhotoFromLibrary(onPhotoURISuccess:Function, onFail:Function):void
		{
			// Retrieve image file location from specified source
			navigator['camera'].getPicture(onPhotoURISuccess, onFail, { quality: 50,
				destinationType: navigator['camera'].DestinationType.FILE_URI,
				sourceType: navigator['camera'].PictureSourceType.PHOTOLIBRARY });
		}
		
		public function cleanup( cameraSuccess:Function, cameraError:Function ) : void
		{
			navigator["camera"].cleanup();
		}
	}
	
	[Mixin]
	COMPILE::SWF
	public class Camera
	{
		private var cameraSuccess:Function;
		private var cameraError:Function;
		private var ui:Sprite;
		private var camera:flash.media.Camera;
		
		private static var root:DisplayObjectContainer;
		
		public static function init(r:DisplayObjectContainer):void
		{
			root = r;		
		}
		
		public function Camera()
		{
		}
		
		public function capturePhoto(onPhotoDataSuccess:Function, onFail:Function):void
		{
			this.cameraSuccess = onPhotoDataSuccess;
			this.cameraError = onFail;
			
			camera = flash.media.Camera.getCamera();
			
			if (camera != null) {
				ui = new Sprite();
				var video:Video = new Video(camera.width * 2, camera.height * 2);
				video.attachCamera(camera);
				ui.addChild(video);
				root.addChild(ui);
				ui.addEventListener(MouseEvent.CLICK, mouseClickHandler);
				ui.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			} else {
				trace("You need a camera.");
			}
		}
		
		public function getPhotoFromLibrary(onPhotoURISuccess:Function, onFail:Function):void
		{
			// TBD
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			savePicture();
			root.removeChild(ui);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
				root.removeChild(ui);
			else if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.SPACE)
			{
				savePicture();
				root.removeChild(ui);
			}
		}
		
		private function savePicture():void
		{
			var f:File = File.createTempFile();
			var bd:BitmapData = new BitmapData(camera.width, camera.height, false);
			var pix:ByteArray = new ByteArray();
			var rect:Rectangle = new Rectangle(0, 0, camera.width, camera.height);
			camera.copyToByteArray(rect, pix);
			pix.position = 0;
			bd.setPixels(rect, pix);
			var png:PNGEncoder = new PNGEncoder();
			var ba:ByteArray = png.encode(bd);
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			cameraSuccess(f.url);
		}
		
		public function cleanup( cameraSuccess:Function, cameraError:Function ) : void
		{
			// not required for SWF version
		}
	}
}
