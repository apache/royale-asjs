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
package org.apache.royale.text.engine
{
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.EventDispatcher;

	public class GraphicElement extends ContentElement
	{
		public function GraphicElement(graphic:IUIBase = null, elementWidth:Number = 15.0, elementHeight:Number = 15.0, elementFormat:ElementFormat = null, eventMirror:EventDispatcher = null, textRotation:String = "rotate0")
		{
			this.graphic = graphic;
			this.elementWidth = elementWidth;
			this.elementHeight = elementHeight;
			super(elementFormat, eventMirror, textRotation);
		}
	public var elementHeight : Number;
	public var elementWidth : Number;
	public var graphic : IUIBase;
	}
}
