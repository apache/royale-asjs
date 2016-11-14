/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.flex.svg
{
    import org.apache.flex.core.ContainerBase;
    import org.apache.flex.core.IChild;
    import org.apache.flex.core.IFlexJSElement;
    import org.apache.flex.core.ITransformHost;

	COMPILE::JS
	{
		import org.apache.flex.core.IContainer;
		import org.apache.flex.core.UIBase;
	}

	[DefaultProperty("mxmlContent")]

	COMPILE::SWF
    public class GraphicContainer extends ContainerBase implements ITransformHost
    {
        public function GraphicContainer()
        {
            super();
        }

    }
	
	COMPILE::JS
	public class GraphicContainer extends UIBase implements ITransformHost, IContainer
	{
		private var graphicGroup:ContainerBase;
		
		public function GraphicContainer()
		{
			super();
		}
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		override protected function createElement():org.apache.flex.core.WrappedHTMLElement
		{
			element = document.createElementNS('http://www.w3.org/2000/svg', 'svg') as org.apache.flex.core.WrappedHTMLElement;
			
			positioner = element;
			
			// absolute positioned children need a non-null
			// position value in the parent.  It might
			// get set to 'absolute' if the container is
			// also absolutely positioned
			
			element.flexjs_wrapper = this;
			
			graphicGroup = new GraphicGroup();
			super.addElement(graphicGroup);
			return element;
		}

		COMPILE::JS
		override protected function setClassName(value:String):void
		{
			element.setAttribute('class', value);           
		}
		
		override public function get transformElement():org.apache.flex.core.WrappedHTMLElement
		{
			return graphicGroup.element;
		}

		/**
		 *  @copy org.apache.flex.core.IParent#getElementAt()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function getElementAt(index:int):IChild
		{
			return graphicGroup.getElementAt(index);
		}        
		
		/**
		 *  @copy org.apache.flex.core.IParent#addElement()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			graphicGroup.addElement(c, dispatchEvent);
			if (dispatchEvent)
				this.dispatchEvent(new Event("childrenAdded"));
		}
		
		/**
		 *  @copy org.apache.flex.core.IParent#addElementAt()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			graphicGroup.addElementAt(c, index, dispatchEvent);
			if (dispatchEvent)
				this.dispatchEvent(new Event("childrenAdded"));
		}
		
		/**
		 *  @copy org.apache.flex.core.IParent#removeElement()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			graphicGroup.removeElement(c, dispatchEvent);
			if (dispatchEvent)
				this.dispatchEvent(new Event("childrenRemoved"));
		}
		
		/**
		 *  @copy org.apache.flex.core.IContainer#childrenAdded()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function childrenAdded():void
		{
			dispatchEvent(new Event("childrenAdded"));
		}
		
		/**
		 *  @copy org.apache.flex.core.IParent#getElementIndex()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
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
		 *  @productversion FlexJS 0.0
		 */
		override public function get numElements():int
		{
			return graphicGroup.numElements;
		}
	}
}

import org.apache.flex.core.ContainerBase;

class GraphicGroup extends ContainerBase
{
	/**
	 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
	 */
	COMPILE::JS
	override protected function createElement():org.apache.flex.core.WrappedHTMLElement
	{
		element = document.createElementNS('http://www.w3.org/2000/svg', 'g') as org.apache.flex.core.WrappedHTMLElement;
		
		positioner = element;
		
		// absolute positioned children need a non-null
		// position value in the parent.  It might
		// get set to 'absolute' if the container is
		// also absolutely positioned
		
		element.flexjs_wrapper = this;
		
		/*addEventListener('childrenAdded',
		runLayoutHandler);
		addEventListener('elementRemoved',
		runLayoutHandler);*/
		
		return element;
	}
}