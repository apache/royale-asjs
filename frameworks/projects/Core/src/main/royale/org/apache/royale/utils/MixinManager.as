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
    import flash.display.DisplayObject;            
    import flash.system.ApplicationDomain;            
}

import org.apache.royale.core.ElementWrapper;
import org.apache.royale.core.IBead;
import org.apache.royale.core.IFlexInfo;
import org.apache.royale.core.IStrand;

/**
 *  The MixinManager class is the class that instantiates mixins
 *  linked into the application.  Mixins are classes with [Mixin]
 *  metadata and are often linked in via the -includes option.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class MixinManager implements IBead
{
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function MixinManager()
    {
        super();
    }
    	
    private var _strand:IStrand;
    
    /**
     *  @copy org.apache.royale.core.IBead#strand
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royaleignorecoercion Array
     *  @royaleignorecoercion org.apache.royale.core.IFlexInfo
     *  @royaleignoreimport org.apache.royale.core.IFlexInfo
     */
    public function set strand(value:IStrand):void
    {
        _strand = value;
        
        COMPILE::SWF
        {
            var app:IFlexInfo = value as IFlexInfo;
            if (app)
            {
                var mixins:Array = app.info().mixins;
                var domain:ApplicationDomain = app.info().currentDomain;
                for each (var mixin:String in mixins)
                {
                    var mixinClass:Object = domain.getDefinition(mixin); 
					if (value is DisplayObject)
	                    mixinClass.init(value);
					else
					{
	                    mixinClass.init((value as ElementWrapper).element);
					}
                }
            }
        }
        COMPILE::JS
        {
            var app:IFlexInfo = value as IFlexInfo;
            if (app) 
            {
				var info:Object = app.info();
				if (info)
				{
                    var mixins:Array = info['mixins'] as Array;
                    if (mixins) {
                        var n:int = mixins.length;
                        for (var i:int = 0; i < n; i++) 
                        {
                            mixins[i]['init'](value);
                        }
                    }
				}
            }
        }
    }    
   
}
}
