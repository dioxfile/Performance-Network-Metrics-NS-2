# (NEWs, NEWs, NEWs!!!) Performance-Network-Metrics-NS-2
 ![alt text](https://github.com/dioxfile/Performance-Network-Metrics-NS-2/blob/master/metric.png)
  * Name: "Performance-Network-Metrics-NS-2". Script to extract performance metrics from NS-2 traces, such as throughput, energy consumption, packet loss rate (selfish nodes too), routing overhead, packet forwarding rate, end-to-end delay, jitter, and packet delivery rate.                                           
  
  *   Copyright (C) 2013 by Diógenes Antônio Marque José dioxfile@unemat.br.                                            
  *   UNEMAT Brazil, Barra do Bugres Campus: bbg.unemat.br.                 
  *   This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License or (at your option) any later version.                               
 
  *   This program is distributed in the hope that it will be useful,  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A IPICULAR PURPOSE.  See the GNU General Public License for more details.                          
  
  *   You should have received a copy of the GNU General Public License along with this program; If not, see <http://www.gnu.org/licenses/>.

  Script to extract performance metrics from NS-2 traces, such as throughput, energy consumption, packet loss rate (e.g., selfish nodes too, but you should create a packet dropping event by selfishness in NS-2 as 'SEL'), routing overhead, packet forwarding rate, end-to-end delay, jitter, and packet delivery rate.
  Developed by Diógenes Antônio Marques José from Mato Grosso State University (UNEMAT) - Barra do Bugres - MT BRAZIL, for extract performance metrics from NS-2 MANETs Trace File (e.g., only old trace format).

Usage: 

```user@terminal:$ sudo ./Metrics_Performance_Extractor.sh <FILE.tr> <PACKET_SIZE> <NODE_N> <FLOW_N>```
# OBS: 
    a) <FILE.tr>: trace file.
    b) <PACKET_SIZE>: Packet size in bytes plus 20 bytes extra (e.g., This will be explained below).
    c) <NODE_N>: Node quantity in the simulation.
    d) <FLOW_N>: Number of traffic flows.
    d) Decimal places in Brazil use ',' instead '.'. 
    e) This script runs only on Linux Systems. To run on Windows it must be severely adapted.
# Result of running the script:
![Sceenshot](MPE.png)
  
  The script takes as a parameter four arguments which are: <FILE.tr> (e.g., Trace File); <PACKET_SIZE>, packet size plus 20 bytes extra; <NODE_N> (e.g., number of nodes in the simulation), and <FLOW_N> (ex. number of traffic flows). Thus, after the script is executed eight folders are created, for example, Throughput/, Energy/, Packet_Loss/, Overhead/, Forward/, Delay/, Jitter/, and PDR/. All folders contain many files that can be used for simulation analysis. In addition, it is necessary to change parameters in the script according to the simulation to be performed, for example, packet size, nodes numbers, or a new routing protocol.
  
 How do I test this script?
 
 Step 1 - Download Metrics_Performance_Extractor_NEW_(CBR/TCP).sh and TRACE_File_DSDV.tr, and put them in the same directory/folder (if possible).
 
 Step 2 - Install dialog (not substantial) and gawk/awk (substantial). Ex. command on shell Linux:
 
 ``` sudo apt install dialog gawk```
 
 Step 3 - Execute permission to script with the following command shell Linux: 
 
  ```sudo chmod +x Metrics_Performance_Extractor_NEW_(CBR/TCP).sh```
 
 Step 4 - Run the script: Ex. command on shell Linux:
 
 ```sudo ./Metrics_Performance_Extractor.sh TRACE_File_DSDV.tr 270 50 2```
 
 
# How can I use this script in my NS-2 simulations?

Step 1 - Download the script (e.g., Metrics_Performance_Extractor_NEW_(CBR/TCP).sh) and open it with your preferred editor and change the parameters according to your needs, for instance: 
 
 a) ```user@terminal:$ sudo ./Metrics_Performance_Extractor_NEW_(CBR/TCP).sh <FILE.tr> <PACKET_SIZE> <NODE_N> <FLOW_N>```;
 
 b) Packet size for throughput calculation line 56 (e.g., ($8==$PACKET_SIZE)) is used because in the destination application layer (e.g., 'AGT') 20 more bytes are added and they should not be included in the throughput calculation. For example: ```r 59.996499045 _16_ AGT  --- 9223 cbr 270 13a 10 31 800 energy 92.187329 ei 0.000 es 0.000 et 2.230 er 5.583 ------- 49 0 16 0 31 16 3197 1 1```, in this trace file snippet the packet received by node 16 has 270 Bytes (e.g., the field eight = 270). However, the original size is 250 Bytes, the additional 20 bytes were inserted by the application layer;
 
 c) An observation to be made is the fact that some protocols, for example, the DSR, do not add the 20 bytes application layer, so using the following code if ($8=="'$PACKET_SIZE'") {totalBits += 8*($8-20);}else{totalBits += 8*$8;};};, lines 56 to 60.

Step 2 - Install dialog (not substantial) and gawk/awk (substantial). Ex. command on shell Linux:

```sudo apt install dialog gawk```
 
Step 3 - Execute permission to script with the following command: 

```sudo chmod +x Metrics_Performance_Extractor_NEW_(CBR/TCP).sh```
 
Step 4 - Run the script on shell Linux (ex. dash, bash, sh, etc.): Ex. 

```user@terminal:$ sudo ./Metrics_Performance_Extractor_NEW_(CBR/TCP).sh <FILE.tr> <PACKET_SIZE> <NODE_N> <FLOW_N>```

OBS (VERY IMPORTANT): Another important issue is to use the amount of traffic flows as a parameter. The amount of traffic flows is used to calculate average throughput, average delay, and average jitter. Therefore, in situations where Type 1 selfish nodes are evaluated (eg. https://ieeexplore.ieee.org/document/5440229) some links/flows between two nodes can be zero, depending on the action of selfish nodes, and generate result errors. Thus, for this not to happen, it is necessary to use the number of flows as a parameter. NS-2 users can find the number of flows in the traffic file, for example in the last line of it: ```Total sources/connections: 8/8```, in this example there are eight flows. So, before using the metrics extractor, find the number of flows in the traffic file!!!
 

## NOW This script can be used with CBR/FTP Application, and UDP/TCP Traffic!!!
  
