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
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    
    import org.apache.flex.utils.MXMLDataInterpreter;

	[DefaultProperty("mxmlContent")]
	public class ItemRendererClassFactory extends Strand implements IItemRendererClassFactory, IDocument, IBead
	{
		public function ItemRendererClassFactory()
		{
			super();
		}
				
        private var _strand:IStrand;
        
        public function set strand(value:IStrand):void
        {
            _strand = value;
            itemRendererClass = ValuesManager.valuesImpl.getValue(_strand, "iItemRenderer") as Class;
            if (itemRendererClass)
                createFunction = createFromClass;
        }

		public function get MXMLDescriptor():Array
		{
			return null;
		}
		
		public function get MXMLProperties():Array
		{
			return null;
		}
		
		public var mxmlContent:Array;
		
        public function createItemRenderer(parent:IItemRendererParent):IItemRenderer
        {
            return createFunction(parent);
        }
        
        public var createFunction:Function = createFromMXMLContent;

        protected function createFromMXMLContent(parent:IItemRendererParent):IItemRenderer
        {
            return MXMLDataInterpreter.generateMXMLArray(document, parent as DisplayObjectContainer, MXMLDescriptor, true)[0];
        }
        
        public var itemRendererClass:Class;
        
        public function createFromClass(parent:IItemRendererParent):IItemRenderer
        {
            var renderer:IItemRenderer = new itemRendererClass();
            parent.addChild(renderer as DisplayObject);
            return renderer;
        }
        
        private var document:Object;
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;
        }
	}
}