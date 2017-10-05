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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	/** Interface to a format resolver. An implementation allows you to attach a styling mechanism of your choosing, such as
	 *  Flex CSS styling and named styles, to a ITextFlow.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * 
	 * @see org.apache.royale.textLayout.elements.ITextFlow#formatResolver ITextFlow.formatResolver
	 */
	 
	public interface IFormatResolver 
	{
		/** Invalidates any cached formatting information for a ITextFlow so that formatting must be recomputed.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		function invalidateAll(textFlow:ITextFlow):void;
		
		/** Invalidates cached formatting information on this element because, for example, the <code>parent</code> changed, 
		 *  or the <code>id</code> or the <code>styleName</code> changed or the <code>typeName</code> changed. 
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	  	 * @langversion 3.0*/
	  	 
		function invalidate(target:Object):void;
		
		/** Given a FlowElement or ContainerController object, return any format settings for it.
		 *
		 * @return format settings for the specified object.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
	 	 */
	 	 
		function resolveFormat(target:Object):ITextLayoutFormat;
		
		/** Given a FlowElement or ContainerController object and the name of a format property, return the format value
		 * or <code>undefined</code> if the value is not found.
		 *
		 * @return the value of the specified format for the specified object.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		 
		function resolveUserFormat(target:Object,userFormat:String):*;
		
		/** Returns the format resolver when a ITextFlow is copied.
		 *
		 * @return the format resolver for the copy of the ITextFlow.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		 
		function getResolverForNewFlow(oldFlow:ITextFlow,newFlow:ITextFlow):IFormatResolver;
	}
}
