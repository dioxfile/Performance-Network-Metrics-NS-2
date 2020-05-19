# Performance-Network-Metrics-NS-2
 
  * Name: "Performance-Network-Metrics-NS-2". Script to extract performance metrics from NS-2 trace, such as: throughput, end-to-end delay, jitter, routing overhead, packet forwarding, packet loss rate (selfish nodes too) and energy consumption.                                           
  
  *   Copyright (C) 2013 by Diógenes Antônio Marque José dioxfile@unemat.br.                                            
  *   UNEMAT Brazil, Barra do Bugres Campus: bbg.unemat.br.                 
  *   This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                               
 
  *   This program is distributed in the hope that it will be useful,  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A IPICULAR PURPOSE.  See the GNU General Public License for more details.                          
  
  *   You should have received a copy of the GNU General Public License along with this program; If not, see <http://www.gnu.org/licenses/>.

  Script to extract performance metrics from NS-2 trace, such as: throughput, end-to-end delay, jitter, routing overhead, packet forwarding, packet loss rate (e.g., selfish nodes too, but you should create a packet dropping event by selfishness in NS-2 as 'SEL'.) and energy consumption.
  Developed by Diógenes Antônio Marques José (Mato Grosso State University (UNEMAT) - Barra do Bugres - MT, BRAZIL.) for extract performance metrics from NS-2 MANETs Trace File (e.g., only old trace format).

Usage: 

```root@terminal:# ./Metrics_Performance_Extractor.sh```

![Screenshot](image.png)
  
  OBS: Decimal places in Brazil use ',' instead '.'. This script runs only on Linux Systems. To run on Windows it must be severely adapted.
  
  The script only will works correctly if the trace file is inside the same folder of the script, "TRACE_File.tr". Thus, after the script is executed seven folders are created, for example: Delay/, Energy/, Forward/, Jitter/, Overhead/, Packet_Loss/ and Throughput/. All folders contain many files that can be used for simulation analysis. In addition, it is necessary to change parameters in the script according to the simulation to be performed, for example: simulation time, nodes numbers, or a new routing protocol.
  
 How do I test this script?
 
 Step 1 - Download Metrics_Performance_Extractor.sh and TRACE_File_DSDV.tr. Put them in the same directory/folder and change the file name TRACE_File_DSDV.tr to TRACE_File.tr.
 
 Step 2 - Install dialog (not substancial) and gawk (substancial). Ex. command on shell Linux:
 
 ``` sudo apt install dialog gawk```
 
 Step 3 - Execute permission to script with the following command shell Linux: 
 
  ```sudo chmod +x Metrics_Performance_Extractor.sh```
 
 Step 4 - Run the script: Ex. command on shell Linux:
 
 ```sudo ./Metrics_Performance_Extractor.sh```
 
 
# How can I use this script in my NS-2 simulations?

Step 1 - Download the script (e.g., Metrics_Performance_Extractor.sh) and open it with your preferred editor and change the parameters according to your needs, for instance: a) trace file name, line 16 "TRACE_File.tr"; b) simulation time line 17, "60.000000000" is the simulation time; c) nodes numbers in all lines with this code "for conta in $(seq 0 62)", 62 is the node quantity; d) Packet size for throughput calculation line 35, because in 'AGT' layer is add 20 bytes by Application Layer, and it mustn't be calculated. For example: ```r 59.996499045 _16_ AGT  --- 9223 cbr 270 13a 10 31 800 energy 92.187329 ei 0.000 es 0.000 et 2.230 er 5.583 ------- 49 0 16 0 31 16 3197 1 1```, in this snippet of a trace file (e.g., the field eight = 270) the packet received by node 16 has 270 Bytes, however, the original size is 250 bytes, the additional 20 bytes were inserted by the application layer. Finally save the script to the same folder where the simulation trace was generated and change the name of your trace to TRACE_File.tr.

Step 2 - Install dialog (not substancial) and gawk (substancial). Ex. command on shell Linux:

```sudo apt install dialog gawk```
 
Step 3 - Execute permission to script with the following command: 

```sudo chmod +x Metrics_Performance_Extractor.sh```
 
Step 4 - Run the script on shell Linux: Ex. 

```./Metrics_Performance_Extractor.sh```
 

OBS: This script was only used with CBR Application and UDP Traffic, but it can be adapted to FTP Application and TCP Traffic easily.
  
