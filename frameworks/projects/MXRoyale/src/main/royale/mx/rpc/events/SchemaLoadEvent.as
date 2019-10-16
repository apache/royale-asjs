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

package mx.rpc.events
{

import org.apache.royale.events.IRoyaleEvent;
import org.apache.royale.events.Event;
import mx.rpc.xml.Schema;

[ExcludeClass]

/**
 * This event is dispatched when an XML Schema has loaded sucessfully.
 * 
 * @private
 */
public class SchemaLoadEvent extends XMLLoadEvent
{
    /**
     * Creates a new SchemaLoadEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SchemaLoadEvent(type:String, bubbles:Boolean = false, 
        cancelable:Boolean = true, schema:Schema = null, location:String = null)
    {
        super(type == null ? LOAD : type,
            bubbles,
            cancelable,
            schema == null ? null : schema.xml,
            location);

        this.schema = schema;
    }

    /**
     * The full Schema document.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var schema:Schema;

    /**
     * Returns a copy of this SchemaLoadEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function cloneEvent():IRoyaleEvent
    {
        return new SchemaLoadEvent(type, bubbles, cancelable, schema, location);
    }

    /**
     * Returns a String representation of this SchemaLoadEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function toString():String
    {
        return formatToString("SchemaLoadEvent", "location", "type", "bubbles",
            "cancelable", "eventPhase");
    }

    /**
     * A helper method to create a new SchemaLoadEvent.
     * @private
     */
    public static function createEvent(schema:Schema, location:String = null):SchemaLoadEvent
    {
        return new SchemaLoadEvent(LOAD, false, true, schema, location);
    }

    public static const LOAD:String = "schemaLoad";
}

}