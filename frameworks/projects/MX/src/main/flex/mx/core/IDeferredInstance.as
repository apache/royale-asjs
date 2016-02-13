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

package mx.core
{

/**
 *  The IDeferredInstance interface defines the Flex deferred instance factory interface.
 *  An implementation of IDeferredInstance creates a particular instance value
 *  when the <code>getInstance()</code> method is first called, and returns a reference to that value
 *  when the <code>getInstance()</code> method is called subsequently.
 *
 *  <p>The Flex compiler performs the following automatic coercions when it
 *  encounters MXML that assigns a value to a property with the
 *  IDeferredInstance type:</p>
 *
 *  <ol>
 *      <li>If you assign a property of type IDeferredInstance a value that is
 *          an MXML child tag representing a class, such as a component
 *          tag, the compiler creates an IDeferredInstance implementation
 *          whose <code>getInstance()</code> method returns an instance
 *          of the class, configured as specified in the MXML code.
 *          The following example shows this format; in this example, 
 *          MyComp is a custom component that has a variable called 
 *          myDeferredInstanceProperty of type IDeferredInstance. The compiler
 *          generates an IDeferredInstance1 implementation whose
 *          <code>getInstance()</code> method returns an instance of the
 *          Label class, with its text property set to
 *          &quot;This is a deferred label&quot;:
 *          <pre>
 *          &lt;MyComp&gt;
 *              &lt;myDeferredInstanceProperty&gt;
 *                  &lt;Label text=&quot;This is a deferred label&quot;/&gt;
 *              &lt;/myDeferredInstanceProperty&gt;
 *          &lt;/MyComp&gt;</pre>
 *      </li>
 *      <li>If you assign a text string to a property of type IDeferredInstance,
 *          the compiler interprets the string as a fully qualified class name,
 *          and creates an
 *          IDeferredInstance implementation whose <code>getInstance()</code>
 *          method returns a new instance of the specified class.
 *          The specified class must have a constructor with no arguments.
 *          The following example shows this format; in this example, the compiler
 *          generates an IDeferredInstance1 implementation whose
 *          <code>getInstance()</code> method returns an instance of the
 *          MyClass class:
 *          <pre>
 *          &lt;MyComp myDeferredInstanceProperty="myPackage.MyClass/&gt;</pre>
 *      </li>
 *  </ol>
 *
 *  <p>Use the IDeferredInstance interface when an ActionScript class defers
 *  the instantiation of a property value.
 *  You cannot use IDeferredInstance if an ActionScript class requires
 *  multiple instances of the same value.
 *  In those situations, use the IFactory interface.</p>
 *  
 *  <p>The states.AddChild class includes a <code>childFactory</code>
 *  property that is of type IDeferredInstance.</p>
 * 
 *  @see mx.states.AddChild
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IDeferredInstance
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates an instance Object from a class or function,
     *  if the instance does not yet exist.
     *  
     *  @return The instance Object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function getInstance():Object;
}

}
