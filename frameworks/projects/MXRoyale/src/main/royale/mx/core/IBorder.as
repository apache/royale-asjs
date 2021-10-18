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
 *  The IBorder interface defines the interface that all classes 
 *  used for border skins should implement.
 *
 *  <p>It is not an error if the border skin does not implement IBorder. 
 *  In this case, however, the container using the skin cannot determine 
 *  the border metrics of the border. 
 *  Therefore, the container places content starting at its top-left edge 
 *  (adjusted for padding, if any). 
 *  For the HaloBorder class, the <code>borderThickness</code> style 
 *  usually determines the value of the <code>borderMetrics</code> style. 
 *  For graphical skin classes, Flex examines the <code>scale9Grid</code>
 *  property to determine the value of the <code>borderMetrics</code> style.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IBorder
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  borderMetrics
    //----------------------------------

    /**
     *  Returns an EdgeMetrics object for the border that has four properties:
     *  <code>left</code>, <code>top</code>, <code>right</code>,
     *  and <code>bottom</code>.
     *  The value of each property is equal to the thickness of one side
     *  of the border, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get borderMetrics():EdgeMetrics;

}

}
