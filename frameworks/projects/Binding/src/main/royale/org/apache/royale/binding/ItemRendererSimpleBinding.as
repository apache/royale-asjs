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
package org.apache.royale.binding
{
import org.apache.royale.core.IBead;
import org.apache.royale.core.IStrand;
import org.apache.royale.core.IDocument;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.Event;
import org.apache.royale.events.ValueChangeEvent;

/**
 *  The SimpleBinding class is lightweight data-binding class that
 *  is optimized for simple assignments of one object's property to
 *  another object's property.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class ItemRendererSimpleBinding implements IBead, IDocument
{
	/**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function ItemRendererSimpleBinding()
	{
	}

	/**

	 *  The source object that dispatches an event
	 *  when the property changes
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	protected var source:Object;

	/**
	 *  The host mxml document for the source and
	 *  destination objects.  The source object
	 *  is either this document for simple bindings
	 *  like {foo} where foo is a property on
	 *  the mxml documnet, or found as document[sourceID]
	 *  for simple bindings like {someid.someproperty}
	 *  It may be the document class for local static
	 *  bindables (e.g. from a script block)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	protected var document:Object;

    private var _destinationID:String;

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
    public function get destinationID():String
    {
        return _destinationID;
    }
    
    public function set destinationID(value:String):void
    {
        _destinationID = value;
    }

    private var _sourcePropertyName:String;
    
	/**
	 *  If not null, the name of a property on the
	 *  mxml document that is being watched for changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    public function get sourcePropertyName():String
    {
        return _sourcePropertyName;
    }
    
    public function set sourcePropertyName(value:String):void
    {
        _sourcePropertyName = value;
    }

    private var _destinationPropertyName:String;
    
	/**
	 *  The name of the property on the strand that
	 *  is set when the source property changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    public function get destinationPropertyName():String
    {
        return _destinationPropertyName;
    }
    
    public function set destinationPropertyName(value:String):void
    {
        _destinationPropertyName = value;
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
		document.addEventListener("dataChange",
							dataChangeHandler);
	}

	/**
	 *  @copy org.apache.royale.core.IDocument#setDocument()
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public function setDocument(document:Object, id:String = null):void
	{
		this.document = document;
	}

	private function dataChangeHandler(event:Event):void
	{
		if (destinationID == "this")
		{
			document[destinationPropertyName] = document.data[sourcePropertyName];
		}
		else
        {
            document[destinationID][destinationPropertyName] = document.data[sourcePropertyName];
        }
	}

}
}
