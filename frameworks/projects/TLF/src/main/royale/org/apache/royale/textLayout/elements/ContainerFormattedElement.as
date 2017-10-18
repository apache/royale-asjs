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
package org.apache.royale.textLayout.elements {
	import org.apache.royale.textLayout.compose.IFlowComposer;
	CONFIG::debug{
		import org.apache.royale.textLayout.container.IContainerController;
	}
	

	/** 
	* ContainerFormattedElement is the root class for all container-level block elements, such as DivElement
	* and TextFlow objects. Container-level block elements are grouping elements for other FlowElement objects.
	*
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	*
	* @see DivElement
	* @see TextFlow
	*/	
	public class ContainerFormattedElement extends ParagraphFormattedElement implements IContainerFormattedElement
	{
		override public function get className():String
		{
			return "ContainerFormattedElement";
		}
		/** @private */
		public function get flowComposer():IFlowComposer
		{ 
			// TODO: this is here for legacy purposes.  What we really want to do is determine if a given element has its own physical representation
			// That used to be the containerController and may be again.  This is all intermediate for now.  Reinvestigate when Tables are enabled and Div's with containers are implemented.
			return null; 
		}
		
		/** @private */
		public override function formatChanged(notifyModelChanged:Boolean = true):void
		{
			super.formatChanged(notifyModelChanged);
			// The associated container, if there is one, inherits its container
			// attributes from here. So we need to tell it that these attributes
			// have changed.
			if (flowComposer)
			{
				for (var idx:int = 0; idx < flowComposer.numControllers; idx++)
					flowComposer.getControllerAt(idx).formatChanged();
			}
		}
		
		/** @private */
		public function preCompose():void
		{ return; }
		
		/** @private */
		CONFIG::debug public override function debugCheckFlowElement(depth:int = 0, extraData:String = ""):int
		{
			// debugging function that asserts if the flow element tree is in an invalid state
			if (flowComposer && flowComposer.numControllers)
			{
				var controller:IContainerController = flowComposer.getControllerAt(0);
				extraData = getDebugIdentity(controller.container)+" b:"+controller.absoluteStart+" l:" +controller.textLength+extraData;
				extraData = extraData+" w:"+controller.compositionWidth+" h:"+controller.compositionHeight;
			}
			return super.debugCheckFlowElement(depth,extraData);
		}
		
		
		/** @private */
		public override function normalizeRange(normalizeStart:uint,normalizeEnd:uint):void
		{
			super.normalizeRange(normalizeStart,normalizeEnd);
			ElementHelper.normalizeContainerFormatRange(this);
		}
	}
}
