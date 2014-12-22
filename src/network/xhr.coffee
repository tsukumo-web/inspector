ko = require 'knockout'

module.exports = xhrs = ko.observableArray [ ]

XHR = window.XMLHttpRequest
window.XMLHttpRequest = class XHRWrapper

    constructor: () ->

        @xhr = new XHR

        @time = [ new Date ]
        @size = null
        @method = null
        @domain = null
        @file = null

        @aborted = false

        @on =
            readystatechange: @xhr.onreadystatechange

        @xhr.onreadystatechange = () =>
            @on.readystatechange?()
            @time[@xhr.readyState] = new Date

            if @xhr.readyState is 4
                @size = encodeURI(@xhr.responseText).split(/%..|./).length - 1;

                xhrs.push
                    status: @xhr.status
                    method: @method
                    domain: @domain
                    file: @file
                    size: @size
                    duration: @time[@time.length - 1] - @time[0]
                    time: @time
                    type: @xhr.responseType
                    aborted: @aborted

        Object.defineProperty @, 'onreadystatechange',
            set: ( v ) => @on.readystatechange = v
            get: ( ) => @on.readystatechange
        Object.defineProperty @, 'readyState',
            get: ( ) => @xhr.readyState
        Object.defineProperty @, 'response',
            get: ( ) => @xhr.response
        Object.defineProperty @, 'responseText',
            get: ( ) => @xhr.responseText
        Object.defineProperty @, 'responseType',
            set: ( v ) => @xhr.responseType = v
            get: ( ) => @xhr.responseType
        Object.defineProperty @, 'responseXML',
            get: ( ) => @xhr.responseXML
        Object.defineProperty @, 'status',
            get: ( ) => @xhr.status
        Object.defineProperty @, 'statusText',
            get: ( ) => @xhr.statusText
        Object.defineProperty @, 'timeout',
            set: ( v ) => @xhr.timeout = v
            get: ( ) => @xhr.timeout
        Object.defineProperty @, 'ontimeout',
            set: ( v ) => @xhr.ontimeout = v
        Object.defineProperty @, 'upload',
            get: ( ) => @xhr.upload
        Object.defineProperty @, 'withCredentials',
            set: ( v ) => @xhr.withCredentials = v
            get: ( ) => @xhr.withCredentials

        Object.defineProperty @, 'onabort',
            set: ( v ) => @xhr.onabort = v
            get: ( ) => @xhr.onabort

        Object.defineProperty @, 'onerror',
            set: ( v ) => @xhr.onerror = v
            get: ( ) => @xhr.onerror

        Object.defineProperty @, 'onload',
            set: ( v ) => @xhr.onload = v
            get: ( ) => @xhr.onload

        Object.defineProperty @, 'onloadend',
            set: ( v ) => @xhr.onloadend = v
            get: ( ) => @xhr.onloadend

        Object.defineProperty @, 'onloadstart',
            set: ( v ) => @xhr.onloadstart = v
            get: ( ) => @xhr.onloadstart

        Object.defineProperty @, 'onprogress',
            set: ( v ) => @xhr.onprogress = v
            get: ( ) => @xhr.onprogress


    abort: () ->
        @aborted = true
        @xhr.abort.apply @xhr, arguments
    getAllResponseHeaders: () ->
        @xhr.getAllResponseHeaders.apply @xhr, arguments
    getResponseHeader: () ->
        @xhr.getResponseHeader.apply @xhr, arguments
    open: (type, host) ->
        @method = type
        @domain = host.split '/'
        @file = @domain[@domain.length - 1]
        @domain = @domain[2]
        @time[1] = new Date
        @xhr.open.apply @xhr, arguments
    overrideMimeType: () ->
        @xhr.overrideMimeType.apply @xhr, arguments
    send: () ->
        @xhr.send.apply @xhr, arguments
    setRequestHeader: () ->
        @xhr.setRequestHeader.apply @xhr, arguments
    sendAsBinary: () ->
        @xhr.sendAsBinary.apply @xhr, arguments

