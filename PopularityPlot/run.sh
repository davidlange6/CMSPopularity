#!/bin/bash
set -o errexit
odir=$PWD/output
# cmspopdb nod settings
phedexInput=/data/dlange/inputs/200114/phedex_2019.out.gz
dbsInput=/data/dlange/inputs/dbs_events.csv.gz
baseDir=/data/dlange/inputs/condor
classAdsInput=$baseDir
intervalDates="20190901,20190601,20190101"
intervalEnd=20191231

date=`date +%Y%m%d`
start_time="$(date -u +%s)"

echo "Job run on date : $date (`date`)"
echo "Phedex     input: $phedexInput"
echo "DBS        input: $dbsInput"
echo "ClassAds   input: $classAdsInput"
echo "Output area     : $odir"
echo "interval dates  : $intervalDates"
echo "interval ends   : $intervalEnd"
#echo "Title           : $title"

# step 1: generate phedex means
echo "Step 1: Run phedexMeans.py module"
python phedexMeans.py --output=$odir --phedexInput=$phedexInput --dbsInput=$dbsInput --baseDir=$baseDir --classAdsInput=$classAdsInput --intervalDates=$intervalDates --intervalEnd=$intervalEnd 
#--useOnlyTier2

# step 2: generate classAds
echo "Step 2: Run classadInput.py module"
python classadInput.py --output=$odir --phedexInput=$phedexInput --dbsInput=$dbsInput --baseDir=$baseDir --classAdsInput=$classAdsInput --intervalDates=$intervalDates --intervalEnd=$intervalEnd

# step 3: make plots
echo "Step 3: Run popularity.py module"
python popularity.py --output=$odir --phedexInput=$phedexInput --dbsInput=$dbsInput --baseDir=$baseDir --classAdsInput=$classAdsInput --intervalDates=$intervalDates --intervalEnd=$intervalEnd --loadClassAds --loadPhedexMeans

end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"
echo "Total of $elapsed seconds elapsed for process"
