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

package mx.styles
{

/**
 *  An enumeration of the kinds of CSSCondition.
 * 
 *  @see mx.styles.CSSCondition
 *  @see mx.styles.CSSSelector
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
final public class CSSConditionKind
{
    /**
     *  A selector condition to match a component by styleName.
     *  Examples:
     *      Button.special { ... }
     *      .special { ... }
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const CLASS:String = "class";

    /**
     *  A selector condition to match a component by id.
     *  Examples:
     *      Button#special { ... }
     *      #special { ... }
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const ID:String = "id";

    /**
     *  A selector condition to match a component by state (which may be
     *  dynamic and change over time).
     *  Examples:
     *      Button:special { ... }
     *      :special { ... }
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public static const PSEUDO:String = "pseudo";

    /**
     *  Constructor. Not used.
     *  @private
     */   
    public function CSSConditionKind()
    {
    }
}
}
