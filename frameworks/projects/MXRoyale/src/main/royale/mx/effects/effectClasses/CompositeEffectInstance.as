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

package mx.effects.effectClasses
{

/* import flash.events.Event;
import flash.system.ApplicationDomain;

import mx.core.mx_internal;
import mx.effects.IEffectInstance;
import mx.effects.Tween;
import mx.events.EffectEvent;

use namespace mx_internal; */
import mx.effects.EffectInstance;
    
/**
 *  The CompositeEffectInstance class implements the instance class
 *  for the CompositeEffect class.
 *  Flex creates an instance of this class  when it plays a CompositeEffect;
 *  you do not create one yourself.
 *
 *  @see mx.effects.CompositeEffect
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class CompositeEffectInstance extends EffectInstance
{
/*     include "../../core/Version.as";
 */
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.  
     *
     *  @param target This argument is ignored for Composite effects.
     *  It is included only for consistency with other types of effects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function CompositeEffectInstance(target:Object)
    {
        super(target);
    }

    
}

}
