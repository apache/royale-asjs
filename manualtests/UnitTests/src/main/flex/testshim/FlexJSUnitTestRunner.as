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
package testshim {

import org.apache.flex.reflection.MetaDataArgDefinition;
import org.apache.flex.reflection.MetaDataDefinition;
import org.apache.flex.reflection.MethodDefinition;
import org.apache.flex.reflection.TypeDefinition;
import org.apache.flex.reflection.describeType;

import flexunit.framework.Assert;
public class FlexJSUnitTestRunner {


    public function FlexJSUnitTestRunner(testerClass:Class, notificationReceiver:Function) {
        this.testerClass = testerClass;
        this.callback = notificationReceiver;
        prepare();
    }

    private var testerClass:Class;
    private var callback:Function;

    private var _testingName:String;
    public function get testingName():String{
        return _testingName;
    }
    private var _successCount:uint=0;
    public function get successCount():uint {
        return _successCount;
    }

    private var _failCount:uint=0;
    public function get failCount():uint {
        return _failCount;
    }

    private var _successfulAssertions:uint=0;
    public function get successfulAssertions():uint {
        return _successfulAssertions;
    }

    private var beforeClassFunc:Function;
    private var afterClassFunc:Function;
    private var setupFunc:MethodDefinition;
    private var tearDownFunc:MethodDefinition;

    private var testMethods:Array=[];

    private function prepare():void{
        var typeDef:TypeDefinition = describeType(testerClass);
        _testingName = typeDef.name;
        var staticMethods:Array = typeDef.staticMethods;
        for each (var methodDef:MethodDefinition in staticMethods) {
            var beforeClass:Array = methodDef.retrieveMetaDataByName("BeforeClass");
            var afterClass:Array = methodDef.retrieveMetaDataByName("AfterClass");
            if ( beforeClass.length ) {
                if (beforeClassFunc!=null) throw new Error("BeforeClass used more than once in "+typeDef.qualifiedName);
                beforeClassFunc = testerClass[methodDef.name];
            }
            if ( afterClass.length ) {
                if (afterClassFunc!=null) throw new Error("AfterClass used more than once in "+typeDef.qualifiedName);
                afterClassFunc = testerClass[methodDef.name];
            }
        }
        var methods:Array = typeDef.methods;
        for each (methodDef in methods) {
            var beforeTests:Array = methodDef.retrieveMetaDataByName("Before");
            var afterTests:Array = methodDef.retrieveMetaDataByName("After");
            if ( beforeTests.length ) {
                if (setupFunc!=null) throw new Error("Before used more than once in "+typeDef.qualifiedName);
                setupFunc = methodDef;
            }
            if ( afterTests.length ) {
                if (tearDownFunc!=null) throw new Error("After used more than once in "+typeDef.qualifiedName);
                tearDownFunc = methodDef;
            }
            var test:Array = methodDef.retrieveMetaDataByName("Test");
            if (test.length) {
                testMethods.push(methodDef);
            }
            testMethods.sortOn("name");
        }

        if (testMethods.length == 0) {
            throw new Error("Zero test methods detected in "+typeDef.qualifiedName+", check to make sure -keep-as3-metadata is configured");
        }
    }

    private function begin():void {
        if (beforeClassFunc!=null) beforeClassFunc();
    }

    public function runTests():void{
        begin();
        var testInstance:Object = new testerClass();
        if (setupFunc!=null) {
            testInstance[setupFunc.name]();
        }
        var i:uint=0, l:uint=testMethods.length;

        for(;i<l;i++) {
            runFlexJSTest(_testingName,testInstance,testMethods[i],callback);
        }

        if (tearDownFunc!=null) {
            testInstance[tearDownFunc.name]();
        }
        end();
    }

    private function end():void{
        if (afterClassFunc!=null) afterClassFunc();
    }


    private function runFlexJSTest(testClass:String,instance:Object,methodDef:MethodDefinition,callback:Function=null):void{
        var methodName:String = methodDef.name;
        trace('running test in '+testClass+":"+methodName);
        var varianceMetas:Array = methodDef.retrieveMetaDataByName("TestVariance");
        
        var method:Function = instance[methodName];
        var preAssertCount:uint = Assert.assertionsMade;
        var result:TestResult = new TestResult();
        result.assertions = 0;
        result.pass = true;
        result.error = null;
        result.testClass = testClass;
        result.testMethod = methodName;

        while (varianceMetas.length) {
            var varianceMeta:MetaDataDefinition = varianceMetas.shift();
            var varianceArgs:Array = varianceMeta.getArgsByKey("variance");
            var i:uint=0, l:uint= varianceArgs.length;
            if (l) {
                result.hasVariance=true;
                for(;i<l;i++) varianceArgs[i] = varianceArgs[i].value;
                result.varianceTarget = varianceArgs.join(",");
            }
            if (result.hasVariance) {
                var descriptionArgs:Array= varianceMeta.getArgsByKey("description");
                if (descriptionArgs.length) result.varianceDescription = "";
                while(descriptionArgs.length) {
                    var description:MetaDataArgDefinition = descriptionArgs.shift();
                    result.varianceDescription +=description.value;
                    if (descriptionArgs.length) result.varianceDescription += ", ";
                }
            }
        }
        //run the test method
        try {
            method();
        } catch (e:Error) {
            result.pass=false;
            result.error = e.name+":" + e.message;
        }
        result.assertions = Assert.assertionsMade - preAssertCount;
        if (preAssertCount == Assert.assertionsMade) {
            result.warning = "WARNING: This test method appears to have zero Assertions";
        }
        if (result.pass) _successCount++;
        else _failCount++;
        _successfulAssertions += result.assertions;
        if (callback!=null) {
            callback(result);
        }
    }

}
}
