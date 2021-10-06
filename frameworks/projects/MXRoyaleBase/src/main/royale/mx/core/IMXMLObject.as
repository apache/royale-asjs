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

package mx.core
{

/**
 *  The IMXMLObject interface defines the APIs that a non-visual component
 *  must implement in order to work properly with the MXML compiler.
 *  Currently, the only supported method is the <code>initialized()</code>
 *  method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IMXMLObject
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

    /**
     *  Called after the implementing object has been created and all
	 *  component properties specified on the MXML tag have been initialized.
	 *
     *  @param document The MXML document that created this object.
	 *
     *  @param id The identifier used by <code>document</code> to refer
	 *  to this object.
	 *  If the object is a deep property on <code>document</code>,
	 *  <code>id</code> is null.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function initialized(document:Object, id:String):void;
}

}
