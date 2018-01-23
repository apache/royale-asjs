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
package org.apache.royale.core
{
    COMPILE::SWF
    {
        import flash.display.Loader;
        import flash.system.LoaderContext;
        import flash.events.Event;
        import flash.events.IOErrorEvent;
        import flash.events.SecurityErrorEvent;
        import flash.net.URLRequest;
        import flash.system.ApplicationDomain;
        import flash.utils.getQualifiedClassName;
        
        import org.apache.royale.events.Event;
        import org.apache.royale.events.IEventDispatcher;
        import org.apache.royale.events.ValueEvent;            
    }
    
    /**
     *  The CSSFontFaceBead class is the class that loads swfs
     *  of converted fonts so they can be used in Flash.
     *  It is just a stub in JS.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CSSFontFaceBead implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CSSFontFaceBead()
		{
		}
		
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            COMPILE::SWF
            {
                IEventDispatcher(ValuesManager.valuesImpl).addEventListener("init", initHandler);
                IEventDispatcher(_strand).addEventListener("preinitialize", preinitHandler);
                var mainClassName:String = getQualifiedClassName(value);
                var styleClassName:String = "_" + mainClassName + "_Styles";
                var c:Class = ApplicationDomain.currentDomain.getDefinition(styleClassName) as Class;
                requestFonts(c["fontFaces"]);                    
            }
        }
            
        COMPILE::SWF
        private var loaders:Array;
        
        COMPILE::SWF
        private function initHandler(event:ValueEvent):void
        {
            var fontFaces:Array = event.value as Array;
            if (fontFaces)
                requestFonts(fontFaces);
        }
        
        COMPILE::SWF
        private function requestFonts(fontFaces:Array):void
        {
            if (!loaders)
                loaders = [];

            if (!fontFaces || fontFaces.length == 0)
            {
                IEventDispatcher(_strand).removeEventListener("preinitialize", preinitHandler);
                return;
            }
            
            for each (var url:String in fontFaces)
            {
                // swap swf in suffix
                var c:int = url.lastIndexOf(".");
                url = url.substr(0, c) + ".swf";
                var foo:Loader = new Loader();
                var bar:URLRequest = new URLRequest(url);
                var ctx:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
                foo.load(bar, ctx);
                foo.name = url;
                foo.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, completeHandler);
                foo.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                foo.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
                loaders.push(foo.contentLoaderInfo);
            }
        }
        
        COMPILE::SWF
        private function completeHandler(event:flash.events.Event):void
        {
            removeTarget(event.target);
        }
        
        COMPILE::SWF
        private function errorHandler(event:flash.events.Event):void
        {
            trace("error loading font from: ", event.target.loader.name);
            removeTarget(event.target);
        }
        
        COMPILE::SWF
        private function removeTarget(target:Object):void
        {
            var n:int = loaders.length;
            for (var i:int = 0; i < n; i++)
            {
                if (loaders[i] === target)
                {
                    loaders.splice(i, 1);
                    if (loaders.length == 0)
                        IEventDispatcher(_strand).removeEventListener("preinitialize", preinitHandler);                        
                    break;
                }
            }
        }
                
        COMPILE::SWF
        private function preinitHandler(event:org.apache.royale.events.Event):void
        {
            event.preventDefault();
        }
    }
}
