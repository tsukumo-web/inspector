
ko = require 'knockout'

module.exports = new class Settings

    constructor: ( ) ->
        @view = ko.observable(false);
