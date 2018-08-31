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
 import mx.utils.ByteArray;
 
   COMPILE::SWF{
       import flash.net.FileFilter;
               }

   COMPILE::JS{
       import mx.net.FileFilter;
              }

   public class FileReference extends org.apache.royale.events.EventDispatcher
   {
      
      public function FileReference()
      {
	  }
  
      
      public function browse(typeFilter:Array = null):Boolean
      {
         return true;
      }
		 
	  public function load():void
	  {
	  }
	  
	  public function get name():String
	  {
	    return "";
	  }
	  
	  public function get data():ByteArray
	  {
	    return null;
	  }
      
   }

            

}
