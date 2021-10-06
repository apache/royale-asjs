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

package mx.collections
{
/*
import flash.system.ApplicationDomain;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.IExternalizable;

import mx.core.mx_internal;

use namespace mx_internal;
*/

import org.apache.royale.utils.net.IExternalizable;
COMPILE::JS {
	import org.apache.royale.utils.net.IDataInput;
	import org.apache.royale.utils.net.IDataOutput;
}
COMPILE::SWF{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
}


[DefaultProperty("source")]

[RemoteClass(alias="flex.messaging.io.ArrayCollection")]

/**
 *  The ArrayCollection class is a wrapper class that exposes an Array as
 *  a collection that can be accessed and manipulated using the methods
 *  and properties of the <code>ICollectionView</code> or <code>IList</code>
 *  interfaces. Operations on a ArrayCollection instance modify the data source;
 *  for example, if you use the <code>removeItemAt()</code> method on an
 *  ArrayCollection, you remove the item from the underlying Array.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:ArrayCollection&gt;</code> tag inherits all the attributes of its
 *  superclass, and adds the following attributes:</p>
 *
 *  <pre>
 *  &lt;mx:ArrayCollection
 *  <b>Properties</b>
 *  source="null"
 *  /&gt;
 *  </pre>
 *
 *  @example The following code creates a simple ArrayCollection object that
 *  accesses and manipulates an array with a single Object element.
 *  It retrieves the element using the IList interface <code>getItemAt</code>
 *  method and an IViewCursor object that it obtains using the ICollectionView
 *  <code>createCursor</code> method.
 *  <pre>
 *  var myCollection:ArrayCollection = new ArrayCollection([ { first: 'Matt', last: 'Matthews' } ]);
 *  var myCursor:IViewCursor = myCollection.createCursor();
 *  var firstItem:Object = myCollection.getItemAt(0);
 *  var firstItemFromCursor:Object = myCursor.current;
 *  if (firstItem == firstItemFromCursor)
 *        doCelebration();
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ArrayCollection extends ListCollectionView implements IExternalizable
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>Creates a new ArrayCollection using the specified source array.
     *  If no array is specified an empty array will be used.</p>
     *
     *  @param source The source Array.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ArrayCollection(source:Array = null)
    {
        super();

        this.source = source;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
		
    //----------------------------------
    //  source
    //----------------------------------

    [Inspectable(category="General", arrayType="Object")]
    [Bindable("listChanged")] //superclass will fire this

    /**
     *  The source of data in the ArrayCollection.
     *  The ArrayCollection object does not represent any changes that you make
     *  directly to the source array. Always use
     *  the ICollectionView or IList methods to modify the collection.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get source():Array
    {
        if (list && (list is ArrayList))
        {
            return ArrayList(list).source;
        }
        return null;
    }

    /**
     *  @private
     */
    public function set source(s:Array):void
    {
        list = new ArrayList(s);
    }
	
	
	
	/**
	 *  @private
	 *  Ensures that only the source property is serialized.
	 */
	public function readExternal(input:IDataInput):void
	{
		if (list is IExternalizable)
			IExternalizable(list).readExternal(input);
		else
			source = input.readObject() as Array;
	}
	
	/**
	 *  @private
	 *  Ensures that only the source property is serialized.
	 */
	public function writeExternal(output:IDataOutput):void
	{
		if (list is IExternalizable)
			IExternalizable(list).writeExternal(output);
		else
			output.writeObject(source);
	}

}

}
