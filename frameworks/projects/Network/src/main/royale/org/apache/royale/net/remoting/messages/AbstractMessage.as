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

package org.apache.royale.net.remoting.messages
{
    import org.apache.royale.utils.ObjectUtil;
	COMPILE::SWF{
		import flash.utils.IDataInput;
		import flash.utils.IDataOutput;
	}
	
	COMPILE::JS{
		import org.apache.royale.utils.net.IDataInput;
		import org.apache.royale.utils.net.IDataOutput;
	}
    import org.apache.royale.utils.BinaryData;
    import org.apache.royale.utils.UIDUtil;
    

    /*
    import mx.utils.RPCObjectUtil;
    import mx.utils.RPCStringUtil;
    */

    /**
     *  Abstract base class for all messages.
     *  Messages have two customizable sections; headers and body.
     *  The <code>headers</code> property provides access to specialized meta
     *  information for a specific message instance.
     *  The <code>headers</code> property is an associative array with the specific
     *  header name as the key.
     *  <p>
     *  The body of a message contains the instance specific data that needs to be
     *  delivered and processed by the remote destination.
     *  The <code>body</code> is an object and is the payload for a message.
     *  </p>
     *
     *  Note: readExternal and writeExternal methods compile but are not tested and maybe not work
     *  but is an initial work
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public class AbstractMessage implements IMessage
    {
        //--------------------------------------------------------------------------
        //
        // Static Constants
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Messages pushed from the server may arrive in a batch, with messages in the
         *  batch potentially targeted to different Consumer instances.
         *  Each message will contain this header identifying the Consumer instance that
         *  will receive the message.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const DESTINATION_CLIENT_ID_HEADER:String = "DSDstClientId";

        /**
         *  Messages are tagged with the endpoint id for the Channel they are sent over.
         *  Channels set this value automatically when they send a message.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const ENDPOINT_HEADER:String = "DSEndpoint";

        /**
         *  This header is used to transport the global RoyaleClient Id value in outbound
         *  messages once it has been assigned by the server.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const ROYALE_CLIENT_ID_HEADER:String = "DSId";

        /**
         *  Messages sent by a MessageAgent can have a priority header with a 0-9
         *  numerical value (0 being lowest) and the server can choose to use this
         *  numerical value to prioritize messages to clients.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const PRIORITY_HEADER:String = "DSPriority";

        /**
         *  Messages that need to set remote credentials for a destination
         *  carry the Base64 encoded credentials in this header.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const REMOTE_CREDENTIALS_HEADER:String = "DSRemoteCredentials";

        /**
         *  Messages that need to set remote credentials for a destination
         *  may also need to report the character-set encoding that was used to
         *  create the credentials String using this header.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const REMOTE_CREDENTIALS_CHARSET_HEADER:String = "DSRemoteCredentialsCharset";
        
        /**
         *  Messages sent with a defined request timeout use this header.
         *  The request timeout value is set on outbound messages by services or
         *  channels and the value controls how long the corresponding MessageResponder
         *  will wait for an acknowledgement, result or fault response for the message
         *  before timing out the request.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const REQUEST_TIMEOUT_HEADER:String = "DSRequestTimeout";

        /**
         *  A status code can provide context about the nature of a response
         *  message. For example, messages received from an HTTP based channel may
         *  need to report the HTTP response status code (if available).
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const STATUS_CODE_HEADER:String = "DSStatusCode";


        //--------------------------------------------------------------------------
        //
        // Private Static Constants for Serialization
        //
        //--------------------------------------------------------------------------

        private static const HAS_NEXT_FLAG:uint = 128;
        private static const BODY_FLAG:uint = 1;
        private static const CLIENT_ID_FLAG:uint = 2;
        private static const DESTINATION_FLAG:uint = 4;
        private static const HEADERS_FLAG:uint = 8;
        private static const MESSAGE_ID_FLAG:uint = 16;
        private static const TIMESTAMP_FLAG:uint = 32;
        private static const TIME_TO_LIVE_FLAG:uint = 64;
        private static const CLIENT_ID_BYTES_FLAG:uint = 1;
        private static const MESSAGE_ID_BYTES_FLAG:uint = 2;

        //--------------------------------------------------------------------------
        //
        // Constructor
        //
        //--------------------------------------------------------------------------

        /**
         *  Constructs an instance of an AbstractMessage with an empty body and header.
         *  This message type should not be instantiated or used directly.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function AbstractMessage()
        {
            super();
        }

        //--------------------------------------------------------------------------
        //
        // Properties
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  body
        //----------------------------------

        /**
         *  @private
         */
        private var _body:Object = {};

        /**
         *  The body of a message contains the specific data that needs to be
         *  delivered to the remote destination.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function get body():Object
        {
            return _body;
        }
        
        /**
         *  @private
         */
        public function set body(value:Object):void
        {
            _body = value;
        }

        //----------------------------------
        //  clientId
        //----------------------------------

        /**
         *  @private
         */
        private var _clientId:String;

        /**
         * @private
         */
        private var clientIdBytes:BinaryData;

        /**
         *  The clientId indicates which MessageAgent sent the message.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function get clientId():String
        {
            return _clientId;
        }

        /**
         *  @private
         */
        public function set clientId(value:String):void
        {
            _clientId = value;
            clientIdBytes = null;
        }

        //----------------------------------
        //  destination
        //----------------------------------
        
        /**
         *  @private
         */
        private var _destination:String = "";
        
        /**
         *  The message destination.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function get destination():String
        {
            return _destination;
        }
        
        /**
         *  @private
         */
        public function set destination(value:String):void
        {
            _destination = value;
        }
        
        //----------------------------------
        //  headers
        //----------------------------------

        /**
         *  @private
         */
        private var _headers:Object;

        /**
         *  The headers of a message are an associative array where the key is the
         *  header name and the value is the header value.
         *  This property provides access to the specialized meta information for the
         *  specific message instance.
         *  Core header names begin with a 'DS' prefix. Custom header names should start
         *  with a unique prefix to avoid name collisions.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function get headers():Object
        {
            if (_headers == null)
                _headers = {};

            return _headers;
        }

        /**
         *  @private
         */
        public function set headers(value:Object):void
        {
            _headers = value;
        }
        
        //----------------------------------
        //  messageId
        //----------------------------------

        /**
         *  @private
         */
        private var _messageId:String;

        /**
         * @private
         */
        private var messageIdBytes:BinaryData;

        /**
         *  The unique id for the message.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function get messageId():String
        {
            if (_messageId == null)
                _messageId = UIDUtil.createUID();

            return _messageId;
        }

        /**
         *  @private
         */
        public function set messageId(value:String):void
        {
            _messageId = value;
            messageIdBytes = null;
        }

        //----------------------------------
        //  timestamp
        //----------------------------------

        /**
         *  @private
         */
        private var _timestamp:Number = 0;
        
        /**
         *  Provides access to the time stamp for the message.
         *  A time stamp is the date and time that the message was sent.
         *  The time stamp is used for tracking the message through the system,
         *  ensuring quality of service levels and providing a mechanism for
         *  message expiration.
         *
         *  @see #timeToLive
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function get timestamp():Number
        {
            return _timestamp;
        }
        
        /**
         *  @private
         */
        public function set timestamp(value:Number):void
        {
            _timestamp = value;
        }
        
        //----------------------------------
        //  timeToLive
        //----------------------------------
        
        /**
         *  @private
         */
        private var _timeToLive:Number = 0;
        
        /**
         *  The time to live value of a message indicates how long the message
         *  should be considered valid and deliverable.
         *  This value works in conjunction with the <code>timestamp</code> value.
         *  Time to live is the number of milliseconds that this message remains
         *  valid starting from the specified <code>timestamp</code> value.
         *  For example, if the <code>timestamp</code> value is 04/05/05 1:30:45 PST
         *  and the <code>timeToLive</code> value is 5000, then this message will
         *  expire at 04/05/05 1:30:50 PST.
         *  Once a message expires it will not be delivered to any other clients.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function get timeToLive():Number
        {
            return _timeToLive;
        }
        
        /**
         *  @private
         */
        public function set timeToLive(value:Number):void
        {
            _timeToLive = value;
        }

        //--------------------------------------------------------------------------
        //
        // Methods
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         *
         * While this class itself does not implement flash.utils.IExternalizable,
         * ISmallMessage implementations will typically use IExternalizable to
         * serialize themselves in a smaller form. This method supports this
         * functionality by implementing IExternalizable.readExternal(IDataInput) to
         * deserialize the properties for this abstract base class.
         */
        public function readExternal(input:IDataInput):void
        {
            trace("AbstractMessage.readExternal");
            var flagsArray:Array = readFlags(input);

            for (var i:uint = 0; i < flagsArray.length; i++)
            {
                var flags:uint = flagsArray[i] as uint;
                var reservedPosition:uint = 0;

                if (i == 0)
                {
                    if ((flags & BODY_FLAG) != 0)
                        readExternalBody(input);
                    else
                        body = null; // default body is {} so need to set it here

                    if ((flags & CLIENT_ID_FLAG) != 0)
                        clientId = input.readObject();
            
                    if ((flags & DESTINATION_FLAG) != 0)
                        destination = input.readObject() as String;
            
                    if ((flags & HEADERS_FLAG) != 0)
                        headers = input.readObject();
            
                    if ((flags & MESSAGE_ID_FLAG) != 0)
                        messageId = input.readObject() as String;
            
                    if ((flags & TIMESTAMP_FLAG) != 0)
                        timestamp = input.readObject() as Number;
            
                    if ((flags & TIME_TO_LIVE_FLAG) != 0)
                        timeToLive = input.readObject() as Number;

                    reservedPosition = 7;
                }
                else if (i == 1)
                {
                    if ((flags & CLIENT_ID_BYTES_FLAG) != 0)
                    {
                        clientIdBytes = input.readObject() as BinaryData;
                        clientId = UIDUtil.fromBinary(clientIdBytes);
                    }
            
                    if ((flags & MESSAGE_ID_BYTES_FLAG) != 0)
                    {
                        messageIdBytes = input.readObject() as BinaryData;
                        messageId = UIDUtil.fromBinary(messageIdBytes);
                    }

                    reservedPosition = 2;
                }

                // For forwards compatibility, read in any other flagged objects to
                // preserve the integrity of the input stream...
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
         *  Returns a string representation of the message.
         *
         *  @return String representation of the message.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function toString():String
        {
            return ObjectUtil._toString(this);
        }

        /**
         * @private
         *
         * While this class itself does not implement flash.utils.IExternalizable,
         * ISmallMessage implementations will typically use IExternalizable to
         * serialize themselves in a smaller form. This method supports this
         * functionality by implementing IExternalizable.writeExternal(IDataOutput)
         * to efficiently serialize the properties for this abstract base class.
         */
        public function writeExternal(output:IDataOutput):void
        {
            var flags:uint = 0;

            // Since we're using custom serialization, we have to invoke the
            // messageId getter to ensure we have a valid id for the message.
            var checkForMessageId:String = messageId;

            if (clientIdBytes == null)
                clientIdBytes = UIDUtil.toBinary(_clientId);

            if (messageIdBytes == null)
                messageIdBytes = UIDUtil.toBinary(_messageId);

            if (body != null)
                flags |= BODY_FLAG;

            if (clientId != null && clientIdBytes == null)
                flags |= CLIENT_ID_FLAG;

            if (destination != null)
                flags |= DESTINATION_FLAG;

            if (headers != null)
                flags |= HEADERS_FLAG;

            if (messageId != null && messageIdBytes == null)
                flags |= MESSAGE_ID_FLAG;

            if (timestamp != 0)
                flags |= TIMESTAMP_FLAG;

            if (timeToLive != 0)
                flags |= TIME_TO_LIVE_FLAG;

            if (clientIdBytes != null || messageIdBytes != null)
                flags |= HAS_NEXT_FLAG;

            output.writeByte(flags);

            flags = 0;

            if (clientIdBytes != null)
                flags |= CLIENT_ID_BYTES_FLAG;

            if (messageIdBytes != null)
                flags |= MESSAGE_ID_BYTES_FLAG;

            // This is only read if the previous flag has HAS_NEXT_FLAG set
            if (flags != 0)
                output.writeByte(flags);

            if (body != null)
                writeExternalBody(output);

            if (clientId != null && clientIdBytes == null)
                output.writeObject(clientId);

            if (destination != null)
                output.writeObject(destination);

            if (headers != null)
                output.writeObject(headers);

            if (messageId != null && messageIdBytes == null)
                output.writeObject(messageId);

            if (timestamp != 0)
                output.writeObject(timestamp);

            if (timeToLive != 0)
                output.writeObject(timeToLive);

            if (clientIdBytes != null)
                output.writeObject(clientIdBytes);

            if (messageIdBytes != null)
                output.writeObject(messageIdBytes);
        }

        //--------------------------------------------------------------------------
        //
        // Protected Methods
        //
        //--------------------------------------------------------------------------

        /**
         *  @private
         */
        /*
        protected function addDebugAttributes(attributes:Object):void
        {
            attributes["body"] = body;
            attributes["clientId"] = clientId;
            attributes["destination"] = destination;
            attributes["headers"] = headers;
            attributes["messageId"] = messageId;
            attributes["timestamp"] = timestamp;
            attributes["timeToLive"] = timeToLive;
        }
        */
        
        /**
         *  @private
         */
        /*
        final protected function getDebugString():String
        {
            var result:String = "(" + getQualifiedClassName(this) + ")";

            var attributes:Object = {};
            addDebugAttributes(attributes);

            var propertyNames:Array = [];
            for (var propertyName:String in attributes)
            {
                propertyNames.push(propertyName);
            }
            propertyNames.sort();

            var length:int = propertyNames.length;
            for (var i:uint = 0; i < length; i++)
            {
                var name:String = String(propertyNames[i]);
                var value:String = RPCObjectUtil.toString(attributes[name]);
                result += RPCStringUtil.substitute("\n  {0}={1}", name, value);
            }

            return result;
        }
        */

        /**
         * @private
         */
        protected function readExternalBody(input:IDataInput):void
        {
            body = input.readObject();
        }
        
        /**
         * @private
         * To support efficient serialization for ISmallMessage implementations,
         * this utility method reads in the property flags from an IDataInput
         * stream. Flags are read in one byte at a time. Flags make use of
         * sign-extension so that if the high-bit is set to 1 this indicates that
         * another set of flags follows.
         *
         * @return The Array of property flags. Each flags byte is stored as a uint
         * in the Array.
         */
        protected function readFlags(input:IDataInput):Array
        {
            var hasNextFlag:Boolean = true;
            var flagsArray:Array = [];

            while (hasNextFlag && input.bytesAvailable > 0)
            {
                var flags:uint = input.readUnsignedByte();
                flagsArray.push(flags);

                if ((flags & HAS_NEXT_FLAG) != 0)
                    hasNextFlag = true;
                else
                    hasNextFlag = false;
            }

            return flagsArray;
        }

        /**
         * @private
         */
        protected function writeExternalBody(output:IDataOutput):void
        {
            output.writeObject(body);
        }
    }
}
