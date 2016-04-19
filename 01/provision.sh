#!/bin/bash -eu

# タイムゾーンをJSTに変更
# http://qiita.com/snaka/items/a291423d6ceac9f091a7
sudo cp -p  /usr/share/zoneinfo/Japan /etc/localtime

# ntpdで時刻同期
sudo yum -y install ntp
sudo chkconfig ntpd on
sudo service ntpd start

# apache2.4インストール
# http://brandondanielbailey.com/tutorials/install-apache-2-4-centos-6-using-software-collections/
sudo yum install -y centos-release-SCL
sudo yum install -y httpd24 httpd24-httpd-devel
sudo chkconfig httpd24-httpd on

# apacheの設定ファイルを配置
# http://qiita.com/100/items/ab31e57fcc66ac661d5c
# http://mk-55.hatenablog.com/entry/2014/07/07/004510
# https://www.seeds-std.co.jp/seedsblog/1227.html
 sudo cp /vagrant/files/httpd.conf /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf

# apache起動
sudo service httpd24-httpd start
sudo service httpd24-httpd reload

