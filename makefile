show:
	echo 'Run "make install" as root to install program!'
install:
	# setup mime types for system
	cp fehOpen.desktop ~/.local/share/applications/ -v
	cp ffplayOpen.desktop ~/.local/share/applications/ -v
	cp mimeapps.list ~/.local/share/applications/ -v
	# setup the support program fehOpen
	pycompile ./supportPrograms/fehOpen.py
	cp ./supportPrograms/fehOpen.pyc ./supportPrograms/fehOpen
	sudo chmod +x ./supportPrograms/fehOpen
	sudo cp ./supportPrograms/fehOpen /usr/bin/fehOpen
	rm ./supportPrograms/fehOpen
	rm ./supportPrograms/fehOpen.pyc
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
	# make post and pre install scripts have the correct permissions
	chmod 775 debdata/postinst
	chmod 775 debdata/postrm
	# copy over configs to be installed
	cp launcherFiles/fehOpen.desktop ./debian/usr/share/applications/ -v
	cp launcherFiles/ffplayOpen.desktop ./debian/usr/share/applications/ -v
	cp mimeapps.list ./debian/etc/skel/.local/share/applications/ -v
	#cp defaults.list ./debian/usr/share/applications/ -v
	cp defaults.list ./debian/opt/hackbox/media/defaults.list -v
	# copy over launchers and make them executable
	cp supportPrograms/fehOpen.py ./debian/usr/bin/fehOpen
	chmod +x ./debian/usr/bin/fehOpen
	# make post and pre install scripts have the correct permissions
	chmod 775 debdata/*
	# start the md5sums file
	find ./debian/ -type f -print0 | xargs -0 md5sum > ./debian/DEBIAN/md5sums
	# remove unneeded md5 sums
	sed -i.bak 's/\.\/debian\///g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*\\n//g' ./debian/DEBIAN/md5sums
	sed -i.bak 's/\\n*DEBIAN*//g' ./debian/DEBIAN/md5sums
	# cleanup and build then cleanup some more
	rm -v ./debian/DEBIAN/md5sums.bak
	cp -rv debdata/. debian/DEBIAN/
	du -sx --exclude DEBIAN ./debian/ | sed "s/[abcdefghijklmnopqrstuvwxyz\ /.]//g" > packageSize.txt
	dpkg-deb --build debian
	cp -v debian.deb hackbox-mimetype-defaults_UNSTABLE.deb
	rm -v debian.deb
	rm -rv debian
