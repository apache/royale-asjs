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
package org.apache.royale.mdl.beads.models
{
    import org.apache.royale.core.IBeadModel;

    /**
     *  The IToastModel interface describes the minimum set of properties
     *  available to simple version of Snackbar - Toast
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public interface IToastModel extends IBeadModel
    {
        /**
         *  Represents main text displayed on Snackbar/Toast
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        function get message():String;
        function set message(value:String):void;

        /**
         *  Describe in milliseconds how long Snackbar/Toast will not disappear
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        function get timeout():int
        function set timeout(value:int):void;

        /**
         *  Configuration object for MDL MaterialSnackbar.show method
         *
         *  {
         *       message: message,
         *       timeout: timeout,
         *       actionHandler: onActionHandler,
         *       actionText: _actionText
         *   };
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        function get snackbarData():Object;
    }
}
