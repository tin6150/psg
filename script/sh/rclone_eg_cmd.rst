

r@y00
rclone copy --progress  --transfers=20 --checkers=20 --size-only /global/sysbase/bases/ ceph:/greta/test_y00_2025_0310_bases/


rclone --transfers=20 --checkers=20 --size-only sync /global/sysbase/ ceph:greta/moveBKUPsysbase --links --exclude ".snapshot/**"


rclone size ceph:
rclone lsd ceph:greta/
