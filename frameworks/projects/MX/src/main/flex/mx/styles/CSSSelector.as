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

import mx.core.mx_internal;

/**
 *  Represents a selector node in a potential chain of selectors used to match
 *  CSS style declarations to components.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class CSSSelector
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     * 
     *  @param subject The plain representation of this selector without
     *  conditions or ancestors. This is typically a fully-qualified class name; for example,
     *  "spark.components.Button". You can use "*" to match all components or "global" for a global selector.
     *  
     *  @param conditions  An optional Array of objects of type CSSCondition that is used to match a
     *  subset of component instances. Currently only a single or a pair of
     *  conditions are supported.
     * 
     *  @param ancestor An optional selector to match on a component that
     *  descends from an arbitrary ancestor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function CSSSelector(subject:String,
            conditions:Array=null, ancestor:CSSSelector=null)
    {
        _subject = subject;
        _conditions = conditions;
        _ancestor = ancestor;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  ancestor
    //----------------------------------

    /**
     *  @private
     */ 
    private var _ancestor:CSSSelector;

    /**
     *  If this selector is part of a descendant selector it may have a further
     *  selector defined for an arbitrary ancestor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get ancestor():CSSSelector
    {
        return _ancestor;
    }

    //----------------------------------
    //  conditions
    //----------------------------------

    /**
     *  @private
     */ 
    private var _conditions:Array; // of CSSCondition

    /**
     *  This selector may match a subset of components by specifying further
     *  conditions (for example, a matching component must have a particular id,
     *  styleName (equivalent to a 'class' condition in CSS) or state
     *  (equivalent to a 'pseudo' condition in CSS)).
     *  
     *  <p>If no conditions are specified, this property is null.</p>
     *  
     *  @return Array of CSSCondition specified for this selector.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get conditions():Array // of CSSCondition
    {
        return _conditions;
    }

    //----------------------------------
    //  specificity
    //----------------------------------

    /**
     *  Calculates the specificity of a selector chain in order to determine
     *  the precedence when applying several matching style declarations. Note
     *  that id conditions contribute 100 points, pseudo and class conditions
     *  each contribute 10 points, types (including descendants in a chain of
     *  selectors) contribute 1 point. Universal selectors ("*") contribute
     *  nothing. The result is the sum of these contributions. Selectors with a
     *  higher specificity override selectors of lower specificity. If
     *  selectors have equal specificity, the declaration order determines
     *  the precedence (the last one wins).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get specificity():int
    {
        var s:int = 0;

        if ("*" != subject && "global" != subject && "" != subject)
            s = 1;

        if (conditions != null)
        {
            for each (var condition:CSSCondition in conditions)
            {
                s += condition.specificity;
            }
        }

        if (ancestor != null)
            s += ancestor.specificity;

        return s;
    }

    //----------------------------------
    //  subject
    //----------------------------------

    /**
     *  @private
     */ 
    private var _subject:String;

    /**
     *  The subject of this selector node (only). To get a String representation
     *  of all conditions and descendants of this selector call the <code>toString()</code>
     *  method.
     * 
     *  <p>If this selector represents the root node of a potential chain of
     *  selectors, the subject also represents the subject of the entire selector
     *  expression.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get subject():String
    {
        return _subject;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Determines whether this selector matches the given component.
     * 
     *  @param object The component to which the selector may apply.
     *  @return true if component is a match, or false if not. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function matchesStyleClient(object:IAdvancedStyleClient):Boolean
    {
        var match:Boolean = false;
        var condition:CSSCondition = null;

        // If we have an ancestor then this is part of a descendant selector
        if (ancestor)
        {
            if (conditions)
            {
                // First, test if the conditions match
                for each (condition in conditions)
                {
                    match = condition.matchesStyleClient(object);
                    if (!match)
                        return false;
                }
            }

            // Then reset and test if any ancestor matches
            match = false;
            var parent:IAdvancedStyleClient = object.styleParent;
            while (parent != null)
            {
                if (parent.matchesCSSType(ancestor.subject)
                        || "*" == ancestor.subject)
                {
                    match = ancestor.matchesStyleClient(parent);
                    if (match)
                        break;
                }
                parent = parent.styleParent;
            }
        }
        else
        {
            // Check the type selector matches
            if (subject == "*" || subject == "" || object.matchesCSSType(subject))
            {
                match = true;
            }

            // Then check if any conditions match 
            if (match && conditions != null)
            {
                for each (condition in conditions)
                {
                    match = condition.matchesStyleClient(object);
                    if (!match)
                        return false;
                }
            }
        }

        return match;
    }

    /**
     *  @private
     */ 
    mx_internal function getPseudoCondition():String
    {
        var result:String = null;

        if (conditions)
        {
            for each (var condition:CSSCondition in conditions)
            {
                if (condition.kind == CSSConditionKind.PSEUDO)
                {
                    result = condition.value;
                    break;
                }
            }
        }

        return result;
    }

    /**
     *  Returns a String representation of this selector.
     *  
     *  @return A String representation of this selector including all of its
     *  syntax, conditions and ancestors.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function toString():String
    {
        var s:String;

        if (ancestor != null)
        {
            s = ancestor.toString() + " " + subject;
        }
        else
        {
            s = subject;
        }

        if (conditions != null)
        {
            for each (var condition:CSSCondition in conditions)
            {
                s += condition.toString();
            }
        }

        return s; 
    }
}

}
