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
    /**
     *  The ValuesManager class is one of the few Singleton classes in
     *  Royale.  Instances of other things can be shared via IValuesImpl, but
     *  this class's API is its one static property where you get the
     *  instance of IValuesImpl by which other instances can be shared.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ValuesManager
	{
        /**
         *  Constructor.  This class should not be instantiated.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ValuesManager()
		{
		}
		
		private static var _valuesImpl:IValuesImpl;
		
        /**
         *  The implementation of IValuesImpl where you can
         *  get default values and shared instances.
         * 
         *  @see org.apache.royale.core.IValuesImpl
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public static function get valuesImpl():IValuesImpl
		{
			return _valuesImpl;
		}

        /**
         *  @private
         */
		public static function set valuesImpl(value:IValuesImpl):void
		{
			_valuesImpl = value;
		}
	}
}
