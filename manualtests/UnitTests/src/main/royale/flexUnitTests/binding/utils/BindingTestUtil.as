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
package flexUnitTests.binding.utils
{

    COMPILE::Flex{
        import mx.core.IVisualElementContainer;
        import mx.core.IVisualElement;
    }

    COMPILE::Royale{
        import IVisualElementContainer=org.apache.royale.core.IParent;
        import IVisualElement=org.apache.royale.core.IChild;
    }
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class BindingTestUtil
    {
        private static var _testParent:IVisualElementContainer;
        private static var _testClasses:Array = [];
        private static var _testInstances:Array = [];
        
        public static function setTestParent(testParent:IVisualElementContainer):void{
            _testParent = testParent;
        }
        
        public static function createAndAddInstance(instanceClass:Class):IVisualElement{
            var inst:IVisualElement;
            if (!_testParent) throw new Error('setTestParent must set a parent before calling createAndAddInstance')
            if (instanceClass) {
                if (_testClasses.indexOf(instanceClass) == -1) {
                    _testClasses.push(instanceClass);
                }
                inst = new instanceClass() as IVisualElement;
                if (!inst) {
                    throw new Error('bad mxml instance class');
                }
                _testInstances.push(inst);
                _testParent.addElement(inst);
            } else {
                throw new Error('instanceClass must not be null');
            }
            
            return inst;
        }
        
        public static function removeInstance(instance:Object):void{
            if (instance is IVisualElement){
                if (IVisualElement(instance).parent) {
                    IVisualElementContainer(instance.parent).removeElement(instance as IVisualElement);
                }
            }
            if (_testInstances.indexOf(instance) != -1) {
                _testInstances.splice(_testInstances.indexOf(instance), 1);
            }
        }

        public static function reset():void{
            _testClasses = [];
            while (_testInstances.length) {
                removeInstance(_testInstances.pop())
            }
        }
        
    }
}
