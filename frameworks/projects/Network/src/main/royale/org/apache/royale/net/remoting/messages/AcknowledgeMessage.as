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

    COMPILE::SWF{
		import flash.utils.IDataInput;
		import flash.utils.IDataOutput;
    }
    
    COMPILE::JS{
		import org.apache.royale.utils.net.IDataInput;
		import org.apache.royale.utils.net.IDataOutput;
    }

    [RemoteClass(alias="flex.messaging.messages.AcknowledgeMessage")]
    /**
     *  An AcknowledgeMessage acknowledges the receipt of a message that
     *  was sent previously.
     *  Every message sent within the messaging system must receive an
     *  acknowledgement.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public class AcknowledgeMessage extends AsyncMessage implements ISmallMessage
    {
        //--------------------------------------------------------------------------
        //
        // Static Constants
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Header name for the error hint header.
         *  Used to indicate that the acknowledgement is for a message that
         *  generated an error.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public static const ERROR_HINT_HEADER:String = "DSErrorHint";
        
        //--------------------------------------------------------------------------
        //
        // Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Constructs an instance of an AcknowledgeMessage with an empty body and header.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion BlazeDS 4
         *  @productversion LCDS 3
         */
        public function AcknowledgeMessage()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        //
        // Overridden Methods
        //
        //--------------------------------------------------------------------------

        /**
         * @private
         */
        override public function getSmallMessage():IMessage
        {
            trace("AcknowledgeMessage.getSmallMessage");
            var o:Object = this;
            if (o.constructor == AcknowledgeMessage)
                return new AcknowledgeMessageExt(this);
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
            trace("AcknowledgeMessage.writeExternal");
            var flags:uint = 0;
            output.writeByte(flags);
        }
    }
}
