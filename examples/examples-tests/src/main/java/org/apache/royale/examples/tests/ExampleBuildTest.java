/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package org.apache.royale.examples.tests;

import org.junit.Assert;
import org.junit.Assume;
import org.junit.Test;

import java.io.File;

/**
 * A simple JUnit test, that checks the typical build artifacts for an SWF
 * build are produced. It currently just checks the existence of the artifacts,
 * it doesn't check, if they are valid or runnable.
 */
public class ExampleBuildTest {

    /**
     * Test the existence of the SWF output for the Flash/air build.
     */
    @Test
    public void testFlashBuild() {
        Assume.assumeTrue("Only run this test in SWF projects", isSwfProject());

        File buildDirectory = getBuildDirectory();

        File swfFile = new File(buildDirectory, getArtifactId() + "-" + getVersion() + ".swf");
        Assert.assertTrue("The SWF file doesn't exist: " + swfFile.getAbsolutePath(), swfFile.exists());
        Assert.assertTrue("The SWF file is not a file.", swfFile.isFile());
        Assert.assertTrue("The SWF file is empty.", swfFile.length() > 0);
    }

    /**
     * Test the existence of the JavaScript and WAR output for the JavaScript build.
     */
    @Test
    public void testJavaScriptBuild() {
        Assume.assumeTrue("Only run this test in SWF projects", isSwfProject());

        File buildDirectory = getBuildDirectory();

        File warFile = new File(buildDirectory, getArtifactId() + "-" + getVersion() + ".war");
        Assert.assertTrue("The WAR file doesn't exist.", warFile.exists());
        Assert.assertTrue("The WAR file is not a file.", warFile.isFile());
        Assert.assertTrue("The WAR file is empty.", warFile.length() > 0);
    }

    ///////////////////////////////////////////////////////////////////
    // Utility methods
    ///////////////////////////////////////////////////////////////////

    protected boolean isSwfProject() {
        String targets = System.getProperty("targets", "SWF,JSRoyale");
        if (!targets.contains("SWF"))
            return false;
        String type = System.getProperty("type", "jar");
        return "swf".equalsIgnoreCase(type);
    }

    protected File getBuildDirectory() {
        Assert.assertNotNull("The 'buildDirectory' system property is not set.",
                System.getProperty("buildDirectory", null));

        File buildDirectory = new File(System.getProperty("buildDirectory"));
        Assert.assertTrue("The directory specified by the 'buildDirectory' system property doesn't exist.",
                buildDirectory.exists());
        Assert.assertTrue("The directory specified by the 'buildDirectory' system property is not a directory.",
                buildDirectory.isDirectory());

        return buildDirectory;
    }

    protected String getArtifactId() {
        Assert.assertNotNull("The 'artifactId' system property is not set.",
                System.getProperty("artifactId", null));
        return System.getProperty("artifactId");
    }

    protected String getVersion() {
        Assert.assertNotNull("The 'version' system property is not set.",
                System.getProperty("version", null));
        return System.getProperty("version");
    }

}
