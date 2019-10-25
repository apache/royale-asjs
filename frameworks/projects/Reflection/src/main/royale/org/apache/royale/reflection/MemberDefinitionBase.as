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
package org.apache.royale.reflection
{
    
    /**
     *  The base class for definition types that can be decorated with metadata in actionscript
     *  source code
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class MemberDefinitionBase extends DefinitionWithMetaData
	{
        public function MemberDefinitionBase(name:String, isStatic:Boolean, owner:TypeDefinition, rawData:Object = null)
        {
            COMPILE::JS{
                var nsCheck:int = name.lastIndexOf('::');
                if (nsCheck != -1) {
                    _uri = name.substr(0, nsCheck);
                    name = name.substr(nsCheck + 2);
                }
            }
           
            super(name, rawData);
            _isStatic = isStatic;
            _owner = owner;
        }
        
        COMPILE::JS
        private var _uri:String = '';
        COMPILE::SWF
        private var _uri:String;
        public function get uri():String{
            COMPILE::SWF
            {
                if (_uri == null) {
                    _uri = rawData.@uri.toString();
                }
            }
            return _uri;
        }

        private var _isStatic:Boolean;
        public function get isStatic():Boolean{
            return _isStatic;
        }
		
		private var _owner:TypeDefinition;
		public function get owner():TypeDefinition{
			return _owner;
		}
    
    
    }
}
