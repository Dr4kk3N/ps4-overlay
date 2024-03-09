'use strict';

var util = require('util');

var logLevels = ['info', 'debug', 'error', 'warn', 'trace'];
var enabled = true;

/**
 * Default console logger for use outside of hapi container
 * @param tags
 * @param message
 */
function logToConsole(tags, message) {
    if (enabled) {
        if (arguments.length < 2) {
            message = tags;
            tags = [];
        }

        if (!util.isArray(tags)) tags = [];

        var text = new Date().getTime() + ', ';
        if (tags.length > 0) {
            text = text + tags[0] + ', ';
        }
        text = text + message;
        console.log(text);
    }
}

/**
 * Assists with parsing var-arg'ed tags
 * @param tags
 * @return {*}
 */
function parseTags(tags) {
    if (tags.length > 0 && util.isArray(tags[0])) {
        tags = tags[0];
    }

    return tags;
}

/**
 * Logger constructor. may be invoked directly or as a constructor
 * @param {string[]=} tags an array of default tags to include with log messages
 * @return {Logger} a new logger instance
 * @constructor
 */
function Logger(tags) {
    tags = parseTags(Array.prototype.slice.call(arguments));
    if (!(this instanceof Logger)) {
        return new Logger(tags);
    }

    this.tags = tags;
}

// the real log function to call. gets swapped out for hapi logger if registered as a plugin
Logger.prototype.log = logToConsole;

Logger.prototype.id = function (id) {
    return new Logger(this.tags.concat(`id:${id}`));
}

Logger.prototype.group = function (group) {
    return new Logger(this.tags.concat(`group:${group}`));
}

logLevels.forEach(function (lvl) {
    Logger.prototype[lvl] = function (tags, message) {
        var params = [];

        if (!(util.isArray(tags))) {
            message = tags;
            tags = [];
            params = [].slice.call(arguments, 1);
        } else {
            params = [].slice.call(arguments, 2);
        }

        // ensure local tags are an array, push the log level on the end
        tags = util.isArray(tags) ? tags : [ tags ];
        tags = tags.concat([lvl]);

        tags = this.tags.concat(tags);

        params = params.length > 0 ? util.format.apply(util, [ message ].concat(params)) : message;

        params = params instanceof Error ? params.stack : params;

        this.log(tags, params);
    };
});

exports.register = function(server, opts, next) {
    const { activeRequest = server => {
        const ns = server.app.namespace;
        return ns ? ns.get('request') : undefined;
    }} = opts;

    Logger.prototype.log = function(...args) {
        const req = activeRequest(server);
        return req ? req.log(...args) : server.log(...args);
    };

    next();
};

exports.register.attributes = {
    pkg: require('../package.json')
};

exports.enabled = function(_enabled_) {
    enabled = _enabled_;
};

exports.Logger = Logger;