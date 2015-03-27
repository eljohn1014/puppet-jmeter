# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter(
  $jmeter_version         = '2.9',
  $jmeter_plugins_install = False,
  $jmeter_plugins_version = '1.0.0',
) {

  Exec { path => '/bin:/usr/bin:/usr/sbin' }

  exec { 'download-jmeter':
    command => "wget -P /root http://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${jmeter_version}.tgz",
    creates => "/root/apache-jmeter-${jmeter_version}.tgz"
  }

  exec { 'install-jmeter':
    command => "tar xzf /root/apache-jmeter-${jmeter_version}.tgz && mv apache-jmeter-${jmeter_version} jmeter",
    cwd     => '/usr/share',
    creates => '/usr/share/jmeter',
    require => Exec['download-jmeter'],
  }

  if $jmeter_plugins_install == True {
    exec { 'download-jmeter-plugins':
      command => "wget -P /root http://jmeter-plugins.googlecode.com/files/JMeterPlugins-${jmeter_plugins_version}.zip",
      creates => "/root/JMeterPlugins-${jmeter_plugins_version}.zip"
    }

    exec { 'install-jmeter-plugins':
      command => "unzip -q -d JMeterPlugins JMeterPlugins-${jmeter_plugins_version}.zip && mv JMeterPlugins/JMeterPlugins.jar /usr/share/jmeter/lib/ext",
      cwd     => '/root',
      creates => '/usr/share/jmeter/lib/ext/JMeterPlugins.jar',
      require => Exec['download-jmeter-plugins']],
    }
  }
}
