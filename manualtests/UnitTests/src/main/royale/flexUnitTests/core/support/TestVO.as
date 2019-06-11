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
package flexUnitTests.core.support
{
    import org.apache.royale.events.EventDispatcher;
    
    [Bindable]
    public class TestVO extends EventDispatcher
    {
        public function TestVO(field1:String, field2:int, field3:String)
        {
            this.field1 = field1;
            this.field2 = field2;
            this.field3 = field3;
        }
        
        public var field1:String = '';
        public var field2:int = 0;
        public var field3:String = '';
        
        COMPILE::SWF
        override public function toString():String{
            return 'TestVO ['+field1+']#'+field2+' ['+field3+']';
        }
    
        COMPILE::JS
        public function toString():String{
            return 'TestVO ['+field1+']#'+field2+' ['+field3+']';
        }
    }
}
