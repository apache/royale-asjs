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


   public class FileFilter 
   {
	   private var _description:String;
	   private var _extension:String;
      public function FileFilter(description:String, extension:String, macType:String = null)
	  {
		  _description = description;
		  _extension = extension;
	  }
	    public function get description():String
		{
		   return _description;
		}
        public function set description(value:String):void
		{
			_description = value;
		}

		
	    public function get extension():String
		{
		   return _extension;
		}
        public function set extension(value:String):void
		{
			_extension = value;
		}
		
		
	    public function get macType():String
		{
		   return "";
		}
        public function set macType(value:String):void
		{
		
		}
        
   }

              

}
