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

public class CompareUtils
{
	
	/**
	 * Sort an <code>IArrayListView</code> collection
	 *
	 * @param collection     The Collection to sort
	 * @param sortBy         The name of the field to sort
	 * @param orderDesc        True ASC , false DESC
	 * @param numericSort    If the sorting should be numeric or alphanumeric
	 *
	 * @return the collection
	 */
	public static function sort(collection :IArrayListView, sortBy :String, orderDesc :Boolean = false, numericSort :Boolean = false) :IArrayListView {
		
		/* Create the sort field and fill it via constructor*/
		
		var sortField :SortField = new SortField(
				sortBy, //field name
				true, //caseInsensitive
				orderDesc, //descending vs ascending, by default it's ascending
				numericSort //numeric or not
		        /*sortCompareType:String = null,
				customCompareFunction:Function = null*/
		);
		
		/* Create the Sort object and add the SortField object created earlier to the array of fields to sort on. */
		var dataSort :Sort = new Sort();
		dataSort.fields = [sortField];
		/* Set the collection object's sort property to our custom sort, and refresh the collection. */
		collection.sort = dataSort;
		collection.refresh();
		/* Return the collection */
		return collection;
	}

	
    /**
     *  Compares two numeric values.
     *
     *  @param a First number.
     *
     *  @param b Second number.
     *
     *  @return 0 is both numbers are NaN.
     *  1 if only <code>a</code> is a NaN.
     *  -1 if only <code>b</code> is a NaN.
     *  -1 if <code>a</code> is less than <code>b</code>.
     *  1 if <code>a</code> is greater than <code>b</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function numericCompare(a:Number, b:Number):int
    {
        if (isNaN(a) && isNaN(b))
            return 0;

        if (isNaN(a))
            return 1;

        if (isNaN(b))
            return -1;

        if (a < b)
            return -1;

        if (a > b)
            return 1;

        return 0;
    }

    /**
     *  Compares two String values.
     *
     *  @param a First String value.
     *
     *  @param b Second String value.
     *
     *  @param caseInsensitive Specifies to perform a case insensitive compare,
     *  <code>true</code>, or not, <code>false</code>.
     *
     *  @return 0 is both Strings are null.
     *  1 if only <code>a</code> is null.
     *  -1 if only <code>b</code> is null.
     *  -1 if <code>a</code> precedes <code>b</code>.
     *  1 if <code>b</code> precedes <code>a</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function stringCompare(a:String, b:String,
                                         caseInsensitive:Boolean = false):int
    {
        if (a == null && b == null)
            return 0;

        if (a == null)
            return 1;

        if (b == null)
            return -1;

        // Convert to lowercase if we are case insensitive.
        if (caseInsensitive)
        {
            a = a.toLocaleLowerCase();
            b = b.toLocaleLowerCase();
        }

        var result:int = a.localeCompare(b);

        if (result < -1)
            result = -1;
        else if (result > 1)
            result = 1;

        return result;
    }

    /**
     *  Compares the two Date objects and returns an integer value
     *  indicating if the first Date object is before, equal to,
     *  or after the second item.
     *
     *  @param a Date object.
     *
     *  @param b Date object.
     *
     *  @return 0 if <code>a</code> and <code>b</code> are equal
     *  (or both are <code>null</code>);
     *  -1 if <code>a</code> is before <code>b</code>
     *  (or <code>b</code> is <code>null</code>);
     *  1 if <code>a</code> is after <code>b</code>
     *  (or <code>a</code> is <code>null</code>);
     *  0 is both dates getTime's are NaN;
     *  1 if only <code>a</code> getTime is a NaN;
     *  -1 if only <code>b</code> getTime is a NaN.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function dateCompare(a:Date, b:Date):int
    {
        if (a == null && b == null)
            return 0;

        if (a == null)
            return 1;

        if (b == null)
            return -1;

        var na:Number = a.getTime();
        var nb:Number = b.getTime();

        if (na < nb)
            return -1;

        if (na > nb)
            return 1;

        if (isNaN(na) && isNaN(nb))
            return 0;

        if (isNaN(na))
            return 1;

        if (isNaN(nb))
            return -1;

        return 0;
    }
	
}
}
