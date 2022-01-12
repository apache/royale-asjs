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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.DispatcherBead;
	import org.apache.royale.events.ValueEvent;

	/**
	 *  Dispatched when an image fails to load.
	 *  The ValueEvent contains the caught error event
	 *  https://developer.mozilla.org/en-US/docs/Web/API/Element/error_event
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.9
	 */
	[Event(name="error", type="org.apache.royale.events.ValueEvent")]

	/**
	 * Catches errors in loaded images anywhere in the hierarchy below the strand.
	 * Caught error can have global handling.
	 * Dispatches a ValueEvent which contains the caught event as its value.
	 */
	public class HandleImageLoadErrors extends DispatcherBead
	{

		public static const ERROR:String = "error";

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			attachListener();
		}
		COMPILE::JS
		private function attachListener():void
		{
			(_strand as IRenderedObject).element.addEventListener("error",handleError,true);
		}
		COMPILE::JS
		protected function handleError(ev:Event):void
		{
			if(ev.target is HTMLImageElement || ev.target is SVGImageElement)
			{
				dispatchEvent(new ValueEvent(ERROR,ev));
			}
		}

		COMPILE::SWF
		private function attachListener():void
		{
			//TODO SWF implementation
		}
		COMPILE::SWF
		protected function handleError(ev:Event):void
		{
			//TODO SWF implementation
		}

	}
}