
oldload = window.onload
window.onload = ( ) ->
    oldload?.apply this, arguments

    i = document.createElement 'inspector'

    document.body.parentNode.appendChild i
    require('../frame/frame') i

    require('knockout').applyBindings { }, i


