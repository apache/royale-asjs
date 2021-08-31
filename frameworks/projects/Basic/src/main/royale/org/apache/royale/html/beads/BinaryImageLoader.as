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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.CallLaterBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBinaryImageLoader;
	import org.apache.royale.core.IBinaryImageModel;
	import org.apache.royale.core.IImageView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.loadBeadFromValuesManager;

    COMPILE::JS
    {
        import goog.events;
        import org.apache.royale.utils.URLUtils;
		import org.apache.royale.core.IBinaryImage;
    }
	
	
	/**
	 *  The ImageView class creates the visual elements of the org.apache.royale.html.Image component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class BinaryImageLoader implements IBinaryImageLoader
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function BinaryImageLoader()
		{
		}
		
        private var _objectURL:String;
        private var _strand:IStrand;
		
		private var _model:IBinaryImageModel;
		/**
     * @royaleignorecoercion org.apache.royale.core.IBinaryImageModel
		 * 
		 */
		private function get model():IBinaryImageModel
		{
			if(!_model)
				_model = loadBeadFromValuesManager(IBinaryImageModel, "iBeadModel", _strand) as IBinaryImageModel;
			
			return _model;
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			model.addEventListener("binaryChanged", handleBinaryChange);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IBinaryImage
		 * @royaleignorecoercion org.apache.royale.core.IBinaryImageModel
		 * @royaleignorecoercion org.apache.royale.core.IImageView
		 */
		private function handleBinaryChange(event:Event):void
		{
			var m:IBinaryImageModel = model;
			var imageView:IImageView = _strand.getBeadByType(IImageView) as IImageView;
			COMPILE::SWF
			{
				if (m.binary)
				{
					imageView.setupLoader();
					imageView.loader.loadBytes(m.binary.array);
				}
			}
			COMPILE::JS
			{
				if (m.binary)
				{
					imageView.setupLoader();
					if(_objectURL)
						URLUtils.revokeObjectURL(_objectURL);
					var blob:Blob = new Blob([m.binary.array]);
					// I don't think we need to specify the type.
//                    var blob = new Blob([response], {type: "image/png"});
					_objectURL = URLUtils.createObjectURL(blob);
					(_strand as IBinaryImage).applyImageData(_objectURL);
				}
			}
		}
	}
}
