---
layout: post
status: publish
published: true
title: jSSC library - for easy work with serial ports


date: '2016-01-03 20:04:13 +0800'
date_gmt: '2016-01-03 12:04:13 +0800'
categories:
- Opensource
tags:
- jssc
- serial
comments: []
---
<p>jSSC (Java Simple Serial Connector) - library for work with serial port from Java. The library was created as a simple and reliable replacement of existing facilities. Briefly about the opportunities it provides. With jSSC you can get the port names, read and write data, control lines RTS and DTR, receive Event etc. jSSC designed to operate 24/7 multi-threaded systems and is currently successfully used in automation, data collection and recording. Now let me give a few examples of actual work with the component.</p>
<p><b>Example 1. Getting the names of serial ports:</b></p>
<div class="bbcode_container">
<div class="bbcode_description"></div>
<div class="bbcode_code">
<div class="java">
<pre>import jssc.SerialPortList;
&nbsp;
public class Main {
&nbsp;
    public static void main(<a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Astring+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">String</a>[] args) {
        //Method getPortNames() returns an array of strings. Elements of the array is already sorted.
        <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Astring+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">String</a>[] portNames = SerialPortList.getPortNames();
        for(int i = 0; i < portNames.length; i++){
            <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println(portNames[i]);
        }
    }
}</pre>
</div>
</div>
</div>
<p><b>Example 2. Read and write data:</b></p>
<div class="bbcode_container">
<div class="bbcode_description"></div>
<div class="bbcode_code">
<div class="java">
<pre>import jssc.SerialPort;
import jssc.SerialPortException;
&nbsp;
public class Main {
&nbsp;
    public static void main(<a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Astring+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">String</a>[] args) {
        //In the constructor pass the name of the port with which we work
        SerialPort serialPort = new SerialPort("COM1");
        try {
            //Open port
            serialPort.openPort();
            //We expose the settings. You can also use this line - serialPort.setParams(9600, 8, 1, 0);
            serialPort.setParams(SerialPort.BAUDRATE_9600, 
                                 SerialPort.DATABITS_8,
                                 SerialPort.STOPBITS_1,
                                 SerialPort.PARITY_NONE);
            //Writes data to port
            serialPort.writeBytes("Test");
            //Read the data of 10 bytes. Be careful with the method readBytes(), if the number of bytes in the input buffer
            //is less than you need, then the method will wait for the right amount. Better to use it in conjunction with the
            //interface SerialPortEventListener.
            byte[] buffer = serialPort.readBytes(10);
            //Closing the port
            serialPort.closePort();
        }
        catch (SerialPortException ex) {
            <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println(ex);
        }
    }
}</pre>
</div>
</div>
</div>
<p><b>Example 3. Read and write data using the interface SerialPortEventListener:</b></p>
<div class="bbcode_container">
<div class="bbcode_description"></div>
<div class="bbcode_code">
<div class="java">
<pre>import jssc.SerialPort;
import jssc.SerialPortEvent;
import jssc.SerialPortEventListener;
import jssc.SerialPortException;
&nbsp;
public class Main {
&nbsp;
    static SerialPort serialPort;
&nbsp;
    public static void main(<a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Astring+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">String</a>[] args) {
        serialPort = new SerialPort("COM1"); 
        try {
            serialPort.openPort();
            serialPort.setParams(9600, 8, 1, 0);
            //Preparing a mask. In a mask, we need to specify the types of events that we want to track.
            //Well, for example, we need to know what came some data, thus in the mask must have the
            //following value: MASK_RXCHAR. If we, for example, still need to know about changes in states 
            //of lines CTS and DSR, the mask has to look like this: SerialPort.MASK_RXCHAR + SerialPort.MASK_CTS + SerialPort.MASK_DSR
            int mask = SerialPort.MASK_RXCHAR;
            //Set the prepared mask
            serialPort.setEventsMask(mask);
            //Add an interface through which we will receive information about events
            serialPort.addEventListener(new SerialPortReader());
        }
        catch (SerialPortException ex) {
            <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println(ex);
        }
    }
&nbsp;
    static class SerialPortReader implements SerialPortEventListener {
&nbsp;
        public void serialEvent(SerialPortEvent event) {
            //Object type SerialPortEvent carries information about which event occurred and a value.
            //For example, if the data came a method event.getEventValue() returns us the number of bytes in the input buffer.
            if(event.isRXCHAR()){
                if(event.getEventValue() == 10){
                    try {
                        byte buffer[] = serialPort.readBytes(10);
                    }
                    catch (SerialPortException ex) {
                        <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println(ex);
                    }
                }
            }
            //If the CTS line status has changed, then the method event.getEventValue() returns 1 if the line is ON and 0 if it is OFF.
            else if(event.isCTS()){
                if(event.getEventValue() == 1){
                    <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println("CTS - ON");
                }
                else {
                    <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println("CTS - OFF");
                }
            }
            else if(event.isDSR()){
                if(event.getEventValue() == 1){
                    <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println("DSR - ON");
                }
                else {
                    <a href="http://www.google.com/search?hl=en&amp;q=allinurl%3Asystem+java.sun.com&amp;btnI=I%27m%20Feeling%20Lucky" rel="nofollow">System</a>.out.println("DSR - OFF");
                }
            }
        }
    }
}</pre>
</div>
</div>
</div>
<p>Here are a few examples to work with the component. I wish you success. At the moment there is a stable implementation of the libraries under Win32 (Win98-Win7).</p>
<p>摘自『http://www.javaprogrammingforums.com/java-se-api-tutorials/5603-jssc-library-easy-work-serial-ports.html』</p>
<p><strong>GitHub</strong>：<a href="https://github.com/scream3r/java-simple-serial-connector" target="_blank">https://github.com/scream3r/java-simple-serial-connector</a></p>
