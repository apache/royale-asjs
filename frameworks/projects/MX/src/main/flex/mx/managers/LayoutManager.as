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

package mx.managers
{
COMPILE::SWF
{
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
}
COMPILE::JS
{
	import flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
}

import mx.core.ILayoutElement;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.events.DynamicEvent;
import mx.events.FlexEvent;
import mx.managers.layoutClasses.PriorityQueue;

CONFIG::performanceInstrumentation
{
import mx.utils.PerfUtil; 
}

use namespace mx_internal;

/**
 *  The LayoutManager is the engine behind
 *  Flex's measurement and layout strategy.
 *  Layout is performed in three phases; commit, measurement, and layout.
 *
 *  <p>Each phase is distinct from the others and all UIComponents of
 *  one phase are processed prior to moving on to the next phase.
 *  During the processing of UIComponents in a phase, requests for
 *  UIComponents to get re-processed by some phase may occur.
 *  These requests are queued and are only processed
 *  during the next run of the phase.</p>
 *
 *  <p>The <b>commit</b> phase begins with a call to
 *  <code>validateProperties()</code>, which walks through a list
 *  (reverse sorted by nesting level) of objects calling each object's
 *  <a href="../core/UIComponent.html#validateProperties()">
 *  <code>validateProperties()</code></a>method.</p>
 *
 *  <p>The objects in the list are processed in reversed nesting order,
 *  with the <b>least</b> deeply nested object accessed first.
 *  This can also be referred to as top-down or outside-in ordering.</p>
 *
 *  <p>This phase allows components whose contents depend on property
 *  settings to configure themselves prior to the measurement
 *  and the layout phases.
 *  For the sake of performance, sometimes a component's property setter
 *  method does not do all the work to update to the new property value.
 *  Instead, the property setter calls the <code>invalidateProperties()</code>
 *  method, deferring the work until this phase runs.
 *  This prevents unnecessary work if the property is set multiple times.</p>
 *
 *  <p>The <b>measurement</b> phase begins with a call to
 *  <code>validateSize()</code>, which walks through a list
 *  (sorted by nesting level) of objects calling each object's
 *  <a href="../core/UIComponent.html#validateSize()"><code>validateSize()</code></a>
 *  method to determine if the object has changed in size.</p>
 *
 *  <p>If an object's <a href="../core/UIComponent.html#invalidateSize()">
 *  <code>invalidateSize()</code></a> method was previously called,
 *  then the <code>validateSize()</code> method is called.
 *  If the size or position of the object was changed as a result of the
 *  <code>validateSize()</code> call, then the object's
 *  <a href="../core/UIComponent.html#invalidateDisplayList()">
 *  <code>invalidateDisplayList()</code></a> method is called, thus adding
 *  the object to the processing queue for the next run of the layout phase.
 *  Additionally, the object's parent is marked for both measurement
 *  and layout phases, by calling
 *  <a href="../core/UIComponent.html#invalidateSize()">
 *  <code>invalidateSize()</code></a> and
 *  <a href="../core/UIComponent.html#invalidateDisplayList()">
 *  <code>invalidateDisplayList()</code></a> respectively.</p>
 *
 *  <p>The objects in the list are processed by nesting order,
 *  with the <b>most</b> deeply nested object accessed first.
 *  This can also be referred to as bottom-up inside-out ordering.</p>
 *
 *  <p>The <b>layout</b> phase begins with a call to the 
 *  <code>validateDisplayList()</code> method, which walks through a list
 *  (reverse sorted by nesting level) of objects calling each object's
 *  <a href="../core/UIComponent.html#validateDisplayList()">
 *  <code>validateDisplayList()</code></a> method to request the object to size
 *  and position all components contained within it (i.e. its children).</p>
 *
 *  <p>If an object's <a href="../core/UIComponent.html#invalidateDisplayList()">
 *  <code>invalidateDisplayList()</code></a> method was previously called,
 *  then <code>validateDisplayList()</code> method for the object is called.</p>
 *
 *  <p>The objects in the list are processed in reversed nesting order,
 *  with the <b>least</b> deeply nested object accessed first.
 *  This can also be referred to as top-down or outside-in ordering.</p>
 *
 *  <p>In general, components do not override the <code>validateProperties()</code>, 
 *  <code>validateSize()</code>, or <code>validateDisplayList()</code> methods.  
 *  In the case of UIComponents, most components override the 
 *  <code>commitProperties()</code>, <code>measure()</code>, or 
 *  <code>updateDisplayList()</code> methods, which are called
 *  by the <code>validateProperties()</code>, 
 *  <code>validateSize()</code>, or 
 *  <code>validateDisplayList()</code> methods, respectively.</p>
 *
 *  <p>At application startup, a single instance of the LayoutManager is created
 *  and stored in the <code>UIComponent.layoutManager</code> property.  
 *  All components are expected to use that instance.  
 *  If you do not have access to the UIComponent object, 
 *  you can also access the LayoutManager using the static 
 *  <code>LayoutManager.getInstance()</code> method.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LayoutManager extends EventDispatcher implements ILayoutManager
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  The sole instance of this singleton class.
     */
    private static var instance:LayoutManager;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the sole instance of this singleton class,
     *  creating it if it does not already exist.
         *
         *  @return Returns the sole instance of this singleton class,
     *  creating it if it does not already exist.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
    public static function getInstance():LayoutManager
    {
        if (!instance)
            instance = new LayoutManager();

        return instance;
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @private
     */
    public function LayoutManager()
    {
        super();

        systemManager = SystemManagerGlobals.topLevelSystemManagers[0];
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  A queue of objects that need to dispatch updateComplete events
     *  when invalidation processing is complete
     */
    private var updateCompleteQueue:PriorityQueue = new PriorityQueue();

    /**
     *  @private
     *  A queue of objects to be processed during the first phase
     *  of invalidation processing, when an ILayoutManagerClient  has
     *  its validateProperties() method called (which in a UIComponent
     *  calls commitProperties()).
     *  Objects are added to this queue by invalidateProperties()
     *  and removed by validateProperties().
     */
    private var invalidatePropertiesQueue:PriorityQueue = new PriorityQueue();

    /**
     *  @private
     *  A flag indicating whether there are objects
     *  in the invalidatePropertiesQueue.
     *  It is set true by invalidateProperties()
     *  and set false by validateProperties().
     */
    private var invalidatePropertiesFlag:Boolean = false;

    // flag when in validateClient to check the properties queue again
    private var invalidateClientPropertiesFlag:Boolean = false;

    /**
     *  @private
     *  A queue of objects to be processed during the second phase
     *  of invalidation processing, when an ILayoutManagerClient  has
     *  its validateSize() method called (which in a UIComponent
     *  calls measure()).
     *  Objects are added to this queue by invalidateSize().
     *  and removed by validateSize().
     */
    private var invalidateSizeQueue:PriorityQueue = new PriorityQueue();

    /**
     *  @private
     *  A flag indicating whether there are objects
     *  in the invalidateSizeQueue.
     *  It is set true by invalidateSize()
     *  and set false by validateSize().
     */
    private var invalidateSizeFlag:Boolean = false;

    // flag when in validateClient to check the size queue again
    private var invalidateClientSizeFlag:Boolean = false;

    /**
     *  @private
     *  A queue of objects to be processed during the third phase
     *  of invalidation processing, when an ILayoutManagerClient  has
     *  its validateDisplayList() method called (which in a
     *  UIComponent calls updateDisplayList()).
     *  Objects are added to this queue by invalidateDisplayList()
     *  and removed by validateDisplayList().
     */
    private var invalidateDisplayListQueue:PriorityQueue = new PriorityQueue();

    /**
     *  @private
     *  A flag indicating whether there are objects
     *  in the invalidateDisplayListQueue.
     *  It is set true by invalidateDisplayList()
     *  and set false by validateDisplayList().
     */
    private var invalidateDisplayListFlag:Boolean = false;

    /**
     *  @private
     */
    private var waitedAFrame:Boolean = false;

    /**
     *  @private
     */
    private var listenersAttached:Boolean = false;

    /**
     *  @private
     */
    private var originalFrameRate:Number;

    /**
     *  @private
     *  used in validateClient to quickly estimate whether we have to
     *  search the queues again
     */
    private var targetLevel:int = int.MAX_VALUE;

    /**
     *  @private
     *  the top level systemmanager
     */
    private var systemManager:ISystemManager;

	/**
	 *  @private
	 *  the current object being validated
	 *  it could be wrong if the validating object calls validateNow on something.
	 */
	private var currentObject:ILayoutManagerClient;
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  usePhasedInstantiation
    //----------------------------------

    /**
     *  @private
     *  Storage for the usePhasedInstantiation property.
     */
    private var _usePhasedInstantiation:Boolean = false;

    /**
     *  A flag that indicates whether the LayoutManager allows screen updates
     *  between phases.
     *  If <code>true</code>, measurement and layout are done in phases, one phase
     *  per screen update.
     *  All components have their <code>validateProperties()</code> 
     *  and <code>commitProperties()</code> methods 
     *  called until all their properties are validated.  
     *  The screen will then be updated.  
     * 
     *  <p>Then all components will have their <code>validateSize()</code> 
     *  and <code>measure()</code>
     *  methods called until all components have been measured, then the screen
     *  will be updated again.  </p>
     *
     *  <p>Finally, all components will have their
     *  <code>validateDisplayList()</code> and 
     *  <code>updateDisplayList()</code> methods called until all components
     *  have been validated, and the screen will be updated again.  
     *  If in the validation of one phase, an earlier phase gets invalidated, 
     *  the LayoutManager starts over.  
     *  This is more efficient when large numbers of components
     *  are being created an initialized.  The framework is responsible for setting
     *  this property.</p>
     *
     *  <p>If <code>false</code>, all three phases are completed before the screen is updated.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get usePhasedInstantiation():Boolean
    {
        return _usePhasedInstantiation;
    }

    /**
     *  @private
     */
    public function set usePhasedInstantiation(value:Boolean):void
    {
        if (_usePhasedInstantiation != value)
        {
            _usePhasedInstantiation = value;

            // While we're doing phased instantiation, temporarily increase
            // the frame rate.  That will cause the enterFrame and render
            // events to fire more promptly, which improves performance.
			COMPILE::SWF
			{
            try {
                // can't use FlexGlobals here.  It may not be setup yet
                var stage:Stage = systemManager.stage;
                if (stage)
                {
                    if (value)
                    {
                        originalFrameRate = stage.frameRate;
                        stage.frameRate = 1000;
                    }
                    else
                    {
                        stage.frameRate = originalFrameRate;
                    }
                }
            }
            catch (e:SecurityError)
            {
                // trace("ignoring security error changing the framerate " + e);
            }
			}
        }
    }

    //----------------------------------
    //  debugHelper
    //----------------------------------
    
    /* 
    // LAYOUT_DEBUG
    import mx.managers.layoutClasses.LayoutDebugHelper;
    private static var _layoutDebugHelper:LayoutDebugHelper;
    
    public static function get debugHelper():LayoutDebugHelper
    {
        if (!_layoutDebugHelper)
        {
            _layoutDebugHelper = new LayoutDebugHelper();
            _layoutDebugHelper.mouseEnabled = false;
            var sm:ISystemManager = SystemManagerGlobals.topLevelSystemManagers[0]
            sm.addChild(_layoutDebugHelper);
        }
        return _layoutDebugHelper;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Invalidation
    //
    //--------------------------------------------------------------------------

    /**
     *  Adds an object to the list of components that want their 
     *  <code>validateProperties()</code> method called.
     *  A component should call this method when a property changes.  
     *  Typically, a property setter method
     *  stores a the new value in a temporary variable and calls 
     *  the <code>invalidateProperties()</code> method 
     *  so that its <code>validateProperties()</code> 
     *  and <code>commitProperties()</code> methods are called
     *  later, when the new value will actually be applied to the component and/or
     *  its children.  The advantage of this strategy is that often, more than one
     *  property is changed at a time and the properties may interact with each
     *  other, or repeat some code as they are applied, or need to be applied in
     *  a specific order.  This strategy allows the most efficient method of
     *  applying new property values.
     *
     *  @param obj The object whose property changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invalidateProperties(obj:ILayoutManagerClient ):void
    {
        if (!invalidatePropertiesFlag && systemManager)
        {
            invalidatePropertiesFlag = true;

            if (!listenersAttached)
                attachListeners(systemManager);
        }

        // trace("LayoutManager adding " + Object(obj) + " to invalidatePropertiesQueue");

        if (targetLevel <= obj.nestLevel)
            invalidateClientPropertiesFlag = true;

        invalidatePropertiesQueue.addObject(obj, obj.nestLevel);

        // trace("LayoutManager added " + Object(obj) + " to invalidatePropertiesQueue");
    }

    /**
     *  Adds an object to the list of components that want their 
     *  <code>validateSize()</code> method called.
     *  Called when an object's size changes.
     *
     *  <p>An object's size can change for two reasons:</p>
     *
     *  <ol>
     *    <li>The content of the object changes. For example, the size of a
     *    button changes when its <code>label</code> is changed.</li>
     *    <li>A script explicitly changes one of the following properties:
     *    <code>minWidth</code>, <code>minHeight</code>,
     *    <code>explicitWidth</code>, <code>explicitHeight</code>,
     *    <code>maxWidth</code>, or <code>maxHeight</code>.</li>
     *  </ol>
     *
     *  <p>When the first condition occurs, it's necessary to recalculate
     *  the measurements for the object.
     *  When the second occurs, it's not necessary to recalculate the
     *  measurements because the new size of the object is known.
     *  However, it's necessary to remeasure and relayout the object's
     *  parent.</p>
     *
     *  @param obj The object whose size changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invalidateSize(obj:ILayoutManagerClient ):void
    {
        if (!invalidateSizeFlag && systemManager)
        {
            invalidateSizeFlag = true;

            if (!listenersAttached)
            {
                attachListeners(systemManager);
            }
        }

        // trace("LayoutManager adding " + Object(obj) + " to invalidateSizeQueue");

        if (targetLevel <= obj.nestLevel)
            invalidateClientSizeFlag = true;

        invalidateSizeQueue.addObject(obj, obj.nestLevel);

        // trace("LayoutManager added " + Object(obj) + " to invalidateSizeQueue");
    }

    /**
     *  Called when a component changes in some way that its layout and/or visuals
     *  need to be changed.
     *  In that case, it is necessary to run the component's layout algorithm,
     *  even if the component's size hasn't changed.  For example, when a new child component
     *  is added, or a style property changes or the component has been given
     *  a new size by its parent.
     *
     *  @param obj The object that changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invalidateDisplayList(obj:ILayoutManagerClient ):void
    {
        if (!invalidateDisplayListFlag && systemManager)
        {
            invalidateDisplayListFlag = true;

            if (!listenersAttached)
            {
                attachListeners(systemManager);
            }
        }
        else if (!invalidateDisplayListFlag && !systemManager)
        {
            // trace("systemManager is null");
        }

        // trace("LayoutManager adding " + Object(obj) + " to invalidateDisplayListQueue");

        invalidateDisplayListQueue.addObject(obj, obj.nestLevel);

        // trace("LayoutManager added " + Object(obj) + " to invalidateDisplayListQueue");
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Commitment, measurement, layout, and drawing
    //
    //--------------------------------------------------------------------------

    /**
     *  Validates all components whose properties have changed and have called
     *  the <code>invalidateProperties()</code> method.  
     *  It calls the <code>validateProperties()</code> method on those components
     *  and will call <code>validateProperties()</code> on any other components that are 
     *  invalidated while validating other components.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function validateProperties():void
    {
        // trace("--- LayoutManager: validateProperties --->");
        CONFIG::performanceInstrumentation
        {
            var perfUtil:PerfUtil = PerfUtil.getInstance();
            perfUtil.markTime("validateProperties().start");
        }

        // Keep traversing the invalidatePropertiesQueue until we've reached the end.
        // More elements may get added to the queue while we're in this loop, or a
        // a recursive call to this function may remove elements from the queue while
        // we're in this loop.
        var obj:ILayoutManagerClient = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallest());
        while (obj)
        {
            // trace("LayoutManager calling validateProperties() on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);

            CONFIG::performanceInstrumentation
            {
                var token:int = perfUtil.markStart();
            }
            
			if (obj.nestLevel)
			{
				currentObject = obj;
	            obj.validateProperties();
	            if (!obj.updateCompletePendingFlag)
	            {
	                updateCompleteQueue.addObject(obj, obj.nestLevel);
	                obj.updateCompletePendingFlag = true;
	            }
			}            
            CONFIG::performanceInstrumentation
            {
                perfUtil.markEnd(".validateProperties()", token, 2 /*tolerance*/, obj);
            }

            // Once we start, don't stop.
            obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallest());
        }

        if (invalidatePropertiesQueue.isEmpty())
        {
            // trace("Properties Queue is empty");

            invalidatePropertiesFlag = false;
        }

        // trace("<--- LayoutManager: validateProperties ---");
        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("validateProperties().end");
        }
    }

    /**
     *  Validates all components whose properties have changed and have called
     *  the <code>invalidateSize()</code> method.  
     *  It calls the <code>validateSize()</code> method on those components
     *  and will call the <code>validateSize()</code> method 
     *  on any other components that are 
     *  invalidated while validating other components.  
     *  The </code>validateSize()</code> method  starts with
     *  the most deeply nested child in the tree of display objects
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function validateSize():void
    {
        // trace("--- LayoutManager: validateSize --->");
        CONFIG::performanceInstrumentation
        {
            var perfUtil:PerfUtil = PerfUtil.getInstance();
            perfUtil.markTime("validateSize().start");
        }

        var obj:ILayoutManagerClient = ILayoutManagerClient(invalidateSizeQueue.removeLargest());
        while (obj)
        {
            // trace("LayoutManager calling validateSize() on " + Object(obj));
            CONFIG::performanceInstrumentation
            {
                var objToken:int;
                if (PerfUtil.detailedSampling)
                    objToken = perfUtil.markStart();
            }
            
			if (obj.nestLevel)
			{
				currentObject = obj;
		        obj.validateSize();
		        if (!obj.updateCompletePendingFlag)
		        {
		            updateCompleteQueue.addObject(obj, obj.nestLevel);
		            obj.updateCompletePendingFlag = true;
		        }
			}

            CONFIG::performanceInstrumentation
            {
                if (PerfUtil.detailedSampling)
                    perfUtil.markEnd(".validateSize()", objToken, 2 /*tolerance*/, obj);
            }
            // trace("LayoutManager validateSize: " + Object(obj) + " " + IFlexDisplayObject(obj).measuredWidth + " " + IFlexDisplayObject(obj).measuredHeight);

            obj = ILayoutManagerClient(invalidateSizeQueue.removeLargest());
        }

        if (invalidateSizeQueue.isEmpty())
        {
            // trace("Measurement Queue is empty");

            invalidateSizeFlag = false;
        }

        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("validateSize().end");
        }
        // trace("<--- LayoutManager: validateSize ---");
    }

    /**
     *  Validates all components whose properties have changed and have called
     *  the <code>invalidateDisplayList()</code> method.  
     *  It calls <code>validateDisplayList()</code> method on those components
     *  and will call the <code>validateDisplayList()</code> method 
     *  on any other components that are 
     *  invalidated while validating other components.  
     *  The <code>validateDisplayList()</code> method starts with
     *  the least deeply nested child in the tree of display objects
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private function validateDisplayList():void
    {
        // trace("--- LayoutManager: validateDisplayList --->");        
        CONFIG::performanceInstrumentation
        {
            var perfUtil:PerfUtil = PerfUtil.getInstance();
            perfUtil.markTime("validateDisplayList().start");
        }

        var obj:ILayoutManagerClient = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallest());
        while (obj)
        {
            // trace("LayoutManager calling validateDisplayList on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);
            CONFIG::performanceInstrumentation
            {
                var objToken:int;
                if (PerfUtil.detailedSampling)
                    objToken = perfUtil.markStart();
            }
            
			if (obj.nestLevel)
			{
				currentObject = obj;
	            obj.validateDisplayList();
	            if (!obj.updateCompletePendingFlag)
	            {
	                updateCompleteQueue.addObject(obj, obj.nestLevel);
	                obj.updateCompletePendingFlag = true;
	            }
			}
            // trace("LayoutManager return from validateDisplayList on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);
            
            CONFIG::performanceInstrumentation
            {
                if (PerfUtil.detailedSampling)
                    perfUtil.markEnd(".validateDisplayList()", objToken, 2 /*tolerance*/, obj);
            }

            // Once we start, don't stop.
            obj = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallest());
        }


        if (invalidateDisplayListQueue.isEmpty())
        {
            // trace("Layout Queue is empty");

            invalidateDisplayListFlag = false;
        }

        CONFIG::performanceInstrumentation
        {
            perfUtil.markTime("validateDisplayList().end");
        }
        // trace("<--- LayoutManager: validateDisplayList ---");
    }

    /**
     *  @private
     */
    private function doPhasedInstantiation():void
    {
        // trace(">>DoPhasedInstantation");

        // If phasing, do only one phase: validateProperties(),
        // validateSize(), or validateDisplayList().
        if (usePhasedInstantiation)
        {
            if (invalidatePropertiesFlag)
            {
                validateProperties();

                // The Preloader listens for this event.
                systemManager.document.dispatchEvent(
                    new Event("validatePropertiesComplete"));
            }

            else if (invalidateSizeFlag)
            {
                validateSize();

                // The Preloader listens for this event.
                systemManager.document.dispatchEvent(
                    new Event("validateSizeComplete"));
            }

            else if (invalidateDisplayListFlag)
            {
                validateDisplayList();

                // The Preloader listens for this event.
                systemManager.document.dispatchEvent(
                    new Event("validateDisplayListComplete"));
            }
        }

        // Otherwise, do one pass of all three phases.
        else
        {
            if (invalidatePropertiesFlag)
                validateProperties();

            if (invalidateSizeFlag)
                validateSize();

            if (invalidateDisplayListFlag)
                validateDisplayList();
        }

        // trace("invalidatePropertiesFlag " + invalidatePropertiesFlag);
        // trace("invalidateSizeFlag " + invalidateSizeFlag);
        // trace("invalidateDisplayListFlag " + invalidateDisplayListFlag);

        if (invalidatePropertiesFlag ||
            invalidateSizeFlag ||
            invalidateDisplayListFlag)
        {
            attachListeners(systemManager);
        }
        else
        {
            usePhasedInstantiation = false;

			listenersAttached = false;

			var obj:ILayoutManagerClient = ILayoutManagerClient(updateCompleteQueue.removeLargest());
            while (obj)
            {
                if (!obj.initialized && obj.processedDescriptors)
                    obj.initialized = true;
                if (obj.hasEventListener(FlexEvent.UPDATE_COMPLETE))
                    obj.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
                obj.updateCompletePendingFlag = false;
                obj = ILayoutManagerClient(updateCompleteQueue.removeLargest());
            }

            // trace("updateComplete");

            dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
        }

        // trace("<<DoPhasedInstantation");
    }

    /**
     *  When properties are changed, components generally do not apply those changes immediately.
     *  Instead the components usually call one of the LayoutManager's invalidate methods and
     *  apply the properties at a later time.  The actual property you set can be read back
     *  immediately, but if the property affects other properties in the component or its
     *  children or parents, those other properties may not be immediately updated.  To
     *  guarantee that the values are updated, you can call the <code>validateNow()</code> method.  
     *  It updates all properties in all components before returning.  
     *  Call this method only when necessary as it is a computationally intensive call.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function validateNow():void
    {
        if (!usePhasedInstantiation)
        {
            var infiniteLoopGuard:int = 0;
            while (listenersAttached && infiniteLoopGuard++ < 100)
                doPhasedInstantiation();
        }
    }

    /**
     *  When properties are changed, components generally do not apply those changes immediately.
     *  Instead the components usually call one of the LayoutManager's invalidate methods and
     *  apply the properties at a later time.  The actual property you set can be read back
     *  immediately, but if the property affects other properties in the component or its
     *  children or parents, those other properties may not be immediately updated.  
     *
     *  <p>To guarantee that the values are updated, 
     *  you can call the <code>validateClient()</code> method.  
     *  It updates all properties in all components whose nest level is greater than or equal
     *  to the target component before returning.  
     *  Call this method only when necessary as it is a computationally intensive call.</p>
     *
     *  @param target The component passed in is used to test which components
     *  should be validated.  All components contained by this component will have their
     *  <code>validateProperties()</code>, <code>commitProperties()</code>, 
     *  <code>validateSize()</code>, <code>measure()</code>, 
     *  <code>validateDisplayList()</code>, 
     *  and <code>updateDisplayList()</code> methods called.
     *
     *    @param skipDisplayList If <code>true</code>, 
     *  does not call the <code>validateDisplayList()</code> 
     *  and <code>updateDisplayList()</code> methods.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function validateClient(target:ILayoutManagerClient, skipDisplayList:Boolean = false):void
    {
        CONFIG::performanceInstrumentation
        {
            var perfUtil:PerfUtil = PerfUtil.getInstance();
            var token:int = perfUtil.markStart();
        }

		var lastCurrentObject:ILayoutManagerClient = currentObject;
		
        var obj:ILayoutManagerClient;
        var i:int = 0;
        var done:Boolean = false;
        var oldTargetLevel:int = targetLevel;

        // the theory here is that most things that get validated are deep in the tree
        // and so there won't be nested calls to validateClient.  However if there is,
        // we don't want to have a more sophisticated scheme of keeping track
        // of dirty flags at each level that is being validated, but we definitely
        // do not want to keep scanning the queues unless we're pretty sure that
        // something might be dirty so we just say that if something got dirty
        // during this call at a deeper nesting than the first call to validateClient
        // then we'll scan the queues.  So we only change targetLevel if we're the
        // outer call to validateClient and only that call restores it.
        if (targetLevel == int.MAX_VALUE)
            targetLevel = target.nestLevel;

        // trace("--- LayoutManager: validateClient ---> target = " + target);

        while (!done)
        {
            // assume we won't find anything
            done = true;

            // Keep traversing the invalidatePropertiesQueue until we've reached the end.
            // More elements may get added to the queue while we're in this loop, or a
            // a recursive call to this function may remove elements from the queue while
            // we're in this loop.
            obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
            while (obj)
            {
                // trace("LayoutManager calling validateProperties() on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);

				if (obj.nestLevel)
				{
					currentObject = obj;
	                obj.validateProperties();
	                if (!obj.updateCompletePendingFlag)
	                {
	                    updateCompleteQueue.addObject(obj, obj.nestLevel);
	                    obj.updateCompletePendingFlag = true;
	                }
				}
				
                // Once we start, don't stop.
                obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
            }

            if (invalidatePropertiesQueue.isEmpty())
            {
                // trace("Properties Queue is empty");

                invalidatePropertiesFlag = false;
                invalidateClientPropertiesFlag = false;
            }
            
            // trace("--- LayoutManager: validateSize --->");

            obj = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(target));
            while (obj)
            {
                // trace("LayoutManager calling validateSize() on " + Object(obj));

				if (obj.nestLevel)
				{
					currentObject = obj;
	                obj.validateSize();
	                if (!obj.updateCompletePendingFlag)
	                {
	                    updateCompleteQueue.addObject(obj, obj.nestLevel);
	                    obj.updateCompletePendingFlag = true;
	                }
				}

                // trace("LayoutManager validateSize: " + Object(obj) + " " + IFlexDisplayObject(obj).measuredWidth + " " + IFlexDisplayObject(obj).measuredHeight);
                
                if (invalidateClientPropertiesFlag)
                {
                    // did any properties get invalidated while validating size?
                    obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
                    if (obj)
                    {
                        // re-queue it. we'll pull it at the beginning of the loop
                        invalidatePropertiesQueue.addObject(obj, obj.nestLevel);
                        done = false;
                        break;
                    }
                }
                
                obj = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(target));
            }

            if (invalidateSizeQueue.isEmpty())
            {
                // trace("Measurement Queue is empty");

                invalidateSizeFlag = false;
                invalidateClientSizeFlag = false;
            }

            if (!skipDisplayList)
            {
                // trace("--- LayoutManager: validateDisplayList --->");

                obj = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallestChild(target));
                while (obj)
                {
                    // trace("LayoutManager calling validateDisplayList on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);

					if (obj.nestLevel)
					{
						currentObject = obj;
	                    obj.validateDisplayList();
	                    if (!obj.updateCompletePendingFlag)
	                    {
	                        updateCompleteQueue.addObject(obj, obj.nestLevel);
	                        obj.updateCompletePendingFlag = true;
	                    }
					}
                    // trace("LayoutManager return from validateDisplayList on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);

                    if (invalidateClientPropertiesFlag)
                    {
                        // did any properties get invalidated while validating size?
                        obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
                        if (obj)
                        {
                            // re-queue it. we'll pull it at the beginning of the loop
                            invalidatePropertiesQueue.addObject(obj, obj.nestLevel);
                            done = false;
                            break;
                        }
                    }

                    if (invalidateClientSizeFlag)
                    {
                        obj = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(target));
                        if (obj)
                        {
                            // re-queue it. we'll pull it at the beginning of the loop
                            invalidateSizeQueue.addObject(obj, obj.nestLevel);
                            done = false;
                            break;
                        }
                    }

                    // Once we start, don't stop.
                    obj = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallestChild(target));
                }


                if (invalidateDisplayListQueue.isEmpty())
                {
                    // trace("Layout Queue is empty");

                    invalidateDisplayListFlag = false;
                }
            }
        }

        if (oldTargetLevel == int.MAX_VALUE)
        {
            targetLevel = int.MAX_VALUE;
            if (!skipDisplayList)
            {
                obj = ILayoutManagerClient(updateCompleteQueue.removeLargestChild(target));
                while (obj)
                {
                    if (!obj.initialized)
                        obj.initialized = true;
                    
                    if (obj.hasEventListener(FlexEvent.UPDATE_COMPLETE))
                        obj.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
                    obj.updateCompletePendingFlag = false;
                    obj = ILayoutManagerClient(updateCompleteQueue.removeLargestChild(target));
                }
            }
        }

		currentObject = lastCurrentObject;
		
        CONFIG::performanceInstrumentation
        {
            perfUtil.markEnd(" validateClient()", token, 2 /*tolerance*/, target);
        }
		
        // trace("<--- LayoutManager: validateClient --- target = " + target);
    }

    /**
     *  Returns <code>true</code> if there are components that need validating;
     *  <code>false</code> if all components have been validated.
         *
         *  @return Returns <code>true</code> if there are components that need validating;
     *  <code>false</code> if all components have been validated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function isInvalid():Boolean
    {
        return invalidatePropertiesFlag ||
               invalidateSizeFlag ||
               invalidateDisplayListFlag;
    }

    /**
     *  @private
     *  callLater() is called immediately after an object is created.
     *  We really want to wait one more frame before starting in.
     */
    private function waitAFrame(event:Event):void
    {
        // trace(">>LayoutManager:WaitAFrame");

        systemManager.removeEventListener(Event.ENTER_FRAME, waitAFrame);
        systemManager.addEventListener(Event.ENTER_FRAME, doPhasedInstantiationCallback);
        waitedAFrame = true;

        // trace("<<LayoutManager:WaitAFrame");
    }

    public function attachListeners(systemManager:ISystemManager):void
    {
        if (!waitedAFrame)
        {
            systemManager.addEventListener(Event.ENTER_FRAME, waitAFrame);
        }
        else
        {
            systemManager.addEventListener(Event.ENTER_FRAME, doPhasedInstantiationCallback);
            if (!usePhasedInstantiation)
            {
				COMPILE::SWF
				{
                if (systemManager && (systemManager.stage || usingBridge(systemManager)))
                {
                    systemManager.addEventListener(Event.RENDER, doPhasedInstantiationCallback);
                    if (systemManager.stage)
                        systemManager.stage.invalidate();
                }
				}
            }
        }

        listenersAttached = true;
    }

    private function doPhasedInstantiationCallback(event:Event):void
    {
        // if our background processing is suspended, then we shouldn't do any 
        // validation
        if (UIComponentGlobals.callLaterSuspendCount > 0)
            return;
        
        systemManager.removeEventListener(Event.ENTER_FRAME, doPhasedInstantiationCallback);
		COMPILE::SWF
		{
        systemManager.removeEventListener(Event.RENDER, doPhasedInstantiationCallback);		
		}

        if (!UIComponentGlobals.catchCallLaterExceptions)
        {
            doPhasedInstantiation();
        }

        else
        {
            try
            {
                doPhasedInstantiation();
            }
            catch(e:Error)
            {
                // Dispatch a callLaterError dynamic event for Design View. 
                var callLaterErrorEvent:DynamicEvent = new DynamicEvent("callLaterError");
                callLaterErrorEvent.error = e;
                callLaterErrorEvent.source = this; 
				callLaterErrorEvent.object = currentObject;
                systemManager.dispatchEvent(callLaterErrorEvent);
            }
        }
		currentObject = null;
    }

    private var _usingBridge:int = -1;

    /**
     *  @private
     */
    private function usingBridge(sm:ISystemManager):Boolean
    {
		COMPILE::LATER
		{	
        if (_usingBridge == 0) return false;
        if (_usingBridge == 1) return true;

        if (!sm) return false;

        // no types so no dependencies
        var mp:Object = sm.getImplementation("mx.managers::IMarshalSystemManager");
        if (!mp)
        {
            _usingBridge = 0;
            return false;
        }
        if (mp.useSWFBridge())
        {
            _usingBridge = 1;
            return true;
        }
        _usingBridge = 0;
		}
        return false;
    }

}

}

