#!/bin/sh
#### Clears the trace up to the simulation time limit
rm -v *.result
rm -v Trace_Cleaned.tr
rm -r Jitter/ 
rm -r Delay/ 
rm -r Forward/ 
rm -r Packet_Loss/
rm -r Throughput/
rm -r Energy/

for sim in $(seq 0 0);
do 

echo "Cleanning Trace..."
cat TRACE_File_DSDV.tr   | sed 's/\[//g' | sed 's/\]//g' | sed 's/\_//g' | sed 's/\:/ /g' \
| awk -F" " '{ {if($2 < 60.000000000) {print}}}' > Trace_Cleaned_Sujo.tr 
cat Trace_Cleaned_Sujo.tr | uniq > Trace_Cleaned.tr

egrep "^[sr].*AGT.*" Trace_Cleaned.tr > Trace_R_S.tr 
echo "Trace Clean and node's number updated..."
rm Trace_Cleaned_Sujo.tr

######Throughput Calculation ###### 
#Based in: http://ns2ultimate.tumblr.com/post/3442965938/post-processing-ns2-result-using-ns2-trace-ex1 (T. Issaraiyakul and E. Hossain)
echo "Extracting Throughput..."
mkdir -pv Throughput
for conta in $(seq 0 62);
do 
cat Trace_R_S.tr | awk -F " " 'BEGIN{ 
lineCount = 0;
totalBits = 0;
}
/^r/&&$24=="'$conta'"{
	if ($8==1020) {
		totalBits += 8*($8-20);
   } else {
		totalBits += 8*$8;
	};
	if (lineCount==0) {
		timeBegin = $2;
		lineCount++;
	} else {
		timeEnd = $2;
	};
};
END{
duration = timeEnd-timeBegin;
if(timeEnd==0) {
	duration = (timeEnd-timeBegin)*-1;
} 	
Thoughput = totalBits/duration/1e3;
	printf("%3.5f",Thoughput);
};' > Throughput/Throughput_$conta.tr
done;
rm Throughput/mediaV.tr
for conta in $(seq 0 62);
do
##### Checks if you have any empty files and writes a value so that the average calculation is computed without errors.
if [ -s Throughput/Throughput_$conta.tr ]; then
awk -F" " '{print}' Throughput/Throughput_$conta.tr >> Throughput/mediaV.tr
fi
done;
#Average Throughput
cat Throughput/mediaV.tr | awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(j = 1; j <= NR; j++){
		if(j in Vetor_media){	
			soma = soma + Vetor_media[j]	
		}
	}
	media = soma/NR
    printf("%3.5f",media)
}' > Throughput/Media_Throughput.tr
echo "End of Throughput Calculation..."

### Energy Consumption ###
echo "Extracting Energy..."
mkdir -pv Energy
egrep "^N.*" Trace_Cleaned.tr > Energy/Energia_total.e 
# The fields $5, $7 and $3 correspond respectively to: the node, the total energy and the current time within the simulation
cat Energy/Energia_total.e | awk -F" " '{print $5 " " $7 " " $3}' > Energy/Energia_total_col_nodo_energy.e
rm Energy/Energia_Final_Geral.e  
for conta in $(seq 0 62)
do
#The fields $3 and $2 are based on the file ''Energia_total_col_nodo_energy_unicos.e' and correspond to the simulation time and total energy 
cat Energy/Energia_total_col_nodo_energy.e  | awk -F" " '{if($1=="'$conta'") {print $3 " " $2}}' > Energy/Energia_total_$conta.e 
cat Energy/Energia_total_$conta.e | awk -F" " 'END { print (100.000000 - $2) }' > Energy/Energia_Final_$conta.e
cat  Energy/Energia_Final_$conta.e >> Energy/Energia_Final_Geral.e
done;
#####Global Average Energy Consumption
cat Energy/Energia_Final_Geral.e | awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(m = 1; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
	media = soma/NR
	printf("%3.5f",media)
}' > Energy/MediaGlobal_En.e
echo "End Energy Consumption Calculation..."

#Packet Loss Rate Calculation
echo "Extracting Packet Loss Rate..."
mkdir -pv Packet_Loss
#Print file with all packages marked with event 'D'
cat Trace_Cleaned.tr | awk -F " " '{  
	if($1 == "D" && $5 != "END" && $7 != "OLSR" && $7 != "AODV" && $7 != "DSR" && $7 != "message"){  
		{print}
	}		
 }' > Packet_Loss/Trace_Descartados.tr
awk -F" " 'END { print NR }' Packet_Loss/Trace_Descartados.tr > Packet_Loss/Descartados.tr  
cat Packet_Loss/Descartados.tr > Packet_Loss/Temp_D_SR_DP # 1 
#Print file with all packages marked with event 's'
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "s" && $4 == "AGT"){
		{print}		
	}
 }' > Packet_Loss/S.tr 
awk -F" " 'END { print NR }' Packet_Loss/S.tr >> Packet_Loss/Temp_D_SR_DP 
#Print file with all packages marked with event 'r'
cat Trace_R_S.tr | awk -F " " '{   
	if($1 == "r" && $4 == "AGT"){
		{print}		
	}
 }' > Packet_Loss/R.tr 
