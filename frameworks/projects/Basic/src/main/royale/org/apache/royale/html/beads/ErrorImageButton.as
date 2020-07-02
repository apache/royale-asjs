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
package org.apache.royale.html.beads {

    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;

    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.core.IRenderedObject;
    import org.apache.royale.core.IImageModel;
  
  /**
	 *  The ErrorImage class is a bead that can be used to 
     *  display an alternate image, in the event that the specified image 
     *  cannot be loaded.
     * 
     *  It will be supported by controls that load the ImageModel bead and 
     *  expose an imageElement property that references its img element.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */

    public class ErrorImageButton implements IBead {

        protected var _strand:IStrand;

        public function ErrorImageButton() {            
        }

        private var _src:String;
		/**
		 *  The source of the image
		 */
        public function get src():String {
            return _src;
        }

        public function set src(value:String):void {
            _src = value;
        }
        
		COMPILE::JS{
        private var _hostElement:Element;
		protected function get hostElement():Element
		{
			return _hostElement;
		}
        }
        protected function get hostModel():IImageModel
        {             
            return _strand.getBeadByType(IImageModel) as IImageModel;
        }

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function set strand(value:IStrand):void 
        {
            _strand = value;

	        COMPILE::JS {

                if(_strand is IRenderedObject)
                {
                    try 
                    {
                        _hostElement = Element((_strand as Object).imageElement) as Element;
                    }
                    catch (error:Error) 
                    {
                        trace(error);
                    }
                    if(_hostElement){
                        
                        _hostElement.addEventListener('error', errorHandler);

                        if(_emptyIsError)
                        {
                            (_strand as EventDispatcher).addEventListener("beadsAdded", beadsAddedHandler);
                        }
                    }   
                }
            }
        }

		COMPILE::JS
        private function beadsAddedHandler(event:Event):void
        {
            (_strand as EventDispatcher).removeEventListener("beadsAdded", beadsAddedHandler);

            if(hostModel)
                hostModel.addEventListener("urlChanged",srcChangedHandler);
            srcChangedHandler(null);
        }

        private var _emptyIsError:Boolean = false;
		/**
		 *  Indicates whether the "empty or null" values will be treated as errors and replaced by the indicated src
		 */
        public function get emptyIsError():Boolean {
            return _emptyIsError;
        }
        public function set emptyIsError(value:Boolean):void {
            _emptyIsError = value;
        }

		COMPILE::JS
        private function errorHandler(event:Event):void {
        
            var imgEle:Object = hostElement as Object;
            if (imgEle.src != _src)
            {
                imgEle.src = _src;
            }
        }
		
        private function srcChangedHandler(event:Event):void
        {
            if(hostModel && !hostModel.url){

                if(hostModel.hasEventListener("urlChanged")){
                    hostModel.removeEventListener("urlChanged",srcChangedHandler);
                    hostModel.url = src;
                    hostModel.addEventListener("urlChanged",srcChangedHandler);                    
                }
                (hostElement as Object).src = src;
            }
            
        }

    }
}

