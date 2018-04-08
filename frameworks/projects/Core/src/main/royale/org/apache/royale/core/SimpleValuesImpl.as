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
	import org.apache.royale.events.ValueChangeEvent;
	
    /**
     *  The SimpleValuesImpl class implements a simple lookup rules that is 
     *  sufficient for many very simple applications.  Every value
     *  is essential global and shared by other instances.  Values
     *  are set via calls to setValue.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SimpleValuesImpl extends EventDispatcher implements IValuesImpl
	{
		public function SimpleValuesImpl()
		{
			super();
		}
		
        /**
         *  The map of values.  The format is not documented and it is not recommended
         *  to manipulate this structure directly.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
		public var values:Object;
		
        /**
         *  @copy org.apache.royale.core.IValuesImpl#getValue()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function getValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
			return values[valueName];
		}
		
		/**
		 *  @copy org.apache.royale.core.IValuesImpl#newInstance()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function newInstance(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
			var c:Class = values[valueName];
			if (c)
				return new c();
			return null;
		}
		
        /**
         *  A method that stores a value to be shared with other objects.
         *  It is global, not per instance.  Fancier implementations
         *  may store shared values per-instance.
         * 
         *  @param thisObject An object associated with this value.  Thiis
         *                parameter is ignored.
         *  @param valueName The name or key of the value being stored.
         *  @param value The value to be stored.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function setValue(thisObject:Object, valueName:String, value:Object):void
		{
			var oldValue:Object = values[valueName];
			if (oldValue != value)
			{
				values[valueName] = value;
				dispatchEvent(new ValueChangeEvent(ValueChangeEvent.VALUE_CHANGE, false, false, oldValue, value));
			}
		}
        
        /**
         *  @copy org.apache.royale.core.IValuesImpl#getInstance()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getInstance(valueName:String):Object
        {
            return values[valueName];
        }
        
        /**
         *  @copy org.apache.royale.core.IValuesImpl#init()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function init(mainClass:Object):void
        {
            // do nothing
        }
        
        /**
         *  @copy org.apache.royale.core.IValuesImpl#convertColor()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function convertColor(value:Object):uint
        {
            if (!(value is String))
                return uint(value);
            
            var stringValue:String = value as String;
            if (stringValue.charAt(0) == '#')
                return uint(stringValue.substr(1));
            return uint(stringValue);
        }
        
        /**
         *  @copy org.apache.royale.core.IValuesImpl#parseStyles()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function parseStyles(value:String):Object
        {
            value = value.replace(/;/g, ",");
            return JSON.parse("{" + value + "}");
        }

        /**
         *  @copy org.apache.royale.core.IValuesImpl#addRule()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function addRule(ruleName:String, values:Object):void
        {
            // ignore ruleName since all values are global
            for (var p:String in values)
                values[p] = values[p];
        }
        
        COMPILE::JS
        public function applyStyles(thisObject:IUIBase, styles:Object):void
        {
            // to do or not needed?
        }

    }
}
