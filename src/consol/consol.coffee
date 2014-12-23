ko = require 'knockout'
coffee = require './coffee'

trace = require './trace'

properties = ( o ) ->
    props = [ ]
    curr = o
    while Object.getPrototypeOf curr
        for prop in Object.getOwnPropertyNames curr
            props.push prop if -1 is props.indexOf prop
        curr = Object.getPrototypeOf curr
    return props

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

        console.info 'trace logging enabled'

        @registry = [ ]
        @tmp_registry = [ ]
        @obj = ko.observable null

        @aclick = ( target ) =>
            target = target.match /<a.+data-registry=.(\d+)/
            if target = target?[1]
                @view @registry[target]
        @oclick = ( target ) =>
            target = target.v.match /<a.+data-registry=.(\d+)/
            if target = target?[1]
                @view @tmp_registry[target]

    process: ( arr, v ) ->
        if v is undefined
            return '[undefined]'
        if v is null
            return '[null]'
        if typeof v is 'object'
            p = arr.push v
            return "<a data-registry='#{p-1}'>#{v.constructor.name}</a>"
        if typeof v is 'string'
            return v.replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
        return v

    log: ( args ) ->
        for v, i in args.info
            args.info[i] = @process @registry, v

        args.icon = Console.icons[args.type]
        @logs.push args
        undefined # change return value to undefined

    view: ( o ) ->
        @tmp_registry = [ ] # reset temp obj storage
        if o instanceof Array
            i = 0
            @obj [
                k: 'length'
                v: o.length
                t: 'number'
                l: 'n'
            ].concat o.map ( k ) =>
                type = typeof k

                k: i++
                v: @process @tmp_registry, k
                t: type
                l: type.substring 0, 1
        else
            @obj properties(o).map ( k ) =>
                type = typeof o[k]

                k: k
                v: @process @tmp_registry, o[k]
                t: type
                l: type.substring 0, 1

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



