////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.mdl.utils
{
    import org.apache.royale.core.IParent;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }

    /**
     *  To some MDL components after upgrading process
     *  MDL framework adding additional container which is not part of Royale.
     *  Function is trying to return parent component of that added container.
     *
     *  @langversion 3.0
     *  @productversion Royale 0.9.4
     *
     *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
     *  @royaleignorecoercion org.apache.royale.core.IParent
     */
    COMPILE::JS
    public function getMdlContainerParent(positioner:WrappedHTMLElement):IParent
    {
        var p:WrappedHTMLElement = positioner.parentNode as WrappedHTMLElement;
        var wrapper:IParent = p ? p.royale_wrapper as IParent : null;

        if (!wrapper)
        {
            p = p ? p.parentNode as WrappedHTMLElement : null;
            wrapper = p ? p.royale_wrapper as IParent : null;
        }

        return wrapper;
    }
}