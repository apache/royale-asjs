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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IColorSpectrumModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModel;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
	
    /**
     *  The HideColorSpectrumThumbWhenEmpty bead can modifiy a color spectrum 
	 *  view to hide the thumb when it's empty
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	public class HideColorSpectrumThumbWhenEmpty implements IBead
	{
		private var _strand:IStrand;
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
		public function HideColorSpectrumThumbWhenEmpty()
		{
			super();
		}
		
        /**
         *  @private
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			(colorModel as IEventDispatcher).addEventListener("baseColorChange", changeHandler);
			updateThumb();
		}
		
		private function changeHandler(e:Event):void
		{
			updateThumb();
		}
		
		/**
		 *  The track component.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get track():IUIBase
		{
			return _strand as IUIBase;
		}

		protected function updateThumb():void
		{
			(_strand.getBeadByType(ISliderView) as ISliderView).thumb.visible = !isNaN(colorModel.baseColor);
		}
		
		private function get colorModel():IColorSpectrumModel
		{
			return (_strand as IStrandWithModel).model as IColorSpectrumModel;
		}
	}
}
