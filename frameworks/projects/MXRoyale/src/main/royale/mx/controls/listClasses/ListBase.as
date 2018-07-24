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
package mx.controls.listClasses
{   
import mx.core.mx_internal;
import org.apache.royale.core.DataContainerBase;

use namespace mx_internal;

	
	
    /**
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royalesuppresspublicvarwarning
	*/
	public class ListBase extends DataContainerBase
	{
	
	//----------------------------------
    //  selectedIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedIndex property.
     */
    mx_internal var _selectedIndex:int = -1;

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="-1")]

    /**
     *  The index in the data provider of the selected item.
     * 
     *  <p>The default value is -1 (no selected item).</p>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedIndex():int
    {
        return _selectedIndex;
    }

    /**
     *  @private
     */
    public function set selectedIndex(value:int):void
    {
       // if (!collection || collection.length == 0)
       // {
            _selectedIndex = value;
         //   bSelectionChanged = true;
         //   bSelectedIndexChanged = true;
          //  invalidateDisplayList();
            return;
       // }
        //commitSelectedIndex(value);
    }
	
	 //----------------------------------
    //  variableRowHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the variableRowHeight property.
     */
    private var _variableRowHeight:Boolean = false;

    [Inspectable(category="General")]

    /**
     *  A flag that indicates whether the individual rows can have different
     *  height. This property is ignored by TileList and HorizontalList.
     *  If <code>true</code>, individual rows can have different height values.
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get variableRowHeight():Boolean
    {
        return _variableRowHeight;
    }

    /**
     *  @private
     */
    public function set variableRowHeight(value:Boolean):void
    {
        _variableRowHeight = value;
       // itemsSizeChanged = true;

       // invalidateDisplayList();

       // dispatchEvent(new Event("variableRowHeightChanged"));
    }

	
	
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ListBase()
		{
			super();            
		}
    }
}
