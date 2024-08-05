#!/bin/bash

files=(
00:2011_10_03_drive_0027
)
echo 'start downloading trained model......'
wget 'https://www.polybox.ethz.ch/index.php/s/90OlHg6KWBzG6gR'
echo 'model downloading finished! start downloading raw images....'

target_dir='data'

mkdir -p "$target_dir"

for i in ${files[@]}; do
        if [ ${i:(-3)} != "zip" ]
        then
                rename=${i:0:2}
                shortname=${i:3}'_sync.zip'
                fullname=${i:3}'/'${i:3}'_sync.zip'
        else
                $i=${i:(-3)}
                shortname=$i
                fullname=$i
        fi

        wget -O $target_dir'/'$shortname 'https://s3.eu-central-1.amazonaws.com/avg-kitti/raw_data/'$fullname
        if [ $? -ne 0 ]
        then
                wget -O $target_dir'/'$shortname 'http://kitti.is.tue.mpg.de/kitti/raw_data/'$fullname
        fi

        unzip -o $target_dir'/'$shortname -d "$target_dir"
        #tar -xvf $shortname
        rm $target_dir'/'$shortname

        # Remove image00 image01 image02, rename dir
        if [ ${i:(-3)} != "zip" ]
        then
                dirn=${i:3:10}'/'${i:3}'_sync''/'
                rm -r $target_dir'/'$dirn'image_00/' $target_dir'/'$dirn'image_01/' $target_dir'/'$dirn'image_02/' $target_dir'/'$dirn'velodyne_points/'
                mv $target_dir'/'$dirn'image_03/data' $target_dir'/'$rename
                rm -r "$target_dir/${dirn:0:10}"
        fi
done
echo 'all downloading done!'

