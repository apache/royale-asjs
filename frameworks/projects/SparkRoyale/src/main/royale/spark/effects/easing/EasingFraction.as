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
package spark.effects.easing
{
/**
 *  The EasingFraction class defines constants for 
 *  the <code>easeInFraction</code> property of the EaseInOutBase class.
 * 
 *  @see EaseInOutBase
 *  @see EaseInOutBase#easeInFraction
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public final class EasingFraction
{
    /**
     *  Specifies that the easing instance
     *  spends the entire animation easing in. This is equivalent
     *  to setting the <code>easeInFraction</code> property to 1.0.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const IN:Number = 1;

    /**
     *  Specifies that the easing instance
     *  spends the entire animation easing out. This is equivalent
     *  to setting the <code>easeInFraction</code> property to 0.0.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const OUT:Number = 0;

    /**
     *  Specifies that an easing instance
     *  that eases in for the first half and eases out for the
     *  remainder. This is equivalent
     *  to setting the <code>easeInFraction</code> property to 0.5.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const IN_OUT:Number = 0.5;
}
}
