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

package mx.styles
{
/**
 * Support class for MediaQueryParser to store and compare versions such as X.Y.Z
 * Its mainly used in os-version  media selector.
 */
public class CSSOSVersion
{
    /** @private
     *  separator between version parts
     *  */
    static private  const SEPARATOR: String = ".";

    /**
     *  major figure of the version.
     */
    public var major: int = 0;
    /**
     *  minor figure  of the version.
     */
    public var minor: int = 0;
    /**
     *  revision figure  of the version.
     */
    public var revision: int = 0;

    /** Contructor
     *   Returns an CSSOSVersion for versionString.
     * @param versionString
     */
    public function CSSOSVersion(versionString: String = "")
    {
        var versionParts: Array = versionString.split(SEPARATOR);
        var l: int = versionParts.length;
        if (l >= 1)
            major = Number(versionParts[0]);
        if (l >= 2)
            minor = Number(versionParts[1]);
        if (l >= 3)
            revision = Number(versionParts[2]);
        // ignore remaining parts
    }

    /**
     *  Compares to another CSSOSVersion instance
     *
     *  @param otherVersion another CSSOSVersion.
     *
     *  @return 0 if both versions are equal
     *  -1 if <code>this</code> is lower than <code>otherVersion</code>.
     *  1 if <code>this</code> is greater than <code>otherVersion</code>.
     *  @langversion 3.0
     *  @productversion Flex 4.13
     */
    public function compareTo(otherVersion: CSSOSVersion): int
    {
        if (major > otherVersion.major)
            return 1;
        else if (major < otherVersion.major)
            return -1;
        else //major == other.major)
        {
            if (minor > otherVersion.minor)
                return 1;
            else if (minor < otherVersion.minor)
                return -1;
            else //minor == other.minor)
            {
                if (revision > otherVersion.revision)
                    return 1;
                else if (revision < otherVersion.revision)
                    return -1;
                else
                    return 0; // all equal
            }
        }
    }

    /**
     * Printable string of the version, as X.Y.Z
     * @return version as a string
     */
    public function toString(): String
    {
        return  major.toString() + SEPARATOR + minor.toString() + SEPARATOR + revision.toString();
    }

}
}
