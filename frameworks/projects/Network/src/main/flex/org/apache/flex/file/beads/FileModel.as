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
package org.apache.flex.file.beads
{
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.EventDispatcher;

	COMPILE::SWF
	{
		import flash.net.FileReference;
	}
	
	/**
	 *  The FileModel class is a bead that contains basic information
	 *  on the file referenced by FileProxy
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class FileModel extends EventDispatcher implements IBeadModel
	{
		private var _strand:IStrand;
		COMPILE::SWF
		{
			private var _data:FileReference;
		}
		COMPILE::JS
		{
			private var _data:File;
		}
	
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function FileModel(data:Object)
		{
			COMPILE::SWF
			{
				_data = data as FileReference;			
			}
			COMPILE::JS
			{
				_data = data as File;			
			}
		}
		
		
		
		/**
		 *  The size of the file
		 * 
		 *  @copy org.apache.flex.core.IAlertModel#title
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get size():Number
		{
			return _data.size;
		}
		
		/**
		 *  The name of the file
		 * 
		 *  @copy org.apache.flex.core.IAlertModel#title
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get name():String
		{
			return _data.name;
		}
		
		// TODO this will give different results in flash and in JS (extension and MIME respectively). Fix this.
		/**
		 *  The type
		 * 
		 *  @copy org.apache.flex.core.IAlertModel#title
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get type():String
		{
			return _data.type;
		}
		
		/**
		 *  The last modified time of the file, in millisecond since the UNIX epoch (January 1st, 1970 at Midnight).
		 * 
		 *  @copy org.apache.flex.core.IAlertModel#title
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get lastModified():uint
		{
			COMPILE::SWF
			{
				return _data.modificationDate.milliseconds;
			}
			COMPILE::JS
			{
				return _data.lastModified;
			}
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
	}
}