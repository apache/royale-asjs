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
package flexUnitTests.binding
{

COMPILE::Royale{
    import flexUnitTests.binding.support.bindings.royale.SimpleBindingsA;
    import flexUnitTests.binding.support.bindings.royale.SimpleBindingsB;
    import flexUnitTests.binding.support.bindings.royale.FunctionBindingsA;
    import flexUnitTests.binding.support.bindings.royale.DeepBindingsA;
    import org.apache.royale.test.asserts.*;
}
COMPILE::Flex{
    import flexUnitTests.binding.support.bindings.flex.SimpleBindingsA;
    import flexUnitTests.binding.support.bindings.flex.SimpleBindingsB;
    import flexUnitTests.binding.support.bindings.flex.FunctionBindingsA;
    import flexUnitTests.binding.support.bindings.flex.DeepBindingsA;


    // reverse message arguments between RoyaleUnit and FlexUnit
    //wild card import does not seem to work here in Flex:
    //using specific imports:
    import royale.flexunitcompatible.asserts.assertEquals;
    import royale.flexunitcompatible.asserts.assertStrictlyEquals;
}

import flexUnitTests.binding.support.IBindingTest;
import flexUnitTests.binding.utils.BindingTestUtil;

/**
 * @royalesuppresspublicvarwarning
 */
public class BindingCoreTests
{


    [BeforeClass]
    public static function setUpBeforeClass():void
    {
        COMPILE::Royale{
            //Main is the Flex application
            BindingTestUtil.setTestParent(FlexUnitRoyaleApplication.getInstance().bindingsTestParent)
        }
        COMPILE::Flex{
            //Main is the Flex application
            BindingTestUtil.setTestParent(Main.getInstance().bindingsTestParent)
        }
    }

    [AfterClass]
    public static function tearDownAfterClass():void
    {
        BindingTestUtil.reset();
    }

    private var testInstance:Object;

    [Before]
    public function setUp():void
    {

    }

    [After]
    public function tearDown():void
    {
        if (testInstance) {
            BindingTestUtil.removeInstance(testInstance);
        }
    }

    private function createTestInstance(clazz:Class):IBindingTest{
        return (testInstance =  BindingTestUtil.createAndAddInstance(clazz)) as IBindingTest;
    }


    //no bindings, just test startup values
    [Test]
    public function testPlainLabel():void
    {

        var simpleBindings:IBindingTest = createTestInstance(SimpleBindingsA);

        //initial value should be '' for the Label
        //in flex this is null for Spark Label and '' for mx Label
        //using mx Label as 'expected' emulation ....
        assertEquals(simpleBindings.getBindingResultValue(0), '', 'Bad initial value in simple binding');


    }


    [Test]
    public function testSimpleBindings():void
    {
        var simpleBindings:IBindingTest = createTestInstance(SimpleBindingsA);

        //simpleBindings.labelText = 'testSimpleBindings';
        simpleBindings.setInboundValue('testSimpleBindings', 0);
        //simpleBindings.testLabel.text
        assertEquals(simpleBindings.getBindingResultValue(0), 'testSimpleBindings', 'Bad binding text value in simple binding');

        //simpleBindings.labelText = null;
        simpleBindings.setInboundValue(null, 0);
        //in flex this is null for Spark Label and '' for mx Label
        //using mx Label as 'expected' emulation ....
        assertEquals(simpleBindings.getBindingResultValue(0), '', 'Bad null inbound value in simple text binding');

        simpleBindings.setInboundValue(undefined, 0);
        //in flex this is null for Spark Label and '' for mx Label
        //using mx Label as 'expected' emulation ....
        assertEquals(simpleBindings.getBindingResultValue(0), '', 'Bad null inbound value in simple text binding');

    }


    [Test]
    public function testSimpleBindingsB():void
    {
        var simpleBindings:IBindingTest = createTestInstance(SimpleBindingsB);

        //simpleBindings.labelText = 'testSimpleBindings';
        simpleBindings.setInboundValue('setStringValue', 0);
        //simpleBindings.testLabel.text
        assertEquals(simpleBindings.getBindingResultValue(0), 'setStringValue', 'Bad binding text value in simple binding');
        assertEquals(simpleBindings.getBindingResultValue(1), 'setStringValue', 'Bad binding Object target value in simple binding');


        //this is not really a Binding test, more a mxml codgen  test, there were errors before a compiler fix:
        assertEquals(simpleBindings.getBindingResultValue(2), 'test', 'Bad codegen for fx:Object tag');

        simpleBindings.setInboundValue('testval', 2);
        assertEquals(simpleBindings.getBindingResultValue(2), 'testval', 'Bad codegen for fx:Object tag');
        simpleBindings.setInboundValue('testval', 3);
        assertEquals(simpleBindings.getBindingResultValue(3), 'testval', 'Bad codegen for fx:Object tag');


        simpleBindings.setInboundValue(99, 4);
        assertStrictlyEquals(simpleBindings.getBindingResultValue(4), 99, 'Bad binding numeric value in simple binding');
        simpleBindings.setInboundValue(99, 5);
        assertStrictlyEquals(simpleBindings.getBindingResultValue(5), '99', 'Bad binding text value in simple binding');


        simpleBindings.setInboundValue(99, 6);
        assertStrictlyEquals(simpleBindings.getBindingResultValue(6), 99, 'Bad binding numeric value in simple binding');

        simpleBindings.setInboundValue(99, 7);
        assertStrictlyEquals(simpleBindings.getBindingResultValue(7), 99, 'Bad binding numeric value in simple binding');

    }




    [Test]
    public function testDeepBindingsA():void
    {
        var deepBindings:IBindingTest = createTestInstance(DeepBindingsA);

        deepBindings.setInboundValue('setStringValue', 0);
        //deepBindings.testLabel.text
        assertEquals(deepBindings.getBindingResultValue(0), 'setStringValue', 'Bad binding text value in simple binding');
        assertEquals(deepBindings.getBindingResultValue(1), 'setStringValue', 'Bad binding Object target value in simple binding');

        deepBindings.setInboundValue(99, 2);
        assertStrictlyEquals(deepBindings.getBindingResultValue(2), 99, 'Bad binding numeric value in simple binding');
        deepBindings.setInboundValue(99, 3);
        assertStrictlyEquals(deepBindings.getBindingResultValue(3), '99', 'Bad binding text value in simple binding');


        deepBindings.setInboundValue(99, 4);
        assertStrictlyEquals(deepBindings.getBindingResultValue(4), 99, 'Bad binding numeric value in simple binding');


    }

    [Test]
    public function testFunctionBindingsA():void
    {
        var funcBindings:IBindingTest = createTestInstance(FunctionBindingsA);

        //check startup values for all
        assertEquals(funcBindings.getBindingResultValue(0), 'Internally false', 'Bad binding text value in function binding');
        assertEquals(funcBindings.getBindingResultValue(1), 'Internally false', 'Bad binding Object target value in function binding');

        assertEquals(funcBindings.getBindingResultValue(2), 'Inbound only', 'Bad binding text value in function binding');
        assertEquals(funcBindings.getBindingResultValue(3), 'Inbound only', 'Bad binding Object target value in function binding');

        assertEquals(funcBindings.getBindingResultValue(4), 'Internally false', 'Bad binding text value in function binding');
        assertEquals(funcBindings.getBindingResultValue(5), 'Internally false', 'Bad binding Object target value in function binding');

        assertEquals(funcBindings.getBindingResultValue(6), 'Inbound only', 'Bad binding text value in function binding');
        assertEquals(funcBindings.getBindingResultValue(7), 'Inbound only', 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(true,8); //changes:
        assertEquals(funcBindings.getBindingResultValue(8), 'Internally false', 'Bad binding text value in function binding');
        assertEquals(funcBindings.getBindingResultValue(9), 'Internally false', 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(true,10);

        assertEquals(funcBindings.getBindingResultValue(10), "Both are true", 'Bad binding text value in function binding');
        assertEquals(funcBindings.getBindingResultValue(11), "Both are true", 'Bad binding Object target value in function binding');

        //bindable2.bindableOne.toggle = value;
        funcBindings.setInboundValue(true,12);

        assertEquals(funcBindings.getBindingResultValue(12), 'Internally false', 'Bad binding text value in function binding');
        funcBindings.setInboundValue(true,13);
        assertEquals(funcBindings.getBindingResultValue(13), 'Internally false', 'Bad binding Object target value in function binding');
        funcBindings.setInboundValue(false,13);
        assertEquals(funcBindings.getBindingResultValue(13), 'Internally false', 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(true,14);
        assertEquals(funcBindings.getBindingResultValue(14), 'Internally false', 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(false,14);
        assertEquals(funcBindings.getBindingResultValue(14), 'Internally false', 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(true,15);
        assertEquals(funcBindings.getBindingResultValue(15), 'Internally false', 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(false,15);
        assertEquals(funcBindings.getBindingResultValue(15), 'Internally false', 'Bad binding Object target value in function binding');


        funcBindings.setInboundValue(true,16);
        assertEquals(funcBindings.getBindingResultValue(16), "Inbound only", 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(false,16);
        assertEquals(funcBindings.getBindingResultValue(16), "Inbound only", 'Bad binding Object target value in function binding');


        funcBindings.setInboundValue(true,17);
        assertEquals(funcBindings.getBindingResultValue(17), "Both are true", 'Bad binding Object target value in function binding');

        funcBindings.setInboundValue(false,17);
        assertEquals(funcBindings.getBindingResultValue(17), "Inbound only", 'Bad binding Object target value in function binding');

    }


}
}
