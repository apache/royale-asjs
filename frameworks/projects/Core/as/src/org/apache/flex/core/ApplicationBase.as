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
package org.apache.flex.core
{
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;

    COMPILE::AS3 {
        import flash.display.Sprite;
    }
        
    /**
     *  This is a platform-dependent base class
     *  for Application
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::AS3
	public class ApplicationBase extends Sprite
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ApplicationBase()
		{
			super();
		}
        
   	}
    
    COMPILE::JS
    public class ApplicationBase extends HTMLElementWrapper implements IFlexInfo
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function ApplicationBase()
        {
            super();
        }
        
        private var _info:Object;
        
        /**
         *  An Object containing information generated
         *  by the compiler that is useful at startup time.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function info():Object
        {
            if (!_info)
            {
                var mainClassName:String = getQualifiedClassName(this);
                var initClassName:String = "_" + mainClassName + "_FlexInit";
                var c:Class = ApplicationDomain.currentDomain.getDefinition(initClassName) as Class;
                _info = c.info();
            }
            return _info;
        }
        

    }
}
