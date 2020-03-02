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
    import org.apache.royale.core.UIBase;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class BindingTestUtil
    {
        private static var _testParent:UIBase;
        private static var _testClasses:Array = [];
        private static var _testInstances:Array = [];
        
        public static function setTestParent(testParent:UIBase):void{
            _testParent = testParent;
        }
        
        public static function createAndAddInstance(instanceClass:Class):UIBase{
            var inst:UIBase;
            if (!_testParent) throw new Error('setTestParent must set a parent before calling createAndAddInstance')
            if (instanceClass) {
                if (_testClasses.indexOf(instanceClass) == -1) {
                    _testClasses.push(instanceClass);
                }
                inst = new instanceClass() as UIBase;
                if (!inst) {
                    throw new Error('bad mxml instance class');
                }
                _testInstances.push(inst);
                _testParent.addElement(inst);
                /*} else {
                    throw new Error('duplicate test class');
                }*/
            } else {
                throw new Error('instanceClass must not be null');
            }
            
            return inst;
        }
        
        public static function removeInstance(instance:Object):void{
            if (instance is UIBase){
                if (UIBase(instance).parent) {
                    UIBase(instance.parent).removeElement(instance as UIBase);
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
