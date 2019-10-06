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
package org.apache.royale.html
{
    import org.apache.royale.core.IFlexInfo;
    import org.apache.royale.core.IModule;
    import org.apache.royale.core.IValuesImpl;
    import org.apache.royale.core.ValuesManager;
    
    COMPILE::SWF
    {
        import flash.system.ApplicationDomain;
        import flash.utils.getQualifiedClassName;        
    }

    /**
     *  Indicates that the state change has completed.  All properties
     *  that need to change have been changed, and all transitinos
     *  that need to run have completed.  However, any deferred work
     *  may not be completed, and the screen may not be updated until
     *  code stops executing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="stateChangeComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  Indicates that the initialization of the container is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="initComplete", type="org.apache.royale.events.Event")]
    
    /**
     *  Indicates that the children of the container is have been added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="childrenAdded", type="org.apache.royale.events.Event")]
    
    /**
     *  The UIModule class is the base class for modules of user
     *  interface controls in Royale.  It is usable as the root tag of MXML
     *  documents and UI controls and containers are added to it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class UIModule extends Group implements IFlexInfo, IModule
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function UIModule()
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
         *  @productversion Royale 0.0
         */
        public function info():Object
        {
            COMPILE::SWF
            {
            if (!_info)
            {
                var mainClassName:String = getQualifiedClassName(this);
                var initClassName:String = "_" + mainClassName + "_FlexInit";
                var c:Class = ApplicationDomain.currentDomain.getDefinition(initClassName) as Class;
                _info = c.info();
            }
            }
            return _info;
        }
        
        /**
         *  The org.apache.royale.core.IValuesImpl that is
         *  used by the loading application or module.
         *  A new instance is not created as the main
         *  one is shared but this adds the required
         *  depedencies for the JS compiler optimizer
         *  and adds the values for this module
         *
         *  @see org.apache.royale.core.SimpleCSSValuesImpl
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set valuesImpl(value:IValuesImpl):void
        {
            ValuesManager.valuesImpl.init(this);
        }


    }
}
