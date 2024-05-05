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
package mx.events
{
    import org.apache.royale.events.ProgressEvent;
    /**
     *  The ProgressEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
	public class ProgressEvent extends org.apache.royale.events.ProgressEvent
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
                                      current:Number = NaN, total:Number = NaN)
		{
    		super(type, bubbles, cancelable, current, total);
		}
		
      

        
		public static const PROGRESS:String = "progress";
		public static const SOCKET_DATA:String = "socketData";
		public static const STANDARD_ERROR_DATA:String = "standardErrorData";
		public static const STANDARD_INPUT_PROGRESS:String = "standardInputProgress";
		public static const STANDARD_OUTPUT_DATA:String = "standardOutputData";
		 
		 public function get bytesTotal():Number{
		    return total;
		 }
		 
		 public function set bytesTotal(value:Number):void{
		 }
		 
		 
		
		 public function get bytesLoaded():Number{
		     return current;
		 }
		 
		 public function set bytesLoaded(value:Number):void{
		 }
	}
}
