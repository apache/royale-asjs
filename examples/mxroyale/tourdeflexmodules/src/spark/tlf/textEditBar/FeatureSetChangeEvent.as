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
package textEditBar
{
import flash.events.Event;
import flashx.textLayout.elements.TextFlow;

public class FeatureSetChangeEvent extends Event
{
	public const FEATURE_SET:String = "featureSet";
	
	public var featureSet:String;

	public function FeatureSetChangeEvent(newFeatureSet:String, type:String = FEATURE_SET,
							  bubbles:Boolean = false,
							  cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
		featureSet = newFeatureSet;
	}
	override public function clone():Event
	{
		return new FeatureSetChangeEvent(featureSet, type, bubbles, cancelable);
	}
}		// end class
}
