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

    import org.apache.royale.core.Bead;
    import org.apache.royale.core.IHasImage;
    import org.apache.royale.core.IImageModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
  
    /**
	 *  The ErrorImage class is a bead that can be used to 
     *  display an alternate image, in the event that the specified image 
     *  cannot be loaded.
     * 
     *  It will be supported by controls that load the ImageModel bead and 
     *  implement the IImage interface
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
    public class ErrorImage extends Bead
    {
        /**
         *  constructor.
         *
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
        */
        public function ErrorImage() {            
        }

        private var _src:String = "assets/no-image.svg";
		/**
		 *  The source of the image
         *  Defaults to "assets/no-image.svg"
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get src():String {
            return _src;
        }
        public function set src(value:String):void {
            _src = value;
        }
        
        /**
		 *  The image element
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
		COMPILE::JS
        private var _hostElement:HTMLImageElement;
        
        private var _hostModel:IImageModel;
        /**
		 *  The image model
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        protected function get hostModel():IImageModel
        {    
            if(!_hostModel)
                _hostModel = _strand.getBeadByType(IImageModel) as IImageModel;
            return _hostModel;
        }

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         *  @royaleignorecoercion org.apache.royale.core.IHasImage
         *  @royaleignorecoercion HTMLImageElement
         */
        override public function set strand(value:IStrand):void 
        {
            super.strand = value;

            COMPILE::JS {
            _hostElement = (_strand as IHasImage).imageElement as HTMLImageElement;
            if(_hostElement)
            {    
                _hostElement.addEventListener('error', errorHandler);
                if(_emptyIsError)
                    listenOnStrand("beadsAdded", beadsAddedHandler);
            }   
            }
        }

		COMPILE::JS
        private function beadsAddedHandler(event:Event):void
        {
            if(hostModel)
                hostModel.addEventListener("urlChanged", srcChangedHandler);
            srcChangedHandler(null);
        }

        private var _emptyIsError:Boolean = false;
		/**
		 *  Indicates whether the "empty or null" values will be treated as errors and replaced by the indicated src
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.8
         */
        public function get emptyIsError():Boolean {
            return _emptyIsError;
        }
        public function set emptyIsError(value:Boolean):void {
            _emptyIsError = value;
        }
        /**
         * Keep track of the last applied src to prevent an endless loop if the error src is missing
         */
        private var lastAppliedSrc:String;
		COMPILE::JS
        private function errorHandler(event:Event):void {
            if (lastAppliedSrc != _src && _hostElement.src != _src)
            {
                _hostElement.src = _src;
                lastAppliedSrc = _src;
            }
        }
		
        private function srcChangedHandler(event:Event):void
        {
            if(hostModel && !hostModel.url){                
                // Op1: Updating the model (It causes a double assignment that we must control)
                if(hostModel.hasEventListener("urlChanged")){
                    hostModel.removeEventListener("urlChanged", srcChangedHandler);
                    hostModel.url = src;
                    hostModel.addEventListener("urlChanged", srcChangedHandler);                    
                }
                // Op2: Direct assignment to element
                //(hostElement as Object).src = src;
            }
        }
    }
}