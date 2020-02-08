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
    
    import org.apache.royale.core.ClassFactory;
    import org.apache.royale.core.IFactory;
    import org.apache.royale.core.IItemRendererProvider;
    
    import org.apache.royale.utils.MXMLDataInterpreter;

	[DefaultProperty("mxmlContent")]
    
    /**
     *  The ItemRendererClassFactory class is the default implementation of
     *  IItemRendererClassFactory.  This implementation checks for an itemRenderer
     *  property on the strand, then looks for a default definition in CSS, but
     *  also handles the renderer being defined in MXML in sub tags of the
     *  ItemRendererClassFactory.  Other more advanced implementations could
     *  return different renderers based on the data item's type.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class ItemRendererClassFactory extends Strand implements IItemRendererClassFactory, IDocument, IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ItemRendererClassFactory()
		{
			super();
		}
				
        protected var _strand:IStrand;
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion Class
         *  @royaleignorecoercion org.apache.royale.core.IItemRendererProvider
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            
            if (_strand is IItemRendererProvider && (_strand as IItemRendererProvider).itemRenderer) {
            	itemRendererFactory = (_strand as IItemRendererProvider).itemRenderer;
            	createFunction = createFromClass;
            }
			else {
				var itemRendererClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iItemRenderer") as Class;
				if (itemRendererClass) {
					itemRendererFactory = new ClassFactory(itemRendererClass);
					createFunction = createFromClass;
				}
				else if (!MXMLDescriptor)
					createFunction = createFromClass;
			}
        }

        /**
         *  @copy org.apache.royale.core.Application#MXMLDescriptor
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get MXMLDescriptor():Array
		{
			return null;
		}
		
        /**
         *  The default property.  Child tags in MXML documents get assigned
         *  to this property, but are actually encoded by the compiler into the MXMLDescriptor
         *  array.  Therefore, setting this property from ActionScript will have no
         *  effect at runtime.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
		public var mxmlContent:Array;
		
        /**
         *  @copy org.apache.royale.core.IItemRendererClassFactory#createItemRenderer()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function createItemRenderer():IItemRenderer
        {
            return createFunction();
        }
        
        /**
         *  This is the method that actually does the work for createItemRenderer.  It
         *  defaults to creating an instance from child MXML tags, but if the strand
         *  has an item renderer property or style, it switches to generating instances
         *  of the item renderer specified by that property or style.  And yes, since
         *  it is public, you could theoretically assign some other method that generates
         *  item renderer instances.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var createFunction:Function = createFromMXMLContent;

        /**
         *  Creates an instance of an item renderer from child MXML tags.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IParent
         */
        protected function createFromMXMLContent():IItemRenderer
        {
            return MXMLDataInterpreter.generateMXMLArray(document, null, MXMLDescriptor)[0];
        }
        
        /**
         *  Stores the IFactory that will be used to generate item renderer instances if
         *  createFromClass is the createFunction.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var itemRendererFactory:IFactory;
        
        /**
         *  Creates an instance of an item renderer from itemRendererFactory.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function createFromClass():IItemRenderer
        {
            var renderer:IItemRenderer = itemRendererFactory.newInstance();
            return renderer;
        }
        
        private var document:Object;
        
        /**
         *  @copy org.apache.royale.core.IDocument#setDocument()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;
        }
	}
}
