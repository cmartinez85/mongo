#!/bin/bash

function help(){

  echo "Script to delete Shard-key from mongoDB Sharded Database"
  echo " "
  echo " "
  echo "!!! Caution with this script !!! "
  echo " "
  echo "This script remove and restore the database removing sharding but restoring shard-index, after that, you can remove the index manually"
  echo "Please, ensure that you have enought disk space for save the collection"
  echo " "
  echo "$package -S <SERVER> -d <database>  -c <collection>"
  echo " "
  echo "options:"
  echo "-h, --help                show brief help"
  echo "-S                        MongoS server IP"
  echo "-d                        Database"
  echo "-c                        Collection with the sharded Key"
  exit 0
}


if test $# -ne 6 ;
then
 help
fi
#get parameters
while test $# -gt 0; do
  case "$1" in
     -h|--help)
         help
     ;;
     -S)
       shift
       SERVER=$1
       shift
     ;;
     -d)
       shift
       DATABASE=$1
       shift
     ;;
     -c)
       shift
       COLLECTION=$1
       shift
     ;;
     *)
      help
     ;;


FILE=/tmp/$DATABASE
if [ $? -ne 0 ]
then
  exit
fi
#conectamos contra un mongoS para sacar la base de datos con sharding
echo "dumping database..."
mongodump --host $SERVER -d $DATABASE --out $FILE
if [ $? -ne 0]
then
  exit
fi
echo "Removing database..."
mongo --host $SERVER/$DATABASE --eval "db.dropDatabase()"

echo "restoring database..."
mongorestore --host $SERVER -d $DATABASE $FILE/$DATABASE/$COLLECTION.bson
if [ $? -ne 0]
then
  exit
fi
rm -rf $FILE
echo " Shard-key deleted, we encourage to remove the related shard index"
