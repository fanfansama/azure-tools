
source ./setEnv.sh


export TMP_DUMP='/tmp/postgresdump'

rm -rf $TMP_DUMP && mkdir $TMP_DUMP
chmod +777 $TMP_DUMP

docker run -it -v $TMP_DUMP:/tmp postgres /bin/bash
