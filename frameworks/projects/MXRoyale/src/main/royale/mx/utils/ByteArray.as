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

package mx.utils
{
COMPILE::SWF{
	import flash.utils.ByteArray;
}
COMPILE::JS{
import org.apache.royale.utils.BinaryData;
import org.apache.royale.utils.net.IDataInput;
import org.apache.royale.utils.net.IDataOutput;

}

COMPILE::SWF{
	public class ByteArray extends flash.utils.ByteArray
	{	
	  public function ByteArray()
	  {
	  super();
	  }
	}													
}

COMPILE::JS{
	public class ByteArray extends org.apache.royale.utils.BinaryData implements IDataInput, IDataOutput
	{	
		public function ByteArray(bytes:Object = null)
		{
			super(bytes);
		}
		public function readMultiByte(length:uint, charSet:String):String
		{
		return "";
		}
		public function writeMultiByte(value:String, charSet:String):void
		{
		}
		public function readObject():*
        {
           return null;
        }
        public function writeObject(object:*):void
        {
		}
	}
}

}
