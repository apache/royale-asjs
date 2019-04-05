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

package mx.messaging.messages
{

import org.apache.royale.utils.BinaryData;
import org.apache.royale.utils.net.IDataInput;
import org.apache.royale.utils.net.IDataOutput;

import mx.utils.RPCUIDUtil;

[RemoteClass(alias="flex.messaging.messages.AsyncMessage")]

/**
 *  AsyncMessage is the base class for all asynchronous messages.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3
 */
public class AsyncMessage extends AbstractMessage implements ISmallMessage
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    //
    //--------------------------------------------------------------------------
    
	/**
	 *  Messages sent by a MessageAgent with a defined <code>subtopic</code>
	 *  property indicate their target subtopic in this header.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion BlazeDS 4
	 *  @productversion LCDS 3
	 */
	public static const SUBTOPIC_HEADER:String = "DSSubtopic";

    //--------------------------------------------------------------------------
    //
    // Private Static Constants for Serialization
    //
    //--------------------------------------------------------------------------

    private static const CORRELATION_ID_FLAG:uint = 1;
    private static const CORRELATION_ID_BYTES_FLAG:uint = 2;

    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructs an instance of an AsyncMessage with an empty body and header.
     *  In addition to this default behavior, the body and the headers for the
     *  message may also be passed to the constructor as a convenience.
     *  An example of this invocation approach for the body is:
     *  <code>var msg:AsyncMessage = new AsyncMessage("Body text");</code>
     *  An example that provides both the body and headers is:
     *  <code>var msg:AsyncMessage = new AsyncMessage("Body text", {"customerHeader":"customValue"});</code>
     *
     *  @param body The optional body to assign to the message.
     *
     *  @param headers The optional headers to assign to the message.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public function AsyncMessage(body:Object = null, headers:Object = null)
    {
        super();

        correlationId = "";
        if (body != null)
            this.body = body;
            
        if (headers != null)
            this.headers = headers;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------

	//----------------------------------
	//  correlationId
	//----------------------------------

    /**
     * @private
     */
    private var _correlationId:String;

    /**
     * @private
     */
    private var correlationIdBytes:BinaryData;

    /**
     *  Provides access to the correlation id of the message.
     *  Used for acknowledgement and for segmentation of messages.
     *  The <code>correlationId</code> contains the <code>messageId</code> of the
     *  previous message that this message refers to.
     *
     *  @see mx.messaging.messages.AbstractMessage#messageId
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public function get correlationId():String
    {
        return _correlationId;
    }

    /**
     * @private
     */
    public function set correlationId(value:String):void
    {
        _correlationId = value;
        correlationIdBytes = null;
    }

    //--------------------------------------------------------------------------
    //
    // Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public function getSmallMessage():IMessage
    {
        // If it is a subclass, it will need to override this itself if it wants to use
        // small messages.
        var o:Object = this;
        if (o.constructor == AsyncMessage)
            return new AsyncMessageExt(this);
        return null;
    }

    /**
     * @private
     */
    override public function readExternal(input:IDataInput):void
    {
        super.readExternal(input);

        var flagsArray:Array = readFlags(input);
        for (var i:uint = 0; i < flagsArray.length; i++)
        {
            var flags:uint = flagsArray[i] as uint;
            var reservedPosition:uint = 0;

            if (i == 0)
            {
                if ((flags & CORRELATION_ID_FLAG) != 0)
                    correlationId = input.readObject() as String;

                if ((flags & CORRELATION_ID_BYTES_FLAG) != 0)
                {
                    correlationIdBytes = input.readObject() as BinaryData;
                    correlationId = RPCUIDUtil.fromBinary(correlationIdBytes);
                }

                reservedPosition = 2;
            }

            // For forwards compatibility, read in any other flagged objects
            // to preserve the integrity of the input stream...
            if ((flags >> reservedPosition) != 0)
            {
                for (var j:uint = reservedPosition; j < 6; j++)
                {
                    if (((flags >> j) & 1) != 0)
                    {
                        input.readObject();
                    }
                }
            }
        }
    }

    /**
     * @private
     */
    override public function writeExternal(output:IDataOutput):void
    {
        super.writeExternal(output);

        if (correlationIdBytes == null)
            correlationIdBytes = RPCUIDUtil.toBinary(_correlationId);

        var flags:uint = 0;

        if (correlationId != null && correlationIdBytes == null)
            flags |= CORRELATION_ID_FLAG;

        if (correlationIdBytes != null)
            flags |= CORRELATION_ID_BYTES_FLAG;

        output.writeByte(flags);

        if (correlationId != null && correlationIdBytes == null)
            output.writeObject(correlationId);

        if (correlationIdBytes != null)
            output.writeObject(correlationIdBytes);
    }

    /**
     *  @private
     */
    override protected function addDebugAttributes(attributes:Object):void
    {
        super.addDebugAttributes(attributes);
        attributes["correlationId"] = correlationId;
    }


}

}
