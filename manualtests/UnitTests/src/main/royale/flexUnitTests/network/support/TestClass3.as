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
package flexUnitTests.network.support
{
	import org.apache.royale.utils.net.IExternalizable;
	COMPILE::JS{
		import org.apache.royale.utils.net.IDataInput;
		import org.apache.royale.utils.net.IDataOutput;
	}
	
	COMPILE::SWF{
		import flash.utils.IDataInput;
		import flash.utils.IDataOutput;
	}
	
	
	public class TestClass3 implements IExternalizable
	{
		
		public var content:Array=["TestClass3"];
		
		
		public function readExternal(input:IDataInput):void{
			var content:Array = input.readObject() as Array;
			this.content = content;
		}
		
		public function writeExternal(output:IDataOutput):void {
			output.writeObject(content);
		}
	
	}
	
}
