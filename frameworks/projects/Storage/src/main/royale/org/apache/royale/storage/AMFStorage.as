////////////////////////////////////////////////////////////////////////////////
//
//	Licensed to the Apache Software Foundation (ASF) under one or more
//	contributor license agreements.	See the NOTICE file distributed with
//	this work for additional information regarding copyright ownership.
//	The ASF licenses this file to You under the Apache License, Version 2.0
//	(the "License"); you may not use this file except in compliance with
//	the License.	You may obtain a copy of the License at
//
//			http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.storage
{
	COMPILE::SWF{
		import flash.events.Event;
		import flash.net.SharedObject;
	}

	COMPILE::JS
	{
		import goog.DEBUG;
		import org.apache.royale.debugging.assert;
		import org.apache.royale.net.remoting.amf.AMFBinaryData;
	}

	import org.apache.royale.events.EventDispatcher;

	public class AMFStorage extends EventDispatcher
	{
		private static const map:Object = {};

    public static const PENDING:String = "pending";
    public static const FLUSHED:String = "flushed";
    public static const FAILED:String = "failed";

		public static function getLocal(name:String, localPath:String = null, secure:Boolean = false):AMFStorage
		{
			var pathKey:String = localPath == null ? '$null$' : localPath;
			COMPILE::JS {
					localPath = pathKey;
			}
			var cached:AMFStorage = map[pathKey + '::' + name];
			if (!cached)
			{
				cached = new AMFStorage();
				map[pathKey + '::' + name] = cached;
				cached.setName(name);
				cached.setLocalPath(localPath);
				cached.createSO(secure);
			}
			COMPILE::JS{
				if (!map['#']) {
					window.addEventListener('pagehide', unloadHandler);
					map['#'] = true;
				}
			}
			return cached;
		}	
		COMPILE::JS
		private static function unloadHandler(event:PageTransitionEvent):void{
				//@todo consider whether we do anything different if event.persisted is true or false
				for (var key:String in map) {
						if (key != '#') {
								var so:AMFStorage = map[key];
								//@todo what to do with errors here:
								so.save();
						}
				}
		}

		private function AMFStorage()
		{
			
		}
		COMPILE::SWF
		private var _so:flash.net.SharedObject;
		
		COMPILE::JS
		private var _ls:Storage;

		/**
		 *
		 * @param minDiskSpace ignored for javascript targets
		 * @return a string indicating the flush status. This can be (on swf) FLUSHED or PENDING on swf. For JS is it FLUSHED or FAILED
		 *
		 * @throws Error #2044: Unhandled NetStatusEvent
		 */
		public function save(minDiskSpace:int = 0):String
		{
			COMPILE::JS
			{
				if (_data)
				{
					try{
						var amf:AMFBinaryData = new AMFBinaryData();
						amf.writeObject(_data);
						var base64:String = window['btoa'](String.fromCharCode.apply(null, amf.array));
						_ls.setItem(_localPath + "::" + _name, base64);
					} catch(e:Error) {
						return FAILED;
					}
				}
				//js never returns pending, because there is no way for the user to accept or decline the byte size storage limits
				return FLUSHED;
			}
			COMPILE::SWF
			{
					return _so.flush(minDiskSpace);
			}
		}

		public function clear():void{
			COMPILE::SWF{
				_so.clear();
			}
			COMPILE::JS{
				if (_data) {
					if (_ls) {
						_ls.removeItem(_localPath + "::" + _name);
					}
					_data = null;
				}
			}
		}
		
		COMPILE::JS
		private var _data:Object;

		public function get data():Object
		{
			COMPILE::SWF
			{
				return _so.data;
			}
			COMPILE::JS
			{
				if (!_data)
				{
					_data = {};
				}
				return _data;
			}
		}
		
		private var _name:String;
		protected function setName(name:String):void
		{
			_name = name;
		}
		
		private var _localPath:String;
		private function setLocalPath(localPath:String):void
		{
			_localPath = localPath;
		}
		COMPILE::SWF
		protected function redispatch(event:flash.events.Event):void{
			//just redispatch?
			dispatchEvent(event.clone());
		}
        
		private function createSO(secure:Boolean):void
		{
			COMPILE::SWF{
				_so = flash.net.SharedObject.getLocal(_name, _localPath, secure);
				_so.addEventListener('netStatus', redispatch);
				_so.addEventListener('asyncError', redispatch); //not sure about this one for LSO..
				//_so.addEventListener('sync', redispatch); //only relevant for RSO, not LSO
			}
			COMPILE::JS{
				_ls = window.localStorage;
				if(goog.DEBUG)
				{
					if (!_ls && typeof Storage != "undefined") {
						//this gets around an issue with local testing with file:// protocol in IE11
						var p:String = window.location.pathname.replace(/(^..)(:)/, "$1$$");
						window.location.href = window.location.protocol + "//127.0.0.1" + p;
						_ls = window.localStorage;
					}
				}
				assert(_ls != null,'local storage not supported');
				var base64:String = _ls.getItem(_localPath + "::" + _name);
				if (base64)
				{
					var binary_string:String = window['atob'](base64);
					var arr:Uint8Array = new Uint8Array(
						binary_string.split('')
							.map(
								function (charStr:String):uint
								{
									return charStr.charCodeAt(0);
								}
							)
					);
					var amf:AMFBinaryData = new AMFBinaryData(arr.buffer);
					_data = amf.readObject();
				}
			}
		}
	}
}