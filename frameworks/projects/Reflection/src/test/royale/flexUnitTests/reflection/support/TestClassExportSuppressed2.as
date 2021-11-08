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
package flexUnitTests.reflection.support
{
    
    
    /**
     * @royalesuppresspublicvarwarning
     *
     */
    public class TestClassExportSuppressed2
    {
        //Note: do not change this test class unless you change the related tests to
        //support any changes that might appear when testing reflection into it

        public static const CLASSNAME:String = 'flexUnitTests.reflection.support.TestClassExportSuppressed2'

        /**
         *
         */
        public static function myStaticMethod():void{

        }
        /**
         *
         */
        public static function get somethingStatic():Boolean{
            return false;
        }

        /**
         *
         */
        public static var someStaticVar:Boolean;

        /**
         * @royalesuppressexport
         */
        public static function myOtherStaticMethod():void{

        }

        /**
         * @royalesuppressexport
         */
        public static function get somethingElseStatic():Boolean{
            return false;
        }

        /**
         * @royalesuppressexport
         */
        public static var someOtherStaticVar:Boolean;


        
        public function TestClassExportSuppressed2()
        {

        }

        /**
         *
         */
        public function myInstanceMethod():void{

        }

        /**
         *
         */
        public function get something():Boolean{
            return false;
        }

        /**
         *
         */
        public var someVar:Boolean;

        /**
         * @royalesuppressexport
         */
        public function myOtherInstanceMethod():void{

        }

        /**
         * @royalesuppressexport
         */
        public function get somethingElse():Boolean{
            return false;
        }

        /**
         * @royalesuppressexport
         */
        public var someOtherVar:Boolean;
    }
}
