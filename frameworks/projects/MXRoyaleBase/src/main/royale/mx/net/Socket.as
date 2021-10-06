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


package mx.net
{


import org.apache.royale.events.EventDispatcher;

    public class Socket extends EventDispatcher
    {
		   public function Socket(host:String = null, port:int = 0)
		   {
				super();
		   }
		   
		   public function get bytesAvailable():uint {
				trace("bytesAvailable in Socket is not implemented");
				return 0;
		   }
		   
		   public function connect(host:String, port:int):void {
				trace("connect in Socket is not implemented");
		   }
		   
			public function flush():void {
				trace("flush in Socket is not implemented");
		   }
		   
		   public function readUTFBytes(length:uint):String {
				trace("readUTFBytes in Socket is not implemented");
				return "";
		   }
		   public function writeUTFBytes(value:String):void {
				trace("writeUTFBytes in Socket is not implemented");
		   }
		   
		   public function get connected():Boolean {
				trace("connected in Socket is not implemented");
				return false;
		   }
		   
		   public function close():void {
				trace("close in Socket is not implemented");
		   }
	}
	
}
