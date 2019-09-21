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

package org.apache.royale.net.beads {
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.net.URLLoader;
    

    COMPILE::SWF
    public class URLLoaderCORSCredentialsBead implements IBead{
        public function URLLoaderCORSCredentialsBead(filter:* = null) {
            trace("Only needed for JavaScript HTTP Server calls");
        }
    
        public function set strand(value:IStrand):void {
            //doing nothing with strand
        }
    }

    /**
     *  Bead to allow passing on user authentication information in a XMLHttpRequest request.
     *
     *  If you don't use this bead any cross domain calls that require user authentication
     *  (via say basic authentication or cookies) will fail.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    COMPILE::JS
    public class URLLoaderCORSCredentialsBead implements IBead {
    
        private static const alwaysTrue:Function = function(url:String):Boolean{return true};
        private static function getRegexpChecker(regexp:RegExp):Function {
            return function(url:String):Boolean{
                return regexp.test(url);
            }
        }
        
        
        
        public function URLLoaderCORSCredentialsBead(filter:* = null) {
            if (filter) {
                withCredentialsFilter = filter;
            }
        }


        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function set strand(value:IStrand):void {
            //doing nothing with strand
        }

        
        
        private var _withCredentialsFilter:* ;

        /**
         *  configure setting for URLLoader requests
         *  Can be set to true or false
         *  Or a Regexp that tests for what should be true in a url string
         *  Or a String value this is 'always' or 'never'
         *  Or a String that is used to construct a Regexp
         *  Or a Function that does its own checking
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get withCredentialsFilter():* {
            return _withCredentialsFilter;
        }

        public function set withCredentialsFilter(filter:*):void {
            if (!filter) {
                _withCredentialsFilter = null;
            } else {
                if (typeof filter == 'boolean' || filter == 'always' || filter == 'never') { //it must be true because false was already eliminated
                    _withCredentialsFilter = filter != 'never' ? alwaysTrue : null;
                } else {
                    if (filter is String) {
                        //pre-process to Regexp
                        filter = new RegExp(String(filter));
                    }
                    if (filter is RegExp) {
                        _withCredentialsFilter = getRegexpChecker(filter as RegExp);
                    } else {
                        if (filter is Function) {
                            _withCredentialsFilter = filter as Function;
                        } else  {
            
                            throw new Error('Unsupported argument for withCredentialsFilter');
                        }
                    }
                }
            }
            URLLoader.setCORSCredentialsChecker(_withCredentialsFilter);
        }
    }
}
