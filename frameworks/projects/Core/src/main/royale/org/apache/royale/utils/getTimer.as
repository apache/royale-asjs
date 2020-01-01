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
package org.apache.royale.utils
{
    COMPILE::SWF
    {
        import flash.utils.getTimer;
    }
    
    COMPILE::JS{
        import goog.global;
    }
    
    /**
     * The number of milliseconds since the current script host environment was started.
     * This is from the time of the current window load (Browser javascript), or process started (Node javascript) or the AVM started (SWF)
     * @return an integer representing the number of milliseconds since start.
     * @royalesuppressexport
     */
    public function getTimer():int
    {
        COMPILE::SWF{
           return flash.utils.getTimer();
        }
        COMPILE::JS{
            return int(goog.global['performance'].now());
        }
    }
}
