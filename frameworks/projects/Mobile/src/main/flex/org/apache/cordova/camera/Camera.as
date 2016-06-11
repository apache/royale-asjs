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
        
        import org.apache.flex.utils.PNGEncoder;
    }
    
	[Mixin]
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

        COMPILE::SWF
		private static var root:DisplayObjectContainer;
		
        COMPILE::SWF
		public static function init(r:DisplayObjectContainer):void
		{
			root = r;		
		}
		
		public function Camera()
		{
			pictureSourceType = org.apache.cordova.camera.Camera.PictureSourceType.PHOTOLIBRARY;
			destinationType = org.apache.cordova.camera.Camera.DestinationType.DATA_URL;
			mediaType = org.apache.cordova.camera.Camera.MediaType.PICTURE;
			encodingType = org.apache.cordova.camera.Camera.EncodingType.JPEG;
			direction = org.apache.cordova.camera.Camera.Direction.BACK;
		}
		
		public var pictureSourceType:int;
		public var destinationType:int;
		public var mediaType:int;
		public var encodingType:int;
		public var direction:int;
		
		private var cameraSuccess:Function;
		private var cameraError:Function;
        COMPILE::SWF
		private var ui:Sprite;
        COMPILE::SWF
		private var camera:flash.media.Camera;
		
		public function getPicture( cameraSuccess:Function, cameraError:Function, cameraOptions:Object ) : void
		{
            COMPILE::SWF
            {
                this.cameraSuccess = cameraSuccess;
                this.cameraError = cameraError;
                
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
            COMPILE::JS
            {
                // TODO: (aharui) Cordova externs
                navigator["camera"].getPicture(cameraSuccess, cameraError, cameraOptions);
            }
		}
		
        COMPILE::SWF
		private function mouseClickHandler(event:MouseEvent):void
		{
			savePicture();
			root.removeChild(ui);
		}
		
        COMPILE::SWF
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

        COMPILE::SWF
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
            // no cleanup required in Flash
            COMPILE::JS
            {
                navigator["camera"].cleanup();                
            }
		}
	}
}
