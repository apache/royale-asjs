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
package org.apache.royale.core
{
	import org.apache.royale.events.EventDispatcher;
	
    /**
     *  The SimpleLocalizedValuesImpl class implements a simple getValue
	 *  implementation that is sufficient for many very simple applications.  
	 *  Every key in every bundle must be provided in every locale.  There
	 *  is no fall-through logic to the next locale.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SimpleLocalizedValuesImpl extends EventDispatcher implements ILocalizedValuesImpl
	{
		public function SimpleLocalizedValuesImpl()
		{
			super();
		}
		
		private var mainClass:Object;
		private var locale:String;
		
        /**
         *  The map of bundles.  The format is not documented and it is not recommended
         *  to manipulate this structure directly.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
		public var bundles:Object = {};
		
        /**
         *  @copy org.apache.royale.core.ILocalizedValuesImpl#getValue()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function getValue(bundleName:String, key:String):*
		{
			var actualBundleName:String = locale + bundleName;
			var bundle:Object = bundles[actualBundleName];
			if (!bundle)
			{
				bundle = {};
				bundles[actualBundleName] = bundle;
				// go look for the bundle
				var data:String = mainClass[actualBundleName];
				var rows:Array = data.split("\n");
				var n:int = rows.length;
				for (var i:int = 0; i < n; i++)
				{
					var row:String = rows[i];
					if (row.charAt(0) == "#") 
						continue; // comments
					var parts:Array = row.split("=");
					if (parts.length != 2)
						continue; // blank line?
					bundle[parts[0]] = parts[1];
				}				
			}
			return bundle[key];
		}
				
        /**
         *  @copy org.apache.royale.core.ILocalizedValuesImpl#localeChain()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set localeChain(value:String):void
		{
			locale = value;
		}
        
        /**
         *  @copy org.apache.royale.core.IBead#strand()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            this.mainClass = value;
        }

    }
}
