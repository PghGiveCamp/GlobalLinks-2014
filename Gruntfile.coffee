module.exports = (grunt)->
    require('rupert-grunt')(grunt, config)

    grunt.registerTask 'watcher', [ 'rupert-watch' ]
    grunt.registerTask 'default', [ 'rupert-default' ]
