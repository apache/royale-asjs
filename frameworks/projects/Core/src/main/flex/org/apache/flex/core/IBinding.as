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
package org.apache.royale.core
{
	/**
	 *  IBinding interface is a "marker" for data-binding class that
	 *  is optimized for simple assignments of one object's property to
	 *  another object's property.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface IBinding
	{
		/**
		 *  The destination object.  It is always the same
		 *  as the strand.  SimpleBindings are attached to
		 *  the strand of the destination object.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
        function get destination():Object;
        function set destination(value:Object):void;

		/**
		 *  If not null, the id of the mxml tag who's property
		 *  is being watched for changes.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		 function get sourceID():String;
		 function set sourceID(value:String):void;

		/**
		 *  If not null, the name of a property on the
		 *  mxml document that is being watched for changes.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		 function get sourcePropertyName():String;
		 function set sourcePropertyName(value:String):void;

		/**
		 *  The name of the property on the strand that
		 *  is set when the source property changes.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		 function get destinationPropertyName():String;
		 function set destinationPropertyName(value:String):void;
    }
}
