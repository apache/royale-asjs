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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.binding
{	
	import org.apache.royale.binding.GenericBinding;
	import org.apache.royale.binding.PropertyWatcher;
	import org.apache.royale.core.IStrand;
    
    /**
     *  The CruxBinding class is the data-binding class that is specific to
     *  support for MetaTag driven bindings
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
	public class CruxBinding extends GenericBinding
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CruxBinding()
		{
		}


        
        public var rootWatcher:PropertyWatcher;
        
        /**
         *  The source root
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var sourceRoot:Object;
        
        
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function set strand(value:IStrand):void
		{
            throw new Error('this is not intended for use as a Bead');
        }
        
        /**
         * @royaleignorecoercion Array
         * @royaleignorecoercion Function
         */
        private function getValueFromSource():Object
        {
            if (source is Array)
            {
                var arr:Array = source as Array;
                var n:int = arr.length;
                var obj:Object;
                obj = sourceRoot[arr[0]];

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
            else if (source is String)
            {
                obj = sourceRoot[source];
                return obj;
            }
            return null;
		}
        

        /**
         * @royaleignorecoercion Array
         */
        private function applyValue(value:Object):void
        {
			if (destinationFunction != null)
			{
				destinationFunction.apply(document, [value]);
			}
			else if (destinationData is Array)
            {
                var arr:Array = destinationData as Array;
                var n:int = arr.length;
                var obj:Object = document;
                for (var i:int = 1; i < n - 1; i++)
                {
                    obj = obj[arr[i]];
                    if (obj == null)
                        return;
                }
                obj[arr[n-1]] = value;                
            } else if (destinationData is String) {
                document[destinationData] = value;
            }
        }
		
		
        /**
         *  The method that gets called by the watcher when the value
         *  may have changed.
         *
         *  @param value The new value.
         *  @param getFromSource true if the value parameter should be ignored, and an
         *  attempt should be made to get the value directly from the source object.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function valueChanged(value:Object, getFromSource:Boolean):void
		{
            try 
            {
			
                if (getFromSource) {
					value = getValueFromSource();
				}
                applyValue(value);
            } 
            catch (e:Error)
            {
            }
		}
        
        
        public function unwatch():void{
            if (rootWatcher) {
                rootWatcher.parentChanged(null);
            }
        }
  
	}
}
