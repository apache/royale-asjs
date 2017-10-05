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
package org.apache.royale.utils
{
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.effects.IEffect;
	import org.apache.royale.effects.Resize;
	
	public class ResizeGenerator implements IEffectsGenerator
	{
		public function ResizeGenerator()
		{
		}
		
		public function generateEffect(source:ILayoutChild, destination:ILayoutChild):IEffect
		{
			var widthDiff:Number = destination.width - source.width;
			var heightDiff:Number = destination.height - source.height;
			if (widthDiff != 0 || heightDiff != 0)
			{
				var resize:Resize = new Resize(source as IUIBase);
				resize.widthBy = widthDiff;
				resize.heightBy = heightDiff;
				return resize;
			}
			return null;
		}
		
	}
}
