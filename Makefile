
dummy: plexsign.key

clean:
	rm -rf plexmediaserver plexmediaserver.deb plexmediaserver_$(shell wget -q -O - https://downloads.plex.tv/repo/deb/dists/public/main/binary-amd64/Packages.gz | gzip -d --to-stdout | head | grep Version | sed 's|Version: ||g')-initdmod-1_amd64.deb plex description-pak

clobber: clean
	rm plexsign.key

plexsign.key:
	wget -q -O plexsign.key https://downloads.plex.tv/plex-keys/PlexSign.key
	gpg --import plexsign.key
	gpg --list-keys | grep -i -C 1 plex

gpg-recv:
	gpg --recv-keys CD665CBA0E2F88B7373F7CB997203C7B3ADCA79D

gpg-verify:
	gpg --verify plexmediaserver.deb

plexmediaserver.deb: clean plexsign.key
	wget -O plexmediaserver.deb https://downloads.plex.tv/repo/deb/$(shell wget -q -O - https://downloads.plex.tv/repo/deb/dists/public/main/binary-amd64/Packages.gz | gzip -d --to-stdout | head | grep Filename | sed 's|Filename: ||g')
	make gpg-verify

plexmediaserver: plexmediaserver.deb
	dpkg -x plexmediaserver.deb plexmediaserver

get: plexmediaserver.deb plexmediaserver
	rm plexmediaserver.deb

install:
	install -m 744 bin/kill_plex.sh /usr/sbin/kill_plex.sh
	install -m 744 bin/watch_plex.sh /usr/sbin/watch_plex.sh
	install -m 755 init.d/plex /etc/init.d/plex
	#
	install plexmediaserver/etc/apt/sources.list.d/plexmediaserver.list /etc/apt/sources.list.d/plexmediaserver.list
	install plexmediaserver/etc/default/plexmediaserver /etc/default/plexmediaserver
	install plexmediaserver/etc/init/plexmediaserver.conf /etc/init/plexmediaserver.conf
	#
	install -D plexmediaserver/lib/systemd/system/plexmediaserver.service /lib/systemd/system/plexmediaserver.service
	#
	cp -r plexmediaserver/usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/
	#install -D plexmediaserver/lib/udev/rules.d/60-tvbutler-perms.rules /lib/udev/rules.d/60-tvbutler-perms.rules
	install -D plexmediaserver/usr/share/applications/plexmediamanager.desktop /usr/share/applications/plexmediamanager.desktop
	#
	mkdir -p /usr/share/doc/plexmediaserver/
	install -D plexmediaserver/usr/share/doc/plexmediaserver/changelog.Debian.gz /usr/share/doc/plexmediaserver/changelog.Debian.gz
	install -D plexmediaserver/usr/share/doc/plexmediaserver/copyright /usr/share/doc/plexmediaserver/copyright
	install -D plexmediaserver/usr/share/doc/plexmediaserver/README.Debian /usr/share/doc/plexmediaserver/README.Debian
	#
	install -D plexmediaserver/usr/share/pixmaps/plexmediamanager.png /usr/share/pixmaps/plexmediamanager.png
	install -D plexmediaserver/usr/sbin/start_pms /usr/sbin/start_pms

repack-deb:
	checkinstall --install=no \
		--default \
		--pkgname plexmediaserver \
		--pkgversion "$(shell wget -q -O - https://downloads.plex.tv/repo/deb/dists/public/main/binary-amd64/Packages.gz | gzip -d --to-stdout | head | grep Version | sed 's|Version: ||g')"-initdmod \
		--provides plexmediaserver \
		--nodoc \
		--deldoc=yes \
		--delspec=yes \
		--backup=no

list:
	mkdir -p Packages && cd Packages || exit; \
	wget -q -O - https://downloads.plex.tv/repo/deb/dists/public/main/binary-amd64/Packages.gz | gzip -d --to-stdout

version:
	wget -q -O - https://downloads.plex.tv/repo/deb/dists/public/main/binary-amd64/Packages.gz | gzip -d --to-stdout | head | grep Version | sed 's|Version: ||g'

unpack:
	dpkg -x plexmediaserver_$(shell wget -q -O - https://downloads.plex.tv/repo/deb/dists/public/main/binary-amd64/Packages.gz | gzip -d --to-stdout | head | grep Version | sed 's|Version: ||g')-initdmod-1_amd64.deb plex
