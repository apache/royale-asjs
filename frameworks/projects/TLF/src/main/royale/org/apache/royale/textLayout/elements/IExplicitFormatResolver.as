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
	/** Interface to a format resolver. Different from IFormatResolver, IExplicitFormatResolver allow you to
	 *  set "before style" and "after style". "After Style" can override the local computedFormat explicitly, 
	 *  which can be fetched by calling function resolveExplicitFormat(), "Before Style" is the format returned
	 *  by function resolveFormat() defined in interface IFormatResolver.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * 
	 * @see org.apache.royale.textLayout.elements.TextFlow#formatResolver TextFlow.formatResolver
	 */
	public interface IExplicitFormatResolver extends IFormatResolver
	{
		/** Given a FlowElement or ContainerController object, return any explicit format settings for it.
		 *
		 * @return format settings for the specified object.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		function resolveExplicitFormat(target:Object):ITextLayoutFormat;
	}
}
