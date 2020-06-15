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
package org.apache.royale.jewel.beads.controls.button
{	
	import org.apache.royale.core.ITextButton;
	import org.apache.royale.jewel.beads.layouts.ResponsiveVisibility;
	import org.apache.royale.jewel.Button;
	
	/**
	 *  The ResponsiveLabelVisibility bead class is a specialty bead that 
	 *  can be used to show or hide the label text of a Button depending on responsive
	 *  rules.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class ResponsiveLabelVisibility extends ResponsiveVisibility
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function ResponsiveLabelVisibility()
		{
		}
		
		override protected function showOrHideHost():void
		{
			COMPILE::JS
			{
			// var button:ITextButton = _strand as ITextButton;
			var button:Button = _strand as Button;
			if (button)
            {
				var spanLabel:HTMLSpanElement = button.spanLabel;
				spanLabel.classList.remove("visible-phone");
				spanLabel.classList.remove("hidden-phone");
				spanLabel.classList.remove("visible-tablet");
				spanLabel.classList.remove("hidden-tablet");
				spanLabel.classList.remove("visible-desktop");
				spanLabel.classList.remove("hidden-desktop");
				spanLabel.classList.remove("visible-widescreen");
				spanLabel.classList.remove("hidden-widescreen");

				if(phoneVisible != null)
				{
					if(phoneVisible)
						spanLabel.classList.add("visible-phone");
					else
						spanLabel.classList.add("hidden-phone");
				}

				if(tabletVisible != null)
				{
					if(tabletVisible)
						spanLabel.classList.add("visible-tablet");
					else
						spanLabel.classList.add("hidden-tablet");
				}
				
				if(desktopVisible != null)
				{
					if(desktopVisible)
						spanLabel.classList.add("visible-desktop");
					else
						spanLabel.classList.add("hidden-desktop");
				}

				if(wideScreenVisible != null)
				{
					if(wideScreenVisible)
						spanLabel.classList.add("visible-widescreen");
					else
						spanLabel.classList.add("hidden-widescreen");
				}
			}
        	}
		}
	}
}
