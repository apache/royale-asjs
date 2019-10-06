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
package testshim
{
    
    import org.apache.royale.reflection.MetaDataArgDefinition;
    import org.apache.royale.reflection.MetaDataDefinition;
    import org.apache.royale.reflection.MethodDefinition;
    import org.apache.royale.reflection.TypeDefinition;
    import org.apache.royale.reflection.describeType;
    
    import flexunit.framework.Assert;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class RoyaleUnitTestRunner
    {
        
        
        public static var swfVersion:uint=0;
        
        public static function getCurrentPlatform():String{
            COMPILE::SWF{
                return 'SWF';
            }
            COMPILE::JS{
                return 'JS';
            }
        
            //return '';
        }
    
        public static function consoleOut(message:String, type:String = 'log', ...args):void
        {
            args.unshift(message + '\n');
            COMPILE::JS {
                args.unshift('[JS]');
                console[type].apply(console, args);
            }
            COMPILE::SWF{
                import flash.external.ExternalInterface;
            
                if (ExternalInterface.available)
                {
                    try
                    {
                        args.unshift('[SWF]');
                        const method:String = 'console.' + type + '.apply';
                        ExternalInterface.call(method, null, args);
                    } catch (e:Error)
                    {
                    }
                }
            }
        }
        
        
    
        public static function getErrorStack(e:Error):String
        {
            var stack:*;
            COMPILE::JS {
                stack = e.stack
            }
            COMPILE::SWF{
                stack = e.getStackTrace();
            }
        
            return String(stack)
        }
        
        
        public function RoyaleUnitTestRunner(testerClass:Class, notificationReceiver:Function)
        {
            this.testerClass = testerClass;
            this.callback = notificationReceiver;
            prepare();
        }
        
        private var testerClass:Class;
        private var callback:Function;
        
        private var _testingName:String;
        public function get testingName():String
        {
            return _testingName;
        }
        
        private var _successCount:uint = 0;
        public function get successCount():uint
        {
            return _successCount;
        }
        
        private var _failCount:uint = 0;
        public function get failCount():uint
        {
            return _failCount;
        }
        
        private var _successfulAssertions:uint = 0;
        public function get successfulAssertions():uint
        {
            return _successfulAssertions;
        }
        
        private var beforeClassFunc:Function;
        private var afterClassFunc:Function;
        private var setupFunc:MethodDefinition;
        private var tearDownFunc:MethodDefinition;
        
        private var testMethods:Array = [];
        
        /**
         * @royaleignorecoercion Function
         */
        private function prepare():void
        {
            var typeDef:TypeDefinition = describeType(testerClass);
            _testingName = typeDef.name;
            var staticMethods:Array = typeDef.staticMethods;
            for each (var methodDef:MethodDefinition in staticMethods)
            {
                var beforeClass:Array = methodDef.retrieveMetaDataByName("BeforeClass");
                var afterClass:Array = methodDef.retrieveMetaDataByName("AfterClass");
                if (beforeClass.length)
                {
                    if (beforeClassFunc != null) throw new Error("BeforeClass used more than once in " + typeDef.qualifiedName);
                    beforeClassFunc = testerClass[methodDef.name] as Function;
                }
                if (afterClass.length)
                {
                    if (afterClassFunc != null) throw new Error("AfterClass used more than once in " + typeDef.qualifiedName);
                    afterClassFunc = testerClass[methodDef.name] as Function;
                }
            }
            var methods:Array = typeDef.methods;
            for each (methodDef in methods)
            {
                var beforeTests:Array = methodDef.retrieveMetaDataByName("Before");
                var afterTests:Array = methodDef.retrieveMetaDataByName("After");
                if (beforeTests.length)
                {
                    if (setupFunc != null) throw new Error("Before used more than once in " + typeDef.qualifiedName);
                    setupFunc = methodDef;
                }
                if (afterTests.length)
                {
                    if (tearDownFunc != null) throw new Error("After used more than once in " + typeDef.qualifiedName);
                    tearDownFunc = methodDef;
                }
                var test:Array = methodDef.retrieveMetaDataByName("Test");
                if (test.length)
                {
                    testMethods.push(methodDef);
                }
                testMethods.sortOn("name");
            }
            
            if (testMethods.length == 0)
            {
                throw new Error("Zero test methods detected in " + typeDef.qualifiedName + ", check to make sure -keep-as3-metadata is configured");
            }
        }
        
        private function begin():void
        {
            if (beforeClassFunc != null) beforeClassFunc();
        }
        
        /**
         * @royaleignorecoercion org.apache.royale.reflection.MethodDefinition
         */
        public function runTests():void
        {
            begin();
            var testInstance:Object = new testerClass();
            if (setupFunc != null)
            {
                testInstance[setupFunc.name]();
            }
            var i:uint = 0, l:uint = testMethods.length;
            
            for (; i < l; i++)
            {
                runRoyaleTest(_testingName, testInstance, testMethods[i] as MethodDefinition, callback);
            }
            
            if (tearDownFunc != null)
            {
                testInstance[tearDownFunc.name]();
            }
            end();
        }
        
        private function end():void
        {
            if (afterClassFunc != null) afterClassFunc();
        }
        

        
        /**
         * @royaleignorecoercion Function
         * @royaleignorecoercion org.apache.royale.reflection.MetaDataDefinition
         * @royaleignorecoercion org.apache.royale.reflection.MetaDataArgDefinition
         */
        private function runRoyaleTest(testClass:String, instance:Object, methodDef:MethodDefinition, callback:Function = null):void
        {
            var methodName:String = methodDef.name;
            consoleOut('running test in ' + testClass + ":" + methodName);
            var varianceMetas:Array = methodDef.retrieveMetaDataByName("TestVariance");
            
            
            var method:Function = instance[methodName] as Function;
            var preAssertCount:uint = Assert.assertionsMade;
            var result:TestResult = new TestResult();
            result.assertions = 0;
            result.pass = true;
            result.error = null;
            result.testClass = testClass;
            result.testMethod = methodName;
            
            while (varianceMetas.length)
            {
                var varianceMeta:MetaDataDefinition = varianceMetas.shift() as MetaDataDefinition;

                
                var varianceArgs:Array = varianceMeta.getArgsByKey("variance");
               
                var i:uint = 0, l:uint = varianceArgs.length;
                if (l)
                {
                    for (; i < l; i++) {
                        var target:String = varianceArgs[i] = varianceArgs[i].value;
                        if (target == getCurrentPlatform()) {
                            result.hasVariance = true;
                            result.varianceTarget = varianceArgs.join(",");
                        }
                    }
                }
                if (result.hasVariance)
                {
                    var descriptionArgs:Array = varianceMeta.getArgsByKey("description");
                    if (descriptionArgs.length) result.varianceDescription = "";
                    while (descriptionArgs.length)
                    {
                        var description:MetaDataArgDefinition = descriptionArgs.shift() as MetaDataArgDefinition;
                        result.varianceDescription += description.value;
                        if (descriptionArgs.length) result.varianceDescription += ", ";
                    }
                    break;
                }
            }
            //run the test method
            var stackStrace:String;
            try
            {
                //method.call(instance) is necessary as opposed to simply 'method()' if 'this' is used in js
                method.call(instance);
            } catch (e:Error)
            {
                result.pass = false;
                result.error = e.name + ":" + e.message;
                stackStrace = getErrorStack(e);
            }
            result.assertions = Assert.assertionsMade - preAssertCount;
            if (preAssertCount == Assert.assertionsMade)
            {
                result.warning = "WARNING: This test method appears to have zero Assertions";
            }
            if (result.pass) _successCount++;
            else _failCount++;
            _successfulAssertions += result.assertions;
            if (result.error)
            {
                consoleOut(methodName + '::' + result.error, 'warn', stackStrace);
            }
            if (result.warning)
            {
                consoleOut(methodName + '::' + result.warning, 'warn', stackStrace);
            }
            if (callback != null)
            {
                callback(result);
            }
        }
        
    }
}
