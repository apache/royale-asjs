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

	public class GraphicGroup extends ContainerBase
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
			//positioner.style.position = 'relative';
			element.flexjs_wrapper = this;

			/*addEventListener('childrenAdded',
			runLayoutHandler);
			addEventListener('elementRemoved',
			runLayoutHandler);*/

			return element;
		}
	}

}
