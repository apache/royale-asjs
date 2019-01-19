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
package org.apache.royale.collections
{

	public class CollectionUtils
	{

        /**
		 * Search for an index in a collection of objects, given the key and the value
		 *
		 * @param collection The <code>ICollectionView</code> to inspect
		 * @param key The <code>String</code> that will be use for search
		 * @param value Any kind of object to perform the comparison
		 *
		 * @return an <code>int</code> that represents the index of the object in the collection
		 *
		 * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
		public static function findIndex(collection:ICollectionView, key:String, value:*):int
        {
			var index:int = -1;

			if (collection && key && (key != "") && value !== undefined)
            {
				var i:int;
				const n:int = collection.length;
                const nan:Boolean = value is Number && isNaN(value);
				for (i = 0; i < n; i++)
                {
                    var item:Object = collection.getItemAt(i);
                    if (item) {
                        COMPILE::SWF{
                            if (item[key] == value || (nan && (item[key] is Number && isNaN(item[key])))) {
                                index = i;
                                break;
                            }
                        }
                        COMPILE::JS{
                            //on js, more checking is needed than swf to cover 'undefined' which can be assumed as Number initializer NaN value:
                            if (item[key] == value || (nan && item[key] === undefined || (item[key] is Number && isNaN(item[key])))) {
                                index = i;
                                break;
                            }
                        }
                    } //else ignore this item, it is probably null, but could be another falsey value like empty string or false
				}
			}

			return index;
		}

		/**
		 * Get a item in a given collection given a key and a value
		 *
		 * @param collection The <code>ICollectionView</code> to inspect
		 * @param key The <code>String</code> that will be used for comparison field name
		 * @param value Any kind of object to perform the comparison - a value of undefined is ignored
		 *
		 * @return The first object with a comparison field match to the value, if exists in the collection
		 *
		 * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
		public static function getItemByField(collection:ICollectionView, key:String, value:*):*
		{
			if (collection && key && (key != "") && value !== undefined)
			{
				var i:int;
				const n:int = collection.length;
                const nan:Boolean = value is Number && isNaN(value);
				for (i = 0; i < n; i++)
				{
					var item:Object = collection.getItemAt(i);
					if (item) {
						COMPILE::SWF{
                            if (item[key] == value || (nan && (item[key] is Number && isNaN(item[key])))) {
                                return item;
                            }
						}
						COMPILE::JS{
                            //on js, more checking is needed than swf to cover 'undefined' which can be assumed as Number initializer NaN value:
                            if (item[key] == value || (nan && item[key] === undefined || (item[key] is Number && isNaN(item[key])))) {
                                return item;
                            }
						}
					} //else ignore this item, it is probably null, but could be another falsey value like empty string or false
				}
			}

			return null;
		}

		/**
		 * Tries to find the object or the propertyId in a collection and returns the index if found.
		 * The comparison is based on 'id'
		 * Supports nulls in property object and returns -1
		 * For use with List components in bindings with "selectedIndex"
		 *
		 * @param collection a <code>ICollectionView</code> dataprovider where we need to look for
		 * @param obj an <code>Object</code> with a subproperty used for comparison
		 * @param property the <code>String</code> name of the subproperty. This could be an Object with an id or directly a propertyId
		 *
		 * @return the index if found, -1 if the object is null or not found
		 *
		 * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
		public static function findSelectedIndex(collection:ICollectionView, obj:Object, property:String):Number
		{
			var index :int = -1;

			if (obj && obj[property])
			{
				if (obj[property].hasOwnProperty("id"))
				{
					index = findIndex(collection, 'id', obj[property].id);
				}
				else {
					index = findIndex(collection, 'id', obj[property]);
				}
			}

			return index;
		}
    }
}
