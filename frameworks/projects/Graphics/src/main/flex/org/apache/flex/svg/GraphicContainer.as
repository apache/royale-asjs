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
    import org.apache.flex.core.IParent;
    import org.apache.flex.events.Event;

	COMPILE::JS
	{
		import org.apache.flex.core.WrappedHTMLElement;
	}

    public class GraphicContainer extends ContainerBase
    {
        public function GraphicContainer()
        {
            super();
        }

		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElementNS('http://www.w3.org/2000/svg', 'svg') as WrappedHTMLElement;
			
			positioner = element;
			
			// absolute positioned children need a non-null
			// position value in the parent.  It might
			// get set to 'absolute' if the container is
			// also absolutely positioned
			positioner.style.position = 'relative';
			element.flexjs_wrapper = this;
			
			/*addEventListener('childrenAdded',
			runLayoutHandler);
			addEventListener('elementRemoved',
			runLayoutHandler);*/
			
			return element;
		}
		/**
		 *  @private
		 */
		override public function addElement(c:Object, dispatchEvent:Boolean = true):void
		{
			if(c is GraphicShape || c is DOMWrapper)
				super.addElement(c, dispatchEvent);
			else 
				throw new Error("Only svg elements can be added to svg containers");
		}
		
		/**
		 *  @private
		 */
		override public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
		{
			if(c is GraphicShape || c is DOMWrapper)
				super.addElementAt(c, index, dispatchEvent);
			else 
				throw new Error("Only svg elements can be added to svg containers");
		}

    }
}