show:
	echo 'Run "make install" as root to install program!'
install: build
	sudo gdebi --non-interactive hackbox-mimetype-defaults_UNSTABLE.deb
uninstall:
	sudo apt-get purge hackbox-mimetype-defaults
build: 
	sudo make build-deb;
build-deb:
	mkdir -p debian;
	mkdir -p debian/DEBIAN;
	mkdir -p debian/usr;
	mkdir -p debian/usr/bin;
	mkdir -p debian/etc;
	mkdir -p debian/etc/skel;
	mkdir -p debian/usr/share;
	mkdir -p debian/usr/share/applications;
	mkdir -p debian/etc/skel/.local;
	mkdir -p debian/etc/skel/.local/share;
	mkdir -p debian/etc/skel/.local/share/applications;
	mkdir -p debian/opt;
	mkdir -p debian/opt/hackbox;
	mkdir -p debian/opt/hackbox/media;
	# copy over configs to be installed
	cp launcherFiles/fehOpen.desktop ./debian/usr/share/applications/ -v
	cp launcherFiles/ffplayOpen.desktop ./debian/usr/share/applications/ -v
	cp mimeapps.list ./debian/etc/skel/.local/share/applications/ -v
	#cp defaults.list ./debian/usr/share/applications/ -v
	cp defaults.list ./debian/opt/hackbox/media/defaults.list -v
	# copy over launchers and make them executable
	cp supportPrograms/fehOpen.py ./debian/usr/bin/fehOpen
	chmod +x ./debian/usr/bin/fehOpen
	# Create the md5sums file
	find ./debian/ -type f -print0 | xargs -0 md5sum > ./debian/DEBIAN/md5sums
	# cut filenames of extra junk
	sed -i.bak 's/\.\/debian\///g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*\\n//g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*//g' ./debian/DEBIAN/md5sums
	rm -v ./debian/DEBIAN/md5sums.bak
	# figure out the package size	
	du -sx --exclude DEBIAN ./debian/ > Installed-Size.txt
	# copy over package data
	cp -rv debdata/. debian/DEBIAN/
	# fix permissions in package
	chmod -Rv 775 debian/DEBIAN/
	chmod -Rv ugo+r debian/
	chmod -Rv go-w debian/
	chmod -Rv u+w debian/
	# build the package
	dpkg-deb --build debian
	cp -v debian.deb hackbox-mimetype-defaults_UNSTABLE.deb
	rm -v debian.deb
	rm -rv debian