awk -F" " 'END { print NR }' Packet_Loss/R.tr >> Packet_Loss/Temp_D_SR_DP 
#Total Lost/Dropped Packets.
cat Packet_Loss/Temp_D_SR_DP | awk -F " " '{ 
Drop[NR] = $0
} END {	
		PD = Drop[2] - Drop[3]
		{print PD}
}' > Packet_Loss/Drop_Lost.tr
cat Packet_Loss/Drop_Lost.tr >> Packet_Loss/Temp_D_SR_DP 
#Just Packets Losts
cat Packet_Loss/Temp_D_SR_DP | awk -F " " '{ 
Lost[NR] = $0
} END {	
		PP = Lost[4] - Lost[1]
		{print PP}
}' > Packet_Loss/Perdidos.tr

#Write to a file dropped packets by selfishness.
cat Trace_Cleaned.tr | awk -F " " '{  
	if($5 == "SEL"){  
		{print}
	}		
 }' > Packet_Loss/Selfish_Drops.tr
rm Packet_Loss/Dropped_by_Selfish_Nodes.s
for No in $(seq 0 62);
do 
 cat Packet_Loss/Selfish_Drops.tr | awk -F" " '{
		if($3 == "'$No'"){  
		{print}
		}	
 }' > Packet_Loss/Selfish_Drops_$No.tr
 awk -F" " 'END { print NR }' Packet_Loss/Selfish_Drops_$No.tr >>  Packet_Loss/Dropped_by_Selfish_Nodes.s
 done;	
 echo "End Packet Loss Rate Calculation..."

###FORWARD Rate Calculation.
echo "Extracting Forward Rate..."
mkdir -pv Forward
rm Forward/Forward_by_no.tr 
cat Trace_Cleaned.tr | egrep "^f.*" > Forward/FWD.tr
awk -F" " 'END { print NR }' Forward/FWD.tr > Forward/Forward.tr 
for conta in $(seq 0 62);
do
cat Forward/FWD.tr | awk -F" " '{
	if($3=="'$conta'")
	{print}
}' > Forward/FWD_By_$conta.f
#Checks if you have any empty files and writes a value
if [ -s Forward/FWD_By_$conta.f ]; then
awk -F" " 'END {if($1=="0") {print NR==0} else { print NR} }' Forward/FWD_By_$conta.f >> Forward/Forward_by_no.tr 
fi
done;
#Check which packets have been forwarded once
cat Forward/FWD.tr | awk -F" " '{print $6 " " $24 " " $26}' > Forward/FWD_F.tr
#Catch only ones
cat Forward/FWD_F.tr | uniq -u > Forward/FWD_F_Unicos_u.tr   
awk -F" " 'END { print NR}' Forward/FWD_F_Unicos_u.tr > Forward/Total_Forward_Unicos.tr
#Generates a file with packets that have been forwarded once.
cat Forward/FWD_F.tr | uniq -d > Forward/FWD_F_Unicos_d.tr   
cat Trace_Cleaned.tr | awk -F" " '{if($1=="r" && $4=="AGT"){{print $6 " " $24 " " $26}}}' >> Forward/FWD_F_Unicos_u.tr
#It only takes the packets forwarded with SUCCESS
sort -n Forward/FWD_F_Unicos_u.tr | uniq -d > Forward/FWD_Efetivos.tr 
awk -F" " 'END { print NR}' Forward/FWD_Efetivos.tr  > Forward/FWD_Efetivos_Total.tr 
#Calculates the Packet Forwarding Rate 
cat Forward/Total_Forward_Unicos.tr > Forward/Forward_TMP_SUCESS.tr 
cat Forward/FWD_Efetivos_Total.tr  >> Forward/Forward_TMP_SUCESS.tr 
cat Forward/Forward_TMP_SUCESS.tr | awk -F " " '{ 
FWD[NR] = $0
} END {	
		SUCESS = FWD[2]/FWD[1]
		printf("%3.5f",SUCESS)
}' > Forward/Forward_SUCESS.tr 
echo "End Forward Calculation!!!"

###Routing Overhead Calculation.
echo "Extracting Routing Overhead Rate..."
mkdir -pv Overhead
rm Overhead/Overhead_by_no.tr 
cat Trace_Cleaned.tr | awk -F" " '{if($1=="s" && ($7=="OLSR" || $7=="AODV" || $7=="DSR" || $7=="message")){{print}}}' > Overhead/OVER.tr
awk -F" " 'END { print NR }' Overhead/OVER.tr > Overhead/Overhead.tr 
for conta in $(seq 0 62);
do
cat  Overhead/OVER.tr | awk -F" " '{
	if($3=="'$conta'")
	{print}
}' > Overhead/OVER_By_$conta.ov

