#!/bin/sh

# ref https://mail.google.com/mail/u/0/?zx=q2hs55bbe0kd#search/gnome++reset/15730783550cff13

#FECHA=cfbk.`date +%Y%m%d`
FECHA=cfbk.`date +%Y%m%d_%H%M`
BKDIR=OLD_gnome_${FECHA}
 
mkdir $BKDIR
 
mv .gconf .fonts .ICEauthority .Xauthority $BKDIR
#mv .desktop-milkyway .desktop-paean.chiron.com .desktophost .dtEnvPref .fontconfig $BKDIR
mv .dtEnvPref .fontconfig $BKDIR
mv .fonts.cache-1 .fonts.cache-2  $BKDIR
mv .gconfd .gnome .gnome2 .gnome2_private .gtk-bookmarks .gtkrc-1.2-gnome2 .gvfs .metacity $BKDIR
mv .nautilus $BKDIR
mv .pulse .pulse-cookie $BKDIR
mv .qt .recently-used .sane $BKDIR
mv .xauthoUeZHj $BKDIR
mv .xpbsmonrc .xpbsrc $BKDIR
mv .xsession-errors .xsession-errors.old $BKDIR
mv .xsession-errors*  $BKDIR
 
mv .metadata .mmlist_date .mmlist_list $BKDIR
# .nvidia-settings-rc
# .skel .sversionrc .w3m .vls .wapi .wshttymode
# .showcaserc .server_apps

mv .xinitrc $BKDIR
mv .themes  $BKDIR
mv .kde .icons .cache .config $BKDIR



mv .local  .mkshrc .nv  	$BKDIR
#mv  .mv  canberra gtk 		$BKDIR
## .pki

mv .imsettings.log .gnupg .gmsh-tmp .gmshrc .gmsh-options .fltk .gstreamer-0.10 .visit .hplip .java .gimp-2.6/ .theano $BKDIR

mv .xinitrc~  $BKDIR
mv .abrt  $BKDIR
mv .dbus .gnote .esd_auth  $BKDIR

