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
	
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IParent;
    import org.apache.flex.core.ValuesManager;
	import org.apache.flex.html.staticControls.supportClasses.Border;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

    /**
     *  The TextInputWithBorderView class is the default view for
     *  the org.apache.flex.html.staticControls.TextInput.
     *  It displays text using a TextField, so there is no
     *  right-to-left text support in this view.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class TextInputWithBorderView extends TextInputView
	{
		public function TextInputWithBorderView()
		{
			super();
		}
		
		private var _border:Border;
				
        /**
         *  @private
         */        
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			// add a border to this
			_border = new Border();
			_border.model = new (ValuesManager.valuesImpl.getValue(value, "iBorderModel")) as IBeadModel;
			_border.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);
            IParent(strand).addElement(_border);
			
			IEventDispatcher(strand).addEventListener("widthChanged", sizeChangedHandler);
			IEventDispatcher(strand).addEventListener("heightChanged", sizeChangedHandler);
			sizeChangedHandler(null);
		}
		
		private function sizeChangedHandler(event:Event):void
		{
			var ww:Number = DisplayObject(strand).width;
			_border.width = ww;
			
			var hh:Number = DisplayObject(strand).height;
			_border.height = hh;
		}
	}
}