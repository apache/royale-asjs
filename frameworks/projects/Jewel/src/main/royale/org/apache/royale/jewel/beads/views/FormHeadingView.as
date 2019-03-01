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
package org.apache.royale.jewel.beads.views
{
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ITextModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.GroupView;
    import org.apache.royale.jewel.FormHeading;
    import org.apache.royale.jewel.Label;

    /**
	 *  The FormHeadingView class creates the visual elements of the org.apache.royale.jewel.FormHeading
	 *  component. A FormHeading has two org.apache.royale.jewel.Labels.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class FormHeadingView extends GroupView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FormHeadingView()
		{
			super();
		}

		private var model:ITextModel;

		/**
		 *  The org.apache.royale.jewel.FormItem component
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		protected var formHeading:FormHeading;


		private var spacerLabel:Label;
		private var requiredSpacerLabel:Label;
		private var headingLabel:Label;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IBeadLayout
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IViewport
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

            formHeading = value as FormHeading;

            model = _strand.getBeadByType(ITextModel) as ITextModel;
			model.addEventListener("textChange", textChangeHandler);
			model.addEventListener("htmlChange", textChangeHandler);

			if (spacerLabel == null) {
				spacerLabel = createLabel("");
				spacerLabel.className = "spacerLabel";
			}
			if (spacerLabel != null && spacerLabel.parent == null) {
				formHeading.addElement(spacerLabel);
			}
			
			if (requiredSpacerLabel == null) {
				requiredSpacerLabel = createLabel("");
				requiredSpacerLabel.className = "requiredSpacerLabel";
			}
			if (requiredSpacerLabel != null && requiredSpacerLabel.parent == null) {
				formHeading.addElement(requiredSpacerLabel);
			}
			
			if (headingLabel == null) {
				headingLabel = createLabel(model.text);
				headingLabel.className="headingLabel";
			}
			if (headingLabel != null && headingLabel.parent == null) {
				formHeading.addElement(headingLabel);
			}
		}

		/**
		 * 
		 */
		public function createLabel(labelText:String = null):Label
		{
			var l:Label = new Label();
			if(labelText != null)
				l.text = labelText;
			return l;
		}

		/**
		 * 
		 */
		public function textChangeHandler(event:Event):void
		{
			headingLabel.text = model.text;
		}
    }
}