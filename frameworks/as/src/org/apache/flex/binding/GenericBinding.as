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
package org.apache.flex.binding
{	
	import flash.events.Event;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.core.IStrand;

	public class GenericBinding implements IBead, IDocument
	{
		public function GenericBinding()
		{
		}
		
		protected var document:Object;
        protected var destination:Object;

		public var source:Object;
		public var destinationData:Object;
		
		public function set strand(value:IStrand):void
		{
			destination = value;
            var val:Object = getValueFromSource();
            applyValue(val);
        }
        
        private function getValueFromSource():Object
        {
            if (source is Array)
            {
                var arr:Array = source as Array;
                var n:int = arr.length;
                var obj:Object = document[arr[0]];
                if (obj == null)
                    return null;
                for (var i:int = 1; i < n; i++)
                {
                    obj = obj[arr[i]];
                    if (obj == null)
                        return null;
                }
                return obj;
            }
            else if (source is Function)
            {
                var fn:Function = source as Function;
                obj = fn.apply(document);
                return obj;
            }
            else if (source is String)
            {
                obj = document[source];
                return obj;
            }
            return null;
		}
        
        private function applyValue(value:Object):void
        {
            if (destinationData is Array)
            {
                var arr:Array = destinationData as Array;
                var n:int = arr.length;
                var obj:Object = document[arr[0]];
                if (obj == null)
                    return;
                for (var i:int = 1; i < n - 1; i++)
                {
                    obj = obj[arr[i]];
                    if (obj == null)
                        return;
                }
                obj[arr[n-1]] = value;                
            }
            else if (destinationData is Function)
            {
                Function(destinationData).apply(document, [value]);
            }
        }
		
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;
		}
		
		public function valueChanged(value:Object):void
		{
            var val:Object = getValueFromSource();
            applyValue(val);
		}
	}
}