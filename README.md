# Performance-Network-Metrics-NS-2
 
  * Name: "Performance-Network-Metrics-NS-2". Script to extract performance metrics from NS-2 trace, such as: throughput, end-to-end delay, jitter, routing overhead, packet forwarding, packet loss rate (selfish nodes too) and energy consumption.                                           
  
  *   Copyright (C) 2013 by Diogenes Antonio Marque Jose dioxfile@unemat.br.                                            
  *   UNEMAT Brazil, Barra do Bugres Campus: bbg.unemat.br.                 
  *   This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                               
 
  *   This program is distributed in the hope that it will be useful,  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A IPICULAR PURPOSE.  See the GNU General Public License for more details.                          
  
  *   You should have received a copy of the GNU General Public License along with this program; If not, see <http://www.gnu.org/licenses/>.

  Script to extract performance metrics from NS-2 trace, such as: throughput, end-to-end delay, jitter, routing overhead, packet forwarding, packet loss rate (selfish nodes too) and energy consumption.
  Developed by Diógenes Antonio Marques José (Mato Grosso State University (UNEMAT) - Barra do Bugres - MT, BRAZIL.) for extract performance metrics in NS-2 MANETs Trace File (e.g., only old trace format).

Usage: root@terminal:# ./Metrics_Performance_Extractor.sh

Result: 
  SIMULATION 0
  
  Generated Packets:
  
  9562
  
  Throughput:
  
  129.39777
  
  Energy:
  
  5.68533
  
  Loss by Selfishness:
  
  459
  
  Total Loss:
  
  483
  
  Forward:
  
  0.54511
  
  Overhead:
  
  326
  
  Delay:
  
  0.032161
  
  Jitter:
  
  0.003935381
  
  END SIMULATION
  
  OBS: In Brazil decimal places in Brazil use ',' instead '.'.
  
  The script only will works correctly if the trace file is inside the same folder of the script, "TRACE_File.tr". Thus, after the script is executed seven folders are created, for example: Delay/, Energy/, Forward/, Jitter/, Overhead/, Packet_Loss/ and Throughput/. All folders contain many files that can be used for simulation analysis. In addition, it is necessary to change parameters in the script according to the simulation to be performed, for example: simulation time, nodes numbers, or a new routing protocol.
