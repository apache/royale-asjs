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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.core.IRenderedObject;
    import org.apache.royale.core.ApplicationBase;
    import org.apache.royale.core.UIBase;
    
    COMPILE::JS {
        import org.apache.royale.core.HTMLElementWrapper;
        import org.apache.royale.core.WrappedHTMLElement;
    }
    
    /**
     *  The JSStageEvents class provides a way to simulate 'addedToStage' and 'removedFromStage' events in javascript.
     *
     *  'addedToStage' events can bubble in a way that is similar to Flash Player/Adobe Air.
     *  'removedFromStage' events do not (they are dispatched after 'removal' so must be listened for directly on the target instance)
     *  If using bubbling, and you want to check for 'removedFromStage' a common pattern would be to add the 'removedFromStage' listener directly to instances
     *  as they are handled in the upper level (e.g. application level) event handler, and in the 'removedFromStage' listener, to also remove the 'removedFromStage' listener itself.
     *
     *  For performance reasons, it is possible to filter out packages of view classes that will not have 'stage' events dispatched.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public class JSStageEvents implements IBead
    {
        
        private static var _activeInstance:JSStageEvents;
    
        protected static const packageExclusionFilterDefaults:RegExp = /^mx\.|^spark\.|^org\.apache\.royale\./;
    
    
        public function get isActive():Boolean{
            return _activeInstance != null;
        }
        
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function JSStageEvents()
        {
        
        }
        

        
       
        
        private var host:UIBase;
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         *
         *  @royaleignorecoercion org.apache.royale.core.HTMLElementWrapper
         */
        public function set strand(value:IStrand):void
        {
            COMPILE::JS {
                host = value as UIBase;
                if (_activeInstance) {
                    //assume it will always be that the active instance 'contains' this one...
                    trace('[IGNORING] there is already an active instance of JSStageEvents at ', _activeInstance.host);
                } else {
                    _activeInstance = this;
                    var observer:MutationObserver = new MutationObserver(mutationDetected);
                    observer.observe(HTMLElementWrapper(value).element, {'childList': true, 'subtree': true});
                    trace('Activating JSStageEvents')
                }
            }
        }
        

        private var _packageExclusionFilter:RegExp;
    
        /**
         * The source for a regex that will exclude events from instances of classes that have matches
         * on their fully qualified names. This can be used to reduce the number of events generated
         * (for performance reasons). NB: This pattern matches 'exclusions', not inclusions.
         *
         * By default, this is not active, but you can also set this to the special value '_default_' in which case
         * it will ignore anything in royale framework classes.
         * This can be useful if you are only interested in events from your own local view subclasses, for example.
         */
        public function get packageExclusionFilter():String{
            return _packageExclusionFilter ? _packageExclusionFilter.source : '';
        }
        public function set packageExclusionFilter(value:String):void{
            if (value == null || value == '') {
                _packageExclusionFilter = null;
            } else {
                if (value == '_default_') {
                    _packageExclusionFilter = packageExclusionFilterDefaults;
                } else {
                    if (!_packageExclusionFilter || !(_packageExclusionFilter.source == value)) {
                        _packageExclusionFilter = new RegExp(value);
                    }
                }
            }
        }
        
    
        /**
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion MutationRecord
         *  @royaleignorecoercion NodeList
         */
        COMPILE::JS
        private function mutationDetected(mutationsList:Array):void
        {
            for (var j:int = 0; j < mutationsList.length; j++)
            {
                var royaleInstance:Object;
                var qualifiedName:String;
                var packageExclusionFilterRegexp:RegExp = this._packageExclusionFilter;
                var mutationRecord:MutationRecord = mutationsList[j] as MutationRecord;

                var removedElements:NodeList = mutationRecord.removedNodes as NodeList;
                for (var i:int = 0; i < removedElements.length; i++)
                {
                    var element:WrappedHTMLElement = removedElements[i] as WrappedHTMLElement;
                    royaleInstance = element.royale_wrapper;
                    if (royaleInstance) {
                        if (packageExclusionFilterRegexp ) {
                            qualifiedName = royaleInstance.ROYALE_CLASS_INFO.names[0].qName;
                            if (packageExclusionFilterRegexp.test(qualifiedName)) {
                                //trace('removed from Stage: excluding ',qualifiedName);
                                continue;
                            }
                        }
                        royaleInstance.dispatchEvent(new Event('removedFromStage', true));
                    }
                }
                var addedElements:NodeList = mutationRecord.addedNodes as NodeList;
                for (i = 0; i < addedElements.length; i++)
                {
                    element = addedElements[i] as WrappedHTMLElement;
                    royaleInstance = element.royale_wrapper;
                    if (royaleInstance) {
                        if (packageExclusionFilterRegexp ) {
                            qualifiedName = royaleInstance.ROYALE_CLASS_INFO.names[0].qName;
                            if (packageExclusionFilterRegexp.test(qualifiedName)) {
                                //trace('added to Stage: excluding ',qualifiedName);
                                continue;
                            }
                        }
                        royaleInstance.dispatchEvent(new Event('addedToStage', true));
                    }
                }
            }
        }
    }
}
