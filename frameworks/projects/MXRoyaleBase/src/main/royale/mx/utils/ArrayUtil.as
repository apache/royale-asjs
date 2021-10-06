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

package mx.utils
{
import mx.utils.ObjectUtil;

/**
 *  The ArrayUtil utility class is an all-static class
 *  with methods for working with arrays within Flex.
 *  You do not create instances of ArrayUtil;
 *  instead you call static methods such as the 
 *  <code>ArrayUtil.toArray()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ArrayUtil
{	
	import mx.collections.IList;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Ensures that an Object can be used as an Array.
     *
     *  <p>If the Object is already an Array, it returns the object. 
     *  If the object is not an Array, it returns an Array
     *  in which the only element is the Object.
	 *  If the Object implements IList it returns the IList's array.
     *  As a special case, if the Object is null,
     *  it returns an empty Array.</p>
     *
     *  @param obj Object that you want to ensure is an array.
     *
     *  @return An Array. If the original Object is already an Array, 
     *  the original Array is returned. If the original Object is an
	 *  IList then it's array is returned. Otherwise, a new Array whose
     *  only element is the Object is returned or an empty Array if 
     *  the Object was null. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function toArray(obj:Object):Array
    {
        if (obj == null) 
            return [];
        
		else if (obj is Array)
			return obj as Array;
		
		else if (obj is IList)
			return (obj as IList).toArray();
        
        else
            return [ obj ];
    }
    
    /**
     *  Returns the index of the item in the Array.
     * 
     *  @param item The item to find in the Array. 
     *
     *  @param source The Array to search for the item.
     * 
     *  @return The index of the item, and -1 if the item is not in the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getItemIndex(item:Object, source:Array):int
    {
        var n:int = source.length;
        for (var i:int = 0; i < n; i++)
        {
            if (source[i] === item)
                return i;
        }

        return -1;           
    }

    /**
     *  Checks if the Array instances contain the same values
     *  against the same indexes, even if in different orders.
     *
     *  @param a The first Array instance.
     *  @param b The second Array instance.
     *  @param strictEqualityCheck true if we should compare the
     *  values of the two Arrays using the strict equality
     *  operator (===) or not (==).
     *  @return true if the two Arrays contain the same values
     *  (determined using the strict equality operator) associated
     *  with the same indexes.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function arraysMatch(a:Array, b:Array, strictEqualityCheck:Boolean = true):Boolean
    {
        if(!a || !b)
            return false;

        if(a.length != b.length)
            return false;

        var indexesA:Array = ObjectUtil.getEnumerableProperties(a);

        for (var i:int = 0; i < indexesA.length; i++)
        {
            var index:String = indexesA[i];

            if(!b.hasOwnProperty(index))
                return false;

            if(strictEqualityCheck && a[index] !== b[index])
                return false;

            if(!strictEqualityCheck && a[index] != b[index])
                return false;
        }

        return true;
    }

    /**
     *  Checks if the Array instances contain the same values,
     *  even if in different orders.
     *
     *  @param a The first Array instance.
     *  @param b The second Array instance.
     *  @param strictEqualityCheck true if we should compare the
     *  values of the two Arrays using the strict equality
     *  operator (===) or not (==).
     *  @return true if the two Arrays contain the same values.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function arrayValuesMatch(a:Array, b:Array, strictEqualityCheck:Boolean = true):Boolean
    {
        if(!a || !b)
            return false;

        var valuesOfA:Array = getArrayValues(a);
        valuesOfA.sort();

        var valuesOfB:Array = getArrayValues(b);
        valuesOfB.sort();

        return arraysMatch(valuesOfA, valuesOfB, strictEqualityCheck);
    }

    /**
     *  Used to obtain the values in an Array, whether indexed
     *  or associative.
     *
     *  @param value The Array instance.
     *  @return an indexed Array with the values found in <code>value</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getArrayValues(value:Array):Array
    {
        var result:Array = [];

        if(!value)
            return result;

        var indexes:Array = ObjectUtil.getEnumerableProperties(value);

        for each(var index:String in indexes)
        {
            result.push(value[index]);
        }

        return result;
    }
}

}
