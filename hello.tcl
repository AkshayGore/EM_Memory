#echo $DISPLAY
#echo "HELLO"
#setenv DISPLAY
#add_inst Instances w65536x4c64b1c1i1a1DESTi0ra1s0 65536 4 64 1 STANDARD DEFAULT

#! /bin/csh -f
rm -rf *_inst_error *_f1 *_f2
foreach corner (`cat cor_list`)
echo "$corner" > {$corner}_inst_error
        ls $corner/*/compout/icv_drc/*/*.RESULTS | cut -d"/" -f5 | sort -u > list
	foreach inst (`cat list`)
		sed -n "/Results Summary/,/Assign Layer Statistics/p" $corner/$inst/compout/icv_drc/$inst/$inst.RESULTS | grep -v "v = 0" | grep -v "v = Not Executed" | grep "G\|LAYOUT_ERRORS" > {$inst}_f1
		cat {$inst}_f1 | grep LAYOUT_ERRORS | cut -d'.' -f1 | awk '{print $3}' > {$inst}_f2
		cat {$inst}_f1 | grep G >> {$inst}_f2
		echo "------------------------------------------------" >> {$inst}_f2
		cat {$inst}_f1 | grep -v LAYOUT_ERRORS | awk 'END{print FNR}{s+=$4} END{print s}' | cut -f1 | paste -s | awk '{print "Total_type= "$1"\t""total_count= "$2}' >> {$inst}_f2
		cat {$inst}_f2 >> {$corner}_inst_error
		rm -rf {$inst}_f1 {$inst}_f2
	end
rm -rf list
end
