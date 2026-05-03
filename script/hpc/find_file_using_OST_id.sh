
# Replace '20' with your target OST index
# not recursive.  good for dir with lot of large files like tar balls
#for f in $(ls -1); do
for f in $(ls -1 *.tar ); do
    if lfs getstripe $f | grep -q "l_ost_idx: 20,"; then
        echo "$f is on OST 20"
        ls -lh "$f"
    fi
done
