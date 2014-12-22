ko = require 'knockout'
coffee = require './coffee'

trace = require './trace'

module.exports = new class Console

    @icons =
        log: 'fa-pencil'
        in: 'fa-angle-left'
        out: 'fa-angle-right'
        info: 'fa-info'
        warn: 'fa-exclamation'
        error: 'fa-times'
        debug: 'fa-bug'
        trace: 'fa-ellipsis-v'


    constructor: ( ) ->
        @name = 'console'
        @icon = 'fa-terminal'

        @logs = ko.observableArray [ ]

        trace @log.bind @

        @in = ko.observable ''
        @in.subscribe ( change ) =>
            @exec change if change
            @in ''

        @coffee = false

        @registry = []

        @aclick = ( target ) ->
            alert target?.constructor?.name
            if attr = target.getAttribute? 'data-registry'
                alert attr


    obj: ( o ) ->
        alert 'hi'


    log: ( args ) ->
        for msg, i in args.info
            if msg is undefined
                args.info[i] = '[undefined]'
            if msg is null
                args.info[i] = '[null]'
            if typeof msg is 'object'
                v = @registry.push msg
                args.info[i] = "<a data-registry='#{v-1}'>#{msg.constructor.name}</a>"

        args.icon = Console.icons[args.type]
        @logs.push args
        undefined # change return value to undefined

    exec: ( code ) ->
        if code is 'lang:coffee'
            @log
                type: 'out'
                console: true
                info: ['language set to coffeescript']
            return @coffee = true
        else if code is 'lang:js'
            @log
                type: 'out'
                console: true
                info: ['language set to javascript']
            return @coffee = false

        if @coffee
            code = CoffeeScript.compile code, bare: true

        @log
            type: 'in'
            console: true
            info: [code]

        out = ((str) ->
            try
                return eval(str);
            catch e
                return 'failed: ' + e;
        ).call window, code

        @log
            type: 'out'
            console: true
            info: [out]



