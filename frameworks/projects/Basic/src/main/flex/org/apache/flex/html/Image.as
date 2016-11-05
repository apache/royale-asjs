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
package org.apache.flex.html
{
	import org.apache.flex.core.IImageModel;
	import org.apache.flex.core.UIBase;
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
        import org.apache.flex.html.beads.models.ImageModel;
        import org.apache.flex.html.beads.ImageView;
    }
	
	/**
	 *  The Image class is a component that displays a bitmap. The Image uses
	 *  the following beads:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model for the Image, including the source property.
	 *  org.apache.flex.core.IBeadView: constructs the visual elements of the component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Image extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Image()
		{
			super();
		}
		
		/**
		 *  The location of the bitmap, usually a URL.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.IImageModel
		 */
		public function get url():String
		{
			return (model as IImageModel).url;
		}
		public function set url(value:String):void
		{
			(model as IImageModel).url = value;
		}
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            element = document.createElement('img') as WrappedHTMLElement;
            element.className = 'Image';
            typeNames = 'Image';
            
            positioner = element;
            positioner.style.position = 'relative';
            element.flexjs_wrapper = this;
         
            return element;
        }        

	}
}
