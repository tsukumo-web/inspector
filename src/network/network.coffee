xhr = require './xhr'

module.exports = new class Network

    constructor: ( ) ->
        @name = 'network'
        @icon = 'fa-wifi'

        @xhrs = xhr
