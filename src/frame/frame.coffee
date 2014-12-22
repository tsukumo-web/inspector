scroll = require './scroll'

Hammer = require 'hammerjs'
ko = require 'knockout'


class Frame

    @FULL   = 0
    @TOP    = 1
    @BOTTOM = 2
    @LEFT   = 3
    @RIGHT  = 4
    @HIDE   = 5

    constructor: ( @i ) ->
        @w = window.innerWidth / 3
        @h = window.innerHeight / 3

        @settings = require '../settings/settings'
        @console = require '../consol/consol'
        @network = require '../network/network'

        @cls = [ ]
        @pan = [ ]

        @cls[Frame.FULL]    = '__i__full'
        @cls[Frame.HIDE]    = '__i__hide'

        @cls[Frame.TOP]     = '__i__top'
        @pan[Frame.TOP]     = ( evt ) =>
            @i.style.height = @h + evt.deltaY + 'px'
            if evt.isFinal
                @h += evt.deltaY

        @cls[Frame.BOTTOM]  = '__i__bottom'
        @pan[Frame.BOTTOM]  = ( evt ) =>
            @i.style.height = @h - evt.deltaY + 'px'
            if evt.isFinal
                @h -= evt.deltaY

        @cls[Frame.LEFT]    = '__i__left'
        @pan[Frame.LEFT]    = ( evt ) =>
            @i.style.width = @w + evt.deltaX + 'px'
            if evt.isFinal
                @w += evt.deltaX

        @cls[Frame.RIGHT]   = '__i__right'
        @pan[Frame.RIGHT]   = ( evt ) =>
            @i.style.width = @w - evt.deltaX + 'px'
            if evt.isFinal
                @w -= evt.deltaX

        @attach = ko.observable Frame.HIDE




    register: ( ) ->

        scroll.init()

        @i = @i.children[0]

        # register grip
        @g_mc = new Hammer.Manager @i.children[0]
        @g_mc.add new Hammer.Pan
            direction: Hammer.DIRECTION_ALL
            threshold: 0

        @attach.subscribe ( change ) =>
            @i.className = '__i__ ' + @cls[change]
            @g_mc.off 'pan'
            if change isnt Frame.FULL
                @g_mc.on 'pan', @pan[change]

        @i.style.width = @w + 'px'
        @i.style.height = @h + 'px'

        @i.className = '__i__ ' + @cls[Frame.HIDE]

        html_mc = new Hammer.Manager document.body
        html_mc.add new Hammer.Tap
            taps: 3
        html_mc.add new Hammer.Press
            time: 3000

        state = Frame.BOTTOM
        html_evt = () =>
            if @attach() is Frame.HIDE
                @attach state
            else
                state = @attach()
                @attach Frame.HIDE
        html_mc.on 'tap', html_evt
        html_mc.on 'press', html_evt


module.exports = ( i ) ->

    frame = new Frame i

    # window controls
    window.__i__ =
        resize:
            full: ( ) ->
                frame.attach Frame.FULL
            top: ( ) ->
                frame.attach Frame.TOP
            bottom: ( ) ->
                frame.attach Frame.BOTTOM
            left: ( ) ->
                frame.attach Frame.LEFT
            right: ( ) ->
                frame.attach Frame.RIGHT
            hide: ( ) ->
                frame.attach Frame.HIDE

    ko.components.register 'inspector',
        viewModel: ( params ) ->
            frame.register()
            this.data = frame
        template: require('./view')()

    return frame



