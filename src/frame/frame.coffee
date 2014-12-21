Hammer = require 'hammerjs'
ko = require 'knockout'

class Frame

    @FULL   = 0
    @TOP    = 1
    @BOTTOM = 2
    @LEFT   = 3
    @RIGHT  = 4

    constructor: ( @i ) ->
        @w = window.innerWidth / 3
        @h = window.innerHeight / 3

        @settings = require '../settings/settings'

        @cls = [ ]
        @pan = [ ]

        @cls[Frame.FULL]    = '__i__full'

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

        @attach = ko.observable Frame.BOTTOM

    register: ( ) ->

        @i = @i.children[0]

        # register grip
        @g_mc = new Hammer.Manager @i.children[0]
        @g_mc.add new Hammer.Pan
            direction: Hammer.DIRECTION_ALL
            threshold: 0

        @g_mc.on 'pan', @pan[Frame.BOTTOM]

        @attach.subscribe ( change ) =>
            @i.className = '__i__ ' + @cls[change]
            @g_mc.off 'pan'
            if change isnt Frame.FULL
                @g_mc.on 'pan', @pan[change]

        @i.style.width = @w + 'px'
        @i.style.height = @h + 'px'

        @i.className = '__i__ ' + @cls[Frame.BOTTOM]


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

    ko.components.register 'inspector',
        viewModel: ( params ) ->
            frame.register()
            this.data = frame
        template: require('./view')()

    return frame



