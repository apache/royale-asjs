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
package 
{
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getQualifiedClassName;
    
    import mx.collections.ArrayCollection;
    import mx.core.IVisualElement;
    import mx.core.IVisualElementContainer;
    import mx.core.UIComponent;
    import mx.effects.CompositeEffect;
    import mx.effects.Effect;
    import mx.events.EffectEvent;
    import mx.geom.TransformOffsets;
    import mx.states.Transition;
    
    import spark.primitives.supportClasses.GraphicElement;
    
    /**
    * 
    * This class provides some APIs that can be useful for writing Mustella effects
    * and transitions tests.  This will be instrumental in the Catalyst matrix tests.
    * 
    * It might be useful to think about building a set of TestStep classes that wrap 
    * some of this functionality.
    */
    public class EffectTesting
    {
        // whether to seek the effect on effectStart (default: false)
        public static var requestedSeek:Boolean = false;
        
        // what time to seek to in an effect (default: NaN - seek to the end of the effect)
        public static var requestedSeekTime:Number = NaN;
        
        // the current effect being played
        [Bindable] public static var currentEffect:Effect;
        
        // the document that ready events will be dispatched from and transitions will be pulled from
        private static var rootDocument:UIComponent;
        
        // the character used to separate the elements in the expected values string
        private static var elementSeparator:String = "|";
        
        // the character used to separate the values in the expected values string
        private static var propertySeparator:String = ",";
        
        // keep track of the details of the latest comparison to ease further investigation
        private static var lastResult:ArrayCollection;
        
        /**
        * Sets up for an effect test.  This allows you to seek to a specific time in an effect.
        * 
        * Call this method after the ResetComponent in your (non-transition) effects test.
        */
        public static function setupEffectTest(document:Object, effect:Effect):String {
            
            // reset the test properties
            resetProperties(document);
            
            // null check the effect
            if (effect == null)
                throw new Error("ERROR: You must provide a non-null effect to test.");
            
            // set the current effect
            currentEffect = effect;
            
            // handle the effectEnd event
            currentEffect.removeEventListener(EffectEvent.EFFECT_END, handleEffectEnd);
            currentEffect.addEventListener(EffectEvent.EFFECT_END, handleEffectEnd);
            
            // dispatches a setupComplete event and returns setupComplete String so you can
            // use this with either an AssertMethodValue or RunCode in Mustella
            rootDocument.dispatchEvent(new Event('setupComplete'));
            return "setupComplete";
        }
        
        /**
         * Sets up for a transitions test.  This allows you to seek to a specific time in a transition.
         * 
         * It parses all of the transitions in a document and sets up event listeners in a way that allows
         * seeking to a specific time in the transition.
         * 
         * Call this method after the ResetComponent in your transitions test.
         */
        public static function setupTransitionTest(document:Object):String {
            
            resetProperties(document);
            
            var transitions:Array = rootDocument.transitions;
            
            // don't manage any listeners if there aren't any transitions
            if (transitions == null)
                throw new Error("ERROR: document has no transitions");

            // add event listeners to each transition
            for each (var t:Transition in transitions){
                
                // remove the effectStart event listener and add it again so we don't pile them up
                t.effect.removeEventListener(EffectEvent.EFFECT_START, handleEffectStart);
                t.effect.addEventListener(EffectEvent.EFFECT_START, handleEffectStart);
                
                // remove the effectEnd event listener and add it again so we don't pile them up
                t.effect.removeEventListener(EffectEvent.EFFECT_END, handleEffectEnd);
                t.effect.addEventListener(EffectEvent.EFFECT_END, handleEffectEnd);
            }
            
            // dispatches a setupComplete event and returns setupComplete String so you can
            // use this with either an AssertMethodValue or RunCode in Mustella
            rootDocument.dispatchEvent(new Event('setupComplete'));
            return "setupComplete";
        }
        
        /**
        * Called by the setup methods to reset the properties in this class
        */
        private static function resetProperties(document:Object):void {
            
            // null checks
            if (document == null)
                throw new Error("ERROR: You must provide a non-null document.");
            
            if (!(document is UIComponent))
                throw new Error("ERROR: document must be a UIComponent");
            
            // reset the rootDocument
            rootDocument = document as UIComponent;
            
            // reset the seek information
            requestedSeek = false;
            requestedSeekTime = NaN;
        }
        
        /**
        * Called on effect start, kicks off the seek behavior if it is requested.
        */
        private static function handleEffectStart(event:EffectEvent):void {
            trace('effect start');
            
            currentEffect = event.target as Effect;
            
            // seek if it was requested
            if (requestedSeek){
            
                // wait roughly a frame then pause the effect before seeking
                var timer:Timer = new Timer(0);
                timer.repeatCount = 1;
                timer.addEventListener(TimerEvent.TIMER, function(e:Event):void{ seekCurrentEffect(); });
                timer.start();
            }
        }
        
        /**
        * Pauses then seeks to the position in the current effect. Fires an event when that is done.
        */
        public static function seekCurrentEffect():void {
            var seekTime:Number = requestedSeekTime;
            var c:CompositeEffect = currentEffect as CompositeEffect;
            
            // seek to the end if a specific seek time was not requested
            if (isNaN(seekTime)){
                // set the seekTime to the end of the effect
                if (c){
                    // if its a Parallel/Sequence then use the compositeDuration that also handle startDelay
                    seekTime = c.compositeDuration;
                } else {
                    // just a plain effect so use startDelay + duration
                    seekTime = currentEffect.startDelay + currentEffect.duration;
                }
            }
            
            trace('effect seek to ' + seekTime);
            
            // pause then seek
            currentEffect.pause();
            currentEffect.playheadTime = seekTime;
            
            // dispatch a ready event on the document
            rootDocument.dispatchEvent(new Event("seekAssertionReady"));
        }
        
        /**
        * TODO: The inclusion of this method in the API is not fully baked.
        * This method's name/signature/existance could change in the future
        * when it is properly implemented.
        */
        public static function seekCurrentEffectTo(time:Number):void {
            currentEffect.playheadTime = time;
            rootDocument.dispatchEvent(new Event("seekAssertionReady"));
        }
        
        /**
         * TODO: The inclusion of this method in the API is not fully baked.
         * This method's name/signature/existance could change in the future
         * when it is properly implemented.
         */
        public static function getCurrentEffectDuration():Number {
            var c:CompositeEffect = currentEffect as CompositeEffect;
        
            if (c){
                // if its a Parallel/Sequence then use the compositeDuration that also handle startDelay
                return c.compositeDuration;
            } else {
                // just a plain effect so use startDelay + duration
                return currentEffect.startDelay + currentEffect.duration;
            }
        }
        
        /**
        * Resumes the current effect
        */
        public static function resumeCurrentEffect():void {
            trace("effect resume");
            currentEffect.resume();
        }
        
        /**
        * Fires an event after the effectEnd event that signifies an assertion is now valid.
        * 
        * In a transition this gets called after the state values have been slammed in. 
        */
        private static function handleEffectEnd(e:EffectEvent):void {
            trace('effect end');
            
            // dispatch a ready event on the document
            rootDocument.dispatchEvent(new Event("endAssertionReady"));
        }
        
        /**
        * Given a root element it compares a set of properties across that element and any of its ancestors.
        *
        * Sample usage:
        * 
        * assertPropertySet(test1, 'width, height', '70,22|10,10', 0)
        *   outputs: 'FAIL: test1.width: expected 70 +/- 0, but received 100') 
        * 
        * @param rootContainer - the root element to inspect
        * @param propertyNameString - a string deliminated with a character that lists the properties to inspect
        * @param expectedValuesString - a string deliminiated with a character that lists the values to expect
        * @param tolerance - the amount of difference between actual and expected is allowed before failure
        * @param depth - how deep to recurse in the rootContainer
        * 
        * @return - a string of either "PASS" or "FAIL: ..." with a failure message  
        */
        public static function assertPropertySet(rootContainer:IVisualElement, propertyNamesString:String, 
                                                expectedValuesString:String, tolerance:Number = 0, depth:int = -1):String {
            return checkPropertySet(rootContainer, false, propertyNamesString, expectedValuesString, tolerance, depth);
        }
        
        /**
        * Given a root element it compares a set of properties across that element and any of its ancestors
        * using the postLayoutTransformOffsets object of those elements.
        * 
        * Sample usage:
        * 
        * assertPostLayoutPropertySet(test1, 'rotationX, rotationY', '45,45|0,0', 0)
        *   outputs: 'FAIL: test1.rotationX: expected 45 +/- 0, but received 0')
        * 
        * Use null as an expected value if postLayoutTransformOffsets is null for example:
        *  -  properties: 'rotationX,rotationY'
        *  -  expected string: 'null,null|null,null'
        * 
        * @param rootContainer - the root element to inspect
        * @param propertyNameString - a string deliminated with a character that lists the properties to inspect
        * @param expectedValuesString - a string deliminiated with a character that lists the values to expect
        * @param tolerance - the amount of difference between actual and expected is allowed before failure
        * @param depth - how deep to recurse in the rootContainer
        * 
        * @return - a string of either "PASS" or "FAIL: ..." with a failure message
        */
        public static function assertPostLayoutPropertySet(rootContainer:IVisualElement, propertyNamesString:String, 
                                                          expectedValuesString:String, tolerance:Number = 0, depth:int = -1):String {
            return checkPropertySet(rootContainer, true, propertyNamesString, expectedValuesString, tolerance, depth);
        }
        
        /**
        * Workhorse method that is exposed via the two public assert methods.
        * 
        * Given a root element it compares a set of properties across that element and any of its ancestors
        * 
        * @param rootContainer - the root element to inspect
        * @param postLayout - whether to look at the postLayoutTransformOffsets object of an element
        * @param propertyNameString - a string deliminated with a character that lists the properties to inspect
        * @param expectedValuesString - a string deliminiated with a character that lists the values to expect
        * @param tolerance - the amount of difference between actual and expected is allowed before failure
        * @param depth - how deep to recurse in the rootContainer
        *  
        * @return - a string of either "PASS" or "FAIL: ..." with a failure message
        * 
        */
        private static function checkPropertySet(rootContainer:IVisualElement, postLayout:Boolean, propertyNamesString:String, 
                                    expectedValuesString:String, tolerance:Number = 0, depth:int = -1):String {
            
            // reset the result of the last comparison
            // add to this collection at any point a comparison happens
            lastResult = new ArrayCollection();
            
            // get the list of elements to inspect properties of 
            var elementsToInspect:Array = getElementsToInspect(rootContainer, depth);
            
            // get the list of properties to inspect on each element
            var propertyNames:Array = getPropertyNames(propertyNamesString);
            
            // split up the expectedValue string into values for each element
            var expectedElementValues:Array = expectedValuesString.split(elementSeparator);
            
            // string that represents the reason for fail
            var failString:String = "";
            
            if (elementsToInspect.length != expectedElementValues.length){
                // this will also catch existance failures, for example if an
                // element is supposed to be included or excluded from a state
                failString = "FAIL: number of elements (" + elementsToInspect.length + ") != number of expected elements (" + expectedElementValues.length + ")";
                logResult(failString);
                return failString;
            }
            
            // Go through each of the elements recursively in the rootContainer
            for (var i:int = 0; i < elementsToInspect.length; i++){
                var element:IVisualElement = elementsToInspect[i];
                var expectedPropertyValues:Array = expectedElementValues[i].split(propertySeparator);
                
                // check for a malformed expected string
                if (propertyNames.length != expectedPropertyValues.length){
                    failString = "FAIL: number of properties != number of expected values for " + getElementId(element);
                    logResult(failString);
                    return failString;
                }   
                
                // log that we are checking this property
                logResult(getElementId(element));
                
                // check each property value 
                for (var j:int = 0; j < propertyNames.length; j++){

                    var propertyName:String = propertyNames[j];
                    var e:* = expectedPropertyValues[j];
                    var a:*;
                    
                    // First need to decide whether to grab the property values from 
                    // the element or its postLayoutTransformOffsets
                    if (postLayout){
                        if (element.postLayoutTransformOffsets){
                            a = element.postLayoutTransformOffsets[propertyName];
                        } else {
                            a = null;
                        }
                    } else {
                        a = element[propertyName];                    
                    }
                    
                    // prepare the log object for this property
                    var logItem:Object = new Object();
                    logItem.target = getElementId(element);
                    logItem.propertyName = propertyName;
                    logItem.actual = a;
                    logItem.expected = e;
                    logItem.tolerance = tolerance;
                    logItem.postLayout = postLayout;
                    logItem.depth = "TODO"; // TODO: one day might want to keep track of the depth of this item
                    logItem.result = "Unknown";
                    
                    //
                    // String comparison
                    //
                    
                    // First just check if expected == actual via a simple string comparison.
                    // If so then move on to the next propertyName, otherwise investigate further
                    // via null and number comparisons.
                    if (String(e) == String(a)){
                        // this property passed
                        
                        // log the pass
                        logResult("PASS", logItem);
                        
                        continue;
                    }
                    
                    //
                    // Null comparison
                    //
                    
                    // expected == actual == null so this is fine, continue to next propertyName
                    if (e == 'null' && a == null){

                        // log the pass
                        logResult("PASS", logItem);
                        
                        continue;
                    }
                    
                    // expected or actual is null, but not both (because of above) so fail
                    if (e == 'null' || a == null){
                        failString = "FAIL: " + describeFailureLocation(element, propertyName, postLayout) + ": " + a + ", but expected " + e; 
                        
                        // log the fail
                        logResult(failString, logItem);
                        
                        return failString;
                    }
                    
                    //
                    // Number comparison
                    //
                    
                    // This approach assumes that it's ok treating undefined and NaN the same.
                    // This is because Number(undefined) gets turned into NaN, if this is a limitation
                    // might have to revisit this in the future.  
                    var expectedValue:Number = Number(e);
                    var actualValue:Number = Number(a);
                    
                    //
                    // NaN comparison
                    //
                    
                    // expected == actual == NaN, so this is fine, continue to next propertyName
                    if (isNaN(actualValue) && isNaN(expectedValue)){

                        // log the pass
                        logResult("PASS", logItem);
                        
                        continue;
                    }
                    
                    // expected or actual is NaN, but not both (because of above) so fail
                    if (isNaN(actualValue) || isNaN(expectedValue)){
                        failString = "FAIL: " + describeFailureLocation(element, propertyName, postLayout) + ": expected " + 
                            expectedValue + ' plus or minus ' + tolerance + ", but received " + actualValue;
                        
                        // log the fail
                        logResult(failString, logItem);
                        
                        return failString;
                    }
                    
                    //
                    // Number tolerance comparison
                    //
                    
                    // expected differs from actual by more than the tolerance so fail
                    if (Math.abs(actualValue - expectedValue) > tolerance){
                        failString = "FAIL: " + describeFailureLocation(element, propertyName, postLayout) + ": expected " + 
                            expectedValue + ' plus or minus ' + tolerance + ", but received " + actualValue;
                        
                        // log the fail
                        logResult(failString, logItem);
                        
                        return failString;
                    }
                    
                    // at this point the property passed
                    
                    // log the pass
                    logResult("PASS", logItem);
                }
                // at this point the element passed, no need to log here
            }
            
            return "PASS";
        }
        
        /**
        * Adds a result to the log.
        * 
        * @param result - a simple string to add to the log
        * @param details - an object that if not null is added to the log after setting details.result equal to the first parameter
        */
        private static function logResult(result:String, details:Object = null):void {
            if (details != null){
                details.result = result;
                lastResult.addItem(details);
            } else {
                lastResult.addItem(result);
            }
        }
        
        /**
        * Returns the log of the last assertion result
        */
        public static function getLastResult():ArrayCollection {
            return lastResult;
        }
        
        /**
        * Generates a string that describes what property of what element has failed.
        * 
        * ex: 
        *   target.width
        *   target.postLayoutTransformOffsets.width
        */
        private static function describeFailureLocation(element:IVisualElement, propertyName:String, postLayout:Boolean):String{
            var output:String = "";
            
            output += getElementId(element);
            
            if (postLayout)
                output += ".postLayoutTransformOffsets";
            
            output += "." + propertyName;
            
            return output;
        }
        
        /**
        * Given a root element and a string of property names this returns the formatted string of 
        * each property value against that element and all descendants in a format that the assertion
        * methods require.
        * 
        * @param rootContainer
        * @param propertyNamesString - ex: 'width, height, alpha'
        * @param postLayout - set to true if you want to access the properties of the postLayoutTransformOffsets
        * @param requestedDepth - the depth to recurse (-1 by default for full recursion)
        * 
        * @return string
        */
        public static function generatePropertySet(rootContainer:IVisualElement, propertyNamesString:String, postLayout:Boolean = false, requestedDepth:int = -1):String {
            // get the list of elements to inspect properties of 
            var elementsToInspect:Array = getElementsToInspect(rootContainer, requestedDepth);
            var propertyNames:Array = getPropertyNames(propertyNamesString);
            var output:String = "";
            
            // for each element
            for (var i:int = 0; i < elementsToInspect.length; i++){
                var e:IVisualElement = elementsToInspect[i];
                
                // for each property
                for (var j:int = 0; j < propertyNames.length; j++){
                    // the property name
                    var propertyName:String = propertyNames[j];
                    
                    // concatenate the value
                    if (postLayout){
                        if (e.postLayoutTransformOffsets){
                            // access the value via the transform offsets
                            output += e.postLayoutTransformOffsets[propertyName];
                        } else {
                            // the transform offsets are null
                            output += "null";
                        }
                    } else {
                        // access the value directly
                        output += e[propertyName];
                    }
                    
                    // concatenate the value separator
                    if (j < propertyNames.length - 1)
                        output += ",";
                }
                
                // concatenate the element separator
                if (i < elementsToInspect.length - 1)
                    output += elementSeparator;
            }
            
            return output;
        }
        
        /**
        * Returns an array of property names parsed from a comma separated string with 
        * spaces removed. 
        */
        private static function getPropertyNames(s:String):Array {
            // strip spaces
            while (s.indexOf(" ") != -1){
                s = s.replace(' ','');
            }
            
            return s.split(propertySeparator);
        }

        /**
        * Returns the id of an element, if one is not defined then it returns the class name
        */
        private static function getElementId(element:IVisualElement):String {
            var s:String = String(Object(element).id);

            return (s != "null") ? s : flash.utils.getQualifiedClassName(element).split("::")[1];
        }
        
        /**
        * Returns an array of all elements in a root element. If the element is not a
        * container then it just returns an array of that element.
        */
        public static function getElementsToInspect(root:IVisualElement, requestedDepth:int):Array {
            var output:Array = new Array();
            
            if (root is IVisualElementContainer){
                // if its a container then recursively get all the elements to requestedDepth 
                output = getDescendants(root as IVisualElementContainer, requestedDepth);
            } else {
                // just return the element
                output.push(root);
            }
            
            return output;
        }
        
        /**
        * Recursively generates an array of all elements in a given container (including itself) to a requested depth
        */
        private static function getDescendants(rootContainer:IVisualElementContainer, requestedDepth:int, depth:int = 0):Array{
            var output:Array = new Array();
            
            // push the container element
            output.push(rootContainer);
            
            // return if we've gone past the requested depth (and a requestedDepth of not -1)
            if (requestedDepth != -1 && (depth >= requestedDepth)){
                return output;
            }
            
            for (var i:int = 0; i < rootContainer.numElements; i++){
                var e:IVisualElement = rootContainer.getElementAt(i);
                if (e is IVisualElementContainer){
                    // recursively get the elements of the container
                    output = output.concat(getDescendants(e as IVisualElementContainer, requestedDepth, depth+1));
                } else {
                    // push the non-container element
                    output.push(e);
                }
            }

            return output;
        }
        
    }
}
