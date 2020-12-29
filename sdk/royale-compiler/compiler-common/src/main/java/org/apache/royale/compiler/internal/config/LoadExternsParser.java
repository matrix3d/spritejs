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

package org.apache.royale.compiler.internal.config;

import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import org.apache.royale.compiler.config.ConfigurationValue;
import org.apache.royale.compiler.exceptions.ConfigurationException;
import org.apache.royale.compiler.exceptions.ConfigurationException.ConfigurationIOError;
import org.apache.royale.compiler.filespecs.IFileSpecification;

/**
 * An SAX parser for the XML report generated by {@code -link-report} option.
 * {@code -load-externs} option uses this parser to collect QNames to put to
 * externs.
 */
public class LoadExternsParser extends DefaultHandler
{
    /**
     * Collect externs from the given report file.
     * 
     * @param cfgval configuration value
     * @param file report file 
     * @return externs
     * @throws ConfigurationIOError error
     */
    public static List<String> collectExterns(
            final ConfigurationValue cfgval,
            final IFileSpecification file) throws ConfigurationIOError
    {
        final LoadExternsParser loadExternParser = new LoadExternsParser();
        final String filePath = file.getPath();
        final SAXParserFactory factory = SAXParserFactory.newInstance();
        factory.setNamespaceAware(false);
        try
        {
            SAXParser parser = factory.newSAXParser();
            parser.parse(filePath, loadExternParser);
        }
        catch (Exception e)
        {
            throw new ConfigurationException.ConfigurationIOError(
                    filePath, cfgval.getVar(), cfgval.getSource(), cfgval.getLine());
        }

        return loadExternParser.externs;
    }

    private final List<String> externs = new ArrayList<String>();

    @Override
    public void startElement(
            String uri,
            String localName,
            String qName,
            Attributes attributes) throws SAXException
    {
        if ("def".equals(qName) || "pre".equals(qName) || "ext".equals(qName))
        {
            final String id = attributes.getValue("id");
            if (id != null)
            {
                externs.add(fromColonToDotQName(id));
            }
        }
    }
    
    /**
     * Convert from ":" to "." style qname.
     * 
     * @param qname A {@link String} qname of format "package:name"
     * @return A {@link String} qname of format "package.name"
     */
    private String fromColonToDotQName(String qname)
    {
        StringBuilder sb = new StringBuilder(qname);
        int lastDotIndex = qname.lastIndexOf(':');
        if(lastDotIndex > -1)
        {
            sb.setCharAt(lastDotIndex, '.');
        }
        
        return sb.toString();
    }
    
}
