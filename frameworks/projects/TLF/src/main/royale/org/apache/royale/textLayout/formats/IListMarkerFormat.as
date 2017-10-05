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
package org.apache.royale.textLayout.formats
{
	/**
	 * This interface provides read access to ListMarkerFormat properties.
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public interface IListMarkerFormat extends ITextLayoutFormat
	{
		/** @copy ListMarkerFormat#counterReset*/
		function get counterReset():*;
		/** @copy ListMarkerFormat#counterIncrement*/
		function get counterIncrement():*;
		/** @copy ListMarkerFormat#beforeContent*/
		function get beforeContent():*;
		/** @copy ListMarkerFormat#content*/
		function get content():*;
		/** @copy ListMarkerFormat#afterContent*/
		function get afterContent():*;
		/** @copy ListMarkerFormat#suffix*/
		function get suffix():*;
	}
}
