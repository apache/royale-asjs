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
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IEventDispatcher;

import mx.binding.BindingManager;
import mx.collections.IList;
import mx.core.ContainerCreationPolicy;
import mx.core.IChildList;
import mx.core.IDeferredContentOwner;
import mx.core.IMXMLObject;
import mx.core.ITransientDeferredInstance;
import mx.core.IUIComponent;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

[DefaultProperty("itemsFactory")]

/**
 *  Documentation is not currently available.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class AddItems extends OverrideBase implements IMXMLObject 
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Documentation is not currently available.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const FIRST:String = "first";

    /**
     *  Documentation is not currently available.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const LAST:String = "last";

    /**
     *  Documentation is not currently available.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const BEFORE:String = "before";

    /**
     *  Documentation is not currently available.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static const AFTER:String = "after";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function AddItems()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var document:Object;	
    
    /**
     *  @private
     */
    private var added:Boolean = false;

    /**
     *  @private
     */
    private var startIndex:int;
    
    /**
     *  @private
     */
    private var numAdded:int;

    /**
     *  @private
     */
    private var instanceCreated:Boolean = false;
    

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  creationPolicy
    //------------------------------------
    
    /**
     *  @private
     *  Storage for the creationPolicy property.
     */
    private var _creationPolicy:String = ContainerCreationPolicy.AUTO;

    [Inspectable(category="General")]

    /**
     *  The creation policy for the items.
     *  This property determines when the <code>itemsFactory</code> will create 
     *  the instance of the items.
     *  Flex uses this property only if you specify an <code>itemsFactory</code> property.
     *  The following values are valid:
     * 
     *  <p></p>
     * <table class="innertable">
     *     <tr><th>Value</th><th>Meaning</th></tr>
     *     <tr><td><code>auto</code></td><td>(default)Create the instance the 
     *         first time it is needed.</td></tr>
     *     <tr><td><code>all</code></td><td>Create the instance when the 
     *         application started up.</td></tr>
     *     <tr><td><code>none</code></td><td>Do not automatically create the instance. 
     *         You must call the <code>createInstance()</code> method to create 
     *         the instance.</td></tr>
     * </table>
     *
     *  @default "auto"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get creationPolicy():String
    {
        return _creationPolicy;
    }

    /**
     *  @private
     */
    public function set creationPolicy(value:String):void
    {
        _creationPolicy = value;

        if (_creationPolicy == ContainerCreationPolicy.ALL)
            createInstance();
    }

    //------------------------------------
    //  destructionPolicy
    //------------------------------------
    
    /**
     *  @private
     *  Storage for the destructionPolicy property.
     */
    private var _destructionPolicy:String = "never";

    [Inspectable(category="General")]

    /**
     *  The destruction policy for the items.
     *  This property determines when the <code>itemsFactory</code> will destroy
     *  the deferred instances it manages.  By default once instantiated, all
     *  instances are cached (destruction policy of 'never').
     *  Flex uses this property only if you specify an <code>itemsFactory</code> property.
     *  The following values are valid:
     * 
     *  <p></p>
     * <table class="innertable">
     *     <tr><th>Value</th><th>Meaning</th></tr>
     *     <tr><td><code>never</code></td><td>(default)Once created never destroy
     *        the instance.</td></tr>
     *     <tr><td><code>auto</code></td><td>Destroy the instance when the override
     *         no longer applies.</td></tr>
     * </table>
     *
     *  @default "never"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get destructionPolicy():String
    {
        return _destructionPolicy;
    }

    /**
     *  @private
     */
    public function set destructionPolicy(value:String):void
    {
        _destructionPolicy = value;
    }
    
    //------------------------------------
    //  destination
    //------------------------------------

    /**
     *  The object relative to which the child is added. This property is used
     *  in conjunction with the <code>position</code> property. 
     *  This property is optional; if
     *  you omit it, Flex uses the immediate parent of the <code>State</code>
     *  object, that is, the component that has the <code>states</code>
     *  property, or <code>&lt;mx:states&gt;</code>tag that specifies the State
     *  object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var destination:Object;
    
    //------------------------------------
    //  items
    //------------------------------------

    /**
     *  @private
     *  Storage for the items property
     */
    private var _items:*;

    [Inspectable(category="General")]

    /**
     *
     *  The items to be added.
     *  If you set this property, the items are created at app startup.
     *  Setting this property is equivalent to setting a <code>itemsFactory</code>
     *  property with a <code>creationPolicy</code> of <code>"all"</code>.
     *
     *  <p>Do not set this property if you set the <code>itemsFactory</code>
     *  property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get items():*
    {
        if (!_items && creationPolicy != ContainerCreationPolicy.NONE)
            createInstance();

        return _items;
    }

    /**
     *  @private
     */
    public function set items(value:*):void
    {
        _items = value;
    }
    
    //------------------------------------
    //  itemsDescriptor
    //------------------------------------
    
    /**
     *  @private
     *  Storage for the itemsDescriptor property.
     */
    private var _itemsDescriptor:Array;
    
    [Inspectable(category="General")]
    
    /**
     *
     * The descriptor that describes the items. 
     *
     *  <p>If you set this property, the items are instantiated at the time
     *  determined by the <code>creationPolicy</code> property.</p>
     *  
     *  <p>Do not set this property if you set the <code>items</code>
     *  property.
     *  This propety is the <code>AddItems</code> class default property.
     *  Setting this property with a <code>creationPolicy</code> of "all"
     *  is equivalent to setting a <code>items</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get itemsDescriptor():Array
    {
        return _itemsDescriptor;
    }
    
    /**
     *  @private
     */
    public function set itemsDescriptor(value:Array):void
    {
        _itemsDescriptor = value;
        
        if (creationPolicy == ContainerCreationPolicy.ALL)
            createInstance();
    }

    //------------------------------------
    //  itemsFactory
    //------------------------------------
    
    /**
     *  @private
     *  Storage for the itemsFactory property.
     */
    private var _itemsFactory:ITransientDeferredInstance;

    [Inspectable(category="General")]

    /**
     *
     * The factory that creates the items. 
     *
     *  <p>If you set this property, the items are instantiated at the time
     *  determined by the <code>creationPolicy</code> property.</p>
     *  
     *  <p>Do not set this property if you set the <code>items</code>
     *  property.
     *  This propety is the <code>AddItems</code> class default property.
     *  Setting this property with a <code>creationPolicy</code> of "all"
     *  is equivalent to setting a <code>items</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get itemsFactory():ITransientDeferredInstance
    {
        return _itemsFactory;
    }

    /**
     *  @private
     */
    public function set itemsFactory(value:ITransientDeferredInstance):void
    {
        _itemsFactory = value;

        if (creationPolicy == ContainerCreationPolicy.ALL)
            createInstance();
    }

    //------------------------------------
    //  position
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  The position of the child in the display list, relative to the
     *  object specified by the <code>relativeTo</code> property.
     *
     *  @default AddItems.LAST
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var position:String = AddItems.LAST;

    //------------------------------------
    //  isStyle
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  Denotes whether or not the collection represented by the 
     *  target property is a style.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var isStyle:Boolean = false;
    
    //------------------------------------
    //  isArray
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  Denotes whether or not the collection represented by the 
     *  target property is to be treated as a single array instance
     *  instead of a collection of items (the default).
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var isArray:Boolean = false;

    //------------------------------------
    //  vectorClass
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  When the collection represented by the target property is a
     *  Vector, vectorClass is the type of the target.  It is used to
     *  initialize the target property.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.5
     */
    public var vectorClass:Class;
    
    //------------------------------------
    //  propertyName
    //------------------------------------
    
    [Inspectable(category="General")]

    /**
     *  The name of the Array property that is being modified. If the <code>destination</code>
     *  property is a Group or Container, this property is optional. If not defined, the
     *  items will be added as children of the Group/Container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var propertyName:String;
    
    //------------------------------------
    //  relativeTo
    //------------------------------------
    
    [Inspectable(category="General")]

    /**
     *  The object relative to which the child is added. This property is only
     *  used when the <code>position</code> property is <code>AddItems.BEFORE</code>
     *  or <code>AddItems.AFTER</code>. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var relativeTo:Object;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates the items instance from the factory.
     *  You must use this method only if you specify a <code>targetItems</code>
     *  property and a <code>creationPolicy</code> value of <code>"none"</code>.
     *  Flex automatically calls this method if the <code>creationPolicy</code>
     *  property value is <code>"auto"</code> or <code>"all"</code>.
     *  If you call this method multiple times, the items instance is
     *  created only on the first call.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function createInstance():void
    {
        if (!instanceCreated && !_items && itemsFactory && !_itemsDescriptor)
        {
            instanceCreated = true;
            items = itemsFactory.getInstance();
        }
        else if (!instanceCreated && !_items && !itemsFactory && _itemsDescriptor)
        {
            instanceCreated = true;
            items = generateMXMLArray(document, itemsDescriptor, false);
        }
    }
    
	protected function generateMXMLObject(document:Object, data:Array):Object
	{
		var i:int = 0;
		var cls:Class = data[i++];
		var comp:Object = new cls();
		
		var m:int;
		var j:int;
		var name:String;
		var simple:*;
		var value:Object;
		var id:String;
		
		m = data[i++]; // num props
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			simple = data[i++];
			value = data[i++];
			if (simple === null)
				value = generateMXMLArray(document, value as Array);
			else if (simple === undefined)
				value = generateMXMLVector(document, value as Array);
			else if (simple == false)
				value = generateMXMLObject(document, value as Array);
			if (name == "id")
			{
				document[value] = comp;
				id = value as String;
				if (comp is IMXMLObject)
					continue;  // skip assigment to comp
				if (!("id" in comp))
					continue;
			}
			else if (name == "_id")
			{
				document[value] = comp;
				id = value as String;
				continue; // skip assignment to comp
			}
			comp[name] = value;
		}
		m = data[i++]; // num styles
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			simple = data[i++];
			value = data[i++];
			if (simple == null)
				value = generateMXMLArray(document, value as Array);
			else if (simple == false)
				value = generateMXMLObject(document, value as Array);
			comp.setStyle(name, value);
		}
		
		m = data[i++]; // num effects
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			simple = data[i++];
			value = data[i++];
			if (simple == null)
				value = generateMXMLArray(document, value as Array);
			else if (simple == false)
				value = generateMXMLObject(document, value as Array);
			comp.setStyle(name, value);
		}
		
		m = data[i++]; // num events
		for (j = 0; j < m; j++)
		{
			name = data[i++];
			value = data[i++];
			comp.addEventListener(name, value);
		}
		
		if (comp is IUIComponent)
		{
			if (comp.document == null)
				comp.document = document;
		}
		var children:Array = data[i++];
		if (children)
		{
			comp.generateMXMLInstances(document, children);
		}
		
		if (id)
		{
			document[id] = comp;
			mx.binding.BindingManager.executeBindings(document, id, comp); 
		}
		if (comp is IMXMLObject)
			comp.initialized(document, id);
		return comp;
	}
	
	public function generateMXMLVector(document:Object, data:Array, recursive:Boolean = true):*
	{
		var comps:Array;
		
		var n:int = data.length;
		var hint:* = data.shift();
		var generatorFunction:Function = data.shift();
		comps = generateMXMLArray(document, data, recursive);
		return generatorFunction(comps);
	}
	
	public function generateMXMLArray(document:Object, data:Array, recursive:Boolean = true):Array
	{
		var comps:Array = [];
		
		var n:int = data.length;
		var i:int = 0;
		while (i < n)
		{
			var cls:Class = data[i++];
			var comp:Object = new cls();
			
			var m:int;
			var j:int;
			var name:String;
			var simple:*;
			var value:Object;
			var id:String = null;
			
			m = data[i++]; // num props
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				simple = data[i++];
				value = data[i++];
				if (simple === null)
					value = generateMXMLArray(document, value as Array, recursive);
				else if (simple === undefined)
					value = generateMXMLVector(document, value as Array, recursive);
				else if (simple == false)
					value = generateMXMLObject(document, value as Array);
				if (name == "id")
				{
					document[value] = comp;
					id = value as String;
					if (comp is IMXMLObject)
						continue;  // skip assigment to comp
					try {
						if (!("id" in comp))
							continue;
					}
					catch (e:Error)
					{
						continue; // proxy subclasses might throw here
					}
				}
				if (name == "document" && !comp.document)
					comp.document = document;
				else if (name == "_id")
					id = value as String; // and don't assign to comp
				else
					comp[name] = value;
			}
			m = data[i++]; // num styles
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				simple = data[i++];
				value = data[i++];
				if (simple == null)
					value = generateMXMLArray(document, value as Array, recursive);
				else if (simple == false)
					value = generateMXMLObject(document, value as Array);
				comp.setStyle(name, value);
			}
			
			m = data[i++]; // num effects
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				simple = data[i++];
				value = data[i++];
				if (simple == null)
					value = generateMXMLArray(document, value as Array, recursive);
				else if (simple == false)
					value = generateMXMLObject(document, value as Array);
				comp.setStyle(name, value);
			}
			
			m = data[i++]; // num events
			for (j = 0; j < m; j++)
			{
				name = data[i++];
				value = data[i++];
				comp.addEventListener(name, value);
			}
			
			if (comp is IUIComponent)
			{
				if (comp.document == null)
					comp.document = document;
			}
			var children:Array = data[i++];
			if (children)
			{
				if (recursive)
					comp.generateMXMLInstances(document, children, recursive);
				else
					comp.setMXMLDescriptor(children);
			}
			
			if (id)
			{
				document[id] = comp;
				mx.binding.BindingManager.executeBindings(document, id, comp); 
			}
			if (comp is IMXMLObject)
				comp.initialized(document, id);
			comps.push(comp);
		}
		return comps;
	}
 
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function initialize():void
    {
        if (creationPolicy == ContainerCreationPolicy.AUTO)
            createInstance();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function apply(parent:UIComponent):void
    {
        var dest:* = getOverrideContext(destination, parent);
        var localItems:Array;
        
        added = false;
        parentContext = parent;
        
        // Early exit if destination is null.
        if (!dest)
        {
            if (destination != null && !applied)
            {
                // Our destination context is unavailable so we attempt to register
                // a listener on our parent document to detect when/if it becomes
                // valid.
                addContextListener(destination);
            }
            applied = true;
            return;
        }

        applied = true;
        destination = dest;
        
        // Coerce to array if not already an array, or we wish
        // to treat the array as *the* item to add (isArray == true)
        if (items is Array && !isArray)
            localItems = items;
        else
            localItems = [items];
        
        switch (position)
        {
            case FIRST:
                startIndex = 0;
                break;
            case LAST:
                startIndex = -1;
                break;
            case BEFORE:
                startIndex = getRelatedIndex(parent, dest);
                break;
            case AFTER:
                startIndex = getRelatedIndex(parent, dest) + 1;
                break;
        }    
        
        if ( (propertyName == null || propertyName == "mxmlContent") && (dest is IVisualElementContainer))
        {
            if (!addItemsToContentHolder(dest as IVisualElementContainer, localItems))
                return;
        }
        else if (propertyName == null && dest is IChildList)
        {
            addItemsToContainer(dest as IChildList, localItems);
        }
        else if (propertyName != null && !isStyle && dest[propertyName] is IList)
        {
            addItemsToIList(dest[propertyName], localItems);
        }
        else if (vectorClass)
        {
            addItemsToVector(dest, propertyName, localItems);
        }
        else
        {
            addItemsToArray(dest, propertyName, localItems);
        }
        
        added = true;
        numAdded = localItems.length;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function remove(parent:UIComponent):void
    {
        var dest:* = getOverrideContext(destination, parent);
        var localItems:Array;
        var i:int;
        
        if (!added)
        {
            if (dest == null)
            {
                // It seems our override is no longer active, but we were never
                // able to successfully apply ourselves, so remove our context
                // listener if applicable.
                removeContextListener();
            }
            else if (_waitingForDeferredContent)
            {
                // Or we were waiting around for deferred content of our target
                // to be created and it never happened, so we'll stop listening
                // for now.
                removeCreationCompleteListener();
            }
            applied = false;
            parentContext = null;
            return;
        }
                    
        // Coerce to array if not already an array, or we wish
        // to treat the array as *the* item to add (isArray == true)
        if (items is Array && !isArray)
            localItems = items;
        else
            localItems = [items];
             
        if ((propertyName == null || propertyName == "mxmlContent") && (dest is IVisualElementContainer))
        {
            for (i = 0; i < numAdded; i++)
            {
                if (IVisualElementContainer(dest).numElements > startIndex)
                    IVisualElementContainer(dest).removeElementAt(startIndex);
            }
        }
        else if (propertyName == null && dest is IChildList)
        {
            for (i = 0; i < numAdded; i++)
            {
                if (IChildList(dest).numChildren > startIndex)
                    IChildList(dest).removeChildAt(startIndex);
            }
        }
        else if (propertyName != null && !isStyle && dest[propertyName] is IList)
        {
            removeItemsFromIList(dest[propertyName] as IList);
        }
        else if (vectorClass)
        {
            var tempVector:Object = isStyle ? dest.getStyle(propertyName) : dest[propertyName];
                
            if (numAdded < tempVector.length) 
            {
                tempVector.splice(startIndex, numAdded);
                assign(dest, propertyName, tempVector);
            } 
            else
            {
                // For destinations like ArrayCollection we don't want to 
                // affect the vector in-place in some cases, as ListCollectionView a
                // attempts to compare the "before" and "after" state of the vector
                assign(dest, propertyName, new vectorClass());
            }      
        }
        else
        {
            var tempArray:Array = isStyle ? dest.getStyle(propertyName) : dest[propertyName];
                
            if (numAdded < tempArray.length) 
            {
                tempArray.splice(startIndex, numAdded);
                assign(dest, propertyName, tempArray);
            } 
            else
            {
                // For destinations like ArrayCollection we don't want to 
                // affect the array in-place in some cases, as ListCollectionView a
                // attempts to compare the "before" and "after" state of the array
                assign(dest, propertyName, []);
            }      
        }
        
        if (destructionPolicy == "auto")
            destroyInstance();
            
        // Clear our flags and override context.
        added = false;
        applied = false;
        parentContext = null;
    }
       
    /**
     *  @private
     */
    private function destroyInstance():void
    {
        if (_itemsFactory)
        {
            instanceCreated = false;
            items = null;
            _itemsFactory.reset();
        }
    }
    
    /**
     *  @private
     */
    protected function getObjectIndex(object:Object, dest:Object):int
    {
        try
        {
            if ((propertyName == null || propertyName == "mxmlContent") && (dest is IVisualElementContainer))
                return IVisualElementContainer(dest).getElementIndex(object as IVisualElement);
            
            if (propertyName == null && dest is IChildList)
                return IChildList(dest).getChildIndex(DisplayObject(object));
    
            if (propertyName != null && !isStyle && dest[propertyName] is IList)
                return IList(dest[propertyName].list).getItemIndex(object);
                
            if (propertyName != null && isStyle)
                return dest.getStyle(propertyName).indexOf(object);
            
            return dest[propertyName].indexOf(object);
        }
        catch(e:Error) {}
        return -1;
    }
  
    /**
     * @private 
     * Find the index of the relative object. If relativeTo is an array,
     * search for the first valid item's index.  This is used for stateful
     * documents where one or more relative siblings of the newly inserted
     * item may not be realized within the current state.
     */
    protected function getRelatedIndex(parent:UIComponent, dest:Object):int
    {
        var index:int = -1;
        if (relativeTo is Array)
        {
            for (var i:int = 0; ((i < relativeTo.length) && index < 0); i++)
            { 
                var relativeObject:Object = getOverrideContext(relativeTo[i], parent);
                index = getObjectIndex(relativeObject, dest);
            }
        }
        else
        {
            relativeObject = getOverrideContext(relativeTo, parent);
            index = getObjectIndex(relativeObject, dest);
        }
        return index;
    }
    
    private var _waitingForDeferredContent:Boolean = false;
    
    /**
     *  @private
     */
    protected function addItemsToContentHolder(dest:IVisualElementContainer, items:Array):Boolean
    {
        // If we are being asked to add more children to a deferred content owner,
        // but the deferred content has yet to be created, we will defer application
        // until it is safe to do so.
        if (dest is IDeferredContentOwner && dest is IEventDispatcher)
        {
            var dco:IDeferredContentOwner= dest as IDeferredContentOwner;
            if (!dco.deferredContentCreated)
            {
                IEventDispatcher(dest).addEventListener("contentCreationComplete", onDestinationContentCreated);
                _waitingForDeferredContent = true;
                return false;
            }            
        }
        
        if (startIndex == -1)
            startIndex = dest.numElements;
        
        for (var i:int = 0; i < items.length; i++)
            dest.addElementAt(items[i], startIndex + i);
        
        return true;
    }
       
    /**
     *  @private
     */
    protected function addItemsToContainer(dest:IChildList, items:Array):void
    {
        if (startIndex == -1)
            startIndex = dest.numChildren;
        
        for (var i:int = 0; i < items.length; i++)
            dest.addChildAt(items[i], startIndex + i);
    }
    
    /**
     *  @private
     */
    protected function addItemsToArray(dest:Object, propertyName:String, items:Array):void
    {
        var tempArray:Array = isStyle ? dest.getStyle(propertyName) : dest[propertyName];
        
        if (!tempArray)
            tempArray = [];
        
        if (startIndex == -1)
            startIndex = tempArray.length;
        
        for (var i:int  = 0; i < items.length; i++) 
            tempArray.splice(startIndex + i, 0, items[i]);
        
        assign(dest, propertyName, tempArray);
    }

    /**
     *  @private
     */
    protected function addItemsToVector(dest:Object, propertyName:String, items:Array):void
    {
        var tempVector:Object = isStyle ? dest.getStyle(propertyName) : dest[propertyName];
        
        if (!tempVector)
            tempVector = new vectorClass();
        
        if (startIndex == -1)
            startIndex = tempVector.length;
        
        for (var i:int  = 0; i < items.length; i++) 
            tempVector.splice(startIndex + i, 0, items[i]);
        
        assign(dest, propertyName, tempVector);
    }
    
    /**
     *  @private
     */
    protected function addItemsToIList(list:IList, items:Array):void
    {       
        if (startIndex == -1)
            startIndex = list.length;
        
        for (var i:int = 0; i < items.length; i++)
            list.addItemAt(items[i], startIndex + i);   
    }
    
    /**
     *  @private
     */
    protected function removeItemsFromIList(list:IList):void
    {
        for (var i:int = 0; i < numAdded; i++)
            list.removeItemAt(startIndex);
        
    }
    
    /**
     *  @private
     */
    protected function assign(dest:Object, propertyName:String, value:Object):void
    {
        if (isStyle)
        {
            dest.setStyle(propertyName, value);
            dest.styleChanged(propertyName);
            dest.notifyStyleChangeInChildren(propertyName, true);
        }
        else
        {
            dest[propertyName] = value;
        }
    }

    /**
     *  @private
     *  We've detected that our IDeferredContentOwnder target has created its
     *  content, so it's safe to apply our override content now.
     */
    private function onDestinationContentCreated(e:Event):void
    {
        if (parentContext)
        {
            removeCreationCompleteListener();
            apply(parentContext);
        }   
    }
    
    /**
     *  @private
     *  Remove our contentCreationComplete listener.
     */
    private function removeCreationCompleteListener():void
    {
        if (parentContext)
        {
            parentContext.removeEventListener("contentCreationComplete", onDestinationContentCreated);
            _waitingForDeferredContent = false;
        }   
    }
    
    /**
     *  IMXMLObject support
     */
    public function initialized(document:Object, id:String):void
    {
        this.document = document;
    }
    
}

}
