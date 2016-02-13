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

import mx.utils.StringUtil;

/**
 *  Represents a condition for a CSSSelector which is used to match a subset of
 *  components based on a particular property.
 * 
 *  @see mx.styles.CSSConditionKind
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class CSSCondition
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     * 
     *  @param kind The kind of condition. For valid values see the
     *  CSSConditionKind enumeration.
     *  @param value The condition value (without CSS syntax).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function CSSCondition(kind:String, value:String)
    {
        _kind = kind;
        _value = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  kind
    //----------------------------------

    /**
     *  @private
     */ 
    private var _kind:String;


    /**
     *  The kind of condition this instance represents. Options are class,
     *  id and pseudo.
     * 
     *  @see mx.styles.CSSConditionKind
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get kind():String
    {
        return _kind;
    }

    //----------------------------------
    //  specificity
    //----------------------------------

    /**
     *  Calculates the specificity of a conditional selector in a selector
     *  chain. The total specificity is used to determine the precedence when
     *  applying several matching style declarations. id conditions contribute
     *  100 points, pseudo and class conditions each contribute 10 points.
     *  Selectors with a higher specificity override selectors of lower
     *  specificity. If selectors have equal specificity, the declaration order
     *  determines the precedence (i.e. the last one wins).
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get specificity():int
    {
        if (kind == CSSConditionKind.ID)
            return 100;
        else if (kind == CSSConditionKind.CLASS)
            return 10;
        else if (kind == CSSConditionKind.PSEUDO)
            return 10;
        else
            return 0;
    }

    //----------------------------------
    //  value
    //----------------------------------

    /**
     *  @private
     */ 
    private var _value:String;

    /**
     *  The value of this condition without any CSS syntax. To get a String
     *  representation that includes CSS syntax, call the <code>toString()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get value():String
    {
        return _value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Determines whether this condition matches the given component.
     * 
     *  @param object The component to which the condition may apply.
     *  @return true if component is a match, otherwise false. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function matchesStyleClient(object:IAdvancedStyleClient):Boolean
    {
        if (kind == CSSConditionKind.CLASS)
        {
            const styleName:String = object.styleName as String;
            if (!styleName)
            {
                return false;
            }

            // Look for a match in a whitespace-delimited list of styleNames
            var index:int = styleName.indexOf(value);
            while (index != -1)
            {
                var next:int = index + value.length;

                // At start or after whitespace?
                if (index == 0 || StringUtil.isWhitespace(styleName.charAt(index - 1)))
                {
                    // At end or followed by whitespace?
                    if (next == styleName.length || StringUtil.isWhitespace(styleName.charAt(next)))
                    {
                        return true;
                    }
                }

                index = styleName.indexOf(value, next)
            }

            return false;
        }

        if (kind == CSSConditionKind.ID)
        {
            return (object.id == value);
        }

        if (kind == CSSConditionKind.PSEUDO)
        {
            return object.matchesCSSState(value);
        }

        return false;
    }

    /**
     * Returns a String representation of this condition.
     * 
     *  @return A String representation of this condition, including CSS syntax.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function toString():String
    {
        var s:String;

        if (kind == CSSConditionKind.CLASS)
            s = ("." + value);
        else if (kind == CSSConditionKind.ID)
            s = ("#" + value);
        else if (kind == CSSConditionKind.PSEUDO)
            s = (":" + value);
        else
            s = ""; 

        return s;
    }
}

}
