
#!/bin/bash
FILE_LIST=$(ls |grep 'tar.gz')
for FILE in ${FILE_LIST}
do
    tar -xf $FILE
    echo "tar -xf done"
done

dirname=$(ls -d */ |cut -d '/' -f 1)
cd $dirname/ && pwd

nvidia-smi -L |awk -F ':' '{print $1}' |awk -F " " '{print $2}' > gpuid
echo "done qugpuid"
sleep 1

a=$(cat gpuid)
for k in $a
  do
     cp run.sh run$k.sh
     sed -ri "s/gpu_id=0/gpu_id=$k/g" run$k.sh
     sed -ri "s/last_name}/last_name}_$k/g" run$k.sh
     sed -ri "s/24053:8001/2700$k:8001/g" run$k.sh
     sleep 2
     sh run$k.sh install && sh run$k.sh install --gpus=$k && sh run$k.sh start
done
echo "All done! Please check Engine is running"
