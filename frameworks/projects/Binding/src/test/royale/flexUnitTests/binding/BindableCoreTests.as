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
    import org.apache.royale.test.asserts.*;
    import org.apache.royale.events.IEventDispatcher;
}

COMPILE::Flex{
    import royale.flexunitcompatible.asserts.*;
    import flash.events.IEventDispatcher;
}



import flexUnitTests.binding.support.bindables.*;
import flexUnitTests.binding.utils.BindableTestUtil;

public class BindableCoreTests
{


    public static var testUtil:BindableTestUtil;

    [BeforeClass]
    public static function setUpBeforeClass():void
    {
        testUtil = BindableTestUtil.instance;
    }

    [AfterClass]
    public static function tearDownAfterClass():void
    {
        testUtil.reset();
        testUtil = null;
    }

    [Before]
    public function setUp():void
    {

    }

    [After]
    public function tearDown():void
    {
        testUtil.reset();
    }

    //no bindings, UnBindable is not IEventDispatcher
    [Test]
    public function testBasicUnbindable():void
    {
        var unbindable:UnbindableBase = new UnbindableBase();

        assertFalse(unbindable is IEventDispatcher, 'unbindable should not have IEventDispatcher-ness')
    }

    [Test]
    public function testBasicBindableVar():void
    {
        // a variable member is marked [Bindable], but the class itself is not
        testUtil.reset();
        var bindable:BaseWithBindableVar = new BaseWithBindableVar();

        assertTrue(bindable is IEventDispatcher, 'bindable should have IEventDispatcher-ness');

        var bindableDispatcher:IEventDispatcher = bindable as IEventDispatcher;
        testUtil.listenTo(bindableDispatcher, BindableTestUtil.VALUE_CHANGE_EVENT);

        bindable.bindableVarOfBaseWithBindableVar = 'a new assigned value';
        bindable.bindableVarOfBaseWithBindableVar = 'a second assigned value';

        var expected:String =
                '0:ValueChangeEvent::property(bindableVarOfBaseWithBindableVar), oldVal:(bindableVarOfBaseWithBindableVar_value), newValue:(a new assigned value)\n' +
                '1:ValueChangeEvent::property(bindableVarOfBaseWithBindableVar), oldVal:(a new assigned value), newValue:(a second assigned value)';

        assertEquals(testUtil.getSequenceString(), expected, 'Unexpected results from changes to a "bindable"');

        testUtil.reset();
    }

    [Test]
    public function testBasicBindableClass():void
    {
        // a class is marked [Bindable], but not its variable member(s)
        testUtil.reset();
        var bindable:BaseWithBindableClass = new BaseWithBindableClass();

        assertTrue(bindable is IEventDispatcher, 'bindable should have IEventDispatcher-ness');

        var bindableDispatcher:IEventDispatcher = bindable as IEventDispatcher;
        testUtil.listenTo(bindableDispatcher, BindableTestUtil.VALUE_CHANGE_EVENT);

        bindable.varOfBaseWithBindableClass = 'a new assigned value';
        bindable.varOfBaseWithBindableClass = 'a second assigned value';

        var expected:String =
                '0:ValueChangeEvent::property(varOfBaseWithBindableClass), oldVal:(varOfBaseWithBindableClass_value), newValue:(a new assigned value)\n' +
                '1:ValueChangeEvent::property(varOfBaseWithBindableClass), oldVal:(a new assigned value), newValue:(a second assigned value)';

        assertEquals(testUtil.getSequenceString(), expected, 'Unexpected results from changes to a "bindable"');

        testUtil.reset();
    }


