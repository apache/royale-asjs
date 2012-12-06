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
package org.apache.flex.core
{
	import flash.display.DisplayObject;
	
	import org.apache.flex.binding.SimpleBinding;
	import org.apache.flex.core.IStrand;

	public class ViewBase extends UIBase
	{
		public function ViewBase()
		{
			super();
		}
		
		public function get uiDescriptors():Array
		{
			return null;
		}
		
		public function initUI(app:Application):void
		{
			// cache this for speed
			var descriptors:Array = uiDescriptors;
			
			var n:int = descriptors.length;
			var i:int = 0;
			
			while (i < n)
			{
				var valueName:String;
				var value:Object;

				var c:Class = descriptors[i++];					// class
				var o:DisplayObject = new c() as DisplayObject;
				if (o is UIBase)
					UIBase(o).addToParent(this);
				else
					addChild(o);
				c = descriptors[i++];							// model
				if (c)
				{
					value = new c();
					IStrand(o).addBead(value as IBead);
				}
				if (o is IInitModel)
					IInitModel(o).initModel();
				var j:int;
				var m:int;
				valueName = descriptors[i++];					// id
				if (valueName)
					this[valueName] = o;

				m = descriptors[i++];							// num props
				for (j = 0; j < m; j++)
				{
					valueName = descriptors[i++];
					value = descriptors[i++];
					o[valueName] = value;
				}
				m = descriptors[i++];							// num beads
				for (j = 0; j < m; j++)
				{
					c = descriptors[i++];
					value = new c();
					IStrand(o).addBead(value as IBead);
				}
				if (o is IInitSkin)
				{
					IInitSkin(o).initSkin();
				}
				m = descriptors[i++];							// num events
				for (j = 0; j < m; j++)
				{
					valueName = descriptors[i++];
					value = descriptors[i++];
					o.addEventListener(valueName, value as Function);
				}
				m = descriptors[i++];							// num bindings
				for (j = 0; j < m; j++)
				{
					valueName = descriptors[i++];
					var bindingType:int = descriptors[i++];
					switch (bindingType)
					{
						case 0: 
							var sb:SimpleBinding = new SimpleBinding();
							sb.destination = o;
							sb.destinationPropertyName = valueName;
							sb.source = app[descriptors[i++]];
							sb.sourcePropertyName = descriptors[i++];
							sb.eventName = descriptors[i++];
							sb.initialize();
					}
				}
			}
		}
	}
}