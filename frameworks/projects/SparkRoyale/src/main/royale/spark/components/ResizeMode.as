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

package spark.components
{

/**
 *  The ResizeMode class defines an enumeration of the modes 
 *  a component uses to resize its children in the dimensions
 *  specified by the layout system.
 *
 *  <p>The component can change its own dimensions (<code>width</code> and <code>height</code>)
 *  and re-layout its children appropriately (this is the default resize mode).</p>
 *
 *  <p>An alternative option for the component is to change its scale, in which case
 *  the children don't need to change at all. This option is supported by <code>Group</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public final class ResizeMode
{
    /**
     *  Resizes by changing the <code>width</code> and <code>height</code>.
     *
     *  <p>The component always sizes itself and then lays out 
     *  its children at the actual size specified by the layout or the user.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const NO_SCALE:String = "noScale";

    /**
     *  Resizes by setting the <code>scaleX</code> 
     *  and <code>scaleY</code> properties.
     *
     *  <p>The component always sizes itself and then lays out 
     *  its children at its measured size. 
     *  The scale is adjusted to match the specified size by the layout or the user.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const SCALE:String = "scale";
}

}
