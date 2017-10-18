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
package org.apache.royale.textLayout.compose
{
	/** 
	 * The ISWFContext interface allows a SWF file to share its context with other SWF files that load it.
	 * An application that loads a SWF file of type ISWFContext can call methods in the context of the loaded SWF file.
	 * The main usage is for calling the FTE TextLine creation methods.
	 * 
	 * <p>There are two reasons for an application to use 
	 * this interface to control TextLine creation: </p>
	 * <ul>
	 *   <li><strong>Reuse an embedded font: </strong> if an application wants to use a font embedded in a loaded SWF file,
	 * the application can access the font if a TextLine
	 * is created in the context of the loaded SWF file.</li>
	 *   <li><strong>Reuse existing TextLine instances</strong>: reusing existing TextLine instances can result in faster recompose times. 
	 * TLF reuses existing TextLine instances internally. TLF reuses 
	 * a TextLine by calling <code>TextBlock.recreateTextLine()</code>
	 * instead of <code>TextBlock.createTextLine()</code> when TLF recognizes that a TextLine is extant.</li>
	 * </ul>
	 *
	 * 
	 * <p>Your application may have additional TextLine instances that can be reused. 
	 * To manually reuse existing TextLine instances:</p>
	 * <ol>
	 *   <li>trap calls to <code>TextBlock.createTextLine()</code>, then</li>
	 *   <li>call <code>TextBlock.recreateTextLine()</code> with the extant TextLine instance instead 
	 * of <code>TextBlock.createTextLine()</code>.</li>
	 * </ol>
	 * <p>Please note, however, that the <code>TextBlock.recreateTextLine()</code> is available
	 * only in Flash Player 10.1 and later.</p>
	 *
	 * @see org.apache.royale.text.engine.TextBlock#createTextLine()
	 * @see org.apache.royale.text.engine.TextBlock#recreateTextLine()
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public interface ISWFContext
	{
	    /**
	     *  A way to call a method in a client controlled context.
	     *
	     *  @param fn The function or method to call
	     *  @param thisArg The this pointer for the function
	     *  @param argArray The arguments for the function
	     *  @param returns If true, the function returns a value
	     *
	     *  @return Whatever the function returns, if anything.
	     *
	     *  @see Function#apply()
	
	     *  @langversion 3.0
	     *  @playerversion Flash 10
	     *  @playerversion AIR 1.5
	     */
	    function callInContext(fn:Function, thisArg:Object, argArray:Array, returns:Boolean=true):*;
	}
}
