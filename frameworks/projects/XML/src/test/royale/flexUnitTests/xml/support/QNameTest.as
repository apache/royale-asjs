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
package  flexUnitTests.xml.support
{


    /**
     * @royalesuppresspublicvarwarning
     */
    public class QNameTest {
        
        
        public static var staticBefore:QName = new QName('staticBefore');
        
        public var instanceBefore:QName = new QName('instanceBefore');
        default xml namespace = "foo"; //this appears to do nothing in this context
    
        public static var staticAfter:QName = new QName('staticAfter');
        public var instanceAfter:QName = new QName('instanceAfter');
        
        public function QNameTest() {
            // constructor code
        }
    
    
        /**
         * QName instance was declared as static in source code before the source code default namespace directive
         */
        public function getStaticBeforeQName():QName{
            return staticBefore;
        }
        /**
         * QName instance was declared as static in source code after the source code default namespace directive
         */
        public function getStaticAfterQName():QName{
            return staticAfter;
        }
    
        /**
         * QName instance was declared in source code before the source code default namespace directive
         */
        public function getInstanceBeforeQName():QName{
            return instanceBefore;
        }
    
        /**
         * QName instance was declared in source code after the source code default namespace directive
         */
        public function getInstanceAfterQName():QName{
            return instanceAfter;
        }
    
        public static function getInstanceDeclaredInsideStaticMethod():QName{
            var qName:QName = new QName('localfoo');
            return qName;
        }
        
        public function getInstanceDeclaredInsideInstanceMethod():QName{
            var qName:QName = new QName('localfoo');
            return qName;
        }
    
    
        public static function getInstanceWithDefaultChangeDeclaredInsideStaticMethod():QName{
            default xml namespace = 'foo';
            var qName:QName = new QName('localfoo');
            return qName;
        }
    
        public function getInstanceWithDefaultChangeDeclaredInsideInstanceMethod():QName{
            default xml namespace = 'foo';
            var qName:QName = new QName('localfoo');
            return qName;
        }
    
        
    
       
    }
    
}
