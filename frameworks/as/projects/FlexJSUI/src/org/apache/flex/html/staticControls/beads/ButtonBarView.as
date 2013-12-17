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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.supportClasses.Border;

	public class ButtonBarView extends ListView
	{
		public function ButtonBarView()
		{
			super();
		}
		
		private var _border:Border;
		
		override public function get border():Border
		{
			return _border;
		}
		
		private var _strand:IStrand;
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
			
			_border = new Border();
			_border.model = new (ValuesManager.valuesImpl.getValue(value, "iBorderModel")) as IBeadModel;
			_border.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);
			IParent(_strand).addElement(_border);
		}
	}
}