#Check if you have some empty file and writes a value for the average calculus is computed without errors.
if [ ! -s Overhead/OVER_By_$conta.ov ]; then
echo "File Overhead/OVER_By_$conta.ov is empty!"
echo "0" > Overhead/OVER_By_$conta.ov
else
echo "File Overhead/OVER_By_$conta.ov isn't empty!"
fi
awk -F" " 'END {if($1=="0") { print NR==0} else { print NR} }' Overhead/OVER_By_$conta.ov >> Overhead/Overhead_by_no.tr
done;
echo "End Routing Overhead Calculation!!!"

#End-to-End Delay Calculation
echo "Extracting End-to-End Delay..."
mkdir -pv Delay
rm Delay/media.tr
for conta in $(seq 0 62);
do
cat Trace_R_S.tr | awk -F " " '{
       
	if($1 == "s" && $3=="'$conta'" && $4 == "AGT"){
		s_pacote[$6] = $2
		svetor[$6]=$6			
	}
	
	if($1 == "r" && $4 == "AGT"){
		r_pacote[$6] = $2
		rvetor[$6]=$6
	}
} END {	
	for(t = 0; t < NR; t++){
	  if(t in r_pacote && t in s_pacote && t in svetor && t in rvetor){
		 if(svetor[t]==rvetor[t]){	
				delay = r_pacote[t] - s_pacote[t]
				printf ("%3.9f\n",delay)
			}
		}
	}
}' > Delay/Delay_$conta.tr
#Check if you have some empty file and writes a value for the Delay calculus is computed without errors..
if [ -s Delay/Delay_$conta.tr ]; then
#Average Delay
cat Delay/Delay_$conta.tr |awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(m = 1; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
	media = soma/NR
	printf("%3.9f",media)
}' > Delay/Media_Delay_$conta.tr
awk -F" " '{print}' Delay/Media_Delay_$conta.tr >> Delay/media.tr
fi
done;
# Global Average Delay
cat Delay/media.tr | awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(m = 1; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
	media = soma/NR
	printf("%3.6f",media)
}' > Delay/MediaGlobal_At.tr
echo  "End Delay Calculation ..."

# Jitter Calculation
echo "Extracting Jitter..."
mkdir -pv Jitter
for conta in $(seq 0 62);
do
cat Delay/Delay_$conta.tr | awk -F " " '{
vetor_Delay[NR] = $0
} END {	
	n = 1
	for(i = 0;i < NR; i++){
		jitter = vetor_Delay[n] - vetor_Delay[i]
		if(jitter < 0){
			jitter = (jitter * -1)
		}	
		printf("%3.9f\n",jitter)
		n++
	}
}' > Jitter/Jitter_$conta.tr
# Average Jitter
cat Jitter/Jitter_$conta.tr |awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(j = 1; j <= NR; j++){
	soma = soma + Vetor_media[j]	
	}
	media = soma/NR
	printf("%3.9f",media)
}' > Jitter/Media_Jitter_$conta.tr
done;
# Global Average Jitter
rm Jitter/media.tr
for conta in $(seq 0 62);
do
awk -F" " '{print}' Jitter/Media_Jitter_$conta.tr >> Jitter/media.tr
done;
cat Jitter/media.tr | awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(m = 1; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
	media = soma/NR
	printf("%3.9f",media)
}' > Jitter/MediaGlobal_Jt.tr
echo "End Jitter Calculation..."

#Stores the average of 'n' simulations in a single file.
echo "Extracting Simulation Result ... Please wait"
echo "\nSIMULATION $sim" >> Simulation_Result.result
echo "Generated Packets:" >> Simulation_Result.result
awk -F" " 'END { print NR }' Packet_Loss/S.tr >> Simulation_Result.result
echo "Throughput:" >> Simulation_Result.result
cat Throughput/Media_Throughput.tr >> Simulation_Result.result
echo "\nEnergy:" >> Simulation_Result.result
cat Energy/MediaGlobal_En.e >> Simulation_Result.result
echo "\nLoss by Selfishness:" >> Simulation_Result.result
cat Packet_Loss/Dropped_by_Selfish_Nodes.s | awk -F" " '{
Vetor_media[NR] = $0
} END {
	for(m = 1; m <= NR; m++){
	soma = soma + Vetor_media[m]	
	}
	printf("%3.0f",soma)
}' >> Simulation_Result.result
echo "\nTotal Loss:" >> Simulation_Result.result
cat Packet_Loss/Drop_Lost.tr >> Simulation_Result.result
echo "Forward:" >> Simulation_Result.result
cat Forward/Forward_SUCESS.tr >> Simulation_Result.result
echo "\nOverhead:" >> Simulation_Result.result
cat Overhead/Overhead.tr >> Simulation_Result.result
echo "Delay:" >> Simulation_Result.result
cat Delay/MediaGlobal_At.tr >> Simulation_Result.result
echo "\nJitter:" >> Simulation_Result.result
cat Jitter/MediaGlobal_Jt.tr >> Simulation_Result.result
echo "\n"
done;
echo "\nEND SIMULATION\n\n" >> Simulation_Result.result
cat Simulation_Result.result | sed -e 's/\./\,/' > Resultado_Final.result

dialog \
--title 'WARNING' \
--msgbox 'End of Script!!!' \
6 40
dialog \
--title 'RESULT'  \
--textbox Simulation_Result.result \
0 40
