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

package spark.layouts
{

/**
 *  The HorizontalAlign class defines the possible values for the 
 *  <code>horizontalAlign</code> property of the VerticalLayout class.
 * 
 * @see VerticalLayout#horizontalAlign
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public final class HorizontalAlign
{   
    /**
     *  Align children to the left of the container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const LEFT:String = "left";

    /**
     *  Align children in the center of the container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const CENTER:String = "center";

    /**
     *  Align children to the right of the container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const RIGHT:String = "right";

    /**
     *  Justify the children with respect to the container.
     *  This uniformly sizes all children to be the same width as the 
     *  container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const JUSTIFY:String = "justify";

    /**
     *  Content justify the children with respect to the container.  
     *  This uniformly sizes all children to be the content width of the container.
     *  The content width of the container is the size of the largest child.
     *  If all children are smaller than the width of the container, then 
     *  all the children will be sized to the width of the container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const CONTENT_JUSTIFY:String = "contentJustify";
    
}

}
