#!/global/software/sl-7.x86_64/modules/langs/python/3.7/bin/python



# there were some reported luster lock problem with hdf5
# seems like a file create would reveal such problem
# run test as:
# pdsh -g savio1,savio2,savio3 /global/home/users/tin/PSG/script/hpc/./test_hdf5_lock.py 
# pdsh -g brc                  /global/home/users/tin/PSG/script/hpc/./test_hdf5_lock.py
# grep STATE 

import h5py
import platform

#hostname = platform.node().split('.', 1)[0]
hostname = platform.node()

#status = 
status = 0
#with h5py.File("mytestfile.hdf5", "w") as f:
try:
  with h5py.File("/global/scratch/tin/JUNK/mytestfile.%s.hdf5" % hostname , "w") as f:
    dset = f.create_dataset("mydataset", (100,), dtype='i')
  print( "hdf5 write/create completed -- STATEOK" )
  exit( 0 )
except EnvironmentError:
    print( "hdf5 write/create exception STATE007 (did not exit 0 above, likely threw error)" )
    exit ( 7 )


#### below should never run ####
print( "houston, we got a problem :)" )


if( status == 0 ) : 
    print( "hdf5 write/create exit status 0" )
else :
    print( "hdf5 write/create exit status NOT 0" )
