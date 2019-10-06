/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.royale.svg
{
    import org.apache.royale.core.GroupBase;
    import org.apache.royale.core.IChild;
	import org.apache.royale.events.Event;
    import org.apache.royale.core.IMXMLDocument;
    import org.apache.royale.core.IRoyaleElement;
    import org.apache.royale.core.ITransformHost;
    import org.apache.royale.events.ValueEvent;
    import org.apache.royale.utils.MXMLDataInterpreter;
	import org.apache.royale.core.ValuesManager;

	COMPILE::JS
	{
		import org.apache.royale.core.IContainer;
		import org.apache.royale.core.UIBase;
		import org.apache.royale.events.Event;
		import org.apache.royale.html.util.addSvgElementToWrapper;
	}

	/**
	 * The default property uses when additional MXML content appears within an element's
	 * definition in an MXML file.
	 */
	[DefaultProperty("mxmlContent")]
	public class GraphicContainer extends GroupBase implements ITransformHost, IMXMLDocument
	{
		private var graphicGroup:GroupBase;
		private var _mxmlDescriptor:Array;
		private var _mxmlDocument:Object = this;
		private var _initialized:Boolean;

		public function GraphicContainer()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():org.apache.royale.core.WrappedHTMLElement
		{
			element = addSvgElementToWrapper(this,'svg');

			// absolute positioned children need a non-null
			// position value in the parent.  It might
			// get set to 'absolute' if the container is
			// also absolutely positioned
			//positioner.style.position = 'relative';
			graphicGroup = new GraphicGroup();
			super.addElement(graphicGroup);
			return element;
		}

		COMPILE::JS
		override protected function setClassName(value:String):void
		{
			element.setAttribute('class', value);
		}

		COMPILE::JS
		override public function get transformElement():org.apache.royale.core.WrappedHTMLElement
		{
			return graphicGroup.element;
		}

		/**
		 *  @copy org.apache.royale.core.IParent#getElementAt()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		override public function getElementAt(index:int):IChild
		{
			return graphicGroup.getElementAt(index);
		}

		/**
		 *  @copy org.apache.royale.core.IParent#addElement()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			graphicGroup.addElement(c, dispatchEvent);
			if (dispatchEvent)
				this.dispatchEvent(new ValueEvent("childrenAdded", c));
		}

		/**
		 *  @copy org.apache.royale.core.IParent#addElementAt()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			graphicGroup.addElementAt(c, index, dispatchEvent);
			if (dispatchEvent)
				this.dispatchEvent(new ValueEvent("childrenAdded", c));
		}

		/**
		 *  @copy org.apache.royale.core.IParent#removeElement()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			graphicGroup.removeElement(c, dispatchEvent);
			if (dispatchEvent)
				this.dispatchEvent(new ValueEvent("childrenRemoved", c));
		}

		/**
		 *  @copy org.apache.royale.core.IParent#getElementIndex()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		override public function getElementIndex(c:IChild):int
		{
			return graphicGroup.getElementIndex(c);
		}


		/**
		 *  The number of elements in the parent.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		override public function get numElements():int
		{
			return graphicGroup.numElements;
		}

		COMPILE::JS
        override public function set x(value:Number):void
        {
			super.x = value;
			// Needed for SVG inside SVG
			element.setAttribute("x", value);
        }

		COMPILE::JS
        override public function set y(value:Number):void
        {
			super.y = value;
			// Needed for SVG inside SVG
			element.setAttribute("y", value);
        }

		/**
		 *  @copy org.apache.royale.core.Application#MXMLDescriptor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get MXMLDescriptor():Array
		{
			return _mxmlDescriptor;
		}

		/**
		 *  @private
		 */
		public function setMXMLDescriptor(document:Object, value:Array):void
		{
			_mxmlDocument = document;
			_mxmlDescriptor = value;
		}

		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			if (!_initialized)
			{
				// each MXML file can also have styles in fx:Style block
				ValuesManager.valuesImpl.init(this);
			}
			
			super.addedToParent();
			
			if (!_initialized)
			{
				MXMLDataInterpreter.generateMXMLInstances(_mxmlDocument, this, MXMLDescriptor);
				
				dispatchEvent(new Event("initBindings"));
				dispatchEvent(new Event("initComplete"));
				_initialized = true;
				
				//?? why was this added here? childrenAdded(); //?? Is this needed since MXMLDataInterpreter will already have called it
			}
		}

		/**
		 *  @copy org.apache.royale.core.Application#generateMXMLAttributes()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function generateMXMLAttributes(data:Array):void
		{
			MXMLDataInterpreter.generateMXMLProperties(this, data);
		}
		
		/**
		 *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var mxmlContent:Array;
	}
}

import org.apache.royale.core.GroupBase;
COMPILE::JS
{
	import org.apache.royale.html.util.addSvgElementToWrapper;
}
class GraphicGroup extends GroupBase
{
	/**
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 */
	COMPILE::JS
	override protected function createElement():org.apache.royale.core.WrappedHTMLElement
	{
		return addSvgElementToWrapper(this, 'g');

		// absolute positioned children need a non-null
		// position value in the parent.  It might
		// get set to 'absolute' if the container is
		// also absolutely positioned
		//positioner.style.position = 'relative';

		/*addEventListener('childrenAdded',
		runLayoutHandler);
		addEventListener('elementRemoved',
		runLayoutHandler);*/
	}
}
