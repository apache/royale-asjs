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
package org.apache.royale.reflection {
	
	COMPILE::JS{
		import org.apache.royale.reflection.nativejs.*
	}
	

	/**
	 *  Information about extra reflection definitions
     *  not required in SWF
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class ExtraData {
		
		public static function get isRelevant():Boolean{
			return false;
		}

		public static function reset():void{
		}
		
		public static function hasData(key:*):Boolean{
			return false
		}
		
		public static function getData(key:*):Object{
			return null;
		}
		
		public static function addExternDefintion(item:Object):void{
		
		}
		
		public static function addAll():void{
		
		}
	}
    
    
    /**
     *  Information about extra reflection definitions
     *  required in JS to optionally support extra reflection
     *  data. This class itself is non-reflectable, and does not create
	 *  dependencies from the org.apache.royale.reflection.nativejs package
	 *  in js release output, unless they are added.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  
	 *  @royalesuppressexport
     */
	COMPILE::JS
	public class ExtraData {
		
		private static var reflectionData:Map;
		
		/**
		 * this is non-reflectable
		 */
		public static function get isRelevant():Boolean{
			return true;
		}

		/**
		 * this is non-reflectable
		 */
		public static function reset():void{
			reflectionData = null;
		}
		
		/**
		 * this is non-reflectable
		 */
		public static function hasData(key:*):Boolean{
			return reflectionData && reflectionData.has(key);
		}
		
		/**
		 * this is non-reflectable
		 */
		public static function getData(key:*):Object{
			return reflectionData.get(key);
		}
		
		/**
		 * this method itself is non-reflectable
		 * If an application requires reflection of specific Native types and Royale synthetic types in javascript
		 * call this method for each specific representation inside the nativejs package
		 * at startup, before reflection is used in any code
		 *
		 * Use this to add selective definitions only (PAYG)
		 * If this method is never used, it
		 * will not be included in release build
		 *
		 * example:
		 * import org.apache.royale.reflection.nativejs.AS3Array
		 * ExtraData.addExternalDefinition(AS3Array())
		 *
		 */
		public static function addExternDefintion(item:Object):void{
			if (!reflectionData) reflectionData = new Map();
			reflectionData.set(item['name'], item);
			reflectionData.set(item['classRef'], item);
		}
		
		/**
		 * this method itself is non-reflectable
		 * If an application requires reflection of default Native types and Royale synthetic types in javascript
		 * call this method near application startup, before reflection is used in any code
		 *
 		 * Use this to add corresponding reflection support for native js definitions
		 * that are used to correspond to common native as3 types (non-PAYG)
		 * If this method is never used, the dependencies inside it
		 * will not be included in release build
		 *
		 */
		public static function addAll():void{
			var items:Array = [
				AS3Array(),
				AS3Number(),
				AS3String(),
				AS3Boolean(),
				AS3int(),
				AS3uint(),
				AS3Vector(),
				AS3Object()
			];
			while(items.length) addExternDefintion(items.pop());
			
		}
		
	}
	
}
