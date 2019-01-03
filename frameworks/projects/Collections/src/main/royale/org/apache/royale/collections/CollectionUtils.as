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
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function CollectionUtils()
		{
			super();
		}

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

			if (collection)
            {
				var i:int;
				var n:int = collection.length;
				for (i = 0; i < n; i++)
                {
					if (collection.getItemAt(i)[key] == value) // || (isNaN(value) && isNaN(collection.getItemAt(i)[key])))
                    {
						index = i;
						break;
					}
				}
			}

			return index;
		}

		/**
		 * Get a item in a given collection given a key and a value
		 *
		 * @param collection The <code>ICollectionView</code> to inspect
		 * @param key The <code>String</code> that will be use for search
		 * @param value Any kind of object to perform the comparison
		 *
		 * @return The object if exists in the collection
		 *
		 * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
		public static function getItemByField(collection:ICollectionView, key:String, value:*):*
		{
			if (collection && key && (key != "") && value)
			{
				var i:int;
				var n:int = collection.length;
				for (i = 0; i < n; i++)
				{
					if (collection.getItemAt(i)[key] == value || (isNaN(value) && isNaN(collection.getItemAt(i)[key])))
					{
						return collection.getItemAt(i);
					}
				}
			}

			return null;
		}

		/**
		 * Tries to find the object or the propertyId in a collection and returns the index if found.
		 * The comparation is based on 'id'
		 * Supports nulls in property object and returns -1
		 * For use with List components in bindinds with "selectedIndex"
		 *
		 * @param collection a <code>ICollectionView</code> dataprovider where we need to look for
		 * @param obj an <code>Object</code> with a subproperty used for comparation
		 * @param property the <code>String</code> name of the subproperty. This could be and Obejct with an id or directly a propertyId
		 *
		 * @return the index if was found, -1 if the object is null or not found
		 *
		 * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
		public static function findSelectedIndex(collection:ICollectionView, obj:Object, property:String):Number
		{
			var index :Number = -1;

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
