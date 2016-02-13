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

package mx.states
{

import mx.core.UIComponent;
import mx.core.IDeferredInstance;
import mx.styles.IStyleClient;
import mx.styles.StyleManager;
import mx.core.IFlexModule;
import mx.styles.IStyleManager2;

/**
 *  The SetStyle class specifies a style that is in effect only during the parent view state.
 *  You use this class in the <code>overrides</code> property of the State class.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:SetStyle&gt;</code> tag
 *  has the following attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:SetStyle
 *   <b>Properties</b>
 *   name="null"
 *   target="null"
 *   value"null"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.states.State
 *  @see mx.states.SetEventHandler
 *  @see mx.states.SetProperty
 *  @see mx.effects.SetStyleAction
 *
 *  @includeExample examples/StatesExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SetStyle extends OverrideBase
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  This is a table of related properties.
     *  Whenever the property being overridden is found in this table,
     *  the related property is also saved and restored.
     */
    private static const RELATED_PROPERTIES:Object =
    {
        left: [ "x" ],
        top: [ "y" ],
        right: [ "x" ],
        bottom: [ "y" ]
    };
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target The object whose style is being set.
     *  By default, Flex uses the immediate parent of the State object.
     *
     *  @param name The style to set.
     *
     *  @param value The value of the style in the view state.
     * 
     *  @param valueFactory An optional write-only property from which to obtain 
     *  a shared value.  This is primarily used when this override's value is 
     *  shared by multiple states or state groups.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SetStyle(
            target:IStyleClient = null,
            name:String = null,
            value:Object = null,
            valueFactory:IDeferredInstance = null
    )
    {
        super();

        this.target = target;
        this.name = name;
        this.value = value;
        this.valueFactory = valueFactory;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Storage for the old style value.
     */
    private var oldValue:Object;
    
    /**
     *  @private
     *  True if old value was set as an inline style.
     */
    private var wasInline:Boolean;

    /**
     *  @private
     *  Storage for the old related property values, if used.
     */
    private var oldRelatedValues:Array;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  name
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *
     *  The name of the style to change.
     *  You must set this property, either in 
     *  the SetStyle constructor or by setting
     *  the property value directly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var name:String;

    //----------------------------------
    //  target
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *
     *  The object whose style is being changed.
     *  If the property value is <code>null</code>, Flex uses the
     *  immediate parent of the State object.
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var target:Object;

    /**
     *  The cached target for which we applied our override.
     *  We keep track of the applied target while applied since
     *  our target may be swapped out in the owning document and 
     *  we want to make sure we roll back the correct (original) 
     *  element. 
     *
     *  @private
     */
    private var appliedTarget:Object;
    
    //----------------------------------
    //  value
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  @private
     *  Storage for the style value.
     */
    public var _value:Object;
    
    /**
     *  The new value for the style.
     *
     *  @default undefined
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get value():Object
    {
        return _value;
    }

    /**
     *  @private
     */
    public function set value(val:Object):void
    {
        _value = val;
        
        // Reapply if necessary.
        if (applied) 
        {
            apply(parentContext);
        }
    }
    
    //----------------------------------
    //  valueFactory
    //----------------------------------
    
    /**
     *  An optional write-only property from which to obtain a shared value.  This 
     *  is primarily used when this override's value is shared by multiple states 
     *  or state groups. 
     *
     *  @default undefined
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 4
     */
    public function set valueFactory(factory:IDeferredInstance):void
    {
        // We instantiate immediately in order to retain the instantiation
        // behavior of a typical (unshared) value.  We may later enhance to
        // allow for deferred instantiation.
        if (factory)
            value = factory.getInstance();
    }
    
    //--------------------------------------------------------------------------
    //
    //  IOverride methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function apply(parent:UIComponent):void
    {
        parentContext = parent;
        var context:Object = getOverrideContext(target, parent);
        if (context != null)
        {
            appliedTarget = context;
            var obj:IStyleClient = IStyleClient(appliedTarget);
            
            var relatedProps:Array = RELATED_PROPERTIES[name] ?
                                     RELATED_PROPERTIES[name] :
                                     null;
    
            // Remember the original value so it can be restored later
            // after we are asked to remove our override (and only if we
            // aren't being asked to re-apply a value).
            if (!applied)
            {
                wasInline = obj.styleDeclaration && 
                    obj.styleDeclaration.getStyle(name) !== undefined;
                oldValue = wasInline ? obj.getStyle(name) : null;
            }
    
            if (relatedProps)
            {
                oldRelatedValues = [];
    
                for (var i:int = 0; i < relatedProps.length; i++)
                    oldRelatedValues[i] = obj[relatedProps[i]];
            }
    
            // Set new value
            if (value === null)
            {
                obj.clearStyle(name);
            }
            else if (oldValue is Number)
            {
                // The "value" for colors can be several different formats:
                // 0xNNNNNN, #NNNNNN or "red". We can't use
                // StyleManager.isColorStyle() because that only returns true
                // for inheriting color styles and misses non-inheriting styles like
                // backgroundColor.
                if (name.toLowerCase().indexOf("color") != -1)
                {
                    var styleManager:IStyleManager2;
                    if (obj is UIComponent)
                        styleManager = UIComponent(obj).styleManager;
                    else
                        styleManager = parent.styleManager;
                    
                    obj.setStyle(name, styleManager.getColorName(value));
                }
                else if (value is String && 
                         String(value).lastIndexOf("%") == 
                         String(value).length - 1)
                {
                    obj.setStyle(name, value);
                }
                else
                {
                    obj.setStyle(name, Number(value));
                }               
            }
            else if (oldValue is Boolean)
            {
                obj.setStyle(name, toBoolean(value));
            }
            else
            {
                obj.setStyle(name, value);
            }
            
            // Disable bindings for the base style if appropriate. If the binding
            // fires while our override is applied, the correct value will automatically
            // be applied when the binding is later enabled.
            enableBindings(obj, parent, name, false);
        }
        else if (!applied)
        {
            // Our target context is unavailable so we attempt to register
            // a listener on our parent document to detect when/if it becomes
            // valid.
            addContextListener(target);
        }
        
        // Save state in case our value or target is changed while applied. This
        // can occur when our value property is databound or when a target is 
        // deferred instantiated.
        applied = true;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function remove(parent:UIComponent):void
    {
        var obj:IStyleClient = IStyleClient(getOverrideContext(appliedTarget, parent));
        if (obj != null && appliedTarget)
        {
            if (wasInline)
            {
                // Restore the old value
                if (oldValue is Number)
                    obj.setStyle(name, Number(oldValue));
                else if (oldValue is Boolean)
                    obj.setStyle(name, toBoolean(oldValue));
                else if (oldValue === null)
                    obj.clearStyle(name);
                else
                    obj.setStyle(name, oldValue);
            }
            else
            {
                obj.clearStyle(name);
            }
    
            // Re-enable bindings for the base style if appropriate. If the binding
            // fired while our override was applied, the current value will automatically
            // be applied once enabled.
            enableBindings(obj, parent, name);
            
            var relatedProps:Array = RELATED_PROPERTIES[name] ?
                                     RELATED_PROPERTIES[name] :
                                     null;
    
            // Restore related property values, if needed
            if (relatedProps)
            {
                for (var i:int = 0; i < relatedProps.length; i++)
                {
                    obj[relatedProps[i]] = oldRelatedValues[i];
                }
            }
            
        }
        else
        {
            // It seems our override is no longer active, but we were never
            // able to successfully apply ourselves, so remove our context
            // listener if applicable.
            removeContextListener();
        }
        
        // Clear our flags and override context.
        applied = false;
        parentContext = null;
        appliedTarget = null;
    }

    /**
     *  @private
     *  Converts a value to a Boolean true/false.
     */
    private function toBoolean(value:Object):Boolean
    {
        if (value is String)
            return value.toLowerCase() == "true";

        return value != false;
    }
}

}
