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
package org.apache.royale.test.listeners
{
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.test.AssertionError;
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.test.runners.notification.IAsyncStartupRunListener;
	import org.apache.royale.test.runners.notification.Result;
	import org.apache.royale.utils.Timer;
	
	COMPILE::SWF
	{
		import flash.events.DataEvent;
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.events.SecurityErrorEvent;
		import flash.net.XMLSocket;
	}
	
	/**
	 * Communicates with a socket server to integrate RoyaleUnit tests with a
	 * build system, such as <a href="https://apache.github.io/royale-docs/testing/royaleunit/run-unit-tests-with-ant">Apache Ant</a>.
	 */
	public class CIListener extends EventDispatcher implements IAsyncStartupRunListener
	{
		/**
		 * @private
		 */
		protected static const DEFAULT_PORT:uint = 1024;

		/**
		 * @private
		 */
		protected static const DEFAULT_SERVER:String = "127.0.0.1";

		/**
		 * @private
		 */
		protected static const STATUS_SUCCESS:String = "success";

		/**
		 * @private
		 */
		protected static const STATUS_ERROR:String = "error";

		/**
		 * @private
		 */
		protected static const STATUS_FAILURE:String = "failure";

		/**
		 * @private
		 */
		protected static const STATUS_IGNORE:String = "ignore";

		/**
		 * @private
		 */
		protected static const END_OF_TEST_RUN:String = "<endOfTestRun/>";

		/**
		 * @private
		 */
		protected static const END_OF_TEST_ACK:String = "<endOfTestRunAck/>";

		/**
		 * @private
		 */
		protected static const START_OF_TEST_RUN_ACK:String = "<startOfTestRunAck/>";
		
		/**
		 * Constructor.
		 */
		public function CIListener(port:uint = DEFAULT_PORT, server:String = DEFAULT_SERVER) 
		{
			_port = port;
			_server = server;
			
			COMPILE::SWF
			{
				_socket = new XMLSocket();
				_socket.addEventListener(DataEvent.DATA, socket_dataHandler);
				_socket.addEventListener(Event.CONNECT, socket_connectHandler);
				_socket.addEventListener(IOErrorEvent.IO_ERROR, socket_errorHandler);
				_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_errorHandler);
				_socket.addEventListener(Event.CLOSE, socket_errorHandler);
			}
			COMPILE::JS
			{
				_socket = new WebSocket("ws://" + server + ":" + port);
				_socket.addEventListener("open", webSocket_openHandler);
				_socket.addEventListener("error", socket_errorHandler);
				_socket.addEventListener("message", webSocket_messageHandler);
			}
			
			socketTimeOutTimer = new Timer(2000, 1);
			socketTimeOutTimer.addEventListener(Timer.TIMER, socketTimeOutTimer_timerHandler);
			socketTimeOutTimer.start();

			try
			{
				COMPILE::SWF
				{
					_socket.connect(server, port);
				}
				socketTimeOutTimer.stop();
			}
			catch(e:Error)
			{
				//This needs to be more than a trace
				trace(e.message);
			}
		}
		
		COMPILE::SWF
		protected var _socket:XMLSocket;

		COMPILE::JS
		protected var _socket:WebSocket;

		protected var _port:uint;
		protected var _server:String;
		
		protected var lastTestFailed:Boolean = false;
		protected var socketTimeOutTimer:Timer = null;
		protected var lastTestTime:Number = 123;
		
		protected var _ready:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function get ready():Boolean 
		{
			return _ready;
		}

		/**
		 * @private
		 */
		public function testTimed(description:String, runTime:Number):void
		{
			if(!runTime || isNaN(runTime))
			{
				lastTestTime = 0;
			}
			else
			{
				lastTestTime = runTime;
			}
		}
		
		/**
		 * @private
		 */
		public function testRunStarted(description:String):void
		{
			//Since description tells us nothing about failure, error, and skip counts, this is 
			//computed by the Ant task as the process executes and no work is needed to signify
			//the start of a test run.
		}
		
		/**
		 * @private
		 */
		public function testRunFinished(result:Result):void 
		{
			sendResults(END_OF_TEST_RUN);
		}
		
		/**
		 * @private
		 */
		public function testStarted(description:String):void 
		{
			lastTestFailed = false;
		}
		
		/**
		 * @private
		 */
		public function testFinished(description:String):void 
		{
			if(lastTestFailed)
			{
				return;
			}
			var descriptor:Descriptor = getDescriptorFromDescription(description);

			//we can't use the XML class here because FlexUnit expects the
			//whitespace in the XML to be formatted in an exact way
			var xml:String =
				"<testcase" +
					" classname=\"" + escapeXMLAttribute(descriptor.suite) + "\"" +
					" name=\"" + escapeXMLAttribute(descriptor.method) + "\"" +
					" time=\"" + lastTestTime + "\"" +
					" status=\"" + STATUS_SUCCESS + "\"" +
					" />"

			sendResults(xml);
		}

		/**
		 * @private
		 */
		protected function escapeXMLAttribute(value:String):String
		{
			if(value == null)
			{
				return "";
			}
			COMPILE::SWF
			{
				var xml:XML = <escaped value={value}/>;
				return xml.@value.toXMLString();
			}
			COMPILE::JS
			{
				var serializer:XMLSerializer = new XMLSerializer()
				var attr:Attr = document.createAttribute("attr");
				attr.value = value;
				return serializer.serializeToString(attr);
			}
		}
		
		/**
		 * @private
		 */
		public function testIgnored(description:String):void 
		{
			var descriptor:Descriptor = getDescriptorFromDescription(description);

			//we can't use the XML class here because FlexUnit expects the
			//whitespace in the XML to be formatted in an exact way
			var xml:String =
				"<testcase" +
					" classname=\"" + escapeXMLAttribute(descriptor.suite) + "\"" +
					" name=\"" + escapeXMLAttribute(descriptor.method) + "\"" +
					" time=\"0\"" +
					" status=\"" + STATUS_IGNORE + "\"" +
					">" +
					"<skipped />" +
				"</testcase>";

			sendResults(xml);
		}
		
		/**
		 * @private
		 */
		public function testFailure(failure:Failure):void 
		{
			lastTestFailed = true;
			var descriptor:Descriptor = getDescriptorFromDescription(failure.description);

			var xml:String = null;
			if(failure.exception is AssertionError) 
			{
				//we can't use the XML class here because FlexUnit expects the
				//whitespace in the XML to be formatted in an exact way
				xml =
					"<testcase" +
						" classname=\"" + escapeXMLAttribute(descriptor.suite) + "\"" +
						" name=\"" + escapeXMLAttribute(descriptor.method) + "\"" +
						" time=\"" + lastTestTime + "\"" +
						" status=\"" + STATUS_FAILURE + "\"" +
						">" +
						"<failure" +
							" message=\"" + escapeXMLAttribute(failure.message) + "\"" +
							" type=\"" + escapeXMLAttribute(failure.description) + "\"" +
							">" +
							"<![CDATA[" + failure.stackTrace + "]]>" +
						"</failure>" +
					"</testcase>";
			}
			else 
			{
				//we can't use the XML class here because FlexUnit expects the
				//whitespace in the XML to be formatted in an exact way
				xml =
					"<testcase" +
						" classname=\"" + escapeXMLAttribute(descriptor.suite) + "\"" +
						" name=\"" + escapeXMLAttribute(descriptor.method) + "\"" +
						" time=\"" + lastTestTime + "\"" +
						" status=\"" + STATUS_ERROR + "\"" +
						">" +
						"<error" +
							" message=\"" + escapeXMLAttribute(failure.message) + "\"" +
							" type=\"" + escapeXMLAttribute(failure.description) + "\"" +
							">" +
							"<![CDATA[" + failure.stackTrace + "]]>" +
						"</error>" +
					"</testcase>";
			}
			
			sendResults(xml);
		}
		
		/**
		 * @private
		 */
		private function getDescriptorFromDescription(description:String):Descriptor
		{
			var descriptor:Descriptor = new Descriptor();
			var descriptionArray:Array = description.split("::");
			var classMethod:String;
			if(descriptionArray.length > 1) 
			{
				descriptor.path = descriptionArray[0];
				classMethod = descriptionArray[1];
			} 
			else 
			{
				classMethod = descriptionArray[0];
			}
			var classMethodArray:Array = classMethod.split(".");
			if(descriptor.path == "")
			{
				descriptor.suite = classMethodArray[0];
			}
			else
			{
				descriptor.suite = descriptor.path + "::" + classMethodArray[0];
			}
			if(classMethodArray.length > 1)
			{
				descriptor.method = classMethodArray[1];
			}
			else
			{
				descriptor.method = "";
			}
			return descriptor;
		}
		
		/**
		 * @private
		 */
		protected function sendResults(msg:String):void
		{
			COMPILE::SWF
			{
				if(_socket.connected)
				{
					_socket.send(msg);			
				}
			}
			COMPILE::JS
			{
				if(_socket.readyState == 1)
				{
					_socket.send(msg);
				}
			}
			
			trace(msg);
		}
		
		/**
		 * @private
		 */
		protected function socketTimeOutTimer_timerHandler(event:org.apache.royale.events.Event):void
		{
			trace("Socket timeout in CIListener");
			dispatchEvent(new org.apache.royale.events.Event("skip"));
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function socket_connectHandler(event:flash.events.Event):void
		{
			//we're not "ready" yet. wait until we get some data first.
		}
		
		/**
		 * @private
		 */
		COMPILE::JS
		protected function webSocket_openHandler(event:Event):void
		{
			//we're not "ready" yet. wait until we get some data first.
		}

		/**
		 * @private
		 */
		protected function socket_errorHandler(event:Object):void
		{
			trace("Socket error in CIListener");
			trace(event);
			dispatchEvent(new org.apache.royale.events.Event("skip"));
		}

		/**
		 * @private
		 */
		COMPILE::SWF
		protected function socket_dataHandler(event:DataEvent):void
		{
			var data:String = event.data;

			//if we received an acknowledgement on startup, the java server is ready and we can start sending.			
			if(data == START_OF_TEST_RUN_ACK)
			{
				_ready = true;
				dispatchEvent(new org.apache.royale.events.Event("ready"));
			}
			else if(data == END_OF_TEST_ACK)
			{
				//if we received an acknowledgement finish-up, close the socket.
				_socket.close();
			}
		}

		/**
		 * @private
		 */
		COMPILE::JS
		protected function webSocket_messageHandler(event:MessageEvent):void
		{
			var data:String = event.data as String;

			//if we received an acknowledgement on startup, the java server is ready and we can start sending.			
			if(data == START_OF_TEST_RUN_ACK)
			{
				_ready = true;
				dispatchEvent(new org.apache.royale.events.Event("ready"));
			}
			else if(data == END_OF_TEST_ACK)
			{
				//if we received an acknowledgement finish-up, close the socket.
				_socket.close();
			}

		}
	}
}

class Descriptor
{
	public function Descriptor(path:String = "", suite:String = "", method:String = "")
	{
		this.path = path;
		this.suite = suite;
		this.method = method;
	}

	public var path:String;
	public var suite:String;
	public var method:String;
}