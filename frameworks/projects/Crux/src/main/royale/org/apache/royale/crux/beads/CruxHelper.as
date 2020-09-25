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
package org.apache.royale.crux.beads
{
    import org.apache.royale.core.ApplicationBase;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.crux.ICrux;
    import org.apache.royale.crux.utils.buildCrux;
    import org.apache.royale.events.IEventDispatcher;
    
    /**
     *  CruxHelper generate a Crux for an Application or a Module
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
    public class CruxHelper implements IBead
    {
        public function CruxHelper() {
			super();
		}

        private var host:IEventDispatcher;
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         *
         *  @royaleignorecoercion org.apache.royale.core.ElementWrapper
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        public function set strand(value:IStrand):void
        {
            host = value as IEventDispatcher;

            if(host is ApplicationBase)
            {
                var jsStageEvents:JSStageEvents = new JSStageEvents();
                jsStageEvents.packageExclusionFilter = _packageExclusionFilter;
                value.addBead(jsStageEvents);
            }

            crux = buildCrux(host, beanProviders, eventPackages, viewPackages);
            
            if(parentCrux)
                crux.parentCrux = parentCrux;

            value.addBead(crux);
        }

        private var _crux:ICrux;
        /**
         *  The generated crux instance
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get crux():ICrux
        {
        	return _crux;
        }
        public function set crux(value:ICrux):void
        {
        	_crux = value;
        }

        private var _beanProviders:Array;
        /**
         *  The Array of bean providers
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get beanProviders():Array
        {
        	return _beanProviders;
        }
        public function set beanProviders(value:*):void
        {
        	_beanProviders = value;
        }

        private var _eventPackages:Array;
        /**
         *  The Array of event packages
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get eventPackages():Array
        {
        	return _eventPackages;
        }
        public function set eventPackages(value:*):void
        {
        	_eventPackages = value;
        }

        private var _viewPackages:Array;
        /**
         *  The Array of view packages
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get viewPackages():Array
        {
        	return _viewPackages;
        }
        public function set viewPackages(value:*):void
        {
        	_viewPackages = value;
        }
        
        private var _packageExclusionFilter:String = "_default_";
        /**
         *  The package exclusion filter to use in JSStageEvents 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get packageExclusionFilter():String
        {
        	return _packageExclusionFilter;
        }
        public function set packageExclusionFilter(value:String):void
        {
        	_packageExclusionFilter = value;
        }
        
        private var _parentCrux:ICrux;
        /**
         *  The parent crux 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get parentCrux():ICrux
        {
        	return _parentCrux;
        }
        public function set parentCrux(value:ICrux):void
        {
        	_parentCrux = value;
        }
    }
}