    [Test]
    public function testBasicBindableAndUnbindableVar():void
    {
        // a variable member is marked [Bindable] and another is not, and the class itself is not [Bindable]
        testUtil.reset();
        var bindable:BaseWithBindableAndUnbindableVars = new BaseWithBindableAndUnbindableVars();

        assertTrue(bindable is IEventDispatcher, 'bindable should have IEventDispatcher-ness');

        var bindableDispatcher:IEventDispatcher = bindable as IEventDispatcher;
        testUtil.listenTo(bindableDispatcher, BindableTestUtil.VALUE_CHANGE_EVENT);

        bindable.bindableVarOfBaseWithBindableAndUnbindableVars = 'a new assigned value for bindable';
        bindable.unbindableVarOfBaseWithBindableAndUnbindableVars = 'a new assigned value for unbindable';
        bindable.bindableVarOfBaseWithBindableAndUnbindableVars = 'a second assigned value for bindable';
        bindable.unbindableVarOfBaseWithBindableAndUnbindableVars = 'a second assigned value for unbindable';
        //events are only expected from the Bindable member:
        var expected:String =
                '0:ValueChangeEvent::property(bindableVarOfBaseWithBindableAndUnbindableVars), oldVal:(bindableVarOfBaseWithBindableAndUnbindableVars_value), newValue:(a new assigned value for bindable)\n' +
                '1:ValueChangeEvent::property(bindableVarOfBaseWithBindableAndUnbindableVars), oldVal:(a new assigned value for bindable), newValue:(a second assigned value for bindable)';

        assertEquals(testUtil.getSequenceString(), expected, 'Unexpected results from changes to a "bindable"');

        testUtil.reset();
    }

    [Test]
    public function testBasicBindableGetter():void
    {
        // an accessor member is marked [Bindable], but the class itself is not
        testUtil.reset();
        var bindable:BaseWithBindableGetter = new BaseWithBindableGetter();

        assertTrue(bindable is IEventDispatcher, 'bindable should have IEventDispatcher-ness');

        var bindableDispatcher:IEventDispatcher = bindable as IEventDispatcher;
        testUtil.listenTo(bindableDispatcher, BindableTestUtil.VALUE_CHANGE_EVENT);

        bindable.accessorOfBaseWithBindableGetter = 'a new assigned value';
        bindable.accessorOfBaseWithBindableGetter = 'a second assigned value';


        var expected:String =
                '0:history:accessing value from original getter , accessorOfBaseWithBindableGetter_value\n' +
                '1:history:assigning value in original setter , a new assigned value\n' +
                '2:ValueChangeEvent::property(accessorOfBaseWithBindableGetter), oldVal:(accessorOfBaseWithBindableGetter_value), newValue:(a new assigned value)\n' +
                '3:history:accessing value from original getter , a new assigned value\n' +
                '4:history:assigning value in original setter , a second assigned value\n' +
                '5:ValueChangeEvent::property(accessorOfBaseWithBindableGetter), oldVal:(a new assigned value), newValue:(a second assigned value)';

        assertEquals(testUtil.getSequenceString(), expected, 'Unexpected results from changes to a "bindable"');

        testUtil.reset();
    }


    [Test]
    public function testBasicBindableGetterVariations():void
    {
        // an accessor member is marked [Bindable], but the class itself is not
        testUtil.reset();
        var bindable:BaseWithBindableGetter = new BaseWithBindableGetter();

        assertTrue(bindable is IEventDispatcher, 'bindable should have IEventDispatcher-ness');

        var bindableDispatcher:IEventDispatcher = bindable as IEventDispatcher;
        testUtil.listenTo(bindableDispatcher, BindableTestUtil.VALUE_CHANGE_EVENT);
        testUtil.listenTo(bindableDispatcher,'testEvent');
        testUtil.listenTo(bindableDispatcher,'somethingChanged');

        bindable.accessorOfBaseWithBindableGetter2 = 'a new assigned value';
        bindable.accessorOfBaseWithBindableGetter2 = 'a second assigned value';
        bindable.something = 'this does not dispatch';



        var expected:String =
                '0:history:accessing value from original getter , _accessorOfBaseWithBindableGetter2_value\n' +
                '1:history:assigning value in original setter , a new assigned value\n' +
                '2:Event(type="testEvent", bubbles=false, cancelable=false)\n' +
                '3:ValueChangeEvent::property(accessorOfBaseWithBindableGetter2), oldVal:(_accessorOfBaseWithBindableGetter2_value), newValue:(a new assigned value)\n' +
                '4:history:accessing value from original getter , a new assigned value\n' +
                '5:history:assigning value in original setter , a second assigned value\n' +
                '6:Event(type="testEvent", bubbles=false, cancelable=false)\n' +
                '7:ValueChangeEvent::property(accessorOfBaseWithBindableGetter2), oldVal:(a new assigned value), newValue:(a second assigned value)';

        assertEquals(testUtil.getSequenceString(), expected, 'Unexpected results from changes to a "bindable"');

        testUtil.reset();
    }



