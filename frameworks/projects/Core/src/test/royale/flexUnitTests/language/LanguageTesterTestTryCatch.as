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
package flexUnitTests.language
{

    import org.apache.royale.test.asserts.*;
    import flexUnitTests.language.support.*;


    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterTestTryCatch
    {
    
        public static var isJS:Boolean = COMPILE::JS;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {

        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        [Before]
        public function setUp():void
        {
            _errLog= [];
        }
        
        [After]
        public function tearDown():void
        {
            _errLog = [];
        }


        private var _errLog:Array ;


        private function logError(msg:String):void {
            _errLog.push(msg);
        }

        private function getErrorLog():String {
            return _errLog.join(', ')
        }

        private function throwAnError(clz:Class, errString:String = 'Error'):void{
            var err:Object = new clz(errString);
            throw err;
        }

        
        [Test]
        public function testSimple():void
        {
            try{
                logError('pre-error');
                throwAnError(Error, 'SimpleError');
                logError('should not happen');
            } catch(e:Error){
                logError('caught:'+e.message);
            }

            assertEquals('pre-error, caught:SimpleError', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testSimpleFinally():void
        {
            try{
                logError('pre-error');
                throwAnError(Error, 'SimpleError');
                logError('should not happen');

            } catch(e:Error){
                logError('caught:'+e.message);
            } finally {
                logError('finally');
            }

            assertEquals('pre-error, caught:SimpleError, finally', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testUncaught():void
        {
            function testLocal():void {
                try{
                    logError('pre-error');
                    throwAnError(Error);
                    logError('should not happen');
                } finally {
                    logError('finally');
                }
            }

            try{
                testLocal()
            } catch(e:Error){

            }

            assertEquals('pre-error, finally', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testMultiCatchA():void
        {
            try{
                logError('pre-error');
                throwAnError(ReferenceError, 'ReferenceError');
                logError('should not happen');
            } catch(e:ReferenceError){
                logError('caught:'+e.message);
            } catch (e:Error) {
                logError('caught:'+e.message);
            }

            assertEquals('pre-error, caught:ReferenceError', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testMultiCatchB():void
        {
            try{
                logError('pre-error');
                throwAnError(Error, 'SimpleError');
                logError('should not happen');
            } catch(e:ReferenceError){
                logError('caught:'+e.message);
            } catch (e:Error) {
                logError('caught:'+e.message);
            }

            assertEquals('pre-error, caught:SimpleError', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testMultiCatchC():void
        {
            //check for something that is uncaught in a multi-catch sequence
            function testLocal():void {
                try{
                    logError('pre-error');
                    throw "A String";
                    logError('should not happen');
                } catch(e:ReferenceError){
                    logError('caught:'+e.message);
                } catch (e:Error) {
                    logError('caught:'+e.message);
                }
            }

            try{
                testLocal()
            } catch(e:Object){
                //in this case it is a String
                logError(e.toString());
            }

            assertEquals('pre-error, A String', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testMultiCatchD():void
        {
            //check for something that is uncaught in a multi-catch sequence, with finally clause
            function testLocal():void {
                try{
                    logError('pre-error');
                    throw "A String";
                    logError('should not happen');
                } catch(e:ReferenceError){
                    logError('caught:'+e.message);
                } catch (e:Error) {
                    logError('caught:'+e.message);
                } finally{
                    logError('finally');
                }

            }

            try{
                testLocal()
            } catch(e:Object){
                //in this case it is a String
                logError(e.toString());
            }

            assertEquals('pre-error, finally, A String', getErrorLog(), 'unexpected Error Sequence')
        }


        [Test]
        public function testMultiCatchE():void
        {
            try{
                logError('pre-error');
                throwAnError(Error, 'SimpleError');
                logError('should not happen');
            } catch(e:ReferenceError){
                logError('caught:'+e.message);
            } catch (e) {//anything (implicit) with an error
                logError('caught:'+e.message);
            }

            assertEquals('pre-error, caught:SimpleError', getErrorLog(), 'unexpected Error Sequence')
        }


        [Test]
        public function testMultiCatchF():void
        {
            try{
                logError('pre-error');
                throw "A String";
                logError('should not happen');
            } catch(e:ReferenceError){
                logError('caught:'+e.message);
            } catch (e) { //anything (implicit) with a string
                logError('caught:'+e.toString());
            }

            assertEquals('pre-error, caught:A String', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testMultiCatchG():void
        {
            try{
                logError('pre-error');
                throw "A String";
                logError('should not happen');
            } catch(e:ReferenceError){
                logError('caught:'+e.message);
            } catch (e:*) { //anything (explicit) with a string
                logError('caught:'+e.toString());
            }

            assertEquals('pre-error, caught:A String', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testMultiCatchH():void
        {
            try{
                logError('pre-error');
                throwAnError(ReferenceError, 'ReferenceError');
                logError('should not happen');
            } catch (e:*) { //anything (explicit)
                logError('caught1:'+e.message);
            } catch(e:ReferenceError){ //should never happen because the above is a catchAll
                logError('caught2:'+e.message);
            }

            assertEquals('pre-error, caught1:ReferenceError', getErrorLog(), 'unexpected Error Sequence')
        }

        [Test]
        public function testMultiCatchI():void
        {
            try{
                logError('pre-error');
                throwAnError(ReferenceError, 'ReferenceError');
                logError('should not happen');
            } catch (e:String) { //should not happen because we have a ReferenceError
                logError('caught1:'+e);
            } catch (e:*) { //anything (explicit) - this should happen
                logError('caught2:'+e.message);
            } catch(e:ReferenceError){//should never happen because the above is a catchAll
                logError('caught3:'+e.message);
            }

            assertEquals('pre-error, caught2:ReferenceError', getErrorLog(), 'unexpected Error Sequence')
        }

        
    }
}
