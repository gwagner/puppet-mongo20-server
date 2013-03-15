class mongo20-server
{
    include mongo-server::config, repo_10gen

	package {
        "mongo20-10gen":
            alias => "mongo-10gen",
            ensure => 'installed',
            provider => 'yum',
            require => [
                Yumrepo['10gen']
            ];
        "mongo20-10gen-server":
            alias => "mongo-10gen-server",
            ensure => 'installed',
            provider => 'yum',
            require => [
                Yumrepo['10gen']
            ];
    }

	file {
		'/etc/mongo-secret-key':
			mode => 600,
			owner => "mongod",
			group => "mongod",
			path => "/etc/mongo-secret-key",
			source => "puppet:///modules/mongo-server/mongo-secret-key",
			require => Package["mongo-10gen-server"];

		'/etc/mongod.conf':
			mode => 644,
			owner => "root",
			group => "root",
			path => "/etc/mongod.conf",
			content => template('mongo-server/mongod.erb');
	}

	service {
		'mongod':
			ensure => true,
			enable => true,
			subscribe => [
				Package ['mongo-10gen'],
				Package ['mongo-10gen-server'],
				File['/etc/mongod.conf'],
				File['/etc/mongo-secret-key'],
			];
	}
}