    [Test]
    public function testBasicBindableClassGetter():void
    {
        // a class is marked [Bindable], but not its accessor member(s)
        testUtil.reset();
        var bindable:BaseWithGetterBindableClass = new BaseWithGetterBindableClass();

        assertTrue(bindable is IEventDispatcher, 'bindable should have IEventDispatcher-ness');

        var bindableDispatcher:IEventDispatcher = bindable as IEventDispatcher;
        testUtil.listenTo(bindableDispatcher, BindableTestUtil.VALUE_CHANGE_EVENT);

        bindable.accessorOfBaseWithGetterBindableClass = 'a new assigned value';
        bindable.accessorOfBaseWithGetterBindableClass = 'a second assigned value';


        var expected:String =
                '0:history:accessing value from original getter , accessorOfBaseWithGetterBindableClass_value\n' +
                '1:history:assigning value in original setter , a new assigned value\n' +
                '2:ValueChangeEvent::property(accessorOfBaseWithGetterBindableClass), oldVal:(accessorOfBaseWithGetterBindableClass_value), newValue:(a new assigned value)\n' +
                '3:history:accessing value from original getter , a new assigned value\n' +
                '4:history:assigning value in original setter , a second assigned value\n' +
                '5:ValueChangeEvent::property(accessorOfBaseWithGetterBindableClass), oldVal:(a new assigned value), newValue:(a second assigned value)';

        assertEquals(testUtil.getSequenceString(), expected, 'Unexpected results from changes to a "bindable"');

        testUtil.reset();
    }


    [Test]
    public function testBindableClassWithAccessorVariations():void
    {
        // a class is marked [Bindable], but not its accessor member(s)
        testUtil.reset();
        var bindable:BaseWithAccesorVariantsBindableClass = new BaseWithAccesorVariantsBindableClass();

        assertTrue(bindable is IEventDispatcher, 'bindable should have IEventDispatcher-ness');

        var bindableDispatcher:IEventDispatcher = bindable as IEventDispatcher;
        testUtil.listenTo(bindableDispatcher, BindableTestUtil.VALUE_CHANGE_EVENT);
        testUtil.listenTo(bindableDispatcher, 'alternateChanged');
        testUtil.listenTo(bindableDispatcher, 'alternate2Changed');

        bindable.accessorOfBaseWithAccesorVariantsBindableClass = 'a new assigned value';
        bindable.accessorOfBaseWithAccesorVariantsBindableClass = 'a second assigned value';
        var val:String = bindable.getterOnly;
        bindable.setterOnly = 'assigned value for setterOnly with val from getter:' + val;
        bindable.alternate = 'new value for alternate';
        bindable.alternate = 'another new value for alternate';
        bindable.alternate2 = 'new value for alternate2';
        bindable.alternate2 = 'another new value for alternate2';


        var expected:String =
                '0:history:accessing value from original getter , BaseWithAccessorVariantsBindableClass_value\n' +
                '1:history:assigning value in original setter , a new assigned value\n' +
                '2:ValueChangeEvent::property(accessorOfBaseWithAccesorVariantsBindableClass), oldVal:(BaseWithAccessorVariantsBindableClass_value), newValue:(a new assigned value)\n' +
                '3:history:accessing value from original getter , a new assigned value\n' +
                '4:history:assigning value in original setter , a second assigned value\n' +
                '5:ValueChangeEvent::property(accessorOfBaseWithAccesorVariantsBindableClass), oldVal:(a new assigned value), newValue:(a second assigned value)\n' +
                '6:history:getting non bindable getterOnly , getterOnly\n' +
                '7:history:setting non bindable setterOnly , assigned value for setterOnly with val from getter:getterOnly\n' +
                '8:history:setting alternate value with explicit Bindable event , new value for alternate\n' +
                '9:Event(type="alternateChanged", bubbles=false, cancelable=false)\n' +
                '10:history:setting alternate value with explicit Bindable event , another new value for alternate\n' +
                '11:Event(type="alternateChanged", bubbles=false, cancelable=false)\n' +
                '12:history:setting alternate2 value with both types of Bindable event , new value for alternate2\n' +
                '13:Event(type="alternate2Changed", bubbles=false, cancelable=false)\n' +
                '14:history:setting alternate2 value with both types of Bindable event , another new value for alternate2\n' +
                '15:Event(type="alternate2Changed", bubbles=false, cancelable=false)';


        assertEquals(testUtil.getSequenceString(), expected, 'Unexpected results from changes to a "bindable"');

        testUtil.reset();
    }

}
}
