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

package mx.events
{

/**
 *  The DataGridEventReason class defines constants for the values 
 *  of the <code>reason</code> property of a DataGridEvent object 
 *  when the <code>type</code> property is <code>itemEditEnd</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public final class DataGridEventReason
{
	//include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

    /**
     *  Specifies that the user cancelled editing and that they do not 
     *  want to save the edited data. Even if you call the <code>preventDefault()</code> method 
     *  from within your event listener for the <code>itemEditEnd</code> event, 
     *  Flex still calls the <code>destroyItemEditor()</code> editor to close the editor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const CANCELLED:String = "cancelled";

    /**
     *  Specifies that the list control lost focus, was scrolled, 
     *  or is somehow in a state where editing is not allowed. 
     *  Even if you call the <code>preventDefault()</code> method from within your event 
     *  listener for the <code>itemEditEnd</code> event, 
     *  Flex still calls the <code>destroyItemEditor()</code> editor to close the editor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const OTHER:String = "other";

    /**
     *  Specifies that the user moved focus to a new column in the same row. 
     *  Within an event listener, you can let the focus change occur, or prevent it. 
     *  For example, your event listener might check that the user entered a valid value 
     *  for the item currently being edited. If not, you can prevent the user from moving 
     *  to a new item by calling the <code>preventDefault()</code> method. 
     *  In this case, the item editor remains open, and the user continues to edit 
     *  the current item. If you call the <code>preventDefault()</code> method and 
     *  also call the <code>destroyItemEditor()</code> method, you block the move to the new item, 
     *  but the item editor closes. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const NEW_COLUMN:String = "newColumn";

    /**
     *  Specifies that the user moved focus to a new row. 
     *  You handle this reason much like you handle <code>NEW_COLUMN</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const NEW_ROW:String = "newRow";
}

}
