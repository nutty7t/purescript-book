"use strict"

exports.alert = function (msg) {
  return function () {
    window.alert(msg)
  }
}

exports.confirm = function (msg) {
  return function () {
    return window.confirm(msg)
  }
}

