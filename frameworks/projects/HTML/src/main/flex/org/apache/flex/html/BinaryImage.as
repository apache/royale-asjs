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
	import org.apache.flex.core.IBinaryImage;
	import org.apache.flex.core.IBinaryImageModel;
	import org.apache.flex.core.UIBase;
    import org.apache.flex.utils.BinaryData;
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
        import org.apache.flex.html.beads.models.BinaryImageModel;
        import org.apache.flex.html.beads.BinaryImageView;
    }
	
	/**
	 *  The Image class is a component that displays a bitmap. The Image uses
	 *  the following beads:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model for the Image, including the url/binary property.
	 *  org.apache.flex.core.IBeadView: constructs the visual elements of the component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class BinaryImage extends Image implements IBinaryImage
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function BinaryImage()
		{
			super();
		}
		
		/**
		 *  The binary bitmap data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.IImageModel
		 */
		public function get binary():BinaryData
		{
			return (model as IBinaryImageModel).binary;
		}
		public function set binary(value:BinaryData):void
		{
			(model as IBinaryImageModel).binary = value;
		}
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
        	createElementInternal();
            
            model = new BinaryImageModel();
            
            addBead(new BinaryImageView());
            
            return element;
        }        

	}
}
