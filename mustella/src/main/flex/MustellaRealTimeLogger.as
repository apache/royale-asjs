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
package
{
	import flash.events.DataEvent;
	import flash.net.XMLSocket;
	
	public class MustellaRealTimeLogger
	{
		private static var socketAvailable:Boolean = false;
		private static var isInitialized:Boolean = false;
        private static var xmlsock:XMLSocket = new XMLSocket();

		public static function Init():void
		{
		    try
		    {
	            xmlsock.connect("127.0.0.1", 13000);
	            //xmlsock.addEventListener(DataEvent.DATA, onData);

    	        socketAvailable = true;
    	        isInitialized = true;
	        }
	        catch(e:Error)
	        { 
	        } 
		}

        public function onData(event:DataEvent):void
        {
	        //indata.text = event.text;
        }

        public static function sendData(xmlFormattedData:String):void
        { 
    	    if(!isInitialized)
    	    {
    		    Init();	
    	    } 
        	
    	    xmlsock.send(xmlFormattedData + "\n");
        }
        
        public static function Close():void
        {
            if((socketAvailable) && (isInitialized))
            {
            	xmlsock.close();
            }
        }
	}
}