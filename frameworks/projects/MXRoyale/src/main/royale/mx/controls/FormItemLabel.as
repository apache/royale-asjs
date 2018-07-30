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

package mx.controls
{

//--------------------------------------
//  Other metadata
//--------------------------------------

/**
 *  The FormItem container uses a FormItemLabel object to display the 
 *  label portion of the FormItem container.
 * 
 *  <p>The FormItemLabel class does not add any functionality to its superclass, Label. 
 *  Instead, its purpose is to let you set styles in a FormItemLabel type selector and 
 *  set styles that affect the labels in all FormItem containers.</p>
 * 
 *  <p><strong>Note:</strong> This class has been deprecated.  
 *  The recommended way to style a FormItem label is to use the 
 *  <code>labelStyleName</code> style property of the FormItem class.</p>
 *
 *  @see mx.containers.FormItem
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class FormItemLabel extends Label 
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function FormItemLabel() 
    {
        super();
    }
}

}
