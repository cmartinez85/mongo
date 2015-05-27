__author__ = 'cmartinec'

import os
from config import Config
import pymongo
from pymongo.database import Database
import sys

def main(setup):
    cfg = Config(setup)

    connection = pymongo.Connection(host=cfg.MongoSource)
    connectionDest = pymongo.Connection(host=cfg.MongoDestination)
	

    for db_cfg in cfg.DbToMove:
        db = Database(connection, db_cfg.name)
        db_dest = Database(connectionDest, db_cfg.name)
        for coll in db_cfg.collection:
            print "Eliminando datos de %s" % coll
            db_dest[coll].remove()

            try:
                objects = db[coll].find(timeou=False)
                print "Moviendo datos de %s" % coll
            except:
                print "Error cogiendo objetos del source %s" % coll
            for i in objects:
                try:
                    db_dest[coll].insert(i)
                    #print "Insertado documento"
                except Exception, e:
                    print "Error al insertar documento: %s %s " % i,e


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('Usage: %s config-file-name' % sys.argv[0])
    if not os.path.exists(sys.argv[1]):
        sys.exit('The config file %s is missing' % sys.argv[1])
    main(sys.argv[1])
