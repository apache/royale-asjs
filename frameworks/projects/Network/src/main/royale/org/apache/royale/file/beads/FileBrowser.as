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
package org.apache.royale.file.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.file.FileProxy;
	import org.apache.royale.file.IFileModel;

	COMPILE::SWF 
	{
		import flash.net.FileReference;
		import flash.events.Event;
	}

	COMPILE::JS
	{
		import org.apache.royale.events.Event;
		import org.apache.royale.core.WrappedHTMLElement;
		import goog.events;
	}
	
	/**
	 *  The FileBrowser class is a bead which adds to UploadImageProxy
	 *  the ability to browse the file system and select a file.
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class FileBrowser implements IBead
	{
		private var _strand:IStrand;
		COMPILE::SWF 
		{
			protected var delegate:flash.net.FileReference;
		}
		COMPILE::JS 
		{
			protected var delegate:WrappedHTMLElement;
		}

		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function FileBrowser()
		{
			createDelegate();
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		public function createDelegate():void
		{
			delegate = document.createElement('input') as WrappedHTMLElement;
			delegate.setAttribute('type', 'file');
			goog.events.listen(delegate, 'change', fileChangeHandler);
			}
		
		/**
		 *  @private
		 */
		COMPILE::SWF
		public function createDelegate():void
		{
			delegate = new flash.net.FileReference();
			delegate.addEventListener(flash.events.Event.SELECT, fileSelectHandler);
		}
		
		/**
		 *  @private
		 */
		COMPILE::SWF
		protected function fileSelectHandler(event:flash.events.Event):void
		{
			(host.model as IFileModel).fileReference = delegate;
			host.dispatchEvent(new org.apache.royale.events.Event("modelChanged"));
			// delegate reference passed to model, so cleanup this bead to keep encapsulation
			delegate.removeEventListener(flash.events.Event.SELECT, fileSelectHandler);
			createDelegate();
		}
		
		COMPILE::JS
		private var focusedButton:WrappedHTMLElement;
		COMPILE::JS
		private var interval:int = -1;
		
		/**
		 *  Open up the system file browser. A user selection will trigger a 'modelChanged' event on the strand.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		public function browse():void
		{
			COMPILE::SWF
			{
				delegate.browse();	
			}
			COMPILE::JS 
			{
				focusedButton = document.activeElement as WrappedHTMLElement;
				//trace("activeElement is: " + focusedButton);
				focusedButton.addEventListener("blur", blurHandler);
				focusedButton.addEventListener("focus", focusHandler);				
				window.addEventListener("keydown", keyHandler);
				window.addEventListener("mousemove", mouseHandler);
				window.addEventListener("mousedown", mouseHandler);
				delegate.click();
			}
		}
		
		COMPILE::JS
		private function blurHandler(e:Object):void
		{
			//trace("blur: " + e);
			//trace("files: " + (delegate as HTMLInputElement).files.length);
			cleanupWindow();
		}

		public static const CANCEL_TIMEOUT:Number = 150;
		
		COMPILE::JS
		private function focusHandler(e:Object):void
		{
			//trace("focus: " + e);
			//trace("files: " + (delegate as HTMLInputElement).files.length);
			cleanup();
			setTimeout(maybeCancel, CANCEL_TIMEOUT);
		}
		
		COMPILE::JS
		private function keyHandler(e:Object):void
		{
			//trace("key: " + e);
			//trace("files: " + (delegate as HTMLInputElement).files.length);
			cleanup();
			setTimeout(maybeCancel, CANCEL_TIMEOUT);
		}
		
		COMPILE::JS
		private function mouseHandler(e:Object):void
		{
			//trace("mouse: " + e);
			//trace("files: " + (delegate as HTMLInputElement).files.length);
			cleanup();
			setTimeout(maybeCancel, CANCEL_TIMEOUT);
		}
				
		COMPILE::JS
		private function cleanupWindow():void
		{
			window.removeEventListener("keydown", keyHandler);
			window.removeEventListener("mousemove", mouseHandler);
			window.removeEventListener("mousedown", mouseHandler);
		}
		
		COMPILE::JS
		private function cleanup():void
		{
			focusedButton.removeEventListener("focus", focusHandler);
			focusedButton.removeEventListener("blur", blurHandler);
			window.removeEventListener("keydown", keyHandler);
			window.removeEventListener("mousemove", mouseHandler);
			window.removeEventListener("mousedown", mouseHandler);
		}
		
		private var frameCount:int = 0;
		/**
		 *  @royaleignorecoercion HTMLInputElement
		 */
		COMPILE::JS
		private function maybeCancel():void
		{
			if ((delegate as HTMLInputElement).files.length) {
				//trace("FileReference ok");
			}
			else {
				host.dispatchEvent(new Event("cancel"));
				//trace("FileReference cancel");
			}
		}
						
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.file.FileProxy
		 */
		private function get host():FileProxy
		{
			return _strand as FileProxy;
		}
		
		/**
		 *  @private
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */		
		COMPILE::JS
		private function fileChangeHandler(e:org.apache.royale.events.Event):void
		{
			//trace("fileChange");
			var fileModel:IFileModel = host.model as IFileModel;
			fileModel.fileReference = (delegate as HTMLInputElement).files[0];
			host.dispatchEvent(new Event("modelChanged"));
		}
		
	}
}
