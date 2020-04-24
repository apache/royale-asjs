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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.binding
{
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.reflection.DefinitionWithMetaData;
	import org.apache.royale.reflection.MetaDataArgDefinition;
	import org.apache.royale.reflection.MetaDataDefinition;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.utils.getMembersWithNameMatch;
	import org.apache.royale.reflection.utils.filterForMetaTags;


[ExcludeClass]

/**
 *  @private
 *  Bindability information for children (properties or methods)
 *  of a given class, based on the describeType() structure for that class.
 */
public class BindabilityInfo
{

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Name of [Bindable] metadata.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const BINDABLE:String = "Bindable";
	


	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function BindabilityInfo(typeDefinition:TypeDefinition)
	{
		super();

		this.typeDefinition = typeDefinition;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private var typeDefinition:TypeDefinition;
	
	/**
	 *  @private
	 *  event name -> true
	 */
	private var classChangeEvents:Object;
	
	/**
	 *  @private
	 *  child name -> { event name -> true }
	 */
	private var childChangeEvents:Object = {};	

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  Object containing { eventName: true } for each change event
	 *  (class- or child-level) that applies to the specified child.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getChangeEvents(childName:String):Object
	{
		var changeEvents:Object = childChangeEvents[childName];

		if (!changeEvents)
		{
			// Seed with class-level events.
			changeEvents = copyProps(getClassChangeEvents(), {});
			
			var accessorsAndMethods:Array = [];
			
			getMembersWithNameMatch(typeDefinition.accessors, childName, accessorsAndMethods);
			getMembersWithNameMatch(typeDefinition.methods, childName, accessorsAndMethods);
			
			var numChildren:int = accessorsAndMethods.length;

			if (numChildren == 0)
			{
				trace("warning: no describeType entry for '" +
					  childName + "' on non-dynamic type '" +
					  typeDefinition.name + "'");
			}
			else
			{
				if (numChildren > 1)
				{
					trace("warning: multiple describeType entries for '" +
						  childName + "' on type '" + typeDefinition.name +
						  "':\n" + accessorsAndMethods);
				}

				addBindabilityEvents(accessorsAndMethods, changeEvents);
			}

			childChangeEvents[childName] = changeEvents;
		}

		return changeEvents;
	}

	/**
	 *  @private
	 *  Build or return cached class change events object.
	 */
	private function getClassChangeEvents():Object
	{
		if (!classChangeEvents)
		{
			classChangeEvents = {};

			//@todo check this (currently fails in swf at runtime)
			//addBindabilityEvents(typeDefinition.metadata, classChangeEvents);
			

			//if class has Bindable metadata, assume yes ?
			if (typeDefinition.retrieveMetaDataByName('Bindable').length) {
				classChangeEvents[ValueChangeEvent.VALUE_CHANGE] = true;
			}
			// tbd, do we want this?
			// Class-level [Managed] means all properties
			// dispatch valueChange.
			if (typeDefinition.retrieveMetaDataByName('Managed').length) {
				classChangeEvents[ValueChangeEvent.VALUE_CHANGE] = true;
			}
			
		}

		return classChangeEvents;
	}

	/**
	 *  @private
	 */
	private function addBindabilityEvents(members:Array,
										  eventListObj:Object):void
	{
		var metaNames:Array = [BINDABLE];
		var changeEvents:Array = filterForMetaTags(members, metaNames);

		addChangeEvents(changeEvents, eventListObj );
	}

	/**
	 *  @private
	 *  Transfer change events from a list of change-event-carrying metadata
	 *  to an event list object.
	 *  Note: metadata's first arg value is assumed to be change event name.
	 */
	private function addChangeEvents(members:Array, eventListObj:Object):void
	{
		for each (var md:DefinitionWithMetaData in members)
		{
			var metaNames:Array = [BINDABLE];

			for each(var meta:String in metaNames) {
				var metaItems:Array = md.retrieveMetaDataByName(meta);
				if (metaItems.length) {
					//if there is no arg, then it is valueChange
					for each(var metaItem:MetaDataDefinition in metaItems) {
						if (metaItem.args.length) {
							//check for no key
							var eventTypeArgs:Array = metaItem.getArgsByKey('');
							if (!eventTypeArgs.length) {
								//check for 'event' key
								eventTypeArgs = metaItem.getArgsByKey('event');
							}
							if (eventTypeArgs.length) {
								eventListObj[MetaDataArgDefinition(eventTypeArgs[0]).value] = true;
							}
						} else {
							if (meta == BINDABLE) {
								eventListObj[ValueChangeEvent.VALUE_CHANGE] = true;
							}
							 else {
								trace("warning: unconverted change events metadata in class '" +
										typeDefinition.name + "'", metaItem);
							}
							
						}
					}
				}
			}
		}
	}

	/**
	 *  @private
	 *  Copy properties from one object to another.
	 */
	private function copyProps(from:Object, to:Object):Object
	{
		for (var propName:String in from)
		{
			to[propName] = from[propName];
		}

		return to;
	}
}

}
