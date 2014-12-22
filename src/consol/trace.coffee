
bowser = require('../../bower_components/bowser/bowser').browser
window.bowser = bowser
cb = ( ) ->

stack_info = switch
    when bowser.chrome or bowser.ios then () ->
        trace = new Error().stack.split('\n')[3]
        line = trace.split(':')
        line = line[line.length - 2]
        if bowser.ipad
            left_at = trace.indexOf '@'
            if left_at > -1
                func = trace.substring 0, left_at
            else
                func = ''
        else
            left_paren = trace.indexOf ' ('
            if left_paren > -1
                func = trace.substring trace.indexOf('at ') + 3, left_paren
                func = func.substring func.lastIndexOf(' ') + 1
            else
                func = ''
        slash = trace.indexOf '/'
        if slash > -1
            file = trace.substring trace.lastIndexOf('/') + 1
            file = file.substring 0, file.indexOf ':'
        else
            file = 'console'

        func: func
        file: file
        line: line

    when bowser.safari or bowser.firefox then () ->
        trace = new Error().stack.split('\n')[if bowser.safari then 3 else 2]
        line = trace.split(':')
        line = line[line.length - 2]
        func = trace.substring 0, trace.indexOf '@'
        file = trace.substring trace.lastIndexOf('/') + 1
        file = file.substring 0, file.indexOf ':'

        func: func
        file: file
        line: line

    when bowser.msie then () ->
        func: 'unknown'
        file: 'not implemented'
        line: -1
    else () ->
        func: 'unknown'
        file: 'unsupported'
        line: -1

trace_log = ( type, info... ) ->
    i = stack_info()
    i.info = info
    i.type = type
    cb i

module.exports = ( callback ) -> cb = callback

console['log'] = trace_log.bind null, 'log'
console['warn'] = trace_log.bind null, 'warn'
console['info'] = trace_log.bind null, 'info'
console['error'] = trace_log.bind null, 'error'
console['debug'] = trace_log.bind null, 'debug'
console['trace'] = trace_log.bind null, 'trace'
